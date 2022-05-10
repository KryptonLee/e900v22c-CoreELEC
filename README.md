# Build CoreELEC for Skyworth e900v22c
CoreELEC is a 'Just enough OS' Linux distribution for running the award-winning [Kodi](https://kodi.tv) software on popular low-cost hardware. CoreELEC is a minor fork of [LibreELEC](https://libreelec.tv), it's built by the community for the community. [CoreELEC website](http://coreelec.org).  
  
Unfortunately, the official CoreELEC does not have the driver for unisoc uwe5621ds chip, which is commonly seen on IPTV boxes from China Mobile. This project aims to build CoreELEC system with uwe5621 driver.

## Build instructions
1. Install the necessary packages (E.g Ubuntu 20.04 LTS user)
```yaml
sudo apt-get update -y
sudo apt-get install -y make gcc git texinfo
```

2. Clone the repository to the local. `git clone https://github.com/KryptonLee/e900v22c-CoreELEC.git`

3. Enter the `~/e900v22c-CoreELEC` root directory and run Eg: `./build` to build CoreELEC.
