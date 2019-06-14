. ~/bin/bash_colors.sh

# Add paths that should have been there by default
export PATH=${PATH}:/usr/local/bin
export PATH="~/bin:$PATH"

# Unbreak broken, non-colored terminal
export TERM='xterm-color'
# export TERM='cygwin'
alias ls='ls -G'
alias ll='ls -lG'

# Alias python to python interactive to make it work on git bash
alias python3='winpty python'

export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

# Erase duplicates in history
export HISTCONTROL=erasedups
# Store 10k history entries
export HISTSIZE=10000
# Append to the history file when exiting instead of overwriting it
shopt -s histappend

# Git prompt components
function minutes_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1`
    seconds_since_last_commit=$((now-last_commit))
    minutes_since_last_commit=$((seconds_since_last_commit/60))
    echo $minutes_since_last_commit
}
grb_git_prompt() {
    local g="$(__gitdir)"
    if [ -n "$g" ]; then
        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
        if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
            local COLOR=${RED}
        elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
            local COLOR=${YELLOW}
        else
            local COLOR=${GREEN}
        fi
        #local SINCE_LAST_COMMIT="\[${COLOR}\]$(minutes_since_last_commit)m\[${NORMAL}\]"
        local SINCE_LAST_COMMIT="$(minutes_since_last_commit)m"
        # The __git_ps1 function inserts the current git branch where %s is
        #echo -n `__git_ps1 "(%s|${SINCE_LAST_COMMIT})"`
        local GIT_PROMPT=`__git_ps1 "(%s|${SINCE_LAST_COMMIT}) "`
        #local GIT_PROMPT=`__git_ps1 "(%s|"`
        #local MINUTES=`"(${SINCE_LAST_COMMIT})"`
        echo -n ${GIT_PROMPT}
        #echo -n ${MINUTES}
        #git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    fi
}

shortwd() {
    num_dirs=3
    pwd_symbol="..."
    newPWD="${PWD/#$HOME/~}"
    if [ $(echo -n $newPWD | awk -F '/' '{print NF}') -gt $num_dirs ]; then
        newPWD=$(echo -n $newPWD | awk -F '/' '{print $1 "/.../" $(NF-1) "/" $(NF)}')
    fi
    echo -n $newPWD
}
#PS1="\u:\[${VIOLET}\]\$(shortwd)\[${NORMAL}\] \$(grb_git_prompt) > "
PS1="\u:\[${VIOLET}\]\$(shortwd)\[${NORMAL}\] > "

activate_virtualenv() {
    if [ -f env/bin/activate ]; then . env/bin/activate;
    elif [ -f ../env/bin/activate ]; then . ../env/bin/activate;
    elif [ -f ../../env/bin/activate ]; then . ../../env/bin/activate;
    elif [ -f ../../../env/bin/activate ]; then . ../../../env/bin/activate;
    fi
}

python_module_dir () {
    echo "$(python -c "import os.path as _, ${1}; \
        print _.dirname(_.realpath(${1}.__file__[:-1]))"
        )"
}

source ~/bin/git-completion.bash

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

