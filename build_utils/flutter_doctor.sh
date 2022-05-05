VARS="FLUTTER_DIR" . build_utils/common.sh 0.0.0

cd $FLUTTER_DIR || error "No directory $FLUTTER_DIR";

flutter doctor -v
