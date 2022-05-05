cd "blindytesty/" || exit 1;

current_version=$(yq .version < pubspec.yaml | sed -e 's/"//g')
current_version_number=$(echo "$current_version" | sed 's/\+.*//')
[ -z "$current_version" ] && exit;

cd "build" || exit 1;

build="$PWD"

echo "sha256sums:"

#windows
cd "windows" || exit 1;
sha256sum "windows-blindytesty-v$current_version.rar"
cd "$build"

#linux
cd "linux/x64/release" || exit 1;
sha256sum "linux-blindytesty-v$current_version.tar.gz"
cd "$build"

#android
cd "app/outputs/apk/release" || exit 1;
sha256sum "android-blindytesty-v$current_version-"*
cd "$build"
