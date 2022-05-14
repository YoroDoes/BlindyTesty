VARS="GIT_DIR FLUTTER_DIR RELEASES_DIR PROJECT_NAME WINDOWS_TMP_DIR" . build_utils/common.sh

scp -Bqr "$GIT_DIR/build_utils/windows_clean_build.ps1" windows_server: 2>&-; echo "cleanup copy done";
ssh -o BatchMode=true windows_server '~/windows_clean_build.ps1; rm -Recurse -ErrorAction Ignore ~/windows_clean_build.ps1;' || exit 1;
rm -rf "$WINDOWS_TMP_DIR"
mkdir -p "$WINDOWS_TMP_DIR"
REL_GIT_DIR=$(echo "$GIT_DIR/" | sed "s|^$PWD/||")
REL_FLUTTER_DIR=$(echo "$FLUTTER_DIR/" | sed "s|^$PWD/||")
cp -r --parents "$REL_GIT_DIR"build_utils "$REL_FLUTTER_DIR"windows "$REL_FLUTTER_DIR"lib "$REL_FLUTTER_DIR"assets "$REL_FLUTTER_DIR"analysis_options.yaml "$REL_FLUTTER_DIR"blindytesty.iml "$REL_FLUTTER_DIR"packages "$REL_FLUTTER_DIR"pubspec.yaml "$REL_FLUTTER_DIR"test "$WINDOWS_TMP_DIR" || exit 1;
scp -BCqr "$WINDOWS_TMP_DIR/"* "windows_server:flutter_build/" 2>&-; echo "scp done";
ssh -o BatchMode=true windows_server "~/flutter_build/build_utils/windows_build.ps1 $PROJECT_NAME $VERSION" || exit 1;
scp -B "windows_server:flutter_build/release_build.zip" "/tmp/release_build.zip" || exit 1;
zip -FF "/tmp/release_build.zip" --out "$GIT_DIR/$RELEASES_DIR/latest/windows-$PROJECT_NAME-v$VERSION.zip"
