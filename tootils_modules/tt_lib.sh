#shellcheck disable=SC2034

# ========== Tootils library ==========
#
# While powerful and serious, this library has unused functionality
# that might or might not get picked up by the main program.
#
# The most basic and fundamental functions live in the
# "Essential functions" section in the tt executable instead,
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
# alt() {
#     tput smcup
# }
# altx() {
#     tput rmcup
# }

# ========== Constants ==========

# ANSI Colors
C_RESET=$'\e[m'
C_RED=$'\e[31m'
C_BLUE=$'\e[34m'
C_GREEN_B=$'\e[1;32m'
C_RED_B_BL=$'\e[1;5;31m'
C_UNDERLINE=$'\e[4m'
C_NOT_UNDERLINE=$'\e[24m'
C_STRIKETHROUGH=$'\e[9m'

SEPARATOR=" ${C_STRIKETHROUGH}                                                            ${C_RESET}"
SEPARATOR_BATCH=' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'

# ========== Visual Output ==========

run-op() {
    local op=$1
    # operation == $@
    shift

    echo "$SEPARATOR"
    echo "Tootils Running Command: $C_UNDERLINE${op}$C_NOT_UNDERLINE"
    printf '%q ' "$@"
    echo "$C_BLUE"
    "$@"
    echo "${C_RESET}Tootils Ran Command: $C_UNDERLINE${op}$C_NOT_UNDERLINE"
    printf '%q ' "$@"
    echo
    echo "$SEPARATOR"
}

print-batch-head() {
    local op=$1

    echo "$C_GREEN_B$SEPARATOR_BATCH"
    echo "Tootils Running Batch: $C_UNDERLINE${op}$C_RESET"
}

print-batch-tail() {
    local op=$1

    echo "${C_GREEN_B}Tootils Ran Batch: $C_UNDERLINE${op}$C_NOT_UNDERLINE"
    echo "$SEPARATOR_BATCH$C_RESET"
}

# ========== File Operations ==========

file-to-array() {
    # file < stdin
    local -n arr=$1

    local line
    while read -r line || [[ -n "$line" ]]; do
        line=${line%$'\r'} # delete CR
        [[ -z "$line" ]] && continue

        arr+=("$line")
    done
}

load-config() {
    # configFile < stdin
    local -n table=$1
    local required_entries=$2
    local optional_entries=$3

    local entry value is_valid line

    while read -r line || [[ -n "$line" ]]; do
        line=${line%$'\r'} # delete CR
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        if [[ $line != *=* ]]; then
            fatal "Invalid line in config file: $line"
        fi

        entry=${line%%=*}
        value=${line#*=}

        is_valid=false
        for x in $required_entries $optional_entries; do
            [[ $entry == "$x" ]] && is_valid=true && break
        done
        if ! $is_valid; then
            fatal "Invalid entry in config file: $entry"
        fi

        if [[ -n ${table[$entry]} ]]; then
            fatal "Duplicate entry in config file: $entry"
        fi

        table[$entry]=$value
    done

    for x in $required_entries; do
        if [[ -z ${table[$x]} ]]; then
            fatal "Missing required entry in config file: $x"
        fi
    done
}
