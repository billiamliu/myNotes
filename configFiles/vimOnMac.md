The bundled VIM doesn't have all the dependencies
Get MacVIM, then change terminal editor alias:
In `~/.bash_profile`
```
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
```
ALSO, in `.gitconfig`
```
autocrlf = false
```
AND, for pastbin to work with tmux
```
brew install reattach-to-user-namespace
```
