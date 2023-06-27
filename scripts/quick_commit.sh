#!/bin/sh

gum confirm "Pull repo on git?" && git fetch && git pull

git status

SUMMARY=$(gum input --placeholder "Type your commit message here")

test -n "$SUMMARY" && SUMMARY="$SUMMARY"

echo $SUMMARY

gum confirm "Do you want to commit?" && git add . && git commit -m "$SUMMARY" && git push