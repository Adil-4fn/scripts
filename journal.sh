#!/usr/bin/env bash

NOTES_DIRECTORY="$HOME/notes/journal/"
#directory check
[ -d "$NOTES_DIRECTORY" ] || {
    echo "Directory does not exist"
    exit 1
}

today=$(date +%Y-%m-%d)
daily_note="${NOTES_DIRECTORY}/${today}.md"

touch "$daily_note" ||
    {
        notify-send --expire-time=3000 'journal' "failed to make note"
        exit 1
    }

nvim "$daily_note"
