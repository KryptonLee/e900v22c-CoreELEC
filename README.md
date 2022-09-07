# Build CoreELEC for skyworth e900v22c
CoreELEC is a 'Just enough OS' Linux distribution for running the award-winning [Kodi](https://kodi.tv) software on popular low-cost hardware. CoreELEC is a minor fork of [LibreELEC](https://libreelec.tv), it's built by the community for the community. [CoreELEC website](http://coreelec.org).  

## Device tree file for skyworth e900v22c
The device tree file in source code `common-files/e900v22c.dtb` has fixed the frequency of the uwe5621ds chip for skyworth e900v22c tv box, and it has been packed into the image file as `dtb.img`. Do not use the device tree file `device_tress/g12a_s905x2_2g.dtb` in the boot partition for skyworth e900v22c, otherwise the WIFI will fail. More seriously the system will crash.

## Remote keymap files
The remote keymap files has been packed into the image file. Unfortunately the numeric keys are not working with the virtual keyboard.

## Build instructions
1. Install the necessary packages (E.g Ubuntu 20.04 LTS user)
```yaml
sudo apt-get update -y
sudo apt-get install -y make gcc git texinfo gzip squashfs-tools
```

2. Clone the repository to the local. `git clone https://github.com/KryptonLee/e900v22c-CoreELEC.git`

3. Enter the `~/e900v22c-CoreELEC` root directory and run: `./build` to build CoreELEC.
