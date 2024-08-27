#!/bin/sh
set -e
clear

SOURCECODEURL=https://github.com/luochongjun/edgerouter.git

banner() {
  echo "+------------------------------------------+"
  printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
  echo "+------------------------------------------+"
}

GITHUB_WORKSPACE="$(pwd)"
SDK_FOLDERNAME=openwrt-sdk
SDK_ROOT=$GITHUB_WORKSPACE/$SDK_FOLDERNAME

# "============================================"
banner "Update System Packages"
#sudo -E apt-get update
#sudo -E apt-get install -y asciidoc bash bc binutils bzip2 fastjar flex gawk gcc genisoimage gettext git intltool jikespg libgtk2.0-dev libncurses5-dev libssl-dev
#sudo -E apt-get install -y make mercurial patch perl-modules python2.7-dev rsync ruby sdcc subversion unzip util-linux wget xsltproc zlib1g-dev zlib1g-dev

# "============================================"
banner "Get gl-sdk"
OPENWRT_SDK_URL=https://github.com/gl-inet-builder/openwrt-sdk-mt7981.git

cd $GITHUB_WORKSPACE
if [ ! -d $SDK_ROOT ]; then
  git clone ${OPENWRT_SDK_URL}  $SDK_FOLDERNAME
else
	echo "	Skipped. Folder exists at OpenWRT Target Directory"
fi

# https://cli.github.com/manual/gh_run_download
# gh run download 10340021810 --repo "kk246/gl-sdk-action"

# "============================================"
banner "Downloading newPKG"
PACKAGE_ROOT="$SDK_ROOT/package/newPKG"

if [ ! -d "$PACKAGE_ROOT" ]; then
  git clone ${SOURCECODEURL} $PACKAGE_ROOT
else
	echo "	Skipped. Folder exists at newPKG Target Directory"
fi

# "============================================"
banner "Make defconfig"
cd $SDK_ROOT
CONFIG_FILE="$SDK_ROOT/.config"
if [ ! -f "$CONFIG_FILE" ]; then
	make defconfig
else
	echo "	Skipped. '.config' already exists"
fi

# "============================================"
banner "Get Path"
PACKAGE_ROOT_USED=$PACKAGE_ROOT

cd $SDK_ROOT
PKG_OPENWRT_DIR="$PACKAGE_ROOT/openwrt"
if [ ! -f "$PKG_OPENWRT_DIR" ]; then
	cd "$PKG_OPENWRT_DIR"
fi

# Find the Makefile containing PKG_NAME
MAKEFILE=$(find "$(pwd)" -type f -name 'Makefile' -exec grep -l 'PKG_NAME' {} +)

# Check if exactly one Makefile was found
if [ "$(echo "$MAKEFILE" | wc -l)" -eq 1 ]; then
	# Extract the directory containing the Makefile
	MAKEFILE_DIR=$(dirname "$MAKEFILE")

	# Extract PKG_NAME value from the Makefile
	PKG_NAME_VALUE=$(grep 'PKG_NAME' "$MAKEFILE" | awk -F'=' '{print $2}' | tr -d '[:space:]')

	# Store the values in variables
	MY_VARIABLE="$PKG_NAME_VALUE"
	RELATIVE_DIR=$(realpath --relative-to="$SDK_ROOT" "$MAKEFILE_DIR")
	PACKAGE_ROOT_USED=$RELATIVE_DIR

	echo "PKG_NAME is set to: $MY_VARIABLE"
	echo "Relative directory containing the Makefile: $RELATIVE_DIR"
else
	echo "Either no Makefile or multiple Makefiles found."
fi

# "============================================"
banner "Prepare newPKG"
cd $SDK_ROOT
echo make $PACKAGE_ROOT_USED/prepare V=s
make $PACKAGE_ROOT_USED/prepare V=s

# "============================================"
banner "Compile newPKG"
cd $SDK_ROOT
make $PACKAGE_ROOT_USED/compile V=s

# "============================================"
banner "Finished"
cd $SDK_ROOT
mkdir "${GITHUB_WORKSPACE}/output_ipks"
find bin -type f -exec ls -lh {} \;
find bin -type f -name "*.ipk" -exec cp -f {} "${GITHUB_WORKSPACE}/output_ipks" \; 
ls -al "${GITHUB_WORKSPACE}/output_ipks/"
