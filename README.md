
# Tootils - ! outdated README ! - bkd deleted

What do you get when you combine "tools" with "utils"? A silly redundant name.

Tootils is a suite of handy utilities (currently one) for Linux and Windows (using Bash through MSYS2/Cygwin/MinGW/Git Bash or, the way cool kids call it, MinSYS2CygBash for Lara Croft Windowed).  
MacOS? Undefined behavior.

## Features

bk|bkg|bkd|bkdg) `rsync` wrapper that takes *one* path and creates a mirror in your configured backups drive.  
back) Reads your configured list of paths and backs them all up.  
link) [planned] to be a tracked dotfiles symlinker.

Back-up logic avoids accidentally deleting files by ensuring the source directory argument does *not* contain a trailing slash (infamous `rsync` trap), and by creating a subdirectory in the destination.  
Tootils also has pretty output. :) Apart from its glorious elegance, it will show the external command that it runs.  
Optional `.ttignore` list to skip files/sub-directories.

Tootils creates a configuration file in `$XDG_CONFIG_HOME/tootils`, or `~/.config/tootils` if XDG is unset.  
Use this configuration to select your backups drive. Use a full path, in which a `TootilsBackups` sub-dir will be created.

## Dependencies

`rsync` for the backup functionality.

### Core Utils

`readlink`, `mkdir`, `cp`, `cygpath` (Windows only).  
That's it, the rest are Bash built-ins.

## Installation

> This part should be improved for noobs

- clone the repo
- `chmod +x tt` if on Linux
- either add it to your $PATH or make an alias with `path/to/Tootils/tt`

## Usage

`tt <subcommand> [arg]`

### Commands

- Use `tt bk <dir>` to back up a directory into your configured drive. Only it will show a dry run for you to check before running, so you should then:
- Use `tt bkg <dir>` to actually execute said backup. (`g` for go)
- Use `tt bkd <dir>` to approve deletion of extraneous files, making the destination a *true mirror* of the source. (`d` for delete). If you already copied files with `bkg`, this will only show what will be deleted, which is handy.
- Use `tt bkdg <dir>` to confirm and execute the full mirroring operation.
- Use `tt back [operation]` to read your list of configured directories and run the desired backup operation on all of them. Example: `tt back`, read output, then `tt back bkdg` to confirm and execute a full mirror of all your files.
- Oh, right! You can add a `.ttignore` file at the ***root*** of your source directory. Any patterns listed in that file will be completely ignored by `rsync`. ;)

### Config

Tootils will create these files in your config location:

- `tootils.conf`. For global variables. Currently `backupRoot`. Set it to a full path to your backups destination (i.e. `/e`, `/mnt/backups`).
- `backup.conf`. A list of source directories to be backed up by the `back` subcommand. Full path on each line. You can skip directories by commenting them (start the line with `#`).

## Footnote

This is a draft of a README. The utility will use `tt help` to display all of this in a higher quality way.  
Although now that I wrote this, it's kind of cool.  
The actual `tt` script acts as a generic dispatcher for arbitrary subcommands. It's easy to add functionality now.
