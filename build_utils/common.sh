error() {
    echo "$1" && exit 1;
}
info() {
    echo "$1";
}

[ -f ".env" ] || error "No .env found";
. "${PWD%%/}/.env" || exit 1;

necessary_env_vars="$VARS"
for var in $necessary_env_vars; do
    eval vval="\$$var"
    [ -n "$vval" ] || error "make sure the env vars '$necessary_env_vars' are set in .env."
done

[ -z "$1" ] && error "No version given."
VERSION="$1"
