
# Only sourced on login shells
# Sourced after zshrc

# Add autocompletions
export fpath=("$HOME/.zsh/completion/local" $fpath)
export fpath=("$HOME/.zsh/completion/global" $fpath)

autoload -Uz compinit && compinit

if [[ -f $HOME/.zlocal ]]; then
  source $HOME/.zlocal
fi