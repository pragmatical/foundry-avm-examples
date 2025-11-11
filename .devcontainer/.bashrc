# Custom bash prompt with git information

# Function to get git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Set custom prompt with git info
# Format: user [ /path/to/dir ] (git-branch) #
PS1='\[\e[1;32m\]\u\[\e[0m\] [ \w ] \[\e[1;36m\]$(parse_git_branch)\[\e[0m\] # '

export PS1
