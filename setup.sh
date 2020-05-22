#!/usr/bin/env bash

#Variables
ZSH_LOC="${ZSH_LOC:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"


# Silence pushd/popd
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd > /dev/null
}

# Get Script Directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd "$DIR" || exit

echo "Checking for oh-my-zsh install"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "Oh My Zsh already installed"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"

# Install powerlevel10 theme
if [[-d "$ZSH_CUSTOM/themes/powerlevel10k"]]; then
    echo "Powerlevel10k theme already installed"
else    
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

# Install zsh autocompletions plugin
if [[-d "$ZSH_CUSTOM/plugins/zsh-autosuggestions"]]; then
    echo "Updating zsh-autocompletions repository"
    pushd $ZSH_CUSTOM/plugins/zsh-autosuggestions || exit
    git pull
    popd || exit
else
    echo "Updating zsh-autocompletions"
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions


echo "Setting theme to powerlevel10k (remember to change the font in iTerm preferences)"
sed -i '' 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/g' $HOME/.zshrc
sed -i '' 's/plugins=(git)/plugins=(brew compleat git npm osx yarn)/g' $HOME/.zshrc
sed -i '' 's/# HIST_STAMPS/HIST_STAMPS/g' $HOME/.zshrc
sed -i '' 's/# DISABLE_UNTRACKED_FILES_DIRTY/DISABLE_UNTRACKED_FILES_DIRTY/g' $HOME/.zshrc
sed -i '' 's/# COMPLETION_WAITING_DOTS/COMPLETION_WAITING_DOTS/g' $HOME/.zshrc

if [[-f "$HOME/.p10k.zsh"]] then
    echo "Powerline config file already exists"
else
