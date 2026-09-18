tea-gist() {
    export OPENGIST_CLI_URL="https://gist.gitcodo.hub"

    if [[ -z ${OPENGIST_CLI_TOKEN:-} ]]; then
        export OPENGIST_CLI_TOKEN="$(pass gist.gitcodo.hub.token)"
    fi

    opengist-cli "$@"
}

if [[ -n $commands[opengist-cli] ]]; then
    if [[ ! -f ${fpath[1]}/_opengist-cli ]]; then
        opengist-cli completion zsh >| "${fpath[1]}/_opengist-cli"
    fi

    compdef tea-gist=opengist-cli
fi
