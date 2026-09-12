#! /bin/bash

. ~/scripts/colors.sh

# Prompt variables
PROMPT_BEFORE="$txtcyn\u@\h $txtwht\w$txtrst"
PROMPT_AFTER="\\n> "

# Prompt command
PROMPT_COMMAND='__git_ps1 "$PROMPT_BEFORE" "$PROMPT_AFTER"'

# Git prompt features (read ~/.git-prompt.sh for reference)
export GIT_PS1_SHOWDIRTYSTATE="true"
export GIT_PS1_SHOWSTASHSTATE="true"
export GIT_PS1_SHOWUNTRACKEDFILES="true"
export GIT_PS1_SHOWUPSTREAM="auto verbose"
export GIT_PS1_SHOWCOLORHINTS="true"
