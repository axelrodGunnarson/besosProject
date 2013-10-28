#!/bin/bash
#
# Authors:
# Michele Welponer <mwelponer@gmail.com> Trento University  
# Maurizio Abbà <maurizio.abba00@gmail.com> Polythecnic of Turin
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version
# 2 of the License, or (at your option) any later version.
#
#
# ** 1 ** Download and install a minimal lenny debian system (net install iso may work)
# --------------------------------------------------------------------------------------
# http://cdimage.debian.org/debian-cd/5.0.5/i386/iso-cd/debian-505-i386-netinst.iso
#
# - select: Advanced options -> automated install
# - use the entire disk (partitioning)
# - set the root password "ipflow"
# - create the user "ipflow", password "ipflow"
#
# ** 2 ** Set-up an internet connection
# ---------------------------------------
# - log-in as root (password "ipflow")
# - set up the internet connection (e.g. dhcp on eth1 interface)
#	:/# ifconfig eth1 up
#	:/# dhclient eth1
# - set the proxy if necessary (e.g. proxy.science.unitn.it, port 3128)
# 	:/# vim /etc/apt/apt.conf.d/proxy
# 		Acquire::http::Proxy "http://proxy.science.unitn.it:3128";
# 		Acquire::ftp::Proxy "http://proxy.science.unitn.it:3128";
# 		Acquire::ftp::Timeout "120";
# 		Acquire::ftp::Passive "true";
#
# ** 3 ** Download and run the script
# ------------------------------------
# - Download and run the script on your freshly installed debian
#	:/# wget http://disi.unitn.it/~welponer/RTLsetup.sh
#	:/# sh RTLsetup.sh
#
# ** 4 ** Test the GPS driver
# ----------------------------
# exit and enter as "ipflow" user. Check if all things work
#	:/# tdp.sh 14400 -s
#	   .. see the output in ~/Desktop 
#
#	:/# tdp.sh 14400 -s -h
#	   .. see the output in ~/Desktop

pwd=ipflow
kernel=`uname -r`
instl=/home/ipflow/lenny

##########################
echo -e "\nRTLsetup.sh: Download modules and scripts ..."
##########################
cd /home/ipflow
wget http://disi.unitn.it/~welponer/lenny.tar.gz
echo -e "\nRTLsetup.sh: ... done"
tar -zxvf lenny.tar.gz


##########################
echo -e "\nRTLsetup.sh: Modify the debian sw sources (switch from cd to http sources)"
##########################
cp $instl/etc/apt/sources.list /etc/apt/sources.list
apt-get update
apt-get install sudo vim less locate ssh python bc gnuplot #localepurge
#localepurge


##########################
echo -e "\nRTLsetup.sh: Create admin group and add ipflow"
##########################
addgroup admin
adduser ipflow admin
echo -e "\n# Members of the admin group may gain root privileges" >> /etc/sudoers
echo "%admin ALL=(ALL) ALL" >> /etc/sudoers


##########################
echo -e "\nRTLsetup.sh: Add /sbin /bin to the PATH"
##########################
echo -e "\nPATH=\$PATH:/sbin:/bin" >> /home/ipflow/.bashrc


##########################
echo -e "\nRTLsetup.sh: Configure NICs"
##########################
cp $instl/etc/network/interfaces /etc/network
cp $instl/etc/hostname /etc/
cp $instl/etc/hosts /etc/


##########################
echo -e "\nRTLsetup.sh: Install cset and scripts"
##########################
cp -rf $instl/home/ipflow /home
python /home/ipflow/cpuset-1.5.5/setup.py install


##########################
echo -e "\nRTLsetup.sh: Copy the RT kernel modules"
##########################
cp -rf $instl/lib/modules/2.6.29.6-rt23 /lib/modules
cp -rf $instl/boot /


##########################
echo -e "\nRTLsetup.sh: Create directory for the tests output"
##########################
mkdir /home/ipflow/Desktop


##########################
echo -e "\nRTLsetup.sh: Cleaning temporary files"
##########################
rm -rf $instl 
rm /home/ipflow/lenny.tar.gz

exit
