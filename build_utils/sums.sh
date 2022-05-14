set -- 0.0.0 #stub
VARS="GIT_DIR RELEASES_DIR" . build_utils/common.sh

echo "sha256sums:"

latest="${GIT_DIR%%/}/${RELEASES_DIR%%/}/latest"
cd "$latest" || error "No latest release folder found."

sha256sum "${latest%%/}"/*
