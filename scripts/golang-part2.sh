#!/bin/bash
#=================================================
# File name: preset-clash-core.sh
# Usage: <preset-clash-core.sh $platform> | example: <preset-clash-core.sh armv8>
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
# 参考网址：https://github.com/zzcabc/OpenWrt_Action/blob/11208c3d5160128d22d14318772ec48f1918deb9/script/immortalwrt/diy2.sh
#=================================================

CONFIGDIR="package/base-files/files/bin/config_generate"

# todo
# package/base-files/files/etc/board.d/99-default_network
# hostname

# 修复 GOLANG 版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang


# 修改生成的固件名称include/image.mk
sed -i '/DTS_DIR:=$(LINUX_DIR)/a\BUILD_DATE_PREFIX:=$(shell date +%Y%m%d)' include/image.mk
sed -i '/IMG_PREFIX:=/s/^#\?/#/' include/image.mk
sed -i '/IMG_PREFIX_VERCODE:=/a\IMG_PREFIX:=wayos-$(BUILD_DATE_PREFIX)' include/image.mk 

# LAN LAN LAN LAN 
sed -i "/uci commit/a uci commit network"  $CONFIGDIR
sed -i "/uci commit network/i uci set network.lan.ifname='eth0 eth1 eth2 eth3'"  $CONFIGDIR
sed -i "/uci commit network/i uci set network.lan.dns='61.139.2.69 223.5.5.5'"  $CONFIGDIR
sed -i "/uci commit network/i uci set network.lan.gateway='10.1.12.1'"  $CONFIGDIR
#sed -i "/uci commit network/i uci set network.wan.ifname='xeth0'"  $CONFIGDIR
#sed -i "/uci commit network/i uci set network.wan6.ifname='xeth0'"  $CONFIGDIR
#sed -i "/uci commit network/i uci set network.wan.proto='none'"  $CONFIGDIR
sed -i "/uci commit network/i uci set dhcp.lan.ignore='1'"  $CONFIGDIR
#sed -i "/uci commit network/i uci delete network.wan6"  $CONFIGDIR
#sed -i "/uci commit network/i uci delete network.lan.ip6assign"  $CONFIGDIR
#sed -i "/uci commit network/i uci delete network.globals.ula_prefix"  $CONFIGDIR
sed -i "/uci commit system/a uci commit dhcp"  $CONFIGDIR
#sed -i "/uci commit dhcp/i uci delete dhcp.lan.ra"  $CONFIGDIR
#sed -i "/uci commit dhcp/i uci delete dhcp.lan.dhcpv6"  $CONFIGDIR

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' $CONFIGDIR
#sed -i 's/255.255.0.0/255.255.255.0/g' $CONFIGDIR
sed -i 's/192.168.1.1/10.1.12.222/g' $CONFIGDIR

# DIAG
sed -i "/uci commit/a uci commit diag"  $CONFIGDIR
sed -i "/uci commit diag/i uci set luci.diag.dns='jd.com'"  $CONFIGDIR
sed -i "/uci commit diag/i uci set luci.diag.ping='jd.com'"  $CONFIGDIR
sed -i "/uci commit diag/i uci set luci.diag.route='jd.com'"  $CONFIGDIR

# 隐藏首页显示用户名(by:kokang)
#sed -i 's/name="luci_username" value="<%=duser%>"/name="luci_username"/g' feeds/luci/modules/luci-base/luasrc/view/sysauth.htm
#sed -i 's/name="luci_username" value="<%=duser%>"/name="luci_username"/g' feeds/kenzo/luci-theme-argone/luasrc/view/themes/argonne/sysauth.htm
# 移动光标至第一格(by:kokang)
#sed -i "s/'luci_password'/'luci_username'/g" feeds/luci/modules/luci-base/luasrc/view/sysauth.htm
#sed -i "s/'luci_password'/'luci_username'/g" feeds/kenzo/luci-theme-argonne/luasrc/view/themes/argone/sysauth.htm



# Modify system
sed -i 's/ImmortalWrt/Way/g' $CONFIGDIR
sed -i 's/UTC/CST-8/g' $CONFIGDIR
sed -i "/uci commit/a uci commit system"  $CONFIGDIR
sed -i "/uci commit/a uci commit luci"  $CONFIGDIR
sed -i "/uci commit system/i uci set system.@system[0].timezone=CST-8"  $CONFIGDIR
sed -i "/uci commit system/i uci set system.system.zonename=Asia/\Shanghai"  $CONFIGDIR
# sed -i "/uci commit luci/i uci set luci.main.lang=zh_cn"  $CONFIGDIR

# UDPXY
#sed -i "/uci commit system/a uci commit udpxy"  package/lean/default-settings/files/zzz-default-settings
#sed -i "/uci commit udpxy/i uci set udpxy.@udpxy[0].mcsub_renew='55'"  package/lean/default-settings/files/zzz-default-settings


# TTYD AS ROOT AND OPENPORT
sed -i "/uci commit system/a uci commit ttyd"  $CONFIGDIR
#sed -i "/uci commit ttyd/i uci set ttyd.@ttyd[0].command='/bin/login -f root'"  $CONFIGDIR
sed -i "/uci commit ttyd/i uci set ttyd.@ttyd[0].interface='@lan @wan'"  $CONFIGDIR


# FW
sed -i "/uci commit/a uci commit firewall"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.web=rule"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.web.target='ACCEPT'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.web.src='wan'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.web.proto='tcp'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.web.name='HTTP'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.web.dest_port='80'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ssh=rule"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ssh.target='ACCEPT'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ssh.src='wan'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ssh.proto='tcp'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ssh.dest_port='22'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ssh.name='SSH'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ttyd=rule"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ttyd.target='ACCEPT'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ttyd.src='wan'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ttyd.proto='tcp'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ttyd.dest_port='7681'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ttyd.name='TTYD'"  $CONFIGDIR
sed -i "/uci commit firewall/i uci set firewall.ttyd.enabled='0'"  $CONFIGDIR


# Banner
# Refer https://github.com/unifreq/openwrt_packit/blob/master/public_funcs
#rm -rf package/base-files/files/etc/banner
# 插入信息到 banner
# 在 cat >> .config <<EOF 到 EOF 之间粘贴你的编译配置, 需注意缩进关系
cat >> package/base-files/files/etc/banner <<EOF
-----------------------------------------------------
 PACKAGE:     $OMR_DIST
 VERSION:     $(git -C "$OMR_FEED" tag --sort=committerdate | tail -1)
 TARGET:      $OMR_TARGET
 ARCH:        $OMR_REAL_TARGET 
 BUILD REPO:  $(git config --get remote.origin.url)
 BUILD DATE:  $(date -u)
-----------------------------------------------------
EOF

# SYSINFO
# mkdir -p package/base-files/files/etc/profile.d/
# mv -f files/30-sysinfo.sh package/base-files/files/etc/profile.d/30-sysinfo.sh >/dev/null 2>&1

# Bg
# mkdir -p package/base-files/files/www/luci-static/argonne/background/
# mv -f files/bg/* package/base-files/files/www/luci-static/argonne/background/
# rm -r files/bg/ 

# Bash
sed -i "s/\/bin\/ash/\/bin\/bash/" package/base-files/files/etc/passwd >/dev/null 2>&1
sed -i "s/\/bin\/ash/\/bin\/bash/" package/base-files/files/usr/libexec/login.sh >/dev/null 2>&1

# SSH open to all
sed -i '/option Interface/s/^#\?/#/'  package/network/services/dropbear/files/dropbear.config

# Set DISTRIB_REVISION
sed -i "s/OpenWrt /Way Build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# OPKG
#sed -i 's#mirrors.cloud.tencent.com/lede#mirrors.tuna.tsinghua.edu.cn/openwrt#g' package/lean/default-settings/files/zzz-default-settings
#sed -i 's/x86_64/x86\/64/' /etc/opkg/distfeeds.conf

# 默认执行的UCI命令，可以修改下面的
#cat >files/etc/uci-defaults/change_ip << EOF
#uci set network.lan=interface
#uci set network.lan.device='br-lan'
#uci set network.lan.proto='static'
#uci set network.lan.ipaddr='10.10.10.1'
#uci set network.lan.netmask='255.255.255.0'
#uci set network.lan.ip6assign='60'
#uci commit
#EOF



# 修改DHCP
sed -i 's/100/11/g' package/network/services/dnsmasq/files/dhcp.conf
sed -i 's/150/250/g' package/network/services/dnsmasq/files/dhcp.conf

#修正连接数（by ベ七秒鱼ベ）
#sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

# Set default theme to luci-theme-argon
#uci set luci.main.mediaurlbase='/luci-static/argon'

# Disable IPV6 ula prefix
#sed -i 's/^[^#].*option ula/#&/' /etc/config/network

# Password
# sed -i '/shadow/s/^#\?/# /' $CONFIGDIR
sed -i '/shadow/d' $CONFIGDIR
sed -i 's/root::0:0:99999:7:::/root:$1$P4yrmMQf$XRoELeUToXNeituE0pl22.:19131:0:99999:7:::/g' package/base-files/files/etc/shadow
# sed -i 's/root:::0:99999:7:::/root:$1$P4yrmMQf$XRoELeUToXNeituE0pl22.:19131:0:99999:7:::/g' package/base-files/files/etc/shadow


# 设置密码为空
#sed -i "/CYXluq4wUazHjmCDBCqXF/d" $CONFIGDIR
#sed -i 's/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/root:$1$rOlqcfTl$sQ03k9uRqA\/xTm7pzAmSs1:19130:0:99999:7:::/g' $CONFIGDIR
