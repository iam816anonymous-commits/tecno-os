# IN6-Linux Privacy Model & Telemetry Specification

## Overview
Privacy in **IN6-Linux** is an absolute architectural requirement enforced at the system service and kernel boundary.

---

## Default Privacy Configuration

- **Telemetry**: **STRICTLY OFF**
- **Analytics**: **STRICTLY OFF**
- **Crash Reporting**: **STRICTLY OFF (Local Logging Only)**
- **Cloud Sync**: **STRICTLY OFF**
- **Advertising Identifiers**: **PERMANENTLY DISABLED**
- **Location Tracking**: **DENIED BY DEFAULT**
- **Microphone Access**: **DENIED UNLESS GRANTED**
- **Camera Access**: **DENIED UNLESS GRANTED**
- **Contacts / SMS / Calls**: **DENIED UNLESS GRANTED**

---

## Local Logging & Privacy Dashboard
1. **Zero Automatic Data Transmission**: No log, crash dump, or diagnostic data is ever transmitted over network connections automatically.
2. **Local Log Export**: Logs are stored locally in `/var/log/` and can only be exported manually by the user.
3. **Privacy Dashboard**: A central UI dashboard displays real-time hardware status, active permission grants, blocked network attempts, and sensor access history.
