
# Only sourced on login shells
# Sourced before zshrc

# Make popd/pushd queit
setopt PUSHDSILENT

# Alias mk to popd
alias mk='popd'

# Alias brewup
alias brewup='brew update && brew upgrade && brew cask upgrade && brew cleanup && brew doctor'

function resource_zsh {
  if [[ ! -v ZDOTDIR ]]; then
    ZDOTDIR=$HOME
  fi
  source $ZDOTDIR/.zshenv
  source $ZDOTDIR/.zprofile
  source $ZDOTDIR/.zshrc
  source $ZDOTDIR/.zlogin
}