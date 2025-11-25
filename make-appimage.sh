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
export DEPLOY_GTK=1
export GTK_DIR=gtk-4.0
export ANYLINUX_LIB=1
export DEPLOY_LOCALE=1
export STARTUPWMCLASS=secrets # For Wayland, this is 'org.gnome.World.Secrets', so this needs to be changed in desktop file manually by the user in that case until some potential automatic fix exists for this

# Deploy dependencies
quick-sharun /usr/bin/secrets \
             /usr/lib/libgirepository*

# Patch secrets to use AppImage's directory
sed -i 's|const.PKGDATADIR|os.getenv("SHARUN_DIR"), "share"|' ./AppDir/bin/secrets
sed -i 's|const.LOCALEDIR|os.getenv("SHARUN_DIR"), "share", "locale"|' ./AppDir/bin/secrets

# Turn AppDir into AppImage
quick-sharun --make-appimage
