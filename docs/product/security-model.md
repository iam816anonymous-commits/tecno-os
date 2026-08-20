# IN6-Linux Security Architecture & Sandboxing Model

## Security Architecture Stack

```
+-------------------------------------------------------------+
|                 Restricted Application Sandbox              |
|        (AppArmor Profile / Seccomp BPF / Network NS)        |
+-------------------------------------------------------------+
|                Central Permission IPC Broker                |
|           (Capability Verification & Grant Token)           |
+-------------------------------------------------------------+
|               Linux Security Modules (LSM)                  |
|          (AppArmor / POSIX Capabilities / cgroups v2)       |
+-------------------------------------------------------------+
|                    Linux Kernel (MT6763)                    |
|             (User Namespaces / dm-verity / LUKS)            |
+-------------------------------------------------------------+
```

---

## Core Security Primitives

1. **Linux Namespaces**: User, PID, Mount, Network, IPC, and UTS namespaces isolate each application's environment.
2. **Seccomp-BPF Filters**: System call filtering restricts unprivileged applications from making dangerous kernel calls.
3. **AppArmor MAC Profiles**: Mandatory Access Control profiles restrict application access to specific paths in `/sys`, `/dev`, and `/proc`.
4. **POSIX Capabilities**: Fine-grained capabilities (`CAP_NET_RAW`, `CAP_SYS_ADMIN`) are stripped from unprivileged processes.
5. **Secure Boot & Trust Model**:
   - Device owner holds cryptographic keys for verifying system image updates.
   - Bootloader remains unlocked to ensure user ownership.
