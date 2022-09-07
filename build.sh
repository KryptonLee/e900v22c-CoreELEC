#! /bin/sh
version="19.5-Matrix_rc2"
script_root="${PWD}"
source_img_name="CoreELEC-Amlogic-ng.arm-${version}-Generic"
source_img_file="${script_root}/${source_img_name}.img.gz"
source_img_url="https://github.com/CoreELEC/CoreELEC/releases/download/${version}/${source_img_name}.img.gz"
target_img_prefix="CoreELEC-Amlogic-ng.arm-${version}"
target_img_name="${target_img_prefix}-E900V22C-$(date +%Y.%m.%d)"
mount_point="${script_root}/mnt"
dtb_file="${script_root}/common-files/e900v22c.dtb"
cache_cfg="${script_root}/common-files/advancedsettings.xml"
rc_maps_cfg="${script_root}/common-files/rc_maps.cfg"
rc_keymap_file="${script_root}/common-files/e900v22c.rc_keymap"
remap_backspace_file="${script_root}/common-files/backspace.xml"
wifi_module_load_file="${script_root}/common-files/wifi_dummy.conf"
bt_service_file="${script_root}/common-files/sprd_sdio-firmware-aml.service"

download_source_img() {
	echo "Downloading CoreELEC-${version} generic image"
	wget ${source_img_url} -O ${source_img_file} | exit 1
}

decompress_img() {
	echo "Decompressing CoreELEC image"
	gzip -d ${source_img_file}
}

add_dtb2img() {
	echo "Creating mount point"
	mkdir ${mount_point}
	echo "Mounting CoreELEC boot partition"
	sudo mount -o loop,offset=4194304 ${script_root}/${source_img_name}.img ${mount_point}

	echo "Copying E900V22C DTB file"
	sudo cp ${dtb_file} ${mount_point}/dtb.img

	echo "Unmounting CoreELEC boot partition"
	sudo umount -d ${mount_point}
	echo "Deleting mount point"
	rm -rf ${mount_point}
}

add_custom_cfg2img() {
	echo "Creating mount point"
	mkdir ${mount_point}
	echo "Mounting CoreELEC data partition"
	sudo mount -o loop,offset=541065216 ${script_root}/${source_img_name}.img ${mount_point}

	echo "Creating userdata directory for kodi"
	sudo mkdir -p -m 0755 ${mount_point}/.kodi/userdata
	echo "Copying kodi cache config file"
	sudo cp ${cache_cfg} ${mount_point}/.kodi/userdata/advancedsettings.xml
	sudo chmod 0644 ${mount_point}/.kodi/userdata/advancedsettings.xml

	echo "Creating rc_keymaps directories"
	sudo mkdir -p -m 0775 ${mount_point}/.config/rc_keymaps
	sudo mkdir -p -m 0755 ${mount_point}/.kodi/userdata/keymaps
	echo "Copying rc_keymap files"
	sudo cp ${rc_maps_cfg} ${mount_point}/.config/rc_maps.cfg
	sudo chmod 0664 ${mount_point}/.config/rc_maps.cfg
	sudo cp ${rc_keymap_file} ${mount_point}/.config/rc_keymaps/e900v22c
	sudo chmod 0664 ${mount_point}/.config/rc_keymaps/e900v22c
	sudo cp ${remap_backspace_file} ${mount_point}/.kodi/userdata/keymaps/backspace.xml
	sudo chmod 0644 ${mount_point}/.kodi/userdata/keymaps/backspace.xml

	echo "Creating modules-load.d directory"
	sudo mkdir -p -m 0775 ${mount_point}/.config/modules-load.d
	echo "Copying module-load file for uwe5621ds"
	sudo cp ${wifi_module_load_file} ${mount_point}/.config/modules-load.d/wifi_dummy.conf
	sudo chmod 0644 ${mount_point}/.config/modules-load.d/wifi_dummy.conf

	echo "Creating system.d directory"
	sudo mkdir -p -m 0775 ${mount_point}/.config/system.d/multi-user.target.wants
	echo "Copying bluetooth service file for uwe5621ds"
	sudo cp ${bt_service_file} ${mount_point}/.config/system.d/sprd_sdio-firmware-aml.service
	sudo chmod 0644 ${mount_point}/.config/system.d/sprd_sdio-firmware-aml.service
	sudo ln -s /storage/.config/system.d/sprd_sdio-firmware-aml.service ${mount_point}/.config/system.d/multi-user.target.wants/sprd_sdio-firmware-aml.service

	echo "Unmounting CoreELEC boot partition"
	sudo umount -d ${mount_point}
	echo "Deleting mount point"
	rm -rf ${mount_point}
}

rename_img() {
	echo "Rename image file"
	mv ${script_root}/${source_img_name}.img ${script_root}/${target_img_name}.img
}

compress_img() {
	echo "Compressing CoreELEC image"
	gzip ${script_root}/${target_img_name}.img
	sha256sum ${script_root}/${target_img_name}.img.gz > ${script_root}/${target_img_name}.img.gz.sha256
}

echo "Welcome to build CoreELEC for Skyworth E900V22C!"
download_source_img
decompress_img
add_dtb2img
add_custom_cfg2img
rename_img
compress_img
