VARS="FLUTTER_DIR" . build_utils/common.sh

cd $FLUTTER_DIR || error "No directory $FLUTTER_DIR";

flutter doctor -v
