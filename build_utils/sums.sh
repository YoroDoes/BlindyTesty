set -- 0.0.0 #stub
VARS="GIT_DIR RELEASES_DIR" . build_utils/common.sh

echo "sha256sums:"

latest="${GIT_DIR%%/}/${RELEASES_DIR%%/}/latest"
cd "$latest" || error "No latest release folder found."

sha256sum "${latest%%/}"/*

##windows
#cd ${GIT_DIR%%/}/$WINDOWS_BUILD_DIR || error "No directory ${GIT_DIR%%/}/$WINDOWS_BUILD_DIR";
#sha256sum "windows-blindytesty-v$VERSION.rar"

##linux
#cd ${GIT_DIR%%/}/$LINUX_BUILD_DIR || error "No directory ${GIT_DIR%%/}/$LINUX_BUILD_DIR";
#sha256sum "linux-blindytesty-v$VERSION.tar.gz"

##android
#cd ${GIT_DIR%%/}/$ANDROID_BUILD_DIR || error "No directory ${GIT_DIR%%/}/$ANDROID_BUILD_DIR";
#sha256sum "android-blindytesty-v$VERSION-"*
