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
alias x='exit'
alias ctags='/usr/local/bin/ctags'

#git-autocomplete
if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash
fi

# asdf universal version manager
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
