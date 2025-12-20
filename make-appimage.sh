#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q secrets | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/org.gnome.World.Secrets.svg
export DESKTOP=/usr/share/applications/org.gnome.World.Secrets.desktop
export DEPLOY_SYS_PYTHON=1
export DEPLOY_OPENGL=1
export DEPLOY_P11KIT=1
export DEPLOY_GTK=1
export GTK_DIR=gtk-4.0
export DEPLOY_GSTREAMER=1
export DEPLOY_LOCALE=1
export ANYLINUX_LIB=1
export GTK_CLASS_FIX=1
export PATH_MAPPING='/sbin/ldconfig:${SHARUN_DIR}/bin/ldconfig'

# Deploy dependencies
quick-sharun /usr/bin/secrets \
             /usr/lib/libgirepository* \
             /usr/lib/libusb* \
             /usr/lib/libcups* \
             /sbin/ldconfig

# Patch secrets to use AppImage's directory
sed -i '/from gsecrets import const/a \
SHARUN_DIR = os.getenv('"'"'SHARUN_DIR'"'"')\n\
PKGDATADIR = os.path.join(SHARUN_DIR, '"'"'share'"'"', '"'"'secrets'"'"')\n\
LOCALEDIR = os.path.join(SHARUN_DIR, '"'"'share'"'"', '"'"'locale'"'"')' ./AppDir/bin/secrets
sed -i 's|const.PKGDATADIR|PKGDATADIR|' ./AppDir/bin/secrets
sed -i 's|const.LOCALEDIR|LOCALEDIR|' ./AppDir/bin/secrets


# Turn AppDir into AppImage
quick-sharun --make-appimage
