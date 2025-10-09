# Figma-t***

## ✅ What i have now.

1.  **Figma plan & Dev Mode** (Professional/Organization/Enterprise "Dev or Full" seat) and the **Figma desktop app**.
2.  Enabled **Figma Dev Mode MCP server** (local or remote endpoint).
3.  ✅ **Git repository initialized** and pushed to GitHub
4.  ✅ **GitHub Pages enabled** with automatic deployment
5.  ✅ **First landing page generated** (AI Workshop site)
6.  ✅ **🆕 Area Landing Page deployed** - Complete workflow tested!

***

## 🚧 What i still need to do.on Pipeline

🌐 **Live Sites:** 
- **Main Site:** https://tiagoalvesfernandes-tech.github.io/MCP-figma/
- **🆕 Area Landing Page:** https://tiagoalvesfernandes-tech.github.io/MCP-figma/site_area-landing/

## TL;DR architecture

*   **Figma MCP** exposes structured design context (frames, components, variables, Code Connect mapping) to your AI agent so it can generate code consistent with the template.
*   **Preview Deploys** give designers a live URL for each change; when approved, merge to main → **production**.

***

## What i have now.

1.  **Figma plan & Dev Mode** (Professional/Organization/Enterprise “Dev or Full” seat) and the **Figma desktop app**.
2.  Enabled **Figma Dev Mode MCP server** (local or remote endpoint).

***

## What i still need to do.


### 4) Seed a repo and preview deploys

Create a minimal repo for generated **HTML/CSS/JS** + build config:

> Later will use vercel to publish sites and use this.
**Vercel** (automatic Preview URLs per branch/PR; instant promotion on main):
*   Connect GitHub repo → each PR gets a unique preview URL; merging to `main` publishes production.

> For now, only needs to send the html to a branch in github.
* **Github** Connect GitHub repo -> Setup GitHup Pages and action to build page.


***

### 5) Prompting the agent to generate the landing page

With the Figma file open, select the root frame (e.g., “Landing Page”) and run a prompt in your MCP client:

> **Prompt template**
>
> “Read the selected Figma frame via MCP. Generate a semantic, accessible **single‑file** landing page (HTML + Tailwind CDN or vanilla CSS).
>
> *   Map Figma variables/typography to CSS custom properties.
> *   Export/inline assets (optimize for web).
> *   Preserve section order (hero/features/testimonials/cta).
> *   Output `index.html` + `styles.css` at `/site_name-of-design/`.
> *   Each design will have a `/site_name-of-design/` folder.
> *   Include TODO comments where design tokens map to variables.”

This relies on **Figma MCP tools/resources** to fetch components/variables and produce code consistent with the design.

***

### 6) Auto‑publish a **Preview** on each generation

Add (at least) one automation to show the designer how the page will look.

***

### 7) Let the designer review *inside Figma* (two options)

**Option 1 — Figma “Reviewer” plugin (recommended):**\
Build a lightweight Figma plugin that shows the Preview URL inside its UI and provides “Request edits” / “Approve” actions.

*   A Figma plugin can host a custom HTML UI and call out to allowed domains (whitelist your preview host). The plugin community examples show manifests with `ui.html` and `networkAccess.allowedDomains` for external URLs.
*   On “Request edits”, your plugin can send a message to your MCP server (or open a pre‑formatted task) with the designer’s notes; the agent applies changes and re‑deploys the preview.
*   On “Approve”, your plugin can call your CI (or post back to your MCP server) to **merge** the PR to `main` → production deploy.

**Option 2 — Link‑out review**\
Just paste the Preview URL in the Figma file description/comments (or FigJam board). Netlify/Vercel both comment the PR with the URL; designers review in the browser.

***

### 9) Promote to production

When the designer clicks **Approve** in your plugin (or in PR), your server merges to `main` → **Production Deployment** with instant rollback support if needed (Vercel) or atomic deploys (Netlify).

***

## Minimal snippets

### A) Vercel preview (GitHub → automatic)

`.github/workflows/vercel-preview.yml` (if you prefer an explicit action)

```yaml
name: Vercel Preview
on:
  pull_request:
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: amondnet/vercel-action@v25.2.0
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
          github-comment: true
```

Vercel comments the **preview URL** right on the PR.

***

### B) MCP client config (Figma + filesystem)

`~/.vscode/mcp.json`:

```json
{
  "mcpServers": {
    "figma": { "type": "http", "url": "https://mcp.figma.com/mcp" },
    "filesystem": { "command": "npx", "args": ["@modelcontextprotocol/server-filesystem"] }
  }
}
```

Figma’s guide covers local vs remote server addresses.

***

### C) Figma “Reviewer” plugin (manifest sketch)

```json
{
  "name": "MCP Landing Reviewer",
  "id": "mcp-landing-reviewer",
  "api": "1.0.0",
  "main": "code.js",
  "ui": "ui.html",
  "editorType": ["figma"],
  "networkAccess": {
    "allowedDomains": [
      "https://*.vercel.app",
      "https://*.netlify.app",
      "https://your-ci.example.com"
    ]
  }
}
```

(Whitelist your preview host(s) so the UI can embed/fetch the preview.)

***

### D) Prompt seed for regeneration after edits

> “Apply these change notes to the current landing page:
>
> *   Increase hero heading size to match Figma variable `--font-xl`
> *   Swap CTA button to ‘primary/filled’ component
> *   Tighten spacing between features cards to 24px\
>     Regenerate `index.html` and `styles.css`, preserving existing IDs used by analytics. Commit to branch `feat/landing‑rev2`.”

The agent uses MCP to re‑read the frame and variables before regenerating.

***

## Security & governance notes

*   **Rate limits & beta status**: Figma MCP server is in **open beta**; expect changes and define fallbacks.
*   **Principle of least privilege**: Keep your plugin’s `allowedDomains` tight; do not expose secrets in client UI.
*   **No Figma Sites publishing**: your live site is hosted on Vercel/Netlify (or any host that supports CI).

***

## What you’ll be able to do with this pipeline

*   Designer works in Figma templates; your agent **generates code from the selected frame** via MCP.
*   Every iteration produces a **Preview URL** for review and QA; your Figma plugin surfaces the preview and allows approve/reject with notes.
*   On approval, merge → **Production** with atomic deploy/rollback.

***

## Want me to scaffold the repo + a basic Figma Reviewer plugin?

If you want, I can generate a starter:

*   `/site/index.html`, `styles.css`
*   `vercel.json` (or `netlify.toml`) for preview/production
*   A minimal plugin (`manifest.json`, `ui.html`, `code.js`) that loads the preview URL, shows “Request edits” / “Approve”, and posts back to a tiny Node endpoint that triggers the merge/deploy.

Say the word, and tell me your preferred host (**Vercel** or **Netlify**) and the stack (**vanilla CSS** vs **Tailwind CDN**).
