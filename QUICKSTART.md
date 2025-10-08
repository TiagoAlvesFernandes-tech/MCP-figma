# 🚀 Quick Start Guide

## Generating a New Site from Figma

### One-Command Workflow

```bash
./generate-site.sh
```

That's it! The script will guide you through:
1. Naming your site
2. Getting code from Figma via MCP
3. Downloading images automatically
4. Committing and pushing to GitHub
5. Auto-deploying to GitHub Pages

---

## Step-by-Step Process

### 1. Run the Generator

```bash
./generate-site.sh
```

### 2. Enter Site Name

When prompted, enter a descriptive name:
- Use lowercase
- Use hyphens for spaces
- Example: `ai-workshop`, `product-launch`, `pricing-page`

### 3. Generate from Figma

1. **In Figma**: Select the frame you want to convert
2. **In VS Code**: Use the prompt provided by the script
3. **Wait**: Copilot will generate the files
4. **Press ENTER**: Continue the script

### 4. Review & Deploy

The script will:
- ✅ Move files to the site directory
- ✅ Download all images
- ✅ Update image paths
- ✅ Commit to Git
- ✅ Push to GitHub
- ✅ Trigger automatic deployment

### 5. Access Your Site

After 1-2 minutes, your site will be live at:
```
https://YOUR_USERNAME.github.io/MCP-figma/SITE_NAME/
```

---

## Manual Image Download

If you need to download images for an existing site:

```bash
./download-images.sh
```

Edit the script to change the `SITE_DIR` variable to your target site.

---

## Useful Commands

### Check Deployment Status
```bash
# Open GitHub Actions in browser
open https://github.com/YOUR_USERNAME/MCP-figma/actions
```

### Test Site Locally
```bash
cd site_YOUR_SITE_NAME
python -m http.server 8000
# Visit: http://localhost:8000
```

### Update an Existing Site
```bash
# Edit files in site_NAME/
git add site_NAME/
git commit -m "Update SITE_NAME: description of changes"
git push
```

---

## Prompt Template for Figma MCP

Use this prompt when generating sites:

```
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
```

---

## Troubleshooting

### Images not downloading?
- Make sure Figma MCP server is running
- Check that Figma desktop app is open
- Verify the frame is selected in Figma

### Files not found?
- Make sure Copilot generated the files in the current directory
- Check that index.html and styles.css exist before pressing ENTER

### Push failed?
- Check your GitHub authentication
- Make sure you have push access to the repository
- Try running `git push` manually

---

## File Structure

After generation:

```
site_YOUR_SITE_NAME/
├── index.html          # Main HTML file
├── styles.css          # All styling
├── script.js           # Interactivity (optional)
├── README.md           # Site documentation (optional)
└── assets/             # All images
    ├── image1.png
    ├── image2.png
    └── ...
```

---

## Tips & Best Practices

### Site Naming
- ✅ `product-launch-2024`
- ✅ `pricing-page-v2`
- ✅ `ai-workshop`
- ❌ `Product Launch 2024` (use hyphens)
- ❌ `site1` (not descriptive)

### Image Optimization
Images are downloaded as-is from Figma. Consider optimizing them:
```bash
# Install imageoptim or similar
# Optimize all images in assets/
```

### Version Control
- Commit after each generation
- Use descriptive commit messages
- Tag important versions

---

## What's Next?

1. **Generate more sites** - Test with different Figma designs
2. **Customize the workflow** - Edit `generate-site.sh` to fit your needs
3. **Set up Vercel** - For better preview URLs (see ROADMAP.md)
4. **Build Figma plugin** - For in-app reviews (see ROADMAP.md)

---

## Links

- **Repository**: https://github.com/TiagoAlvesFernandes-tech/MCP-figma
- **Live Sites**: https://tiagoalvesfernandes-tech.github.io/MCP-figma/
- **Actions**: https://github.com/TiagoAlvesFernandes-tech/MCP-figma/actions
- **Roadmap**: See `ROADMAP.md` for future features

---

**Questions?** Open an issue or check the documentation in ROADMAP.md
