# EnergieMonitor
## Based on
Based on the [Entega Energiewende Monitor](https://energiewendemonitor.entega.ag)

[LCD Driver](https://github.com/the-raspberry-pi-guy/lcd)

## Hardware
Raspberry Pi

## Getting Started
Clone the repository with the drivers for the lcd display
```bash
cd /home/${USER}/
git clone https://github.com/the-raspberry-pi-guy/lcd.git
cd lcd/ 
```

Install the drivers

```bash
chmod +x setup.sh
sudo ./install.sh
```

Run the script
```bash
cd /home/${USER}/IoT/EnergieMonitor
python3 energieMonitor.py
```