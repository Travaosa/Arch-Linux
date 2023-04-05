parted /dev/sda mklabel gpt
parted /dev/sda unit mib
parted /dev/sda mkpart EFI 1 513
parted /dev/sda mkpart SWAP 513 2561
parted /dev/sda mkpart / 2561 100%
parted /dev/sda set 1 esp on
parted /dev/sda set 2 swap on
parted /dev/sda print

mkfs.fat -F 32 /dev/sda1
mkfs.swap /dev/sda2 && swapon /dev/sda2
mkfs.btrfs /dev/sda3

mount /dev/sda3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

pacstrap /mnt base linux linux-firmware networkmanager efibootmgr bash-completion grub vim
genfstab -U /mnt >> /mnt/etc/fstab && cat /mnt/etc/fstab

arch-chroot /mnt
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
passwd
exit

umount -R /mnt
reboot
