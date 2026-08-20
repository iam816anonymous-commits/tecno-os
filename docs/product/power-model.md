# IN6-Linux Power Management & Battery Life Specification

## Overview
Battery longevity is a primary requirement for **IN6-Linux** on the TECNO IN6 (3050 mAh battery). Power management is active across all system services.

---

## Power Subsystem Architecture

1. **System Suspend & Wake (`/sys/power/state`)**:
   - Deep sleep (`mem` suspend) enabled when display is powered off.
   - Wakeup sources restricted to Power Key, RTC alarm, incoming calls, and charger insertion.
2. **CPU Frequency Scaling (`cpufreq`)**:
   - Uses `schedutil` governor across all 8 Cortex-A53 cores.
   - Dynamically scales cluster frequencies (Big cores up to 2.0GHz, Little cores up to 1.5GHz).
3. **Thermal Throttling (`thermal-zones`)**:
   - Monitors MT6763 thermal sensors and MT6358 PMIC junction temperature.
   - Automatically throttles CPU/GPU frequencies when temperature exceeds 65°C.
4. **Display Power Management**:
   - MIPI DSI panel enters ULPS (Ultra-Low Power State) when screen turns off.
