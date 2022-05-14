VARS="GIT_DIR FLUTTER_DIR RELEASES_DIR PROJECT_NAME WINDOWS_TMP_DIR" . build_utils/common.sh

cd $FLUTTER_DIR || error "No directory $FLUTTER_DIR";

scp -Bqr "$GIT_DIR/build_utils/windows_clean_build.ps1" windows_server: 2>&-; echo "cleanup copy done";
ssh -o BatchMode=true windows_server '~/windows_clean_build.ps1; rm -Recurse -ErrorAction Ignore ~/windows_clean_build.ps1;' || exit 1;
rm -rf "$WINDOWS_TMP_DIR"
mkdir -p "$WINDOWS_TMP_DIR"
cp -r --parents "$GIT_DIR/build_utils/" "$FLUTTER_DIR/windows" "$FLUTTER_FIR/lib" "$FLUTTER_DIR/assets" "$FLUTTER_DIR/analysis_options.yaml" "$FLUTTER_DIR/blindytesty.iml" "$FLUTTER_DIR/packages" "$FLUTTER_DIR/pubspec.yaml" "$FLUTTER_DIR/test" "$WINDOWS_TMP_DIR" || exit 1;
scp -BCqr "$WINDOWS_TMP_DIR/"* "windows_server:flutter_build/" 2>&-; echo "scp done";
ssh -o BatchMode=true windows_server "~/flutter_build/build_utils/windows_build.ps1 $PROJECT_NAME $VERSION" || exit 1;
scp -B "windows_server:flutter_build/release_build.zip" "/tmp/release_build.zip" || exit 1;
zip -FF "/tmp/release_build.zip" --out "$GIT_DIR/$RELEASES_DIR/latest/$PROJECT_NAME-v$VERSION.zip"
