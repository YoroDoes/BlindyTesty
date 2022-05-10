set -- 0.0.0 #stub
VARS="GIT_DIR RELEASES_DIR" . build_utils/common.sh

latest="${GIT_DIR%%/}/${RELEASES_DIR%%/}/latest"
archives="${GIT_DIR%%/}/${RELEASES_DIR%%/}/archives"
mkdir -p "$latest" "$archives"
mv "${latest%%/}/*" "${archives%%/}/"

