# 🚀 Figma-to-Production Platform

Generate professional websites directly from Figma designs using AI and deploy automatically to Azure Static Web Apps.

## ⚡ Quick Start

1. **Clone & Setup**
   ```bash
   git clone https://github.com/TiagoAlvesFernandes-tech/MCP-figma.git
   cd MCP-figma
   ./scripts/setup.sh
   ```

2. **Generate Your First Site**
   ```bash
   ./scripts/generate-site.sh "my-awesome-site"
   # Follow the MCP prompt instructions
   ./scripts/post-generate.sh "my-awesome-site"
   ```

3. **Deploy Automatically**
   ```bash
   git add . && git commit -m "Add new site" && git push
   # GitHub Actions will deploy to Azure Static Web Apps
   ```

## 🏗️ Project Structure

```
├── sites/                    # 🌐 Generated websites
│   ├── area-landing/        #   Migrated: Area landing page
│   ├── ai-llm-workshop/     #   Migrated: AI Workshop site
│   └── your-site/           #   Your new generated sites
├── scripts/                 # 🔧 Automation scripts
│   ├── setup.sh            #   Initial setup
│   ├── generate-site.sh    #   Site generation v2.0
│   └── post-generate.sh    #   Post-generation validation
├── config/                  # ⚙️  Configuration files
├── templates/               # 📄 Site templates
└── .github/workflows/       # 🚀 CI/CD automation
```

## 🎯 Features

- **🎨 Figma Integration**: Direct connection to Figma Dev Mode
- **🤖 AI Generation**: MCP agent creates semantic HTML/CSS/JS
- **📱 Responsive**: Mobile-first responsive design
- **♿ Accessible**: WCAG compliant with semantic HTML
- **⚡ Performance**: Optimized CSS custom properties and vanilla JS
- **🚀 Auto Deploy**: GitHub Actions → Azure Static Web Apps
- **🔧 Professional**: Production-ready code generation

## 🔧 Requirements

- **Figma**: Dev Mode access and MCP server setup
- **Node.js**: 18+ for tooling
- **Azure**: Static Web Apps for hosting
- **GitHub**: Repository with Actions enabled

## 🌐 Live Examples

- **🆕 Area Landing Page**: https://tiagoalvesfernandes-tech.github.io/MCP-figma/sites/area-landing/
- **AI Workshop**: https://tiagoalvesfernandes-tech.github.io/MCP-figma/sites/ai-llm-workshop/

## 📖 Next Steps

See [NEXT_STEPS.md](NEXT_STEPS.md) for the complete roadmap to transform this into a fully automated platform.

## 🤝 Contributing

This is an open-source platform for Figma-to-production workflows. Contributions welcome!

---

Built with ❤️ by [Tiago Fernandes](https://github.com/TiagoAlvesFernandes-tech)