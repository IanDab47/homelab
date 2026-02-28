#!/bin/bash

# CONFIGURATION: CHANGE THESE
USERNAME="IanDab47"
REPO_NAME="homelab"
PROJECT_DIR="~/Home/homelab" 

# Move into project folder
cd "$PROJECT_DIR" || { echo "Folder not found!"; exit 1; }

# Initialize Git if not initialized
if [ ! -d ".git" ]; then
    git init
    echo "Git repository initialized."
fi

# Create basic .gitignore for sensitive files if it doesn't exist
if [ ! -f ".gitignore" ]; then
cat > .gitignore <<EOL
# Ignore OS / editor files
*.swp
*.swo
*.DS_Store
*.bak
*.tmp

# Ignore any potential sensitive configs
*.conf
*.key
*.pem
.env
opnsense-backup.xml
wireguard.conf
EOL
    echo ".gitignore created."
fi

# Function to generate Table of Contents
generate_toc() {
    README="$PROJECT_DIR/README.md"
    echo "# Homelab Public Documentation" > "$README"
    echo "" >> "$README"
    echo "Welcome to my homelab documentation. This repository outlines my architecture, network design, VM inventory, services, workflows, and lessons learned. All sensitive information has been abstracted." >> "$README"
    echo "" >> "$README"
    echo "## Table of Contents" >> "$README"
    echo "" >> "$README"

    # Loop through all Markdown files under docs/ recursively
    find docs -type f -name "*.md" | sort | while read -r file; do
        # Get relative path for link
        relpath="${file#"$PROJECT_DIR/"}"
        # Use filename without extension as title
        title=$(basename "$file" .md | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')
        echo "- [$title]($relpath)" >> "$README"
    done
}

# Generate TOC
generate_toc
echo "README.md Table of Contents updated."

# Add all files
git add .

# Commit changes
git commit -m "Update docs and README.md TOC"

# Set default branch to main if not already
git branch -M main

# Add remote if not added yet
if ! git remote | grep -q origin; then
    git remote add origin https://github.com/$USERNAME/$REPO_NAME.git
fi

# Push changes
git push -u origin main

echo "All done! Your repo '$REPO_NAME' should now be on GitHub."
