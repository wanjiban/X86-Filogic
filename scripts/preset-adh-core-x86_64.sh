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


# 预置adguardhome内核
ADHCOREDIR="files/usr/bin/"

# openclash 的 TUN内核
ADHCORE_VERSION=$(curl -sL -I https://github.com/AdguardTeam/AdGuardHome/releases/latest | grep -oP 'releases/tag/\K.*' | tr -d '\r')
ADHCORE_URL="https://github.com/AdguardTeam/AdGuardHome/releases/download/$ADHCORE_VERSION/AdGuardHome_linux_amd64.tar.gz"

# 给内核解压
wget -qO- $ADHCORE_URL | tar xOvz > $ADHCOREDIR/AdGuardHome

# 给内核权限
chmod +x $ADHCOREDIR/AdGuardHome
