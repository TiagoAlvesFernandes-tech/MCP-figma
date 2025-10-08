#!/bin/bash

# GitHub Setup Helper Script
# This script helps you connect your local repository to GitHub

echo "🚀 GitHub Setup Helper"
echo "====================="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "❌ Error: Not a git repository. Run 'git init' first."
    exit 1
fi

echo "✅ Git repository detected"
echo ""

# Check if remote already exists
if git remote | grep -q "origin"; then
    echo "⚠️  Remote 'origin' already exists:"
    git remote -v
    echo ""
    read -p "Do you want to remove it and add a new one? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote remove origin
        echo "✅ Removed existing remote"
    else
        echo "Keeping existing remote. Exiting."
        exit 0
    fi
fi

echo ""
echo "📝 Please provide your GitHub repository details:"
echo ""

# Get GitHub username
read -p "GitHub username: " github_user

# Get repository name
read -p "Repository name (default: MCP-figma): " repo_name
repo_name=${repo_name:-MCP-figma}

# Construct the URL
repo_url="https://github.com/${github_user}/${repo_name}.git"

echo ""
echo "🔗 Adding remote: $repo_url"
git remote add origin "$repo_url"

echo "✅ Remote added successfully!"
echo ""

# Show current branch
current_branch=$(git branch --show-current)
echo "📌 Current branch: $current_branch"
echo ""

# Ask if they want to push now
read -p "Do you want to push to GitHub now? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚀 Pushing to GitHub..."
    
    # Ensure we're on main branch
    if [ "$current_branch" != "main" ]; then
        echo "📝 Renaming branch to 'main'..."
        git branch -M main
    fi
    
    # Push to GitHub
    if git push -u origin main; then
        echo ""
        echo "✅ Successfully pushed to GitHub!"
        echo ""
        echo "🎉 Next steps:"
        echo "1. Go to: https://github.com/${github_user}/${repo_name}"
        echo "2. Click 'Settings' → 'Pages'"
        echo "3. Under 'Source', select 'GitHub Actions'"
        echo "4. Wait for deployment (check the 'Actions' tab)"
        echo "5. Your site will be live at: https://${github_user}.github.io/${repo_name}/"
        echo ""
    else
        echo ""
        echo "❌ Push failed. This might be because:"
        echo "   - The repository doesn't exist on GitHub yet"
        echo "   - You need to create it first at: https://github.com/new"
        echo "   - You might need to authenticate (use 'gh auth login' or set up SSH keys)"
        echo ""
        echo "After creating the repository on GitHub, run:"
        echo "  git push -u origin main"
    fi
else
    echo ""
    echo "📝 Remote configured. When you're ready to push, run:"
    echo "  git push -u origin main"
fi

echo ""
echo "Done! 🎉"
