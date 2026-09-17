#!/usr/bin/env bash


# idea is to use 'touch' to open the current day journal
# get the date, format the file name and path, use touch to make it
# and then open it in nvim
# next stage would be terminal version vs niri version

NOTES_DIRECTORY="/home/adil/notes/tempjourn/"
#directory check
[ -d "$NOTES_DIRECTORY" ] ||{
    echo "Directory does not exist"
    exit 1
}

today=$(date +%Y-%m-%d)
daily_note="${NOTES_DIRECTORY}/${today}.md"

touch "$daily_note" ||{
    notify-send 'journal' "failed to make note"
    exit 1
}

#nvim "$daily_note"

