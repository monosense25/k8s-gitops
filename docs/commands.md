## RESET TALOS (credit : https://raw.githubusercontent.com/szinn/k8s-homelab/main/infrastructure/talos/reset.sh)

```bash
#!/bin/bash

# Reset the worker nodes first since the path to them is through the control plane nodes
talosctl reset --graceful=false --reboot -n k8s-w0.monosense.io -e k8s-w0.monosense.io
talosctl reset --graceful=false --reboot -n k8s-w1.monosense.io -e k8s-w1.monosense.io
talosctl reset --graceful=false --reboot -n k8s-w2.monosense.io -e k8s-w2.monosense.io
talosctl reset --graceful=false --reboot -n k8s-w3.monosense.io -e k8s-w3.monosense.io

echo "Waiting for workers to reset... ^C to stop here"
sleep 5

# Reset the control plane nodes
talosctl reset --graceful=false --reboot -n k8s-m0.monosense.io -e k8s-m0.monosense.io
talosctl reset --graceful=false --reboot -n k8s-m1.monosense.io -e k8s-m1.monosense.io
talosctl reset --graceful=false --reboot -n k8s-m2.monosense.io -e k8s-m2.monosense.io
```

```bash
~ > talosctl -n 172.16.11.10 disks --insecure                                                                                                                                                                                          at 15:04:17
DEV        MODEL              SERIAL   TYPE   UUID   WWID   MODALIAS      NAME   SIZE     BUS_PATH                                                                 SUBSYSTEM          SYSTEM_DISK
/dev/sda   SAMSUNG MZ7TD256   -        SSD    -      -      scsi:t-0x00   -      256 GB   /pci0000:00/0000:00:17.0/ata1/host0/target0:0:0/0:0:0:0/                 /sys/class/block   
/dev/sdb   UDisk              -        HDD    -      -      scsi:t-0x00   -      16 GB    /pci0000:00/0000:00:14.0/usb1/1-11/1-11:1.0/host4/target4:0:0/4:0:0:0/   /sys/class/block   

~ > talosctl -n 172.16.11.11 disks --insecure                                                                                                                                                                                          at 15:04:22
DEV        MODEL              SERIAL   TYPE   UUID   WWID   MODALIAS      NAME   SIZE     BUS_PATH                                                               SUBSYSTEM          SYSTEM_DISK
/dev/sda   SAMSUNG MZ7PD256   -        SSD    -      -      scsi:t-0x00   -      256 GB   /pci0000:00/0000:00:17.0/ata1/host0/target0:0:0/0:0:0:0/               /sys/class/block   
/dev/sdb   SanDisk 3.2Gen1    -        HDD    -      -      scsi:t-0x00   -      62 GB    /pci0000:00/0000:00:14.0/usb2/2-6/2-6:1.0/host4/target4:0:0/4:0:0:0/   /sys/class/block   

~ > talosctl -n 172.16.11.12 disks --insecure                                                                                                                                                                                          at 15:04:27
DEV        MODEL              SERIAL   TYPE   UUID   WWID   MODALIAS      NAME   SIZE     BUS_PATH                                                               SUBSYSTEM          SYSTEM_DISK
/dev/sda   SAMSUNG MZ7PD256   -        SSD    -      -      scsi:t-0x00   -      256 GB   /pci0000:00/0000:00:17.0/ata1/host0/target0:0:0/0:0:0:0/               /sys/class/block   
/dev/sdb   SanDisk 3.2Gen1    -        HDD    -      -      scsi:t-0x00   -      62 GB    /pci0000:00/0000:00:14.0/usb2/2-6/2-6:1.0/host4/target4:0:0/4:0:0:0/   /sys/class/block   

~ > talosctl -n 172.16.11.13 disks --insecure                                                                                                                                                                                          at 15:04:31
DEV            MODEL                SERIAL                 TYPE   UUID   WWID   MODALIAS      NAME   SIZE     BUS_PATH                                                               SUBSYSTEM          SYSTEM_DISK
/dev/nvme0n1   PNY CS1031 1TB SSD   PNY2301230103010065A   NVME   -      -      -             -      1.0 TB   /pci0000:00/0000:00:1b.0/0000:02:00.0/nvme/nvme0/nvme0n1               /sys/class/block   
/dev/sda       SAMSUNG MZ7LN256     -                      SSD    -      -      scsi:t-0x00   -      256 GB   /pci0000:00/0000:00:17.0/ata1/host0/target0:0:0/0:0:0:0/               /sys/class/block   
/dev/sdb       Cruzer Blade         -                      HDD    -      -      scsi:t-0x00   -      7.8 GB   /pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/host6/target6:0:0/6:0:0:0/   /sys/class/block   

~ > talosctl -n 172.16.11.14 disks --insecure                                                                                                                                                                                          at 15:04:36
DEV            MODEL                SERIAL                 TYPE   UUID   WWID   MODALIAS      NAME   SIZE     BUS_PATH                                                               SUBSYSTEM          SYSTEM_DISK
/dev/nvme0n1   PNY CS1031 1TB SSD   PNY2301230103010067A   NVME   -      -      -             -      1.0 TB   /pci0000:00/0000:00:1b.0/0000:02:00.0/nvme/nvme0/nvme0n1               /sys/class/block   
/dev/sda       ESA3SMI2HTTBT240     -                      SSD    -      -      scsi:t-0x00   -      240 GB   /pci0000:00/0000:00:17.0/ata1/host0/target0:0:0/0:0:0:0/               /sys/class/block   
/dev/sdb       Cruzer Blade         -                      HDD    -      -      scsi:t-0x00   -      7.8 GB   /pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/host6/target6:0:0/6:0:0:0/   /sys/class/block   

~ > talosctl -n 172.16.11.15 disks --insecure                                                                                                                                                                                          at 15:04:39
DEV            MODEL                SERIAL                 TYPE   UUID   WWID   MODALIAS      NAME   SIZE     BUS_PATH                                                               SUBSYSTEM          SYSTEM_DISK
/dev/nvme0n1   PNY CS1031 1TB SSD   PNY23012301030100E10   NVME   -      -      -             -      1.0 TB   /pci0000:00/0000:00:1b.0/0000:02:00.0/nvme/nvme0/nvme0n1               /sys/class/block   
/dev/sda       ESA3SMI2HTTBT240     -                      SSD    -      -      scsi:t-0x00   -      240 GB   /pci0000:00/0000:00:17.0/ata1/host0/target0:0:0/0:0:0:0/               /sys/class/block   
/dev/sdb       Cruzer Blade         -                      HDD    -      -      scsi:t-0x00   -      16 GB    /pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/host6/target6:0:0/6:0:0:0/   /sys/class/block   

~ > talosctl -n 172.16.11.16 disks --insecure                                                                                                                                                                                          at 15:04:46
DEV            MODEL                  SERIAL                 TYPE   UUID   WWID   MODALIAS      NAME   SIZE     BUS_PATH                                                               SUBSYSTEM          SYSTEM_DISK
/dev/nvme0n1   PNY CS2241 1TB SSD     PNY23242306160103994   NVME   -      -      -             -      1.0 TB   /pci0000:00/0000:00:1b.0/0000:02:00.0/nvme/nvme0/nvme0n1               /sys/class/block   
/dev/nvme1n1   INTEL SSDPEKKF512G7L   BTPY81450FPB512F       NVME   -      -      -             -      512 GB   /pci0000:00/0000:00:1b.4/0000:03:00.0/nvme/nvme1/nvme1n1               /sys/class/block   
/dev/sda       Cruzer Blade           -                      HDD    -      -      scsi:t-0x00   -      7.8 GB   /pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/host4/target4:0:0/4:0:0:0/   /sys/class/block   

~ >
```
