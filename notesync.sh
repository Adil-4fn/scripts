#!/usr/bin/env bash

set -e

# determine machine
. /etc/os-release #source
if [[ "$ID" != "arch" && "$ID" != "ubuntu" ]]; then
    echo "Error: system not recognized: $ID"
    exit 1
fi

if ! REPO=$(git rev-parse --show-toplevel 2>/dev/null); then
    echo "Error: not a git repo"
    exit 1
fi

if ! REMOTE_URL=$(git remote get-url origin 2>/dev/null); then
    echo "Error: no remote found"
    exit 1
fi

EXPECTED_REMOTE="git@github.com:Adil-4fn/notes.git"

if [[ "$REMOTE_URL" != "$EXPECTED_REMOTE" ]]; then
    echo "Error: not in notes."
    exit 1
fi

# check for changes mismatch
git fetch origin
COMMITS=$(git rev-list --left-right --count HEAD...origin/main)
read -r LOCAL_COMMITS REMOTE_COMMITS <<<"$COMMITS" # only commits not changes

# handle diverged
if [[ "$LOCAL_COMMITS" -gt 0 && "$REMOTE_COMMITS" -gt 0 ]]; then
    echo
    echo "Error: branches diverged"
    echo "Please resolve this manually."
    exit 1
fi

if [[ "$REMOTE_COMMITS" -gt 0 ]]; then
    echo
    echo "Remote changes detected"
    # check is needed coz stash can work without stuff but stash pop needs stuff
    if [[ -n "$(git status --porcelain)" ]]; then
        echo "Local changes detected"
        echo "Stashing local changes..."
        git stash -u
        echo "pulling..."
        git pull --ff-only
        echo "Retrieving stashed changes..."
        if ! git stash pop; then
            echo
            echo "Error: conflicts occured while restoring from stash"
            echo "Please resolve manuallly"
            exit 1
        fi
    else
        echo "pulling remote changes..."
        git pull
    fi
fi

if [[ -z "$(git status --porcelain)" ]]; then
    echo
    echo "no changes to sync"
    exit 0
fi

echo
echo "Changes:"
git status --short
git add -A
git commit -m "notesync $ID"
git push
echo
echo "sync finished successfully"
