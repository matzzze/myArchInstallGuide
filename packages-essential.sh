#!/bin/bash

if [ "$EUID" -ne 0 ]
    then echo "must run as root"
        exit
fi

echo "=====> DOWNLOADING ESSENTIAL APPS"

# requires sudo
# --noconfirm is used to select all packages from groups
pacman -Sy --needed $(<packages-essential.txt)

echo "====> CONFIGURING APPS"
#enable battery optimization application
systemctl enable tlp
#create smbconf thats necessary for smbclient to work
[[ -d /etc/samba ]] || mkdir /etc/samba
[[ -f /etc/samba/smb.conf ]] || touch /etc/samba/smb.conf
#create samba password file
[[ -d /etc/samba/credentials ]] || mkdir /etc/samba/credentials
[[ -f /etc/samba/credentials/share ]] || cp sambacredentialfile /etc/samba/credentials/share && chown root:root /etc/samba/credentials && chmod 700 /etc/samba/credentials && chmod 600 /etc/samba/credentials/share
#ask for samba password
if [ -z $(grep password /etc/samba/credentials/share ) ]; then
    echo "Enter password for matze samba share access:"
    read enteredPassword
    echo "password=$enteredPassword" >> /etc/samba/credentials/share
fi 
#enable service for NetworkManager to only mount after being online
systemctl enable NetworkManager-wait-online.service
#create mount directories
mkdir -p /home/matze/mnt 
mkdir -p /home/matze/mnt/matze
mkdir -p /home/matze/mnt/common 
chown -R matze:users /home/matze/mnt
#add sambashare to fstab
if [ -z $(grep AutoSambaAdd /etc/fstab ) ]; then
    cp /etc/fstab /etc/fstab.beforeAutoSambaAdd
    echo "#AutoSambaAdd" >> /etc/fstab
    echo "//192.168.0.2/matze /home/matze/mnt/matze cifs noauto,x-systemd.automount,credentials=/etc/samba/credentials/share,vers=3.0,iocharset=utf8,uid=matze,gid=users 0 0" >> /etc/fstab
    echo "//192.168.0.2/common /home/matze/mnt/common cifs noauto,x-systemd.automount,credentials=/etc/samba/credentials/share,vers=3.0,iocharset=utf8,uid=matze,gid=users 0 0" >> /etc/fstab
fi
