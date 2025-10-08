# GitHub Pages Setup Guide

## 🚀 Quick Setup

Follow these steps to deploy your Figma-generated sites to GitHub Pages:

### 1. Create GitHub Repository

```bash
# You're already in the right directory with Git initialized!
# Now create a repository on GitHub and connect it:

# Option A: Using GitHub CLI (if installed)
gh repo create MCP-figma --public --source=. --remote=origin --push

# Option B: Manual setup
# 1. Go to https://github.com/new
# 2. Create a repository named "MCP-figma" (or your preferred name)
# 3. Don't initialize with README (we already have files)
# 4. Then run these commands:
```

### 2. Connect Your Local Repo to GitHub

Replace `YOUR_USERNAME` with your GitHub username:

```bash
git remote add origin https://github.com/YOUR_USERNAME/MCP-figma.git
git branch -M main
git push -u origin main
```

### 3. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages** (in the left sidebar)
3. Under **Source**, select:
   - **Source**: GitHub Actions
   - (The workflow will automatically deploy)
4. Click **Save**

### 4. Wait for Deployment

- Go to the **Actions** tab in your repository
- You'll see the "Deploy to GitHub Pages" workflow running
- Wait for it to complete (usually takes 1-2 minutes)
- Once complete, your site will be live!

### 5. Access Your Sites

Your sites will be available at:

- **Main index**: `https://YOUR_USERNAME.github.io/MCP-figma/`
- **AI Workshop site**: `https://YOUR_USERNAME.github.io/MCP-figma/ai-llm-workshop/`

## 🎯 How It Works

### Repository Structure

```
MCP-figma/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions workflow
├── site_ai-llm-workshop/       # Your first generated site
│   ├── index.html
│   ├── styles.css
│   ├── script.js
│   └── README.md
├── site_another-design/        # Future sites go here
├── .gitignore
└── readme.md
```

### Workflow Process

1. **Push to main** → Triggers the workflow
2. **Build step**:
   - Creates `_site/` directory
   - Copies all `site_*` folders
   - Generates a main index page listing all sites
3. **Deploy step**:
   - Uploads to GitHub Pages
   - Your sites go live!

### Adding New Sites

When you generate a new site from Figma:

1. Create a new `site_NAME/` folder
2. Add your HTML/CSS/JS files
3. Commit and push:

```bash
git add site_NEW_DESIGN/
git commit -m "Add new landing page: NEW_DESIGN"
git push
```

4. GitHub Actions will automatically deploy it!

## 🔧 Troubleshooting

### Workflow Not Running?

- Check the **Actions** tab in your repository
- Make sure GitHub Actions are enabled in **Settings** → **Actions**
- Verify the workflow file is in `.github/workflows/deploy.yml`

### Page Not Loading?

- Wait a few minutes after first deployment
- Check that GitHub Pages is enabled in **Settings** → **Pages**
- Verify the source is set to "GitHub Actions"
- Check the Actions tab for any error messages

### Images Not Loading?

The current site uses `localhost:3845` for images. You need to:

1. Download images from Figma MCP server
2. Create an `assets/` folder in your site directory
3. Update image paths in HTML

Example script to fix image paths:

```bash
# In your site directory
mkdir assets
# Download images manually or use a script
# Then update HTML to use relative paths: ./assets/image.png
```

## 🎨 Customizing the Index Page

The auto-generated index page lists all your sites. To customize it:

1. Edit the HTML template in `.github/workflows/deploy.yml`
2. Look for the section that creates `_site/index.html`
3. Modify the styles or structure
4. Commit and push your changes

## 📝 Next Steps

- [ ] Push to GitHub
- [ ] Enable GitHub Pages
- [ ] Wait for first deployment
- [ ] Share your live URLs!
- [ ] Generate more sites from Figma designs

## 🔗 Useful Links

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Figma MCP Server](https://www.figma.com/developers/mcp)

---

**Need help?** Check the GitHub Actions logs in the "Actions" tab of your repository for detailed error messages.
