# IN6-Linux Security Architecture & Hardening Model

## Overview
IN6-Linux implements a native Linux security architecture based on standard kernel isolation primitives rather than Android's SEAndroid/SELinux framework.

---

## Security Model Phases

### Phase 1: Development & Bring-Up Security
- **Kernel Enforcement**: Permissive mode (`enforcing=0` or `apparmor=0`) during initial hardware bring-up.
- **Root Shell Access**: Unrestricted root shell enabled over USB serial gadget (`/dev/ttyGS0`).
- **Purpose**: Unhindered driver debugging, register inspection, and log monitoring.

---

### Phase 2: Production Security Architecture

1. **Process Isolation & Sandboxing**
   - **Linux Namespaces**: User, PID, Network, Mount, and IPC namespaces for application isolation.
   - **Seccomp Filters**: System call filtering (`seccomp-bpf`) to restrict unprivileged processes.
   - **Linux Capabilities**: Fine-grained POSIX capabilities instead of monolithic root privilege.

2. **Access Control & MAC**
   - **AppArmor**: Lightweight Mandatory Access Control profile enforcement for services.
   - **udev Rules**: Granular `/dev` node permissions based on user groups (`input`, `audio`, `video`, `dialout`).

3. **Storage & Verification**
   - **Signed Boot Images**: Cryptographic verification of `boot.img` headers if hardware enforcement enabled.
   - **Read-Only System Partition**: `/system` mounted `ro` with `dm-verity` integrity protection.
   - **User Data Encryption**: LUKS2 / fscrypt encryption on `/data` (`/dev/mmcblk0p33`).
