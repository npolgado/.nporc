#!/bin/sh
os=$(uname -s)

#TODO: check if gum is installed

gum style --foreground 99 --border double --border-foreground 99 --padding "1 2" --margin 1 "Updating bash/zsh profile from NPORC"

if [ "$os" = "Darwin" ]; then
    echo "Running on MacOs..."
    
    brew update && brew upgrade

    # Check if ~/.zshrc exists
    if [ -f ~/.zshrc ]; then
        echo "~/.zshrc exists"

        if grep -q "#:begin" ~/.zshrc; then
            echo "updating .zshrc..."
            sed -i '' '/:begin/,$d' ~/.zshrc
            sleep 1
            cat ~/.nporc/.nporc >> ~/.zshrc
            cat ~/.nporc/.npo_aliases >> ~/.zshrc
            
        else
            echo "no previous npo implementation.."
            sleep 1
            cat ~/.nporc/.nporc >> ~/.zshrc
            cat ~/.nporc/.npo_aliases >> ~/.zshrc
        fi
    else
        echo "~/.zshrc does not exist, creating..."
        sleep 1
        touch ~/.zshrc
        cat /etc/zshrc >> ~/.zshrc
        cat ~/.nporc/.nporc >> ~/.zshrc
        cat ~/.nporc/.npo_aliases >> ~/.zshrc
    fi

    # copy tmux config over
    sudo cp .tmux.conf ~

    echo "DONE INSTALLING NPORC..."
    sleep 1.5

    source ~/.zshrc

elif [ "$os" = "Linux" ]; then
    echo "Running on Linux..."
    sudo apt-get update

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
    sudo cp ~/.nporc/.tmux.conf ~

    echo "DONE INSTALLING NPORC..."
    sleep 1.5
else
    echo "Unknown operating system: $os"
fi