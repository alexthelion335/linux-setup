#!/bin/bash
drive=/dev/sda
hostname=new-arch-box
user=alex
passwd=password
echo "--------------------------"
echo "-  Welcome to            -"
echo "-  Alex Kinch's          -"
echo "-  Arch Install          -"
echo "-  script!               -"
echo "--------------------------"
sleep 1
echo -e "\nYou will need to know what drive to install Arch Linux on."
echo "If it is not /dev/sda, you will need to change the script."
sleep 1
fdisk ${drive} << EOF
  o
  n
  p
  1
    
  -2G
  n
  p
  2
   
   
  a
  1
  t
  2
  82
  p
  w
  q
EOF
echo -e "\nDrive $drive was formatted!"
mkfs.ext4 ${drive}1
mkswap ${drive}2
swapon ${drive}2
mount ${drive}1 /mnt
echo -e "\nSwap activated and drive mounted!"
timedatectl set-ntp true
timedatectl status
echo -e "\nTime and date set!"
echo -e "\nInstalling base system..."
sleep 1
pacstrap /mnt base linux linux-firmware
echo -e "\nBase system installed!"
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "\nFstab configured!"
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/America/New_York
hwclock --systohc
echo -e "\nInstalling other necessities..."
pacman -S nano vim sudo base-devel networkmanager dhcpcd grub xorg-server xf86-video-vesa xorg-xinit neofetch i3-gaps i3lock i3status feh firefox konsole xterm mpv thunar dolphin picom inkscape gimp cmatrix lynx lolcat cowsay << EOF
  
  
  
EOF
echo -e "\nOther necessities installed!"
echo $hostname >> /etc/hostname
rm /etc/hosts
echo -e "127.0.0.1    localhost\n::1        localhost\n127.0.1.1    ${hostname}.localdomain ${hostname}" >> /etc/hosts
echo -e "\nHostname set!"
passwd << EOF
  $password
  $password
EOF
useradd -m $user
passwd $user << EOF
  $password
  $password
EOF
usermod -aG wheel,audio,video,optical,storage $user
printf "\n%%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo -e "\nUser settings set!"
grub-install $drive
grub-mkconfig -o /boot/grub/grub.cfg
echo -e "\nGrub installed!"
su alex
echo "exec i3" >> ~/.xinitrc
exit
exit
echo -e "\nArch Linux configuration complete!"
sleep 3
reboot
