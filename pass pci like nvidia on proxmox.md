# Proxmox NVIDIA GPU Passthrough:

This section focuses on preparing the host kernel to handle GPU passthrough by loading necessary modules and preventing the host OS from using the GPU.

---

## Step 2: Load VFIO Modules at Boot

These kernel modules enable PCI passthrough functionality using VFIO (Virtual Function I/O).

### 1. Edit `/etc/modules`:

```bash
nano /etc/modules
```

### 2. Add the following lines:

```text
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

These ensure the modules are loaded at boot time.

---

## Step 3: Prevent Host from Using the GPU

To make sure the Proxmox host doesn't claim the NVIDIA GPU, blacklist the default GPU drivers.

### 1. Create a new blacklist file:

```bash
nano /etc/modprobe.d/blacklist-nvidia.conf
```

### 2. Add the following lines:

```text
blacklist nouveau
blacklist nvidia
blacklist nvidiafb
```

This prevents the Linux kernel from loading NVIDIA drivers on the host.

---

After these steps, continue with device ID binding and passthrough configuration.

### 4. Identify GPU Device IDs
```text
lspci -nn
```

Look for your NVIDIA GPU and its associated audio device. Note the IDs (e.g., 10de:1b81 and 10de:10f0).

### 5. Bind GPU to vfio-pci
Create the VFIO override file:
```text
nano /etc/modprobe.d/vfio.conf
options vfio-pci ids=10de:1b81,10de:10f0
```
```sh
update-initramfs -u -k all
```

Note:- update Windows on PCI of devmgmt.
