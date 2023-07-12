#!/usr/bin/env bash

set -e

# Checking the operating system and architecture
if [[ "$(uname)" != "Linux" || "$(uname -m)" != "x86_64" ]]; then
  echo "This script is only supported on Linux x86_64"
  exit 1
fi

# Checking installed dependencies
if ! command -v curl &> /dev/null; then
  echo "curl is required but not installed. Please install curl"
  exit 1
fi

# Archive name
archName="sonoma-cli-x86_64-unknown-linux-gnu.tar.bz2"

# Creating a temporary directory
tempDir="$(mktemp -d)"
echo $temp_dir
cd "$tempDir"

# Downloading the Sonoma CLI Binary Archive
# As long as the repository is private, you need to pass 
# a token to download files from the repository
if [ $# -eq 1 ]; then
# Get token
  token="$1"
# Custom link to download the Sonoma CLI binary archive
  sonomaURL="https://$token@raw.githubusercontent.com/convowork1/loop-chain-fork/main/bin/$archName"
  
# Downloading the Sonoma CLI Binary
  curl -LJO $sonomaURL
else
  echo "Invalid number of arguments. Please provide either a token"
  exit 1
fi

# Unpacking the Sonoma CLI Binary
tar jxf sonoma-cli-x86_64-unknown-linux-gnu.tar.bz2

# Defining the installation directory
installDir="$HOME/bin/sonoma"  

# Copying the Sonoma CLI binary to the installation directory
mkdir -p "$installDir"
cp -R ./* "$installDir"
rm $installDir/$archName

# Check for the presence of .bash_profile
if [ -f "$HOME/.bash_profile" ]; then
    # Add the bin path to .bash_profile
    if ! grep -q "$installDir" "$HOME/.bash_profile"; then
        echo "export PATH=\"$installDir:\$PATH\"" >> "$HOME/.bash_profile"
        echo "Bin path successfully added to .bash_profile"
    else
        echo "Bin path already exists in .bash_profile"
    fi
# Check for the presence of .profile
elif [ -f "$HOME/.profile" ]; then
    # Add the bin path to .profile
    if ! grep -q "$installDir" "$HOME/.profile"; then
        echo "export PATH=\"$installDir:\$PATH\"" >> "$HOME/.profile"
        echo "Bin path successfully added to .profile"
    else
        echo "Bin path already exists in .profile"
    fi
else
    echo "Neither .profile nor .bash_profile found"
    # Exporting a path to use the Sonoma CLI
    echo "Please update your PATH environment variable to include the solana programs:"
    echo "Use "export PATH="$installDir:\$PATH"""
fi

echo "Sonoma CLI has been installed successfully"
echo "You can now use 'sonoma' command in your terminal after restart"