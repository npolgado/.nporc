#!/bin/sh

SUMMARY=$(gum input --placeholder "write a quick summary")
echo $SUMMARY
# test -n "$SUMMARY" && SUMMARY="($SUMMARY)"

gum confirm "do you want to commit $SUMMARY?" && git add . && git commit -m $SUMMARY && git push