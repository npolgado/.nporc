#!/bin/bash

echo "INSTALLING Required Libraries..."

sudo apt upgrade && sudo apt update
sudo apt install thefuck htop net-tools 


echo "INSTALLING NPORC..."

# Creating npo directory
if [ ! -d ~/.npo ]; then
  mkdir ~/.npo
  cp -r . ~/.npo
fi

# Check if ~/.bashrc exists
if [ -f ~/.bashrc ]; then
    echo "~/.bashrc exists"

    if grep -q "#:begin" ~/.bashrc; then
        echo "updating .bashrc..."
        sed -i '/#:begin/,$d' ~/.bashrc
        cat ~/.npo/.nporc | sed -n '/#:begin/,$p' >> ~/.bashrc
    else
        cat ~/.npo/.nporc >> ~/.bashrc
    fi
else
    echo "~/.bashrc does not exist, creating..."
    /bin/cp /etc/skel/.bashrc ~/
    cat ~/.npo/.nporc >> ~/.bashrc
fi

# Check if ~/.bash_aliases exists
if [ -f ~/.bash_aliases ]; then
    echo "~/.bash_aliases exists"

    if grep -q "#:begin" ~/.bash_aliases; then
        echo "updating .bash_aliases..."
        sed -i '/#:begin/,$d' ~/.bash_aliases
        cat ~/.npo/.npo_aliases | sed -n '/#:begin/,$p' >> ~/.bash_aliases
    else
        cat ~/.npo/.npo_aliases >> ~/.bash_aliases
    fi
else
    echo "~/.bash_aliases does not exist, creating..."
    touch ~/.bash_aliases
    cat ~/.npo/.npo_aliases >> ~/.bash_aliases
fi

echo "DONE INSTALLING NPORC..."
sleep 0.5

source ~/.bashrc

