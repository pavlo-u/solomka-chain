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
archName="solomka-cli-x86_64-unknown-linux-gnu.tar.bz2"

# Creating a temporary directory
tempDir="$(mktemp -d)"
echo $temp_dir
cd "$tempDir"

# Downloading the Solomka CLI Binary Archive
# As long as the repository is private, you need to pass 
# a token to download files from the repository
if [ $# -eq 1 ]; then
# Get token
  token="$1"
# Custom link to download the Solomka CLI binary archive
  solomkaURL="https://$token@raw.githubusercontent.com/convowork1/solomka-mainnet/main/bin/$archName"
  
# Downloading the Solomka CLI Binary
  curl -LJO $solomkaURL
else
  echo "Invalid number of arguments. Please provide either a token"
  exit 1
fi

# Unpacking the Solomka CLI Binary
tar jxf solomka-cli-x86_64-unknown-linux-gnu.tar.bz2

# Defining the installation directory
installDir="$HOME/bin/solomka"  

# Copying the Solomka CLI binary to the installation directory
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
    # Exporting a path to use the Solomka CLI
    echo "Please update your PATH environment variable to include the solana programs:"
    echo "Use "export PATH="$installDir:\$PATH"""
fi

echo "Solomka CLI has been installed successfully"
echo "You can now use 'solomka' command in your terminal after restart"