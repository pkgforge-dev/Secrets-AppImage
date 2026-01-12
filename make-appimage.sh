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
export DEBLOAT_SYS_PYTHON=0 # we will manually debloat, as the pyc directory name is not the same as mainbin (gsecrets vs secrets)
export DEPLOY_P11KIT=1
export DEPLOY_GTK=1
export GTK_DIR=gtk-4.0
export DEPLOY_GSTREAMER=1
export DEPLOY_LOCALE=1
export ANYLINUX_LIB=1
export STARTUPWMCLASS=org.gnome.World.Secrets # Default to Wayland's wmclass. For X11, GTK_CLASS_FIX will force the wmclass to be the Wayland one.
export GTK_CLASS_FIX=1

# Deploy dependencies
quick-sharun /usr/bin/secrets \
             /usr/lib/libgirepository* \
             /usr/lib/libusb* \
             /usr/lib/libcups*

# Manually debloat .pyc files
python_dir=$(echo ./AppDir/shared/lib/python*)
(
	cd "$python_dir"
	for f in $(find ./ -type f -name '*.pyc' -print); do
		case "$f" in
			*/"secrets"*) :;;
			*/"gsecrets"*) :;;
			*) [ ! -f "$f" ] || rm -f "$f";;
		esac
	done
)

# Patch secrets to use AppImage's directory
sed -i '/from gsecrets import const/a \
SHARUN_DIR = os.getenv('"'"'SHARUN_DIR'"'"')\n\
PKGDATADIR = os.path.join(SHARUN_DIR, '"'"'share'"'"', '"'"'secrets'"'"')\n\
LOCALEDIR = os.path.join(SHARUN_DIR, '"'"'share'"'"', '"'"'locale'"'"')' ./AppDir/bin/secrets
sed -i 's|const.PKGDATADIR|PKGDATADIR|' ./AppDir/bin/secrets
sed -i 's|const.LOCALEDIR|LOCALEDIR|' ./AppDir/bin/secrets

# Turn AppDir into AppImage
quick-sharun --make-appimage
