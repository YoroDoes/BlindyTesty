VARS="GIT_DIR ANDROID_BUILD_DIR LINUX_BUILD_DIR WINDOWS_BUILD_DIR" . build_utils/common.sh

echo "sha256sums:"

#windows
cd ${GIT_DIR%%/}/$WINDOWS_BUILD_DIR || error "No directory ${GIT_DIR%%/}/$WINDOWS_BUILD_DIR";
sha256sum "windows-blindytesty-v$VERSION.rar"

#linux
cd ${GIT_DIR%%/}/$LINUX_BUILD_DIR || error "No directory ${GIT_DIR%%/}/$LINUX_BUILD_DIR";
sha256sum "linux-blindytesty-v$VERSION.tar.gz"

#android
cd ${GIT_DIR%%/}/$ANDROID_BUILD_DIR || error "No directory ${GIT_DIR%%/}/$ANDROID_BUILD_DIR";
sha256sum "android-blindytesty-v$VERSION-"*
