# myArchInstallGuide
Summary of my personal arch installation.


## Basic System Installation
**Enable to remotely access the target machine during installation**
1. Check if network access works by running `ip a s` and `ping google`
    - use `wifi-menu` for accessing wireless network
2. Change the password of root (this is just during the installation) with `passwd`
3. enable ssh daemon with `systemctl start sshd`
    - verify sshd is running with `systemctl status sshd`

Now simply connect to the machine via ssh from remote


**Prepare the disks by creating partitions**
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

**Encrypt the root partition**
1. Encrypt the whole partition with "cryptsetup luksFormat /dev/{rootpartition}"
    - `cryptsetup -y --use-random luksFormat /dev/sda2`
2. Open the encrypted partion and map it to a mapperdevice with "cryptsetup open /dev/{rootpartition} {name of mapper}"
    - `cryptsetup open /dev/sda2 cryptroot`
3. Check with `lsblk` in order to see the new {name of mapper} below {rootpartition}
4. In `/dev/mapper` the new {name of mapper} will also appear


**Create filesystem on new partitions**
1. Create filesystem on boot partition with "mkfs.ext4 /dev/{bootpartition}
    - the boot partition has not been encrypted so use the partition right away
    -`mkfs.ext4 /dev/sda1`
2. Create filesystem on root partition with "mkfs.ext4 /dev/mapper/{name of mapper}
    - the root partition has been encrypted so the mapper must be used!
    -`mkfs.ext4 /dev/mapper/cryptroot`
