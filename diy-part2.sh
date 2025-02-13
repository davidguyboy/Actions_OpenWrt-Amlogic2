#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile

# Set DISTRIB_REVISION
#sed -i "s/OpenWrt/Deng Build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/default-settings/files/zzz-default-settings

# Modify default IP（FROM 192.168.1.1 CHANGE TO 10.0.0.1）
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template


# 拉取软件包

git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
git clone https://github.com/kenzok8/small-package.git package/openwrt-packages
#git clone -b luci https://github.com/pexcn/openwrt-chinadns-ng.git package/luci-app-chinadns-ng
#svn co https://github.com/immortalwrt-collections/openwrt-gowebdav/trunk/luci-app-gowebdav package/luci-app-gowebdav
#svn co https://github.com/immortalwrt-collections/openwrt-gowebdav/trunk/gowebdav package/gowebdav
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-openvpn-server package/luci-app-openvpn-server
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-turboacc package/luci-app-turboacc
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-frpc feeds/luci/applications/luci-app-frpc
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-frps feeds/luci/applications/luci-app-frps
svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-upnp feeds/luci/applications/luci-app-upnp
git clone https://github.com/cnsilvan/luci-app-unblockneteasemusic.git package/unblockneteasemusic-go


# 删除重复包

rm -rf feeds/luci/themes/luci-theme-argon
rm -rf package/openwrt-packages/luci-app-openvpn-server
rm -rf package/openwrt-packages/openvpn-easy-rsa-whisky
rm -rf package/openwrt-packages/luci-app-argon*
rm -rf package/openwrt-packages/luci-theme-argon*
rm -rf package/openwrt-packages/luci-app-amlogic
rm -rf package/openwrt-packages/luci-app-unblockneteasemusic
rm -rf feeds/luci/applications/luci-app-dockerman
rm -rf feeds/luci/applications/luci-app-frpc
rm -rf feeds/luci/applications/luci-app-frps
rm -rf feeds/luci/applications/luci-app-upnp


# 其他调整

NAME=$"package/luci-app-unblockneteasemusic/root/usr/share/unblockneteasemusic" && mkdir -p $NAME/core
curl 'https://api.github.com/repos/UnblockNeteaseMusic/server/commits?sha=enhanced&path=precompiled' -o commits.json
echo "$(grep sha commits.json | sed -n "1,1p" | cut -c 13-52)">"$NAME/core_local_ver"
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/app.js -o $NAME/core/app.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/precompiled/bridge.js -o $NAME/core/bridge.js
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/ca.crt -o $NAME/core/ca.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.crt -o $NAME/core/server.crt
curl -L https://github.com/UnblockNeteaseMusic/server/raw/enhanced/server.key -o $NAME/core/server.key

sed -i 's#https://github.com/breakings/OpenWrt#https://github.com/quanjindeng/Actions_OpenWrt-Amlogic2#g' package/luci-app-amlogic/luci-app-amlogic/root/etc/config/amlogic
sed -i 's#ARMv8#openwrt_armvirt#g' package/luci-app-amlogic/luci-app-amlogic/root/etc/config/amlogic
sed -i 's#opt/kernel#kernel#g' package/luci-app-amlogic/luci-app-amlogic/root/etc/config/amlogic

sed -i 's#../../#$(TOPDIR)/feeds/luci/#g' package/luci-app-openvpn-server/Makefile
sed -i 's#../../#$(TOPDIR)/feeds/luci/#g' package/luci-app-turboacc/Makefile
sed -i 's#mount -t cifs#mount.cifs#g' package/openwrt-packages/luci-app-cifs-mount/root/etc/init.d/cifs

sed -i 's#<%+cbi/tabmenu%>##g' package/openwrt-packages/luci-app-nginx-manager/luasrc/view/nginx-manager/index.htm
