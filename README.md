# myArchInstallGuide
Summary of my personal arch installation.


## Preparation
#### Enable to remotely access the target machine during installation ####
1. Check if network access works by running `ip a s` and `ping google`
    - use `wifi-menu` for accessing wireless network
2. Change the password of root (this is just during the installation) with `passwd`
3. enable ssh daemon with `systemctl start sshd`
    - verify sshd is running with `systemctl status sshd`

Now simply connect to the machine via ssh from remote and follow the next steps til reboot


#### Prepare the disks by creating partitions ####
- use `lsblk` to check disks and partitions and identify the disk (e.g. /dev/sda or /dev/nvme01...)
- use cgdisk /dev/{diskname} to make partitioning: `cgdisk /dev/sda2`
  1. Create boot partition
      - Select `New`
      - Keep the first sector that is shown
      - Use a reasonable size (e.g `200M` or `512M`)
      - Keep the current type `8300 (Linux filesystem)`
      - Give it the name `boot`
  3. Create root partition 
      - Repeat the same as for step above but use entire filesystem and use the name `root` for the partition
  4. Select `Write` to make the changes apply
  5. check the partitions with `lsblk`
      - note the root partitions name (e.g. /dev/sda2)



#### Encrypt the root partition ####
1. Encrypt the whole partition with "cryptsetup luksFormat /dev/{rootpartition}"
    - `cryptsetup -y --use-random luksFormat /dev/sda2`
2. Open the encrypted partion and map it to a mapperdevice with "cryptsetup open /dev/{rootpartition} {name of mapper}"
    - `cryptsetup open /dev/sda2 cryptroot`
3. Check with `lsblk` in order to see the new {name of mapper} below {rootpartition}
4. In `/dev/mapper` the new {name of mapper} will also appear



#### Create filesystem on new partitions ####
1. Create filesystem on boot partition with "mkfs.ext4 /dev/{bootpartition}
    - the boot partition has not been encrypted so use the partition right away
    - `mkfs.ext4 /dev/sda1`
2. Create filesystem on root partition with "mkfs.ext4 /dev/mapper/{name of mapper}
    - the root partition has been encrypted so the mapper must be used!
    - `mkfs.ext4 /dev/mapper/cryptroot`



#### Mount the new partitions (non UEFI) ####
1. Mount the root partition by "mount /dev/mapper/{name of mapper} /mnt"
    - `mount /dev/mapper/cryptroot /mnt`
2. Mount the boot partition
    - create a new folder boot in mnt with `mkdir /mnt/boot`
    - mount the boot partition into the new folder with "mount /dev/{bootpartition} /mnt/boot"
        - `mount /dev/sda1 /mnt/boot`
3. run `lsblk` to make sure its fine


## Basic System Installation
#### Pacstrap & fstab ####
**Install a reasonable base system with pacstrap**
- Non-UEFI: 
    - `pacstrap /mnt base base-devel linux linux-headers linux-lts linux-lts-headers linux-firmware vim openssh networkmanager wpa_supplicant wireless_tools netctl dialog grub`
- UEFI:
    - `pacstrap /mnt base base-devel linux linux-headers linux-lts linux-lts-headers linux-firmware vim openssh networkmanager wpa_supplicant wireless_tools netctl dialog grub efibootmgr`
- Arch as a virtualbox guest
    - also install `virtualbox-guest-utils`

**Generate the fstab**
- automatically generate it for the mounted disks with genfstab
- `genfstab -U /mnt >> /mnt/etc/fstab`

#### Chroot ####
- use arch-chroot to go into new installed system
- `arch-chroot /mnt`
- stay in chroot until guide suggests to exit it

**Set timezone and sync hardware clock**
- in `/usr/share/zoneinfo` there are the different timezones, search the right one and link it
- `ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime`
- sync the hardware clock to the system clock `hwclock --systohc`

**Generate locale**
- uncomment the necessary locale(s) in `/etc/locale.gen`
- run `locale-gen` 
- important: export Language towards `/etc/locale.conf` with `echo "LANG=en_US.UTF-8" >> /etc/locale.conf"`

**set hostname and add entries to /etc/hosts**
- run `echo "{myhostname}" >> /etc/hostname`
- add to `/etc/hosts` :
```
127.0.0.1	localhost
::1		localhost
127.0.1.1	{myhostname}.{mylocaldomain}	{myhostname}
```
**change root passwd**
-run `passwd`

**Setup initram filesystem**
- open `etc/mkinitcpio.conf` and look for the section `HOOKS=(base ...`
- add the proper hook for encryption by adding `encrypt` to it after `block` and before `filesystems`
- move the `keyboard` hook between `autodetect` and `modconf` (not sure if this is really necessary)
- the line should look like this: `HOOKS=(base udev autodetect keyboard modconf block encrypt filesystems fsck)`
- regenerate initramfs for both kernels with `mkinitcpio -p linux` and `mkinitcpio -p linux-lts`

**Setup the bootloader**
1. Get the UUIDs with `blkid >> /tmp/ids.txt`
2. Look for the UUID of the actual root partition (e.g. /dev/sda2) and not the mapped device!
3. Open the config for grub at `/etc/default/grub`
    - look for the line `GRUB_CMDLINE_LINUX=""` and replace with:
    - `GRUB_CMDLINE_LINUX="cryptdevice=UUID={device-UUID}:{name of mapper} root=/dev/mapper/{name of mapper}"`
    - replace {device-UUID} with the actual device id of the actual root partition that you find in /tmp/ids.txt
    - replace {name of mapper} with the mapperdevicename that you have set at 
