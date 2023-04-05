parted
mklabel gpt
unit mib
mkpart EFI 1 513
mkpart SWAP 513 2561
mkpart / 2561 100%
set 1 esp on
set 2 swap on
print
quit

read

mkfs.fat -F 32 /dev/sda1
mkfs.swap /dev/sda2 && swapon /dev/sda2
mkfs.btrfs /dev/sda3

mount /dev/sda3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

pacstrap /mnt base linux linux-firmware networkmanager efibootmgr bash-completion grub vim
genfstab -U /mnt >> /mnt/ets/fstab && cat /mnt/etc/fstab

read

arch-chroot /mnt
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
echo -e "Введите пароль от root пользователя"
passwd

exit
umount -R /mnt
reboot
