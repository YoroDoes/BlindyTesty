set -- "0.0.0" #stud
VARS="FLUTTER_DIR" . build_utils/common.sh

cd $FLUTTER_DIR || error "No directory $FLUTTER_DIR";


#crashes on dart errors
# flutter analyze || exit 1;
#crashes on wrong flutter version
flutter channel || exit 1;
flutter doctor -v || exit 1;
