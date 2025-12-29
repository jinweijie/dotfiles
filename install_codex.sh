#!/bin/bash


set -e

# install nvm if not exists
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# install node if not exists
if [ ! -d "$HOME/.nvm/versions/node/v22.16.0" ]; then
    nvm install 22.16.0
fi

# install codex
npm i -g @openai/codex

# copy the codex config from .codex/config.toml to $HOME/.codex/config.toml, check if the file exists
mkdir -p "$HOME/.codex"
cp .codex/config.toml "$HOME/.codex/config.toml"

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
if grep -q "export AZURE_OPENAI_API_KEY=" "$HOME/.api_keys"; then
    echo "AZURE_OPENAI_API_KEY already set."
else
    read -p "Enter AZURE_OPENAI_API_KEY: " AZURE_OPENAI_API_KEY
    echo "export AZURE_OPENAI_API_KEY=$AZURE_OPENAI_API_KEY" >> "$HOME/.api_keys"
fi