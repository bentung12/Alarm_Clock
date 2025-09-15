# Alarm Clock on FPGA

An FPGA implementation of a **24-hour alarm clock**, built in **SystemVerilog** and deployed on the **Terasic DE0-CV (Cyclone V)** board.  
This design demonstrates timekeeping, alarm functionality, LED indicators, and interactive controls via switches and keys.

---

## ⏰ Features

- **24-hour format** timekeeping (00:00 → 23:59).
- Displays time on **HEX3–HEX0** (HH:MM format).  
- **Current time setting**:
  - Controlled by `SW1`.
  - Use `KEY3` (increment hours) and `KEY2` (increment minutes).
- **Alarm setting**:
  - Controlled by `SW2`.
  - Use `KEY3` (increment hours) and `KEY2` (increment minutes).
  - While alarm is being set, current time continues running.
- **Alarm trigger**:
  - When current time = alarm time, **LED7** blinks until cleared.
- **Alarm clear**:
  - `KEY0` stops alarm and resets alarm time to `00:00`.
- **Reset**:
  - `SW0` resets both current time and alarm time to `00:00`.
- **Speed-up mode**:
  - `SW4` enables demo/debug mode (time runs ×120 faster).
- **LED status**:
  - `LED9` blinks once per second to indicate the clock is running.
  - `LED7` blinks when alarm condition is active.

---

## 🎛️ Switch & Button Mapping

| Control | Function |
|---------|----------|
| `SW0` | Global reset (resets current + alarm time to 00:00). |
| `SW1` | Current time set mode (freeze time, use keys to adjust). |
| `SW2` | Alarm set mode (adjust alarm, time keeps running). |
| `SW4` | 120× speed-up mode (minutes increment every 0.5 s). |
| `KEY0` | Alarm clear button (stops LED7 blinking, resets alarm). |
| `KEY2` | Increment minutes (in whichever mode is active). |
| `KEY3` | Increment hours (in whichever mode is active). |

⚠️ **Mutual exclusivity**:  
- Only one of `SW1` / `SW2` should be active at a time.  
- Only one of `KEY2` / `KEY3` should be pressed at a time.  

---

## 🖥️ Display & Indicators

- **HEX3:HEX2** → Hours (00–23)  
- **HEX1:HEX0** → Minutes (00–59)  
- **LED9** → Blinks at 1 Hz while clock is active  
- **LED7** → Blinks when alarm is triggered  

---

## 📂 Repository Structure

| File | Description |
|------|-------------|
| `alarm_clock.sv` | Top-level module (integrates counters, control logic, HEX display, LEDs). |
| `counter.sv` | Parameterized counter used for timekeeping. |
| `ourHex.sv` | Hexadecimal-to-7-segment driver for displaying digits on HEX displays. |
| `ourDff.sv` | Basic D flip-flop with reset (utility module). |
| `alarm_clock.qpf` | Quartus project file. |
| `alarm_clock.qsf` | Quartus settings + DE0-CV pin assignments. |
| `c5_pin_model_dump.txt` | Cyclone V pin model reference. |
| `Lab_3.pdf` | Original lab assignment and design specifications. |

---

## 🚀 Build & Run Instructions

1. Open the project in **Quartus Prime Standard (22.1 or compatible)**.
   - Load `alarm_clock.qpf`.
2. Connect the **DE0-CV board** via USB-Blaster.
3. Compile the project (`Ctrl+L` in Quartus).
4. Program the FPGA with the generated `.sof` bitstream.
5. Use the switches and keys to interact with the alarm clock:
   - Set current/alarm times.
   - Trigger and clear alarm.
   - Test accelerated time with `SW4`.

---

## 🐞 Troubleshooting

- **No display on HEX** → Check pin assignments in `.qsf`.  
- **LEDs not blinking** → Verify clock divider logic is running.  
- **Time not incrementing** → Ensure main counter is enabled and reset is off.  
- **Alarm not triggering** → Confirm `SW2` correctly sets alarm and comparator is working.  

---

## 👤 Author

FPGA project by **Benjamin Tung**.
