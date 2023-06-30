#!/bin/bash

# generate two ssh keys one for work and one for personal
WORK=$(gum input --placeholder "enter your email for work (that you use for github)")
echo $WORK
PERSONAL=$(gum input --placeholder "enter your email for personal github")
echo $PERSONAL

# CREATE KEYS
gum confirm "Create a WORK ssh key?" && \
ssh-keygen -t ed25519 -C "$WORK" -f "$HOME/.ssh/work" -P "" && cat ~/.ssh/work.pub

gum confirm "Create a PERSONAL ssh key?" && \
ssh-keygen -t ed25519 -C "$PERSONAL" -f "$HOME/.ssh/personal" -P "" && cat ~/.ssh/personal.pub

echo "Done!"

# ADD KEYS
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/work ~/.ssh/personal

echo -e "WORK KEY\n\n"
cat ~/.ssh/work.pub

echo -e "\n\nPERSONAL KEY\n\n"
cat ~/.ssh/personal.pub

# SSH CONFIG
gum confirm "init ssh config?" && \
sudo touch ~/.ssh/config && \
sudo cat ~/.nporc/.npogit/.npo_config >> ~/.ssh/config

# GIT CONFIG
