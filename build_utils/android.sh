VARS="GIT_DIR FLUTTER_DIR ANDROID_BUILD_DIR RELEASES_DIR" . build_utils/common.sh

cd $FLUTTER_DIR || error "No directory $FLUTTER_DIR";

flutter build apk --split-per-abi || error "android build fail";
cd ${GIT_DIR%%/}/$ANDROID_BUILD_DIR || error "No directory ${GIT_DIR%%/}/$ANDROID_BUILD_DIR";

latest="${GIT_DIR%%/}/${RELEASES_DIR%%/}/latest"

for f in *.apk; do
    mv "$f" "${latest%%/}/$(echo "$f" | sed -e "s/^app-/android-blindytesty-v$VERSION-/" -e "s/-release.apk/.apk/")"
done
