local ret_status="%(?:🦄 :💥 )"
PROMPT='${ret_status} %{$fg_bold[cyan]%}%c%{$reset_color%} $(git_prompt_info)'


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}) ✍️ "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%}) 👌 "
