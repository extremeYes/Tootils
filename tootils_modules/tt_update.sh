
# SUPER DUPER NOT READY FOR NOTHING YET LOL

#shellcheck disable=SC2164
Update() {
    if ! command -v git; then
        fatal "Git must be installed to update Tootils."
    fi

    builtin cd "$HERE"
    git checkout main
    git pull
}
