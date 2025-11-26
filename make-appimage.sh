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
export STARTUPWMCLASS=secrets # For Wayland, this is 'org.gnome.World.Secrets', so this needs to be changed in desktop file manually by the user in that case until some potential automatic fix exists for this

# Deploy dependencies
quick-sharun /usr/bin/secrets \
             /usr/lib/libgirepository* \
             /usr/lib/libusb* \
             /usr/lib/libcups*

# Patch secrets to use AppImage's directory
sed -i '/from gsecrets import const/a \
SHARUN_DIR = os.getenv('"'"'SHARUN_DIR'"'"')\n\
PKGDATADIR = os.path.join(SHARUN_DIR, '"'"'share'"'"', '"'"'secrets'"'"')\n\
LOCALEDIR = os.path.join(SHARUN_DIR, '"'"'share'"'"', '"'"'locale'"'"')' ./AppDir/bin/secrets
sed -i 's|const.PKGDATADIR|PKGDATADIR|' ./AppDir/bin/secrets
sed -i 's|const.LOCALEDIR|LOCALEDIR|' ./AppDir/bin/secrets

# add weird hack so that this works in alpine
echo 'LD_LIBRARY_PATH=/lib64:/usr/lib64:/lib:/usr/lib:${SHARUN_DIR}/lib' >> ./AppDir/.env
sed -i -e 's|LD_LIBRARY_PATH|LD_LIBRARY_KEK_|g' ./AppDir/shared/lib/anylinux.so
echo '#!/bin/sh
if ! command -v cc 1>/dev/null; then
	>&2 echo '================================================================='
	>&2 echo 'WARNING: No C compiler detected, python may need this at runtime!'
	>&2 echo '================================================================='
fi
' > ./AppDir/bin/cc-check.hook
chmod +x ./AppDir/bin/cc-check.hook

# Turn AppDir into AppImage
quick-sharun --make-appimage
