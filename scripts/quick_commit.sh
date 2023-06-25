#!/bin/sh

SUMMARY=$(gum input --placeholder "write a quick summary")
echo $SUMMARY
test -n "$SUMMARY" && SUMMARY="($SUMMARY)"

git add . && git commit -m $SUMMARY && git push