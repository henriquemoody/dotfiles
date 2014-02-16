# .bashrc
declare -x CLICOLOR=1

alias grep='grep --color'
alias egrep='egrep --color'
alias pgrep='ps aux | grep -v grep | grep'

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

# User specific aliases and functions
PATH="${HOME}/.local/bin:/usr/local/opt/php55/bin:${PATH}"

git_branch_name()
{
    local parsed
    local shortstat
    local length
    local limit
    local parsed_start
    local parsed_end

    git rev-parse 2> /dev/null
    if [[ ${?} -gt 0 ]]; then
        return
    fi

    parsed=$(git branch 2>/dev/null | grep -e '^*' | awk '{print $2}')
    shortstat=$(git diff --shortstat HEAD 2>/dev/null | sed -E 's/[^0-9=,+-]//g')
    length=$(echo "${parsed}" | wc -c | sed 's/[^0-9]//g')

    if [[ ${length} -gt 40 ]]; then
        limit=$((length-17))
        parsed_start=$(echo "${parsed}" | cut -c 1-20)
        parsed_end=$(echo "${parsed}" | cut -c ${limit}-${length})
        parsed="${parsed_start}...${parsed_end}"
    fi

    if [[ ! -z "${shortstat}" ]]; then
        parsed="${parsed} * ${shortstat}"
    fi

    echo "(${parsed}) "
}

PS1="\u [\w] \$(type git_branch_name &>/dev/null && git_branch_name)$ "

export PS1
export PATH
