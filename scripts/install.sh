#!/bin/sh

os=$(uname -s)

echo "INSTALLING Required Libraries..."
sleep 0.5
echo ""

if [ "$os" = "Darwin" ]; then
    echo "Running on macOS..."
    brew update && brew upgrade
    brew install htop tree thefuck speedtest-cli wget gum nmap tldr tmux 
    python -m pip install --upgrade pip
    python -m pip install -r requirements.txt

    echo ""
    echo "INSTALLING NPORC..."
    sleep 0.5

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
    
    # essentials TODO: read from yaml
    sudo apt-get update
    sudo apt-get install -y thefuck htop net-tools tmux tree speedtest-cli 
    sudo apt-get install -y wget nmap ca-certificates indicator-multiload
    sudo apt-get install -y python3-pip python3-venv
    
    # install gum
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install gum
    
    # python
    python3 -m pip install --upgrade pip
    python3 -m pip install -r ~/.nporc/requirements.txt

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
    sudo touch ~/.tmux.conf
    sudo cp ~/.nporc/.tmux.conf ~

    echo "DONE INSTALLING NPORC..."
    sleep 1.5

    # change .nporc remote origin url
    cd ~/.nporc && git remote set-url origin git@github.com:npolgado/.nporc.git

    source ~/.bashrc
else
    echo "Unknown operating system: $os"
fi