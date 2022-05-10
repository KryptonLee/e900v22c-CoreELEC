# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)

PKG_NAME="UWE5621DS-aml"
PKG_VERSION="906c7db22fbe0a233955f20227c3b3d778d801e7"
PKG_SHA256="202187a989e748c3ad94b1271239decd2b15f6dc34e1b82d6061240e01b4fdb6"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/KryptonLee/uwe5621ds-aml"
PKG_URL="https://github.com/KryptonLee/uwe5621ds-aml/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
PKG_LONGDESC="Unisoc UWE5621DS Linux Driver"
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="manual"

make_target() {
  kernel_make -C $(kernel_path) \
    M=${PKG_BUILD} \
    CONFIG_SPARD_WLAN_SUPPORT=y \
    CONFIG_AML_WIFI_DEVICE_UWE5621=y \
    CONFIG_WLAN_UWE5622=m \
    SRC_PATH=${PKG_BUILD}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
    find ${PKG_BUILD}/ -name \*.ko -not -path '*/\.*' -exec cp {} ${INSTALL}/$(get_full_module_dir)/${PKG_NAME} \;

  mkdir -p ${INSTALL}/$(get_full_firmware_dir)/uwe5621ds
    cp ${PKG_BUILD}/wifi_56630001_3ant.ini ${INSTALL}/$(get_full_firmware_dir)/uwe5621ds
    cp ${PKG_BUILD}/wifimac.txt ${INSTALL}/$(get_full_firmware_dir)/uwe5621ds
}
