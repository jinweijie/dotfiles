#!/bin/bash

# install nvm if not exists
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# install node if not exists
if [ ! -d "$HOME/.nvm/versions/node/v22.16.0" ]; then
    nvm install 22.16.0
fi

# install codex
if [ ! -d "$HOME/.codex" ]; then
    git clone https://github.com/codex-ai/codex.git $HOME/.codex
fi

# copy the codex config from .codex/config.toml to $HOME/.codex/config.toml, check if the file exists
if [ ! -f "$HOME/.codex/config.toml" ]; then
    cp .codex/config.toml $HOME/.codex/config.toml
fi

# ask user deployment name and instance name
read -p "Enter deployment name: " DEPLOYMENT_NAME
read -p "Enter instance name: " INSTANCE_NAME

# update the codex config <DEPLOYMENT_NAME> <INSTANCE_NAME> with the deployment name and instance name
sed -i "s/<DEPLOYMENT_NAME>/$DEPLOYMENT_NAME/g" $HOME/.codex/config.toml
sed -i "s/<INSTANCE_NAME>/$INSTANCE_NAME/g" $HOME/.codex/config.toml

# check if $HOME/.api_keys exists, if not, create it
if [ ! -f "$HOME/.api_keys" ]; then
    touch $HOME/.api_keys
fi

# check if AZURE_OPENAI_API_KEY exists in $HOME/.api_keys, if not, ask user to enter the api key, else tell user api key already set
if grep -q "AZURE_OPENAI_API_KEY" "$HOME/.api_keys"; then
    echo "AZURE_OPENAI_API_KEY already set."
else
    read -p "Enter AZURE_OPENAI_API_KEY: " AZURE_OPENAI_API_KEY
    echo "AZURE_OPENAI_API_KEY=$AZURE_OPENAI_API_KEY" >> "$HOME/.api_keys"
fi