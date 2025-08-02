#shellcheck disable=SC2154

Backup() {
    local op=$1
    local arg=$2

    local BACKUPSUBDIR=TootilsBackup
    local destinationDir

    if ! destinationDir=$(readlink -e -- "${conf[backupRoot]}"); then
        erro "Backup device is disconnected or non-existent: ${conf[backupRoot]}"
        return
    fi

    destinationDir+="/$BACKUPSUBDIR/"

    case "$op" in
        bk|bkg|bkd|bkdg)
            bkItem "$op" "$arg"
            ;;
        back)
            bkBatch "$op" "$arg"
            ;;
    esac
}

# we'll replace 'forEachLine' with 'fileToArray' functionality
# just like bkItem does.
bkBatch() {
    local op=$1
    local subOp=$2

    if [[ "$subOp" =~ ^bkd?g?$ || -z "$subOp" ]]; then
        runOpBatch "$op" forEachLine bkItem "${subOp:-bkd}" < "$configFileBackup" # TODO: move list to config
    else
        erro "Use (bk/bkg/bkd/bkdg) as a Backup mode instead of: $subOp"
    fi
}

bkItem() {
    local op=$1
    local srcDir=$2

    local IGNOREFILE=.tootignore
    local trueSrcDir
    local -a ignoreList

    [[ "$srcDir" == "" ]] && { erro "Specify a directory to backup."; return; }

    [[ "$srcDir" =~ ^# ]] && { echo "Skipped: $C_STRIKETHROUGH${srcDir}$C_RESET"; return; }

    # this one also removes the trailing slash!
    trueSrcDir=$(canonicalPath "${srcDir/#\~/$HOME}") || { erro "No such directory: $srcDir"; return; }

    # pattern-ignoring logic
    if [[ -f "$trueSrcDir/$IGNOREFILE" ]]; then
        fileToArray ignoreList < "$trueSrcDir/$IGNOREFILE"

        local index
        for index in "${!ignoreList[@]}"; do
            ignoreList[$index]="--exclude='${ignoreList[$index]}'"
        done
    fi

    case "$op" in
        bk)
            runOp "$op" rsync -avh -n --progress "${ignoreList[@]}" -- "$trueSrcDir" "$destinationDir"
            ;;
        bkg)
            runOp "$op" rsync -avh --progress "${ignoreList[@]}" -- "$trueSrcDir" "$destinationDir"
            ;;
        bkd)
            runOp "$op" rsync -avh -n --progress --delete "${ignoreList[@]}" -- "$trueSrcDir" "$destinationDir"
            ;;
        bkdg)
            runOp "$op" rsync -avh --progress --delete "${ignoreList[@]}" -- "$trueSrcDir" "$destinationDir"
            ;;
    esac
}
