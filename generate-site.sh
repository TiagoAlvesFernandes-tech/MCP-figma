#!/bin/bash

# Figma to Production - Site Generation Script
# Automates the process of generating a new landing page from Figma

echo "=========================================="
echo "  Figma → Production Site Generator"
echo "=========================================="
echo ""

# Get site name from user
read -p "Enter site name (lowercase, use hyphens): " site_name

# Validate site name
if [ -z "$site_name" ]; then
    echo "❌ Error: Site name cannot be empty"
    exit 1
fi

# Convert to lowercase and replace spaces with hyphens
site_name=$(echo "$site_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
site_dir="site_$site_name"

# Check if site already exists
if [ -d "$site_dir" ]; then
    echo "⚠️  Site directory already exists: $site_dir"
    read -p "Do you want to overwrite it? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
    rm -rf "$site_dir"
fi

echo ""
echo "📝 Creating site: $site_name"
echo "📁 Directory: $site_dir"
echo ""

# Create site directory
mkdir -p "$site_dir"
mkdir -p "$site_dir/assets"

echo "✅ Directory structure created"
echo ""

# Instructions for using Figma MCP
echo "=========================================="
echo "  STEP 1: Get Code from Figma"
echo "=========================================="
echo ""
echo "Instructions:"
echo "1. Open your Figma file"
echo "2. Select the root frame you want to generate"
echo "3. In Copilot Chat, use this prompt:"
echo ""
echo "---START PROMPT---"
cat << 'PROMPT'
Read the selected Figma frame via MCP. Generate a semantic, accessible landing page with:

1. **Structure**: Semantic HTML5 with proper heading hierarchy
2. **Styling**: Vanilla CSS with CSS custom properties for design tokens
3. **Interactivity**: Vanilla JavaScript for animations and interactions
4. **Responsiveness**: Mobile-first responsive design
5. **Assets**: Note all image URLs from localhost:3845

Save the files as:
- index.html (in the current directory)
- styles.css (in the current directory)  
- script.js (in the current directory)
- README.md (documentation)

Map all Figma design tokens to CSS custom properties and add TODO comments where variables should be connected.
PROMPT
echo "---END PROMPT---"
echo ""
echo "4. After generation, the files will be created automatically"
echo "5. Come back here and press ENTER to continue..."
read -r

# Check if files were created
if [ ! -f "index.html" ] || [ ! -f "styles.css" ]; then
    echo "❌ Error: Files not found in current directory"
    echo "   Make sure index.html and styles.css were generated"
    exit 1
fi

echo "✅ Files found!"
echo ""

# Move files to site directory
echo "📦 Moving files to $site_dir..."
mv index.html "$site_dir/"
mv styles.css "$site_dir/"
[ -f "script.js" ] && mv script.js "$site_dir/"
[ -f "README.md" ] && mv README.md "$site_dir/"

echo "✅ Files moved"
echo ""

# Download images
echo "=========================================="
echo "  STEP 2: Download Images"
echo "=========================================="
echo ""
echo "Searching for images in HTML..."

cd "$site_dir" || exit

# Extract and download images
image_urls=$(grep -oP 'http://localhost:3845/assets/[a-f0-9]+\.png' index.html | sort -u)

if [ -n "$image_urls" ]; then
    image_count=$(echo "$image_urls" | wc -l)
    echo "📸 Found $image_count images"
    echo ""
    echo "Downloading..."
    
    counter=0
    failed=0
    
    while IFS= read -r url; do
        counter=$((counter + 1))
        filename=$(basename "$url")
        
        echo "[$counter/$image_count] $filename"
        
        if curl -s -f -o "assets/$filename" "$url"; then
            echo "    ✅"
        else
            echo "    ❌ Failed"
            failed=$((failed + 1))
        fi
    done <<< "$image_urls"
    
    echo ""
    if [ $failed -eq 0 ]; then
        echo "✅ All images downloaded!"
        
        # Update HTML to use local paths
        echo "🔧 Updating image paths..."
        sed -i 's|http://localhost:3845/assets/|./assets/|g' index.html
        echo "✅ Paths updated"
    else
        echo "⚠️  Some images failed to download"
        echo "   Make sure Figma MCP server is running"
    fi
else
    echo "ℹ️  No images found (or site doesn't use images)"
fi

cd ..

echo ""
echo "=========================================="
echo "  STEP 3: Git Commit & Push"
echo "=========================================="
echo ""

read -p "Commit and push to GitHub? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add "$site_dir"
    git commit -m "Add new landing page: $site_name"
    
    if git push; then
        echo ""
        echo "✅ Pushed to GitHub!"
        echo ""
        echo "🚀 Your site will be deployed automatically"
        echo "   Check progress: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/actions"
        echo ""
        echo "🌐 Once deployed, your site will be at:"
        repo_name=$(git config --get remote.origin.url | sed 's/.*\/\([^/]*\)\.git/\1/')
        github_user=$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\)\/.*/\1/')
        echo "   https://${github_user}.github.io/${repo_name}/${site_name}/"
    else
        echo "❌ Push failed. Run 'git push' manually when ready."
    fi
else
    echo ""
    echo "📝 Files created but not committed"
    echo "   When ready, run:"
    echo "   git add $site_dir"
    echo "   git commit -m 'Add new landing page: $site_name'"
    echo "   git push"
fi

echo ""
echo "=========================================="
echo "✅ Site generation complete!"
echo "=========================================="
echo ""
echo "Site location: $site_dir/"
echo ""
echo "Next time you want to generate a site, just run:"
echo "  ./generate-site.sh"
echo ""
