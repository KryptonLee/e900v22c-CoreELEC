#! /bin/sh
version="19.4-Matrix"
script_root="${PWD}"
coreelec_name="CoreELEC-${version}"
coreelec_code_path="${script_root}/${coreelec_name}"
coreelec_source_file="${script_root}/${coreelec_name}.tar.gz"
coreelec_source_url="https://github.com/CoreELEC/CoreELEC/archive/refs/tags/${version}.tar.gz"
amlogic_driver_path="${coreelec_code_path}/projects/Amlogic-ce/packages/linux-drivers/amlogic"
patch_file="${script_root}/patches/19.4/0001-fix-compile-error.patch"
output_dir="${script_root}/output"
image_prefix="CoreELEC-Amlogic-ng.arm-19.4-Matrix"
image_name="${image_prefix}-E900V22C-$(date +%Y.%m.%d)"
mount_point="${script_root}/mnt"
dtb_file="${script_root}/common-files/e900v22c.dtb"
cache_cfg="${script_root}/common-files/advancedsettings.xml"
rc_maps_cfg="${script_root}/common-files/rc_maps.cfg"
rc_keymap_file="${script_root}/common-files/e900v22c.rc_keymap"
remap_backspace_file="${script_root}/common-files/backspace.xml"

add_driver_package() {
	echo "Copying uwe5621ds wifi driver source code"
	cp -rf ./UWE5621DS-aml ${amlogic_driver_path}
}

apply_patches() {
	echo "Applying patches"
	git apply --directory=${coreelec_name} ${patch_file}
}

download_source_code() {
	echo "Start downloading CoreELEC-${version} source code"
	wget ${coreelec_source_url} -O ${coreelec_source_file}
	tar -zxf ${coreelec_source_file}
	rm -f ${coreelec_source_file}
}

prepare_source_code() {
	if [ -d "${coreelec_code_path}" ]; then
		echo "Using CoreELEC-${version} source code in local directory"
	else
		download_source_code
		add_driver_package
		apply_patches
	fi
}

build_coreelec() {
	echo "Starting building CoreELEC"
	cd ${coreelec_code_path}
	CUSTOM_GIT_HASH="_"
	export CUSTOM_GIT_HASH
	make image || exit 1
}

move_img2out_dir() {
	if [ ! -d "${script_root}/output" ]; then
		echo "Creating output directory"
		mkdir ${output_dir}
	fi
	echo "Moving CoreELEC image to output directory"
	mv ${coreelec_code_path}/target/${image_prefix}*-Generic.img.gz \
		${output_dir}/${image_name}.img.gz
}

delete_unneeded_img() {
	echo "Deleting unneeded CoreELEC images"
	rm -f ${coreelec_code_path}/target/*
}

decompress_img() {
	echo "Decompressing CoreELEC image"
	gzip -d ${output_dir}/${image_name}.img.gz
}

add_dtb2img() {
	echo "Creating mount point"
	mkdir ${mount_point}
	echo "Mounting CoreELEC boot partition"
	sudo mount -o loop,offset=4194304 ${output_dir}/${image_name}.img ${mount_point}
	echo "Copying DTB file into boot partition"
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
	sudo mount -o loop,offset=541065216 ${output_dir}/${image_name}.img ${mount_point}
	echo "Creating userdata directory in data partition"
	sudo mkdir -p -m 0755 ${mount_point}/.kodi/userdata
	echo "Copying cache config file into data partition"
	sudo cp ${cache_cfg} ${mount_point}/.kodi/userdata/advancedsettings.xml
	sudo chmod 0644 ${mount_point}/.kodi/userdata/advancedsettings.xml
	echo "Creating rc_keymaps directory in data partition"
	sudo mkdir -p -m 0775 ${mount_point}/.config/rc_keymaps
	sudo mkdir -p -m 0755 ${mount_point}/.kodi/userdata/keymaps
	echo "Copying rc_keymap files into data partition"
	sudo cp ${rc_maps_cfg} ${mount_point}/.config/rc_maps.cfg
	sudo chmod 0664 ${mount_point}/.config/rc_maps.cfg
	sudo cp ${rc_keymap_file} ${mount_point}/.config/rc_keymaps/e900v22c
	sudo chmod 0664 ${mount_point}/.config/rc_keymaps/e900v22c
	sudo cp ${remap_backspace_file} ${mount_point}/.kodi/userdata/keymaps/backspace.xml
	sudo chmod 0644 ${mount_point}/.kodi/userdata/keymaps/backspace.xml
	echo "Unmounting CoreELEC boot partition"
	sudo umount -d ${mount_point}
	echo "Deleting mount point"
	rm -rf ${mount_point}
}

compress_img() {
	echo "Compressing CoreELEC image"
	gzip ${output_dir}/${image_name}.img
	sha256sum ${output_dir}/${image_name}.img.gz > ${output_dir}/${image_name}.img.gz.sha256
}

echo "Welcome to build CoreELEC for Skyworth E900V22C!"
prepare_source_code
build_coreelec
move_img2out_dir
delete_unneeded_img
decompress_img
add_dtb2img
add_custom_cfg2img
compress_img
