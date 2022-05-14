set -- "0.0.0" #stub
VARS="FLUTTER_DIR" . build_utils/common.sh

cd $FLUTTER_DIR || error "No directory $FLUTTER_DIR";


#crashes on dart errors
# flutter analyze || exit 1;
#crashes on wrong flutter version
flutter channel || exit 1;
flutter doctor -v || exit 1;
echo "build clean" >&2
rm -rf "$FLUTTER_DIR/build/"
# windows update and check
echo "windows flutter upgrade" >&2;
ssh -o BatchMode=true windows_server "flutter upgrade --force;" || exit 1;
# TODO mac update and check
