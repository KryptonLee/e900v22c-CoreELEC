#! /bin/sh
version="19.4-Matrix"
coreelec_name="CoreELEC-${version}"
coreelec_code_path="${PWD}/${coreelec_name}"
coreelec_source_file="${PWD}/${coreelec_name}.tar.gz"
coreelec_source_url="https://github.com/CoreELEC/CoreELEC/archive/refs/tags/${version}.tar.gz"
amlogic_driver_path="${coreelec_code_path}/projects/Amlogic-ce/packages/linux-drivers/amlogic"
patch_file="${PWD}/patches/19.4/0001-fix-compile-error.patch"

add_driver_package() {
	echo "Copying uwe5621ds wifi driver source code"
	cp -rf ./UWE5621DS-aml ${amlogic_driver_path}
}

apply_patches() {
	echo "Applying patches"
	git apply --directory=${coreelec_name} ${patch_file}
}

download_source_code() {
	if [ -d "${coreelec_code_path}" ]; then
		echo "Using CoreELEC-${version} source code in local directory"
	else
		echo "Start downloading CoreELEC-${version} source code"
		wget ${coreelec_source_url} -O ${coreelec_source_file}
		tar -zxf ${coreelec_source_file}
		add_driver_package
		apply_patches
		rm -f ${coreelec_source_file}
	fi
}

echo "Welcome to build CoreELEC for Skyworth E900V22C!"
download_source_code
echo "Start building CoreELEC"
cd ${coreelec_code_path}
CUSTOM_GIT_HASH="_"
export CUSTOM_GIT_HASH
make image
