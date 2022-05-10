# Build CoreELEC for skyworth e900v22c
CoreELEC is a 'Just enough OS' Linux distribution for running the award-winning [Kodi](https://kodi.tv) software on popular low-cost hardware. CoreELEC is a minor fork of [LibreELEC](https://libreelec.tv), it's built by the community for the community. [CoreELEC website](http://coreelec.org).  
  
Unfortunately, the official CoreELEC does not have the driver for unisoc uwe5621ds chip, which is commonly seen on IPTV boxes from China Mobile. This project aims to build CoreELEC system with uwe5621 driver.

## Device tree file for skyworth e900v22c
The device tree file in source code `common-files/e900v22c.dtb` has fixed the frequency of the uwe5621ds chip for skyworth e900v22c tv box, and it has been packed into the image file as `dtb.img`. Do not use the device tree file `device_tress/g12a_s905x2_2g.dtb` in the boot partition for skyworth e900v22c, otherwise the WIFI will fail when the data traffic becomes too large. More seriously the system will fail.

## WIFI MAC address
The WIFI MAC address is stored in the file `/lib/firmware/uwe5621ds/wifimac.txt`. However, it is not possible to edit this file directly as the filesystem is readonly in CoreELEC. The way to change WIFI MAC address is copying the file `/lib/firmware/uwe5621ds/wifimac.txt` to `/storage/.config/firmware/uwe5621ds/wifimac.txt`. Edit the MAC address in the latter one and then reboot CoreELEC.

## Remote keymap files
The remote keymap files has been packed into the image file. Unfortunately the numeric keys are not working with the virtual keyboard.

## Build instructions
1. Install the necessary packages (E.g Ubuntu 20.04 LTS user)
```yaml
sudo apt-get update -y
sudo apt-get install -y make gcc git texinfo gzip
```

2. Clone the repository to the local. `git clone https://github.com/KryptonLee/e900v22c-CoreELEC.git`

3. Enter the `~/e900v22c-CoreELEC` root directory and run Eg: `./build` to build CoreELEC.
