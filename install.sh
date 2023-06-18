#!/bin/bash

echo "INSTALLING Required Libraries..."
sleep 0.5
echo ""

sudo apt upgrade
sudo apt install thefuck htop net-tools tmux python3-pip python3-venv
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

echo ""
echo ""
echo "INSTALLING NPORC..."
sleep 0.5

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
    echo "#!/bin/bash" >> ~/.bash_aliases
    cat ~/.nporc/.npo_aliases >> ~/.bash_aliases
fi

# copy tmux config over
sudo cp .tmux.conf ~

# copy contents of /templates/enviorment into /etc/environment and source that
# sudo cp ~/.nporc/templates/environment /etc/environment
# source /etc/environment

# TODO: ask y/n if user wants to setup github ssh keys 
# TODO:     copy over .npogit contents (optional)
# TODO:     setup get ssh keys for github (optional)
# TODO:     setup dev and fun stations (optional)

echo "DONE INSTALLING NPORC..."
sleep 1.5

source ~/.bashrc

