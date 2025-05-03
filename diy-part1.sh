#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

function preset_nikki() {
  mkdir -p files/etc/nikki/run
  curl -Lso files/etc/nikki/run/GeoSite.dat https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
  curl -Lso files/etc/nikki/run/GeoIP.dat https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip-lite.dat
  curl -Lso files/etc/nikki/run/geoip.metadb https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip-lite.metadb
  curl -Lso files/etc/nikki/run/ASN.mmdb https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb
  curl -Lso dist.zip https://github.com/Zephyruso/zashboard/releases/latest/download/dist-cdn-fonts.zip
  unzip dist.zip
  rm -f dist.zip
  mv dist files/etc/nikki/run/ui
}

# 使用 O2 级别的优化
sed -i 's,Os,O2 -march=x86-64-v2,g' include/target.mk

# 关闭 Spectre & Meltdown 补丁
sed -i 's,noinitrd,noinitrd mitigations=off,g' target/linux/x86/image/grub-efi.cfg
sed -i 's,noinitrd,noinitrd mitigations=off,g' target/linux/x86/image/grub-iso.cfg
sed -i 's,noinitrd,noinitrd mitigations=off,g' target/linux/x86/image/grub-pc.cfg

# add nikki
sed -i "/nikki/d" "feeds.conf.default"
echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >>"feeds.conf.default"
preset_nikki
