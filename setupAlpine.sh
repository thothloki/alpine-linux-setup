#!/bin/sh

echo "========== step1  ================"
alpineversion=`cat /etc/alpine-release | cut -d "." -f 1-2 | awk '{print "v"$1}'`
echo $alpineversion

echo "http://dl-cdn.alpinelinux.org/alpine/$alpineversion/community" >> /etc/apk/repositories
apk update
apk upgrade

echo "========== step2  ================"
# install some apps
#install xfce stuff
setup-xorg-base
apk add xrandr dbus dbus-x11 xfce4 xfce4-terminal xfce4-screensaver adwaita-icon-theme lightdm thunar-volman
apk add lightdm-gtk-greeter mesa-gl glib accountsservice elogind polkit-elogind
#install utility stuff to make life easy
#apk add util-linux pciutils usbutils coreutils binutils findutils grep iproute2
apk add sudo bash bash-doc bash-completion setxkbmap build-base nmap net-tools curl
#apk add udisks2 udisks2-doc gvfs gvfs-smb ntfs-3g
apk add feh firefox
apk add --no-cache python3 py3-pip
#install printer support
#apk add cups cups-lib cups-pdf cups-client cups-filters hplip
#install docker
apk add docker docker-compose

# add user
adduser thothloki
mkdir -p /home/thothloki/wallpaper
mkdir -p /home/thothloki/icon

# user setup for thothloki
cp ./thothloki/wallpaper/sith.jpg /home/thothloki/wallpaper/sith.jpg
cp ./thothloki/wallpaper/sith.jpg /home/thothloki/wallpaper/sith2.jpg
cp ./thothloki/wallpaper/sith.jpg /home/thothloki/wallpaper/lock.jpg
cp ./thothloki/icon/sith-icon-white.jpg /home.thothloki/sith-icon-white.jpg
cp ./thothloki/icon/sith-icon-red.png /home.thothloki/sith-icon-red.png

chown -R thothloki:thothloki /home/thothloki

#add thothloki to sudoers
cat ./thothloki/sudoers >> /etc/sudoers

# greeter background
echo "background=/home/thothloki/wallpaper/lock.jpg" >> /etc/lightdm/lightdm-gtk-greeter.conf
xfconf-query -c xfce4-desktop -p  /backdrop/screen0/monitor0/workspace0/last-image -s /home/thothloki/walpaper/sith.jpg

# set background image in accountsservice
cp ./thothloki/thothloki /var/lib/AccountsService/users
chown root:root /var/lib/AccountsService/users/thothloki

# add user to docker
addgroup thothloki docker

# give ibuetler write access to /opt dir
chown thothloki:thothloki /opt

# mkdir /opt/docker
mkdir -p /opt/docker
cp ./docker/* /opt/docker/
chown thothloki:thothloki /opt/docker

echo "========== step3  ================"
rc-service dbus start
rc-update add dbus

rc-service lightdm start
rc-update add lightdm

rc-service docker start
rc-update add docker boot

rc-service cupsd start
rc-update add cupsd boot

rc-service udev start
rc-update add udev
