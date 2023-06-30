#!/bin/sh

CHOICE=$(gum choose "work" "personal")

echo $CHOICE

echo "testing ssh connection...\n\n\n\n"

if [ "$CHOICE" = "work" ]; then
    ssh -T git@github-nickolgado
fi

if [ "$CHOICE" = "personal" ]; then
    ssh -T git@github.com
fi

echo "Done!"