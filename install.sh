# Exit immediately if a command exits with a non-zero status
set -e

# Check the distribution name and version and abort if incompatible
source ~/.local/share/omakub/install/check-version.sh

# Install terminal tools
source ~/.local/share/omakub/install/terminal.sh
