# the prompt
PROMPT_COLOR='\e[00m\e[38;05;166m'
export PS1='\['$PROMPT_COLOR'\][\h]: \w\$\[\e[0m\] '

#colouring different file types
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# aliases & shortcuts
# alias textedit='open -a TextEdit'
alias l='ls -al'
alias s='git status'
alias t='tmux -a'
alias gits='git status'

eval "$(thefuck --alias fuck)"

#git-autocomplete
if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
