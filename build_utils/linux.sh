VARS="GIT_DIR FLUTTER_DIR LINUX_BUILD_DIR RELEASES_DIR" . build_utils/common.sh

cd $FLUTTER_DIR || error "No directory $FLUTTER_DIR";

flutter build linux --release || error "linux build fail.";
cd ${GIT_DIR%%/}/$LINUX_BUILD_DIR || error "No directory ${GIT_DIR%%/}/$LINUX_BUILD_DIR";

latest="${GIT_DIR%%/}/${RELEASES_DIR%%/}/latest"

mv "bundle" "blindytesty-v$VERSION" || exit 1;
tar czf "linux-blindytesty-v$VERSION.tar.gz" "./blindytesty-v$VERSION"
mv "linux-blindytesty-v$VERSION.tar.gz" "${latest%%/}/"
