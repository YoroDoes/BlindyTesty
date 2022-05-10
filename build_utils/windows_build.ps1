$project=$args[0]
$version=$args[1]

cd "~/flutter_build/$project"; if (-not $?) { Return };
flutter pub get; if (-not $?) { Return };
flutter build windows --release; if (-not $?) { Return };
cp -Recurse "C:/Program Files (x86)/$project" "~/flutter_build/$project-v$version/"; if (-not $?) { Return }; 
mv "~/flutter_build/$project-v$version" "~/flutter_build/release_build/$project-v$version"
Compress-Archive -Path "~/flutter_build/$project-v$version/" -DestinationPath "~/flutter_build/release_build.zip"; if (-not $?) { Return };
