#shellcheck disable=SC2154

Backup() {
    local op=$1
    local arg=$2

    local BACKUP_SUBDIR=TootilsBackup
    local destination_dir

    if ! destination_dir=$(canonical-path "${conf[backup_root]}"); then
        erro "Backup device is disconnected or non-existent: ${conf[backup_root]}"
        return
    fi

    if [[ ! -d $destination_dir ]]; then
        erro "Backup destination is not a directory: ${conf[backup_root]}"
        return
    fi

    destination_dir+="/$BACKUP_SUBDIR/"

    case "$op" in
        bk|bkg) bk-item "$op" "$arg";;
        back|backg) bk-batch "$op";;
        *) fatal-assert "Invalid operation name in Backup: $op";;
    esac
}

bk-batch() {
    local op=$1

    local list op_i

    case "$op" in
        back) op_i=bk;;
        backg) op_i=bkg;;
        *) fatal-assert "Invalid batch operation name in bk-batch: $op";;
    esac

    file-to-array list < "${conf_file[backup]}"

    print-batch-head "$op"
    local item
    for item in "${list[@]}"; do
        bk-item "$op_i" "$item"
    done
    print-batch-tail "$op"
}

bk-item() {
    local op=$1
    local src_dir=$2

    local IGNORE_FILENAME=.ttignore
    local true_src_dir
    local -a ignore_list

    [[ "$src_dir" == "" ]] && { erro "Specify a directory to backup."; return; }

    [[ "$src_dir" =~ ^# ]] && { echo "=== Skipped: $C_STRIKETHROUGH${src_dir}$C_RESET"; return; }

    # this one also removes the trailing slash!
    true_src_dir=$(canonical-path "${src_dir/#\~/$HOME}") || { erro "No such directory: $src_dir"; return; }

    # TODO: build a separate array so that we pass "--exclude" and "pattern" as separate arguments! <- IMPORTANT
    # pattern-ignoring logic
    if [[ -f "$true_src_dir/$IGNORE_FILENAME" ]]; then
        file-to-array ignore_list < "$true_src_dir/$IGNORE_FILENAME"

        local index
        for index in "${!ignore_list[@]}"; do
            ignore_list[$index]="--exclude='${ignore_list[$index]}'"
        done
    fi

    case "$op" in
        bk)
            run-op "$op" rsync -avh -n --progress --delete "${ignore_list[@]}" -- "$true_src_dir" "$destination_dir"
            ;;
        bkg)
            run-op "$op" rsync -avh --progress --delete "${ignore_list[@]}" -- "$true_src_dir" "$destination_dir"
            ;;
    esac
}
