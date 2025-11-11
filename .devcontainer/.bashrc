# Custom bash prompt with git information

# Function to get git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Set custom prompt with git info
# Format: user [ /path/to/dir ] (git-branch) #
PS1='\[\e[1;32m\]\u\[\e[0m\] [ \w ] \[\e[1;36m\]$(parse_git_branch)\[\e[0m\] # '

export PS1

# Start SSH agent and add all private keys
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    # Add all private keys (files without .pub extension)
    for key in /root/.ssh/id_* /root/.ssh/*_ed25519 /root/.ssh/*_rsa; do
        if [ -f "$key" ] && [ ! "${key##*.}" = "pub" ]; then
            ssh-add "$key" > /dev/null 2>&1
        fi
    done
fi
