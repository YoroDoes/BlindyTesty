cd blindytesty/ || exit 1;

project_path="$PWD"

current_version=$(yq .version < pubspec.yaml | sed -e 's/"//g')
current_version_number=$(echo "$current_version" | sed 's/\+.*//')
[ -z "$current_version" ] && exit 1;

[ -d "build/windows/blindytesty-v$current_version_number" ] || (echo "Build for windows, macOS and iOS before finish the build and releasing." && exit 1);

flutter build linux --release
cd "build/linux/x64/release" || exit 1;
cp -r "bundle" "blindytesty-v$current_version_number" || exit 1;
tar czf "linux-blindytesty-v$current_version.tar.gz" "./blindytesty-v$current_version_number"

cd "$project_path" || exit 1;

flutter build apk --split-per-abi
cd "build/app/outputs/apk/release" || exit 1;
for f in *.apk; do
    mv "$f" "$(echo "$f" | sed -e "s/^app-/android-blindytesty-v$current_version-/" -e "s/-release.apk/.apk/")"
done

cd "$project_path" || exit 1;
cd .. || exit 1;

./sums.sh
