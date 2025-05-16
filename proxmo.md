## Problem i faced install proxmox
- problem 1:  proxmox is stuck on line "waiting for /dev" cause of advanced configuration of that PC AMD Ryzen.
- remedy 1:   so i pass kernal parameters during install nomodeset acpi=off on end of line of strating with linux.
  
- problem 2:  boot failed error.
- remedy 2 :   I choose zfs(RAID 0) during partition of proxmox 8.4
  
- problem 3:  1 cpu is showed in proxmox Data center summary so i cant create segregate cpu for multiple vms
- remedy 3:   It is caused by remedy1, passed the kernal parameter nomodeset acpi=off during installation proxmox
            Steps:-
               1. If You Are Using Systemd-boot (UEFI + ZFS installs):
                 GRUB changes won’t apply, because update-grub only works with GRUB.
                 Instead, do this:   Update file like below /etc/kernel/cmdline
                 ```sh root=ZFS=rpool/ROOT/pve-1 boot=zfs quiet amd_iommu=on iommu=pt acpi_osi=Linux modprobe.blacklist=btusb,bluetooth,snd_hda_intel```
                 ```sh proxmox-boot-tool refresh ```
                 Reboot.
