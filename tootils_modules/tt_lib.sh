#shellcheck disable=SC2034

# ========== Tootils library ==========
#
# While powerful and serious, this library has unused functionality
# that might or might not get picked up by the main program.
#
# The most basic and fundamental functions live in the
# "Essential functions" section in the toot executable instead,
# simply because they are required to exist before loading the library.
#

# ===== Debugging =====
# Uncomment to enable debug functionality, then
# use trap 'deb' to enable "stepping" and trap - to disable it.
# Enable extdebug to have it recurse into functions as well.
decho() {
    echo "${C_RED}decho:${C_RESET}$*" >&2
}
deb() {
    echo "${C_RED}deb:${C_RESET}$BASH_COMMAND" >&2
}
# shopt -s extdebug
# trap 'deb' DEBUG
# trap - DEBUG

# # Alt Screen
# # this is just a random note
# alt() {
#     tput smcup
# }
# altx() {
#     tput rmcup
# }

# ANSI Colors
C_RESET=$'\e[m'
C_RED=$'\e[31m'
C_BLUE=$'\e[34m'
C_GREENB=$'\e[1;32m'
C_REDBBL=$'\e[1;5;31m'
C_UNDERLINE=$'\e[4m'
C_NOTUNDERLINE=$'\e[24m'
C_STRIKETHROUGH=$'\e[9m'

SEPARATOR='~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'

# These are for informative output regarding Tootils operations
runOp() {
    # operation == $@
    local op="$1"
    shift

    echo $SEPARATOR
    echo "Tootils Running Command: $C_UNDERLINE$op$C_NOTUNDERLINE"
    echo "$*$C_BLUE"
    "$@"
    echo "${C_RESET}Tootils Ran Command: $C_UNDERLINE$op$C_NOTUNDERLINE"
    echo "$*"
    echo $SEPARATOR
}

runOpBatch() {
    # operation == $@
    local op="$1"
    shift

    echo "$C_GREENB$SEPARATOR"
    echo "Tootils Running Batch: $C_UNDERLINE$op$C_RESET"
    "$@"
    echo "${C_GREENB}Tootils Ran Batch: $C_UNDERLINE$op$C_NOTUNDERLINE"
    echo "$SEPARATOR$C_RESET"
}

fileToArray() {
    # file < stdin
    local -n arr=$1

    local line
    while read -r line || [[ -n "$line" ]]; do
        line=${line%$'\r'} # delete CR
        [[ -z "$line" ]] && continue

        arr+=("$line")
    done
}

# deprecating......
forEachLine() {
    # file < stdin

    local line
    while read -r line || [[ -n "$line" ]]; do
        line=${line%$'\r'} # delete CR
        [[ -z "$line" ]] && continue

        "$@" "$line"
    done
}

# # receive the file from stdin < "$file"
# # !! -> scope the corresponding stdin to
# # all calls to this function at once
# forOneLine() {
#     if read -r line || [[ -n "$line" ]]; then
#         line=${line%$'\r'} # delete CR
#         [[ -z "$line" ]] && return 1
#         "$@" "$line"
#     fi
# }

loadConfig() {
    # configFile < stdin
    local -n table=$1
    local requiredEntries=$2
    local optionalEntries=$3

    local entry value isValid line

    while read -r line || [[ -n "$line" ]]; do
        line=${line%$'\r'} # delete CR
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        if [[ $line != *=* ]]; then
            fatal "Invalid line in config file: $line"
        fi

        entry=${line%%=*}
        value=${line#*=}

        isValid=false
        for x in $requiredEntries $optionalEntries; do
            [[ $entry == "$x" ]] && isValid=true && break
        done
        if ! $isValid; then
            fatal "Invalid entry in config file: $entry"
        fi

        if [[ -n ${table[$entry]} ]]; then
            fatal "Duplicate entry in config file: $entry"
        fi

        table[$entry]=$value
    done

    for x in $requiredEntries; do
        if [[ -z ${table[$x]} ]]; then
            fatal "Missing required entry in config file: $x"
        fi
    done
}
