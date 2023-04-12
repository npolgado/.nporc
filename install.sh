#!/bin/bash

echo "INSTALLING Required Libraries..."

sudo apt upgrade && sudo apt update
sudo apt install thefuck htop net-tools 
python3 -m pip install --upgrade pip
python3 -m pip install python3-ensurepip
python3 -m pip install -r requirements.txt

echo "INSTALLING NPORC..."

# Check if ~/.bashrc exists
if [ -f ~/.bashrc ]; then
    echo "~/.bashrc exists"

    if grep -q "#:begin" ~/.bashrc; then
        echo "updating .bashrc..."
        sed -i '/#:begin/,$d' ~/.bashrc
        cat ~/.nporc/.nporc | sed -n '/#:begin/,$p' >> ~/.bashrc
    else
        cat ~/.nporc/.nporc >> ~/.bashrc
    fi
else
    echo "~/.bashrc does not exist, creating..."
    /bin/cp /etc/skel/.bashrc ~/
    cat ~/.nporc/.nporc >> ~/.bashrc
fi

# Check if ~/.bash_aliases exists
if [ -f ~/.bash_aliases ]; then
    echo "~/.bash_aliases exists"

    if grep -q "#:begin" ~/.bash_aliases; then
        echo "updating .bash_aliases..."
        sed -i '/#:begin/,$d' ~/.bash_aliases
        cat ~/.nporc/.npo_aliases | sed -n '/#:begin/,$p' >> ~/.bash_aliases
    else
        cat ~/.nporc/.npo_aliases >> ~/.bash_aliases
    fi
else
    echo "~/.bash_aliases does not exist, creating..."
    touch ~/.bash_aliases
    cat ~/.nporc/.npo_aliases >> ~/.bash_aliases
fi

echo "DONE INSTALLING NPORC..."
sleep 1

source ~/.bashrc

