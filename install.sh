#!/data/data/com.termux/files/usr/bin/bash

# AI - Droid Installation Script for Termux (Android/Linux)
echo "Welcome to the AI - Droid installation script!"
echo "This script will download and install AI - Droid on your system."

# Check if the system is running Linux (Termux runs on Android/Linux)
if [[ "$(uname -o)" != "Android" && "$(uname -s)" != "Linux" ]]; then
  echo "This script supports only Linux-based systems (Android/Termux)."
  echo "Installation aborted."
  exit 1
fi

# Check CPU architecture
ARCHITECTURE=$(uname -m)
if [[ "$ARCHITECTURE" != "aarch64" ]]; then
  echo "Unsupported architecture: $ARCHITECTURE. Only arm64 (aarch64) is supported."
  echo "Installation aborted."
  exit 1
fi

echo "System compatibility check passed. Proceeding with installation..."

# Check if curl is installed
if ! command -v curl &> /dev/null; then
  echo "Error: 'curl' is not installed. Install it using 'pkg install curl' and try again."
  echo "Installation aborted."
  exit 1
fi

# Ask for user confirmation before proceeding
read -p "Do you want to continue with the installation of AI - Droid? (y/n): " response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
  echo "Installation aborted. No changes were made."
  exit 0
fi

# Define download URL and installation path
GITHUB_URL="https://Android-Artisan.github.io/AI-Droid/ollama"
INSTALL_DIR="$PREFIX/bin"
BINARY_NAME="ollama"
TEMP_FILE=$(mktemp)

# Ensure cleanup on failure
trap 'rm -f "$TEMP_FILE"' EXIT

# Download function
download_file() {
  echo "Downloading AI - Droid binary..."
  if ! curl -L --progress-bar -o "$TEMP_FILE" "$GITHUB_URL"; then
    echo "Error: Download failed. Check your internet connection and try again."
    echo "Installation aborted."
    exit 1
  fi
}

# Installation function
install_binary() {
  echo "Installing AI - Droid..."
  mkdir -p "$INSTALL_DIR"
  mv "$TEMP_FILE" "$INSTALL_DIR/$BINARY_NAME"
  chmod +x "$INSTALL_DIR/$BINARY_NAME"
  
  if [ -x "$INSTALL_DIR/$BINARY_NAME" ]; then
    echo "AI - Droid installed successfully!"
  else
    echo "Error: Installation failed. Check permissions and try again."
    exit 1
  fi
}

# Post-installation verification
test_installation() {
  echo "Testing AI - Droid installation..."
  if "$INSTALL_DIR/$BINARY_NAME" --version &> /dev/null; then
    echo "AI - Droid is installed and working correctly!"
  else
    echo "Warning: AI - Droid is installed but may not be working correctly."
  fi
}

# Execute functions
download_file
install_binary
test_installation
