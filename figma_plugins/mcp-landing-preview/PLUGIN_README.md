# 🎨 MCP Landing Preview - Figma Plugin

A Figma plugin that allows designers to preview and approve generated landing pages directly within Figma.

## 🎯 What It Does

This plugin bridges the gap between design and deployment:

1. **Preview Sites** - View your live GitHub Pages site inside Figma
2. **Approve/Reject** - Quick approval workflow
3. **Request Changes** - Submit feedback directly
4. **Auto-Configuration** - Remembers your settings

---

## 📦 Installation & Setup

### Step 1: Install Dependencies

```bash
cd figma_plugins/mcp-landing-preview
npm install
```

### Step 2: Compile TypeScript

```bash
npx tsc
```

Or run in watch mode for development:

```bash
npm run watch
```

### Step 3: Load Plugin in Figma

1. Open Figma Desktop App
2. Go to **Menu → Plugins → Development → Import plugin from manifest...**
3. Navigate to `figma_plugins/mcp-landing-preview/`
4. Select `manifest.json`
5. Click **Open**

### Step 4: Run the Plugin

1. In Figma, go to **Menu → Plugins → Development → MCP Landing Preview**
2. The plugin UI will appear

---

## 🚀 How to Use

### First Time Setup

1. **Launch Plugin**: Plugins → Development → MCP Landing Preview

2. **Configure Settings:**
   - **GitHub Username**: Your GitHub username (e.g., `TiagoAlvesFernandes-tech`)
   - **Repository Name**: Your repo name (e.g., `MCP-figma`)
   - **Site Name**: The site folder name without `site_` prefix (e.g., `ai-llm-workshop`)

3. **Load Preview**: Click "Load Preview" button

4. **Review**: The live site will load in an iframe

5. **Take Action**:
   - ✅ **Approve** - Mark as ready for production
   - ✎ **Request Changes** - Submit feedback
   - ✗ **Reject** - Reject the current version

### Daily Workflow

1. Designer creates/updates a frame in Figma
2. Developer generates landing page (using `./generate-site.sh`)
3. Site auto-deploys to GitHub Pages
4. Designer opens plugin in Figma
5. Plugin loads the live preview
6. Designer reviews and approves/rejects

---

## 🎨 Features

### Current Features (v1.0)

- ✅ Live preview of GitHub Pages sites
- ✅ Approve/Reject/Request Changes buttons
- ✅ Configuration persistence (remembers settings)
- ✅ Refresh preview button
- ✅ Loading states and error handling
- ✅ Figma notifications on actions
- ✅ Beautiful, modern UI

### Planned Features (v2.0)

- 🔜 GitHub API integration
  - Create issues for rejections/changes
  - Add labels automatically
  - Update PR status
- 🔜 Side-by-side comparison (Figma vs Live)
- 🔜 Screenshot capture and annotation
- 🔜 Approval history tracking
- 🔜 Multiple reviewer support
- 🔜 Slack/Discord notifications

---

## 🛠️ Development

### Project Structure

```
mcp-landing-preview/
├── manifest.json       # Plugin configuration
├── code.ts            # Main plugin code (TypeScript)
├── code.js            # Compiled JavaScript (generated)
├── ui.html            # Plugin UI
├── package.json       # Dependencies
├── tsconfig.json      # TypeScript config
└── README.md          # This file
```

### Development Mode

Run TypeScript compiler in watch mode:

```bash
npm run watch
```

This will automatically recompile `code.ts` whenever you save changes.

### Testing

1. Make changes to `code.ts` or `ui.html`
2. If TypeScript changed, run `npx tsc` (or use watch mode)
3. In Figma: **Plugins → Development → Reload plugin**
4. Test your changes

### Debugging

- **Console Logs**: Check the browser console in the plugin UI (right-click → Inspect)
- **Figma Console**: Use `console.log()` in `code.ts`, check Figma's developer console
- **Network**: Inspect network requests in the plugin UI dev tools

---

## 🔧 Configuration

### manifest.json

Key settings:

```json
{
  "networkAccess": {
    "allowedDomains": [
      "https://*.github.io",
      "https://api.github.com"
    ]
  }
}
```

**Important**: The plugin can only access:
- GitHub Pages domains (`*.github.io`)
- GitHub API (`api.github.com`)

To add more domains, update the `allowedDomains` array.

### UI Customization

Edit `ui.html` to customize:
- Colors and styling (CSS in `<style>` tag)
- Layout and components (HTML)
- Behavior (JavaScript in `<script>` tag)

---

## 📝 Usage Examples

### Example 1: Review New Landing Page

```
1. Designer: Selects frame "AI Workshop" in Figma
2. Developer: Runs ./generate-site.sh
3. Developer: Names it "ai-workshop-v2"
4. Site deploys to GitHub Pages
5. Designer: Opens plugin
6. Designer: Updates site name to "ai-workshop-v2"
7. Designer: Clicks "Load Preview"
8. Designer: Reviews and clicks "Approve"
```

### Example 2: Request Changes

```
1. Designer: Loads preview
2. Designer: Notices button color is wrong
3. Designer: Clicks "Request Changes"
4. Designer: Types: "CTA button should be green (#10b981)"
5. Developer: Sees notification
6. Developer: Makes changes
7. Developer: Pushes update
8. Designer: Refreshes preview
9. Designer: Approves
```

---

## 🔐 Security & Privacy

### What the Plugin Can Access

✅ **Can access:**
- Selected Figma frames (names, IDs)
- File metadata (file name, file key)
- GitHub Pages URLs you configure
- GitHub API (when implemented)

❌ **Cannot access:**
- Your Figma design content
- Other websites (restricted by manifest)
- Your local filesystem
- Private data outside of configured domains

### Data Storage

- Settings stored in browser `localStorage` (stays on your computer)
- No data sent to external servers (except GitHub when using API)

---

## 🐛 Troubleshooting

### Plugin Won't Load

**Problem**: Error when importing plugin manifest

**Solutions**:
1. Make sure you're using **Figma Desktop App** (not browser)
2. Check that `code.js` exists (run `npx tsc`)
3. Verify `manifest.json` is valid JSON
4. Restart Figma Desktop App

### Preview Not Loading

**Problem**: Iframe shows error or blank page

**Solutions**:
1. Verify the site is actually deployed to GitHub Pages
2. Check the URL format: `https://username.github.io/repo-name/site-name/`
3. Make sure GitHub Pages is enabled in your repo settings
4. Try opening the URL in a regular browser first
5. Check browser console for CORS or loading errors

### TypeScript Errors

**Problem**: Compilation fails with errors

**Solutions**:
1. Run `npm install` to ensure dependencies are installed
2. Check that `@figma/plugin-typings` is installed
3. Verify `tsconfig.json` exists
4. Try deleting `node_modules` and running `npm install` again

### Buttons Disabled

**Problem**: Approve/Reject buttons are grayed out

**Solutions**:
1. Load a preview first
2. Wait for iframe to fully load
3. Check that the URL is correct
4. Refresh the preview

---

## 🚀 Deployment to Figma Community (Future)

To publish this plugin to the Figma Community:

1. **Polish the plugin**:
   - Add proper icons
   - Add cover image
   - Write clear description

2. **Test thoroughly**:
   - Test on different files
   - Test with multiple team members
   - Check all edge cases

3. **Submit for review**:
   - Go to Figma → Plugins → Publish
   - Fill out the submission form
   - Wait for Figma team approval

---

## 📖 API Reference

### Messages from UI to Plugin

```javascript
// Close the plugin
parent.postMessage({
  pluginMessage: { type: 'close-plugin' }
}, '*');

// Show notification
parent.postMessage({
  pluginMessage: {
    type: 'notify',
    message: 'Your message here',
    timeout: 2000
  }
}, '*');

// Get file info
parent.postMessage({
  pluginMessage: { type: 'get-file-info' }
}, '*');
```

### Messages from Plugin to UI

```javascript
// File information
{
  type: 'file-info',
  data: {
    fileName: string,
    fileKey: string,
    selection: Array
  }
}

// Selection changed
{
  type: 'selection-changed',
  data: {
    name: string,
    id: string,
    type: string
  }
}
```

---

## 🤝 Contributing

Want to improve the plugin? Here's how:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Ideas for Contributions

- Add GitHub API integration
- Implement screenshot comparison
- Add annotation tools
- Create approval history
- Add team collaboration features
- Improve error handling
- Add keyboard shortcuts

---

## 📄 License

This plugin is part of the MCP-figma project.

---

## 🔗 Links

- **Main Repository**: https://github.com/TiagoAlvesFernandes-tech/MCP-figma
- **Figma Plugin Docs**: https://www.figma.com/plugin-docs/
- **Figma Plugin API**: https://www.figma.com/plugin-docs/api/

---

## ❓ FAQ

**Q: Do I need to install anything in Figma?**  
A: No, just import the plugin from the manifest file.

**Q: Can other team members use this plugin?**  
A: Yes, but they need to import it on their machines too. For team-wide use, publish to Figma Community.

**Q: Does this work with Vercel or Netlify?**  
A: Currently optimized for GitHub Pages, but you can modify the URL format in the UI to support other hosts.

**Q: Can I preview sites before they're deployed?**  
A: No, the plugin shows the live deployed version. Use local development for pre-deployment testing.

**Q: Is this plugin free?**  
A: Yes, completely free and open source.

---

**Need help?** Open an issue in the main repository or check the ROADMAP.md for planned features!
