#!/usr/bin/env bash
# SPDX-License-Identifier: MIT

_RST_='\033[0m'
Red='\033[38;5;1m'
Yellow='\033[38;5;3m'
Cyan='\033[38;5;6m'

pr_error() { printf "${Red}ERROR: %s${_RST_}\n" "$1"; }
pr_warn() { printf "${Yellow}WARNING: %s${_RST_}\n" "$1"; }
pr_info() { printf "${Cyan}INFO: %s${_RST_}\n" "$1"; }

BUILD_ARCH="${1:-aarch64}"
APORTS_DIR="./aports-trvn/custom"
OUT_DIR="./packages"
PRIVATE_KEY="travmurav@trvn.ru.rsa"
APK_BIN="$(pmbootstrap config work)/apk.static"

pr_info "Building packages for arch $BUILD_ARCH..."

packages="$(basename -a $APORTS_DIR/*)"

pr_info "$(echo "$packages" | wc -w) packages in the aports."

pmbootstrap build --arch "$BUILD_ARCH" $packages

pr_info "Copying the packages..."

mkdir -p $OUT_DIR/$BUILD_ARCH

for pkg in $packages
do
	cp $(pmbootstrap config work)/packages/edge/$BUILD_ARCH/$pkg* \
		$OUT_DIR/$BUILD_ARCH/
done

pr_info "Generating the (unsigned) index..."

$APK_BIN index \
	--allow-untrusted \
	--no-warnings \
	-d "travmurav-$(date -I)" \
	-o $OUT_DIR/$BUILD_ARCH/APKINDEX.tar.gz \
	-x $OUT_DIR/$BUILD_ARCH/APKINDEX.tar.gz \
	$OUT_DIR/$BUILD_ARCH/*.apk

pr_info "Signing the index..."

docker run \
	-it --rm \
	-v $(pwd):/mnt \
	alpine:latest \
	ash -c "apk add abuild; abuild-sign -k /mnt/$PRIVATE_KEY /mnt/packages/$BUILD_ARCH/APKINDEX.tar.gz"

pr_info "DONE!"
