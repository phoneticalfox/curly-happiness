#!/bin/bash

# Finalize LoomChat Setup Script

# Define variables
DIR_NAME="loomchat"

# Navigate to the project directory
cd $DIR_NAME || { echo "Directory $DIR_NAME not found."; exit 1; }

# Finalize project setup
echo "Finalizing setup for LoomChat..."

# Sync dependencies (if any) - Uncomment if you want to use Gradle to sync dependencies
# ./gradlew build

# Run any additional setup commands, e.g., create a sample data directory
mkdir -p app/src/main/assets/sample_data

# Optional: Generate sample text files or data
echo "Generating sample data..."
cat <<EOL > app/src/main/assets/sample_data/sample_text.txt
"The more I study, the more insatiable do I feel my genius for it to be."
"I believe myself to possess a most singular combination of qualities exactly fitted to make me preeminently a discoverer of the hidden realities of nature."
"I am more than ever now the bride of science. Religion to me is science, and science is religion."
EOL

# Notify user of successful setup
echo "Setup finalized successfully for LoomChat!"

# Optional: Open project in Android Studio (uncomment if you have the command-line tools installed)
# studio.sh .

# Exit the script
exit 0