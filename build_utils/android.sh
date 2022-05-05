VARS="GIT_DIR FLUTTER_DIR ANDROID_BUILD_DIR" . build_utils/common.sh

cd $FLUTTER_DIR || error "No directory $FLUTTER_DIR";

flutter build apk --split-per-abi
cd ${GIT_DIR%%/}/$ANDROID_BUILD_DIR || error "No directory ${GIT_DIR%%/}/$ANDROID_BUILD_DIR";
for f in *.apk; do
    mv "$f" "$(echo "$f" | sed -e "s/^app-/android-blindytesty-v$VERSION-/" -e "s/-release.apk/.apk/")"
done
