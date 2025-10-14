# 🚀 NEXT STEPS: Figma-to-Production Automation Platform

## � Visão do Produto Final

Transformar o workflow atual em uma **plataforma automatizada** onde qualquer pessoa pode:
1. Clonar o repositório
2. Conectar ao Figma MCP 
3. Gerar sites profissionais automaticamente
4. Deploy direto para Azure Static Web Apps

---

## 🔧 Problemas Atuais Identificados

### ❌ Problemas Críticos
1. **Arquivos gerados no root** (deveria ser diretamente na pasta do site)
2. **Processo manual demais** (muitos comandos para o usuário)
3. **Configuração complexa** (MCP server, paths, tokens)
4. **Deploy manual** (deveria ser automático via GitHub Actions)
5. **Documentação dispersa** (vários READMEs diferentes)

### ❌ Experiência do Usuário
- Muito técnico para designers
- Muitos passos manuais
- Sem validação de erros
- Sem preview antes do deploy

---

## 🎯 ROADMAP PRIORITIZADO

### 🟢 FASE 1: CORE AUTOMATION (Urgente - 1-2 semanas)

#### 1.1 Reestruturar Scripts Principais
```bash
├── scripts/
│   ├── setup.sh              # Setup inicial completo
│   ├── generate-site.sh       # Geração melhorada
│   ├── deploy.sh             # Deploy automático
│   └── validate.sh           # Validação pré-deploy
```

**Melhorias no `generate-site.sh`:**
- ✅ Criar pasta do site ANTES de gerar arquivos
- ✅ Configurar working directory correto para o agente
- ✅ Validar conexão MCP antes de começar
- ✅ Log estruturado de progresso
- ✅ Rollback automático em caso de erro

**Novo fluxo:**
```bash
./generate-site.sh "meu-novo-site"
# 1. Cria pasta site_meu-novo-site/
# 2. Configura working directory
# 3. Chama agente MCP com contexto correto
# 4. Agente gera arquivos DENTRO da pasta
# 5. Download automático de assets
# 6. Validação de arquivos
# 7. Preview local (opcional)
```

#### 1.2 Sistema de Configuração Centralizada
```yaml
# config/project.yml
figma:
  mcp_endpoint: "localhost:3845"
  default_frame: null
  
deployment:
  platform: "azure-swa"
  resource_group: "figma-sites-rg"
  auto_deploy: true
  
site_generation:
  target_dir: "sites/"
  backup_on_overwrite: true
  validate_before_deploy: true
```

#### 1.3 Setup Automático Completo
```bash
# Novo arquivo: scripts/setup.sh
./setup.sh
# 1. Instala dependências necessárias
# 2. Configura Azure CLI (se necessário)
# 3. Valida conexão Figma MCP
# 4. Cria estrutura de pastas
# 5. Configura GitHub Actions
# 6. Testa pipeline completo
```

### 🟡 FASE 2: AZURE INTEGRATION (2-3 semanas)

#### 2.1 Azure Static Web Apps Setup
```yaml
# .github/workflows/deploy-sites.yml
name: Deploy Sites to Azure SWA
on:
  push:
    paths: ['sites/**']
    
jobs:
  deploy-sites:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        site: ${{ fromJson(needs.detect-changes.outputs.sites) }}
    steps:
      - name: Deploy to Azure SWA
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_SWA_TOKEN }}
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          action: "upload"
          app_location: "sites/${{ matrix.site }}"
```

#### 2.2 Multi-Site Architecture
```
├── sites/
│   ├── area-landing/          # Site 1
│   │   ├── index.html
│   │   ├── assets/
│   │   └── swa-config.json
│   ├── produto-xyz/           # Site 2
│   │   ├── index.html
│   │   └── assets/
│   └── campanha-abc/          # Site 3
├── config/
│   ├── azure-swa.json        # Configuração SWA
│   └── deployment.yml        # Config de deploy
```

#### 2.3 Preview URLs Automáticos
- Cada site em `sites/` = URL única no Azure SWA
- `https://mcp-figma-sites.azurestaticapps.net/area-landing/`
- `https://mcp-figma-sites.azurestaticapps.net/produto-xyz/`

### 🟠 FASE 3: DEVELOPER EXPERIENCE (3-4 semanas)

#### 3.1 CLI Tool Profissional
```bash
npm install -g @figma-mcp/generator

figma-gen init                 # Setup inicial
figma-gen new "site-name"      # Gera novo site
figma-gen deploy "site-name"   # Deploy específico
figma-gen list                 # Lista todos os sites
figma-gen preview "site-name"  # Preview local
```

#### 3.2 Interface Web (Opcional)
- Dashboard para gerenciar sites
- Preview em tempo real
- Histórico de deployments
- Configuração visual do MCP

#### 3.3 Templates Avançados
```
├── templates/
│   ├── landing-page/          # Template atual
│   ├── e-commerce/            # Novo template
│   ├── portfolio/             # Novo template
│   └── blog/                  # Novo template
```

---

## 🔧 IMPLEMENTAÇÃO TÉCNICA DETALHADA

### Novo `generate-site.sh` (Versão 2.0)

```bash
#!/bin/bash
# generate-site.sh v2.0 - Geração automática e organizada

SITE_NAME=$1
FIGMA_FRAME=${2:-""}
BASE_DIR="sites"

# Validações iniciais
validate_setup() {
    echo "🔍 Validando setup..."
    # Verificar MCP connection
    # Verificar dependências
    # Verificar configurações
}

# Criar estrutura do site
create_site_structure() {
    SITE_DIR="$BASE_DIR/$SITE_NAME"
    echo "📁 Criando estrutura: $SITE_DIR"
    
    mkdir -p "$SITE_DIR"/{assets,docs}
    cd "$SITE_DIR"
    
    # Arquivo de configuração do site
    cat > site-config.json << EOF
{
    "name": "$SITE_NAME",
    "created": "$(date -Iseconds)",
    "figma_frame": "$FIGMA_FRAME",
    "status": "generating"
}
EOF
}

# Chamar agente MCP com contexto correto
generate_with_mcp() {
    echo "🤖 Gerando site com MCP Agent..."
    
    # O agente agora sabe que deve gerar arquivos no diretório atual
    # Não mais no workspace root!
    
    local prompt="Generate a complete landing page in the CURRENT DIRECTORY:
    
    Working Directory: $(pwd)
    Site Name: $SITE_NAME
    Figma Frame: $FIGMA_FRAME
    
    Requirements:
    1. Generate files in current directory (NOT workspace root)
    2. Use semantic HTML5, CSS custom properties, vanilla JS
    3. Download assets to ./assets/ folder
    4. Create README.md with deployment instructions
    5. Update site-config.json with completion status
    
    Files to create in current directory:
    - index.html
    - styles.css  
    - script.js
    - README.md"
    
    # Aqui seria a chamada para o agente MCP
    echo "$prompt" | mcp-agent-call
}

# Download de assets
download_assets() {
    echo "📥 Baixando assets..."
    if [ -f "../../../download-images.sh" ]; then
        bash "../../../download-images.sh" "$(basename $(pwd))"
    fi
}

# Validação pós-geração
validate_site() {
    echo "✅ Validando site gerado..."
    
    local required_files=("index.html" "styles.css" "script.js")
    local missing_files=()
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -ne 0 ]; then
        echo "❌ Arquivos faltando: ${missing_files[*]}"
        return 1
    fi
    
    echo "✅ Todos os arquivos necessários foram gerados"
    return 0
}

# Atualizar configuração
update_config() {
    jq '.status = "completed" | .completed_at = now' site-config.json > tmp.json
    mv tmp.json site-config.json
}

# Fluxo principal
main() {
    validate_setup
    create_site_structure
    generate_with_mcp
    download_assets
    
    if validate_site; then
        update_config
        echo "🎉 Site '$SITE_NAME' gerado com sucesso!"
        echo "📁 Localização: $BASE_DIR/$SITE_NAME"
        echo "🌐 Para deploy: ./scripts/deploy.sh $SITE_NAME"
    else
        echo "❌ Erro na geração do site"
        exit 1
    fi
}

main "$@"
```

### Novo README.md Principal

```markdown
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
   ```

3. **Deploy to Azure**
   ```bash
   ./scripts/deploy.sh "my-awesome-site"
   ```

## 🏗️ Architecture

```
├── sites/                    # Generated websites
│   ├── area-landing/        # Example site
│   └── your-site/           # Your generated sites
├── scripts/                 # Automation scripts
├── templates/               # Site templates
├── config/                  # Configuration files
└── .github/workflows/       # CI/CD automation
```

## 🔧 Requirements

- Node.js 18+
- Azure CLI (for deployment)
- Figma Dev Mode access
- GitHub repository with Actions enabled

## 📖 Documentation

- [Setup Guide](docs/SETUP.md)
- [Site Generation](docs/GENERATION.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
```

---

## 🎯 CRONOGRAMA DE EXECUÇÃO

### Semana 1: Core Scripts
- [ ] Reescrever `generate-site.sh` v2.0
- [ ] Criar `setup.sh` completo
- [ ] Implementar sistema de configuração
- [ ] Testar fluxo completo

### Semana 2: Azure Integration  
- [ ] Configurar Azure Static Web Apps
- [ ] Criar GitHub Actions para deploy
- [ ] Implementar multi-site architecture
- [ ] Testar deploy automático

### Semana 3: Documentation & Polish
- [ ] Novo README.md principal
- [ ] Documentação completa
- [ ] Templates adicionais
- [ ] Testes de usuário

### Semana 4: CLI Tool (Opcional)
- [ ] NPM package para CLI
- [ ] Interface web básica
- [ ] Métricas e monitoramento

---

## 🎉 RESULTADO FINAL

**Para o usuário final:**
```bash
# Setup único (5 minutos)
git clone repo && ./scripts/setup.sh

# Gerar site (2 minutos)  
./scripts/generate-site.sh "meu-produto"

# Deploy automático (1 minuto)
# Acontece automaticamente via GitHub Actions
```

**URLs automáticos:**
- `https://mcp-figma-sites.azurestaticapps.net/meu-produto/`
- Preview URLs para cada branch
- SSL automático
- CDN global do Azure

Este roadmap transforma o projeto atual em uma **plataforma profissional de automação** que qualquer pessoa pode usar para gerar sites de alta qualidade a partir do Figma! 🚀

### Step 1: GitHub Pages Configuration ✓
- ✅ Created GitHub Actions workflow (`.github/workflows/deploy.yml`)
- ✅ Set up automatic deployment system
- ✅ Created index page generator for all sites
- ✅ Added setup documentation

## 🚀 Your Next Steps

### 1. Create GitHub Repository

You have two options:

#### Option A: Use the Helper Script (Easiest!)

Since you're on Windows with Git Bash, run:

```bash
./setup-github.sh
```

Or if using Windows Command Prompt:

```cmd
setup-github.bat
```

The script will:
- Ask for your GitHub username
- Ask for repository name (default: MCP-figma)
- Configure the remote
- Offer to push immediately

#### Option B: Manual Setup

1. **Create repository on GitHub:**
   - Go to https://github.com/new
   - Repository name: `MCP-figma` (or your choice)
   - Make it **Public** (required for free GitHub Pages)
   - **Don't** initialize with README/license/gitignore
   - Click "Create repository"

2. **Connect and push:**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/MCP-figma.git
   git push -u origin main
   ```

### 2. Enable GitHub Pages

After pushing to GitHub:

1. Go to your repository: `https://github.com/YOUR_USERNAME/MCP-figma`
2. Click **Settings** (top right)
3. Click **Pages** (left sidebar)
4. Under **Build and deployment**:
   - Source: Select **GitHub Actions**
5. That's it! No need to save, it's automatic

### 3. Wait for Deployment

1. Go to the **Actions** tab in your repository
2. You'll see "Deploy to GitHub Pages" workflow running
3. Wait 1-2 minutes for it to complete
4. Once green ✅, your site is live!

### 4. Access Your Sites

Your sites will be available at:

- **Main index**: `https://YOUR_USERNAME.github.io/MCP-figma/`
  - Lists all your generated sites
  
- **AI Workshop site**: `https://YOUR_USERNAME.github.io/MCP-figma/ai-llm-workshop/`
  - Your first landing page!

## 📁 Repository Structure

```
MCP-figma/
├── .git/                       # Git repository data
├── .github/
│   └── workflows/
│       └── deploy.yml          # Auto-deployment workflow ✨
├── site_ai-llm-workshop/       # Your generated landing page
│   ├── index.html              # Main HTML
│   ├── styles.css              # Styling
│   ├── script.js               # Interactivity
│   └── README.md               # Site documentation
├── .gitignore                  # Files to ignore
├── readme.md                   # Your main README
├── GITHUB_SETUP.md             # Detailed setup guide
├── NEXT_STEPS.md              # This file
├── setup-github.sh             # Linux/Mac helper script
└── setup-github.bat            # Windows helper script
```

## 🎯 How It Works

### The Magic of GitHub Actions

When you push to `main`:

1. **Trigger**: GitHub Actions detects the push
2. **Build**: 
   - Creates `_site/` directory
   - Copies all `site_*` folders
   - Generates beautiful index page listing all sites
3. **Deploy**: 
   - Publishes to GitHub Pages
   - Your sites go live automatically!

### Adding More Sites

When you generate a new landing page from Figma:

```bash
# Generate new site (via Copilot + Figma MCP)
# Creates: site_NEW_DESIGN/

# Commit and push
git add site_NEW_DESIGN/
git commit -m "Add new landing page: NEW_DESIGN"
git push

# That's it! GitHub Actions deploys automatically 🚀
```

## ⚠️ Important Notes

### Image Assets

Your current site uses `localhost:3845` for images. Before going live:

1. **Download images** from Figma MCP server
2. **Create assets folder** in your site:
   ```bash
   mkdir site_ai-llm-workshop/assets
   ```
3. **Update image paths** in `index.html` from:
   ```html
   <img src="http://localhost:3845/assets/abc123.png">
   ```
   To:
   ```html
   <img src="./assets/abc123.png">
   ```

### First Deployment

- First deployment might take 2-3 minutes
- Subsequent deployments are faster (30-60 seconds)
- Check the Actions tab if something seems wrong

## 🔧 Troubleshooting

### "Permission denied" when pushing?

You need to authenticate with GitHub:

```bash
# Configure Git with your GitHub credentials
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# You'll be prompted for username/password on first push
# Use a Personal Access Token as password (not your GitHub password)
# Create one at: https://github.com/settings/tokens
```

### Workflow not running?

1. Check **Actions** tab → Enable workflows if needed
2. Verify `.github/workflows/deploy.yml` exists
3. Make sure GitHub Pages source is set to "GitHub Actions"

### Page shows 404?

1. Wait a few minutes after first deploy
2. Check Actions tab for deployment status
3. Verify the URL structure matches your repository name

## 📚 Documentation

- **GITHUB_SETUP.md** - Detailed GitHub Pages setup
- **readme.md** - Your main project documentation
- **site_ai-llm-workshop/README.md** - Site-specific docs

## 🎨 What's Next?

After your site is live, you can:

1. **Generate more landing pages** from Figma designs
2. **Set up Vercel** for better preview URLs (future step)
3. **Build the Figma plugin** for in-app review (future step)
4. **Add automation scripts** to streamline the workflow

## 🤔 Questions?

Refer to:
- `GITHUB_SETUP.md` for deployment details
- GitHub Actions logs for troubleshooting
- [GitHub Pages Docs](https://docs.github.com/en/pages)

---

**Ready?** Run `./setup-github.sh` to push to GitHub! 🚀
