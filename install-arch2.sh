#!/bin/bash
drive=/dev/sda
hostname=new-arch-box
user=alex
passwd=password
echo -e "\nContinuing installation..."
ln -sf /usr/share/zoneinfo/America/New_York
hwclock --systohc
echo -e "\nInstalling other necessities..."
pacman -S nano vim sudo base-devel git networkmanager dhcpcd grub xorg-server xf86-video-vesa xorg-xinit neofetch i3-gaps i3lock i3status feh firefox konsole xterm mpv thunar dolphin picom inkscape gimp cmatrix lynx lolcat cowsay << EOF
  
  
  
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
echo "exec i3" >> /home/$user/.xinitrc
echo -e "\nUser settings set!"
grub-install $drive
grub-mkconfig -o /boot/grub/grub.cfg
echo -e "\nGrub installed!"
echo -e "\nArch Linux configuration complete!\nRebooting..."
sleep 3
reboot


