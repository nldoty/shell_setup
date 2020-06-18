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
if [[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    echo "Powerlevel10k theme already installed"
else    
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

# Install zsh autocompletions plugin
if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    echo "Updating zsh-autocompletions repository"
    pushd $ZSH_CUSTOM/plugins/zsh-autosuggestions || exit
    git pull
    popd || exit
else
    echo "Downloading zsh-autocompletions"
    git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
fi

echo "Make sure you update your theme in iTerm2 to Solarized Dark"
echo "Setting theme to powerlevel10k (remember to change the font in iTerm preferences)"

sed -i '' 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|g' $HOME/.zshrc
sed -i '' 's/plugins=(git)/plugins=(brew compleat git npm osx yarn zsh-completions)/g' $HOME/.zshrc
sed -i '' 's|# HIST_STAMPS|HIST_STAMPS|g' $HOME/.zshrc
sed -i '' 's|# DISABLE_UNTRACKED_FILES_DIRTY|DISABLE_UNTRACKED_FILES_DIRTY|g' $HOME/.zshrc
sed -i '' 's|# COMPLETION_WAITING_DOTS|COMPLETION_WAITING_DOTS|g' $HOME/.zshrc

# These commands use double quotes so newline characters can be included
sed -i '' '/User configuration/a\
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' $HOME/.zshrc

# Install font tool and fonts
echo "Installing fonts in font folder"
source install-fonts.sh

echo "Symlinking dotfiles to home directory"

# Setting up globignore for zsh
GLOBIGNORE=.

# Grab all .files
FILES=".*"

# Ignore certain files
IGNORE=(".gitignore")

# For each file, symlink to home directory
for f in $FILES; do

  if [[ -d $f ]]; then
    echo "Skipping directory $f"
    continue
  fi
  
  if [[ " ${IGNORE[@]} " =~ " ${f} " ]]; then
    echo "Skipping file $f"
    continue
  fi

  f_source="$DIR/$f"
  f_dest="$HOME/$f"
  echo "Linking $f from $f_source to $f_dest"

  if [[ -f $f_dest ]]; then
    echo "$f_dest already exists, replacing"
    rm "$f_dest"
  fi

  if [[ -L $f_dest ]]; then
    echo "$f_dest is already a symlink, replacing with new symlink"
    rm "$f_dest"
  fi

  ln -s "$f_source" "$f_dest"
done

echo "Updating completions by running compinit"

popd || exit
