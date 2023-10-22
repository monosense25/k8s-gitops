# Wired Network 

## 🔧 Switch HQ

### TL-SG3428X (AGG)

| Source Device           | Source Port | Destination Device | Destination Port | Type            | Remarks              | VLAN    |
| ------------------------| ----------- | ------------------ | ---------------- | --------------- | -------------------- | ------- |
| AGG                     | 1           | OAP01              | eth0             | 1Gbps (CAT6)    | Litebeam 5AC Gen2    | All     |
|                         | 2           | K8S-M0             | eth0             | 1Gbps (CAT6)    |                      | K8S     |
|                         | 3           | K8S-M1             | eth0             | 1Gbps (CAT6)    |                      | K8S     |
|                         | 4           | K8S-M2             | eth0             | 1Gbps (CAT6)    |                      | K8S     |
|                         | 5           | SAN-IPMI           | IDRAC            | 1Gbps (CAT6)    |                      | MGMT    |
|                         | 6           | VG-IPMI            | eth0             | 1Gbps (CAT6)    |                      | MGMT    |
|                         | 7           | K8S-W3-IPMI        | eth0             | 1Gbps (CAT6)    |                      | MGMT    |
|                         | 8           | TVROOM-1           | -                | 1Gbps (CAT6)    | Smart TV             | IOT     |
|                         | 9           | TVROOM-2           | -                | 1Gbps (CAT6)    | PS4Pro               | IOT     |
|                         | 10          | TVROOM-3           | -                | 1Gbps (CAT6)    | -                    | IOT     |
|                         | 12          | FRZ-1              | -                | 1Gbps (CAT6)    | -                    | HOME    |
|                         | 13          | FRZ-2              | -                | 1Gbps (CAT6)    | -                    | HOME    |
|                         | 14          | P53                |                  | 1Gbps (CAT6)    |                      | MGMT    |
|                         | 15          | WORKSTATION        |                  | 1Gbps (CAT6)    |                      | MGMT    |
|                         | 16          |                    |                  | 1Gbps (CAT6)    |                      |         |
|                         | 17          |                    |                  | 1Gbps (CAT6)    |                      |         |
|                         | 18          |                    |                  | 1Gbps (CAT6)    |                      |         |
|                         | 19          |                    |                  | 1Gbps (CAT6)    |                      |         |
|                         | 20          |                    |                  | 1Gbps (CAT6)    |                      |         |
|                         | 21          |                    |                  | 1Gbps (CAT6)    |                      |         |
|                         | 22          |                    |                  | 1Gbps (CAT6)    |                      |         |
|                         | 23          | POE                | 9                | 1Gbps (CAT6)    | LAGG                 | All     |
|                         | 24          | POE                | 10               | 1Gbps (CAT6)    | LAGG                 | All     |
|                         | 25          | VG                 | eth1             | 10Gbps (SFP+)   |                      | All     |
|                         | 26          | VG                 | eth2             | 10Gbps (SFP+)   |                      | All     |
|                         | 27          | TOR01              | 8                | 10Gbps (SFP+)   |                      | All     |
|                         | 28          | TOR02              | 8                | 10Gbps (SFP+)   |                      | All     |
---

### TL-SX3008F (TOR01)
| Source Device           | Source Port | Destination Device | Destination Port | Type            | Remarks              | VLAN    |
| ------------------------| ----------- | ------------------ | ---------------- | --------------- | -------------------- | ------- |
| TOR01                   | 1           | K8S-W0             | eth1             | 10Gbps (SFP+)   |                      | K8S     |
|                         | 2           | K8S-W1             | eth1             | 10Gbps (SFP+)   |                      | K8S     |
|                         | 3           | K8S-W2             | eth1             | 10Gbps (SFP+)   |                      | K8S     |
|                         | 4           | K8S-W3             | eth1             | 10Gbps (SFP+)   |                      | K8S     |
|                         | 5           | -                  | -                | 10Gbps (SFP+)   |                      | -       |
|                         | 6           | CSI                | LAN5             | 10Gbps (SFP+)   |                      | INFRA   |
|                         | 7           | SAN                | ix0              | 10Gbps (SFP+)   |                      | INFRA   |
|                         | 8           | AGG                | 27               | 10Gbps (SFP+)   |                      | All     |
---

### TL-SX3008F (TOR02)
| Source Device           | Source Port | Destination Device | Destination Port | Type            | Remarks              | VLAN    |  
| ------------------------| ----------- | ------------------ | ---------------- | --------------- | -------------------- | ------- |
| TOR02                   | 1           | K8S-W0             | eth2             | 10Gbps (SFP+)   |                      | K8S     |
|                         | 2           | K8S-W1             | eth2             | 10Gbps (SFP+)   |                      | K8S     |
|                         | 3           | K8S-W2             | eth2             | 10Gbps (SFP+)   |                      | K8S     |
|                         | 4           | K8S-W3             | eth2             | 10Gbps (SFP+)   |                      | K8S     |
|                         | 5           | -                  | -                | 10Gbps (SFP+)   |                      | -       |
|                         | 6           | CSI                | LAN6             | 10Gbps (SFP+)   |                      | IOT     |
|                         | 7           | SAN                | ix1              | 10Gbps (SFP+)   |                      | IOT     |
|                         | 8           | AGG                | 28               | 10Gbps (SFP+)   |                      | All     |
---

### TL-SG2210MP (POE)
| Source Device           | Source Port | Destination Device | Destination Port | Type            | Remarks              | VLAN    |
| ------------------------| ----------- | ------------------ | ---------------- | --------------- | -------------------- | ------- |
| POE                     | 1           | IAP01              |                  | 1Gbps (CAT6)    | TP-LINK EAP 653      | All     |
|                         | 2           | IPC01              |                  | 1Gbps (CAT6)    | IP Camera 1          | CCTV    |
|                         | 3           | IPC02              |                  | 1Gbps (CAT6)    | IP Camera 2          | CCTV    |
|                         | 4           | IPC03              |                  | 1Gbps (CAT6)    | IP Camera 3          | CCTV    |
|                         | 5           | NVR                | eth0             | 1Gbps (CAT6)    | NVR                  | CCTV    |
|                         | 6           | -                  | -                | 1Gbps (CAT6)    |                      | -       |
|                         | 7           | -                  | -                | 1Gbps (CAT6)    |                      | -       |
|                         | 8           | -                  | -                | 1Gbps (CAT6)    |                      | -       |
|                         | 9           | AGG                | 23               | 1Gbps (SFP)     | 1GBase-T Module      | All     |
|                         | 10          | AGG                | 24               | 1Gbps (SFP)     | 1GBase-T Module      | All     |
---

## 🔧 Switch Branch01

### HP 1910-8G-PoE+ (BSW01)
| Source Device           | Source Port | Destination Device | Destination Port | Type            | Remarks              | VLAN    |
| ------------------------| ----------- | ------------------ | ---------------- | --------------- | -------------------- | ------- |
| BSW01                   | 1           | -                  | -                | 1Gbps (CAT6)    |                      | -       |
|                         | 2           | -                  | -                | 1Gbps (CAT6)    |                      | -       |
|                         | 3           | -                  | -                | 1Gbps (CAT6)    |                      | -       |
|                         | 4           | -                  | -                | 1Gbps (CAT6)    |                      | -       |
|                         | 5           | IPC04              |                  | 1Gbps (CAT6)    | IP Camera 4          | CCTV    |
|                         | 6           | IPC05              |                  | 1Gbps (CAT6)    | IP Camera 5          | CCTV    |
|                         | 7           | IAP02              |                  | 1Gbps (CAT6)    | Cisco 1831           | All     |
|                         | 8           | OAP02              |                  | 1Gbps (CAT6)    | Litebeam 5AC Gen2    | All     |
|                         | 9           | -                  | -                | 1Gbps (SFP)     |                      | -       |
---