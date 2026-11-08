#!/bin/bash
# xauthority setup
# Edgar Hernandez
# 
# Creates a copy of the current sessions $XAUTHORITY file in XAUTH_DIR.
#   Defaults to /tmp/container_env/.xauth
# 
# usage:
#   ./path/to/xauthority_setup.sh 
# 
# Description:
#   Script to setup the xauthority environmental variable for using graphics in dev container
#   and to allow for peristent development. 
#   Becuase wayland doesnt have a static token, this script caches that token with a static name
#   in /tmp.
# 
#   NOTE: The user owns the cached fPile by default. It is up to the user to deal with permissions!
set -e

# ensure that the actual xauthority exists so we dont get nasty weird bugs...
if [ -z "$XAUTHORITY" ]; then
    echo "Error: XAUTHORITY is not set, ensure system is booted properly and script is ran locally" >&2
    exit 1
fi

XAUTH_DIR="/tmp/container_env"
XAUTH_FILE="$XAUTH_DIR"/.xauth

# creates the container_env directory if it doesnt exist in tmp
if [ ! -d "$XAUTH_DIR" ]; then
    echo "Directory $XAUTH_DIR does not exist. Creating it..."
    mkdir -p "$XAUTH_DIR"
fi

# check permissions/ownership of the source Xauthority file
XAUTH_PERMS=$(stat -c "%a" "$XAUTHORITY")   # gets the octal permission code
XAUTH_OWNER=$(stat -c "%U" "$XAUTHORITY")   # gets the owner, not entirely sure what happens if its a shared computer?

if [ "$XAUTH_PERMS" != "600" ]; then
    echo "Warning: $XAUTHORITY has permissions $XAUTH_PERMS, expected 600." >&2
fi

if [ "$XAUTH_OWNER" != "$(whoami)" ]; then
    echo "Warning: $XAUTHORITY is owned by $XAUTH_OWNER, not current user ($(whoami))." >&2
fi

# Check if the file exists
if [ -f "$XAUTH_FILE" ]; then
    read -p "File $XAUTH_FILE exists. Overwrite? (yes/no) " answer
    if [ "$answer" = "yes" ]; then
        echo "backing up previously cached XAUTHORITY to $XAUTH_FILE.bak"
        cp "$XAUTH_FILE" "$XAUTH_FILE.bak"

        echo "Overwriting $XAUTH_FILE..."
        cp "$XAUTHORITY" "$XAUTH_FILE"
        chmod 600 "$XAUTH_FILE"
    else
        echo "Keeping existing file."
    fi
else
    echo "File $XAUTH_FILE does not exist. Creating it..."
    cp "$XAUTHORITY" "$XAUTH_FILE"
    chmod 600 "$XAUTH_FILE"
fi