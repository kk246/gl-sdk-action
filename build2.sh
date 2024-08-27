#!/bin/sh

SOURCECODEURL = https://github.com/luochongjun/edgerouter.git

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
OPENWRT_SDK_URL = https://github.com/gl-inet-builder/openwrt-sdk-mt7981.git

cd $GITHUB_WORKSPACE
git clone ${OPENWRT_SDK_URL}  $SDK_FOLDERNAME

# https://cli.github.com/manual/gh_run_download
# gh run download 10340021810 --repo "kk246/gl-sdk-action"

# "============================================"
banner "Downloading newPKG"
cd $SDK_ROOT/package
git clone ${SOURCECODEURL} newPKG

# "============================================"
banner "Compile newPKG"
cd $SDK_ROOT
make defconfig
make package/newPKG/prepare V=s
make package/newPKG/compile V=s

# "============================================"
banner "Finished"
