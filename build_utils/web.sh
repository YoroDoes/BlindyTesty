VARS="FLUTTER_DIR GIT_DIR GITHUB_IO_DIR WEB_BUILD_DIR" . build_utils/common.sh

echo "IGNORING WEB"
exit;

cd $FLUTTER_DIR || error "No directory $FLUTTER_DIR"

flutter build web --base-href='/BlindyTesty/'

cd $GIT_DIR || error "No directory $GIT_DIR"

git add "$WEB_BUILD_DIR"
git commit -m 'web build'

git subtree push --prefix "$WEB_BUILD_DIR" origin gh-pages

cd $GITHUB_IO_DIR || error "No directory $GITHUB_IO_DIR"

gitsubm-bump
