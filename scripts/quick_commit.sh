#!/bin/sh

SUMMARY=$(gum input --placeholder "write a quick summary")
test -n "$SUMMARY" && SUMMARY="$SUMMARY"
echo $SUMMARY
gum confirm "do you want to commit?" && git add . && git commit -m "$SUMMARY" && git push