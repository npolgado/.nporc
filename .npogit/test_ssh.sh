#!/bin/sh

CHOICE=$(gum choose "work" "personal")

echo $CHOICE

echo -e "testing ssh connection...\n\n\n\n"

if [ "$CHOICE" = "work" ]; then
    ssh -vT git@github-work.com
fi

if [ "$CHOICE" = "personal" ]; then
    ssh -vT git@github.com
fi

echo "Done!"