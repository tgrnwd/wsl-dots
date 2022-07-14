#!/usr/bin/env bash
# set -e

# skip_system_packages="${1}"


# apt_packages="curl git iproute2 python3-pip ripgrep tmux vim-gtk zsh"
# apt_packages_optional="gnupg htop jq pass pwgen rsync shellcheck unzip"

# function apt_install_packages {
#     sudo apt-get update && sudo apt-get install -y ${apt_packages} ${apt_packages_optional}
# }

# function display_packages {
#     if [ "${os_type}" == "Linux" ]; then
#         echo "${apt_packages} ${apt_packages_optional}"
#     else
#         echo "${brew_packages} ${brew_packages_optional}"
#     fi
# }
##########

# Use apt over HTTPS
sudo apt update && sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add AzureCLI to sources.list
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

# Add Docker to sources.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install development tools
sudo apt update && sudo apt -y upgrade
sudo apt install -y \
    azure-cli \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    fontconfig \
    git \
    gnupg \
    unzip \
    jq \
    zsh

# Add user to docker group
sudo usermod -aG docker $USER

# Create a Code directory for all our work
mkdir $HOME/Code

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Link custom dotfiles
ln -s $HOME/.dotfiles/.aliases.zsh $HOME/.aliases.zsh
ln -s $HOME/.dotfiles/.gitignore_global $HOME/.gitignore

# Install JetBrains Mono typeface
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# tfswitch
ln -s $HOME/.dotfiles/.tfswitch.toml $HOME/.tfswitch.toml
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# Change the default shell to ZSH
chsh -s $(which zsh)