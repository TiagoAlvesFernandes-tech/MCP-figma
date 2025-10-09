#!/bin/bash
# setup.sh - Configuração inicial automática da plataforma Figma-to-Production
# Versão: 2.0.0

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções de log
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Banner
show_banner() {
    echo -e "${BLUE}"
    echo "🚀 =================================="
    echo "   Figma-to-Production Platform"
    echo "   Setup Automático v2.0"
    echo "================================== 🚀"
    echo -e "${NC}"
}

# Verificar dependências
check_dependencies() {
    log_info "Verificando dependências necessárias..."
    
    local missing_deps=()
    
    # Git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    # Node.js
    if ! command -v node &> /dev/null; then
        missing_deps+=("node")
    fi
    
    # curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    # jq (para manipular JSON)
    if ! command -v jq &> /dev/null; then
        log_warning "jq não encontrado. Tentando instalar..."
        if command -v npm &> /dev/null; then
            npm install -g jq
        else
            missing_deps+=("jq")
        fi
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Dependências faltando: ${missing_deps[*]}"
        log_info "Por favor, instale as dependências antes de continuar."
        exit 1
    fi
    
    log_success "Todas as dependências encontradas"
}

# Verificar conexão MCP
validate_mcp_connection() {
    log_info "Validando conexão com Figma MCP..."
    
    local mcp_endpoint="localhost:3845"
    
    if curl -s --max-time 5 "http://$mcp_endpoint/health" &> /dev/null; then
        log_success "Conexão MCP validada em $mcp_endpoint"
        return 0
    else
        log_warning "MCP server não encontrado em $mcp_endpoint"
        log_info "Certifique-se de que o Figma MCP server esteja rodando antes de gerar sites"
        return 1
    fi
}

# Criar estrutura de diretórios
create_directory_structure() {
    log_info "Criando estrutura de diretórios..."
    
    local dirs=(
        "sites"
        "scripts" 
        "config"
        "templates"
        "docs"
        ".github/workflows"
    )
    
    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            log_success "Criado: $dir/"
        fi
    done
}

# Mover sites existentes para nova estrutura
migrate_existing_sites() {
    log_info "Migrando sites existentes para nova estrutura..."
    
    # Mover site_* para sites/
    for site_dir in site_*; do
        if [ -d "$site_dir" ]; then
            local new_name=$(echo "$site_dir" | sed 's/^site_//')
            if [ ! -d "sites/$new_name" ]; then
                mv "$site_dir" "sites/$new_name"
                log_success "Migrado: $site_dir → sites/$new_name"
            else
                log_warning "sites/$new_name já existe, mantendo $site_dir"
            fi
        fi
    done
}

# Configurar GitHub Actions
setup_github_actions() {
    log_info "Configurando GitHub Actions para Azure Static Web Apps..."
    
    cat > .github/workflows/deploy-sites.yml << 'EOF'
name: Deploy Sites to Azure Static Web Apps

on:
  push:
    branches: [ main ]
    paths: [ 'sites/**' ]
  pull_request:
    branches: [ main ]
    paths: [ 'sites/**' ]

jobs:
  detect-changes:
    runs-on: ubuntu-latest
    outputs:
      sites: ${{ steps.changes.outputs.sites }}
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 2
      
      - name: Detect changed sites
        id: changes
        run: |
          CHANGED_SITES=$(git diff --name-only HEAD~1 HEAD | grep '^sites/' | cut -d'/' -f2 | sort -u | jq -R -s -c 'split("\n")[:-1]')
          echo "sites=$CHANGED_SITES" >> $GITHUB_OUTPUT
          echo "Changed sites: $CHANGED_SITES"

  deploy-sites:
    needs: detect-changes
    if: needs.detect-changes.outputs.sites != '[]'
    runs-on: ubuntu-latest
    strategy:
      matrix:
        site: ${{ fromJson(needs.detect-changes.outputs.sites) }}
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy ${{ matrix.site }} to Azure Static Web Apps
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_SWA_TOKEN }}
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          action: "upload"
          app_location: "sites/${{ matrix.site }}"
          api_location: ""
          output_location: ""
          skip_app_build: true
EOF
    
    log_success "GitHub Actions configurado"
    log_info "⚠️  Lembre-se de adicionar o secret AZURE_SWA_TOKEN no GitHub"
}

# Criar script de geração v2.0
create_generate_script() {
    log_info "Criando generate-site.sh v2.0..."
    
    # Mover script antigo como backup
    if [ -f "generate-site.sh" ]; then
        mv generate-site.sh scripts/generate-site-v1-backup.sh
        log_info "Script antigo salvo como backup em scripts/"
    fi
    
    cat > scripts/generate-site.sh << 'EOF'
#!/bin/bash
# generate-site.sh v2.0 - Geração automática e organizada

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Parâmetros
SITE_NAME="$1"
FIGMA_FRAME="${2:-}"
BASE_DIR="sites"
CONFIG_FILE="config/project.yml"

# Validar parâmetros
if [ -z "$SITE_NAME" ]; then
    log_error "Nome do site é obrigatório"
    echo "Uso: $0 <nome-do-site> [figma-frame-id]"
    echo "Exemplo: $0 meu-produto"
    exit 1
fi

# Validar nome do site (sem caracteres especiais)
if [[ ! "$SITE_NAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
    log_error "Nome do site deve conter apenas letras, números e hífens"
    exit 1
fi

log_info "🚀 Iniciando geração do site: $SITE_NAME"

# Validações iniciais
validate_setup() {
    log_info "🔍 Validando setup..."
    
    # Verificar se estamos na raiz do projeto
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "Execute este script da raiz do projeto (onde está o config/project.yml)"
        exit 1
    fi
    
    # Verificar conexão MCP (opcional, não bloqueia)
    if curl -s --max-time 3 "http://localhost:3845/health" &> /dev/null; then
        log_success "Conexão MCP validada"
    else
        log_warning "MCP server não responde. Verifique se está rodando."
    fi
}

# Criar estrutura do site
create_site_structure() {
    SITE_DIR="$BASE_DIR/$SITE_NAME"
    log_info "📁 Criando estrutura: $SITE_DIR"
    
    # Verificar se site já existe
    if [ -d "$SITE_DIR" ]; then
        log_warning "Site $SITE_NAME já existe em $SITE_DIR"
        read -p "Deseja sobrescrever? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Operação cancelada"
            exit 0
        fi
        
        # Fazer backup
        if [ -d "$SITE_DIR.backup" ]; then
            rm -rf "$SITE_DIR.backup"
        fi
        mv "$SITE_DIR" "$SITE_DIR.backup"
        log_info "Backup criado em $SITE_DIR.backup"
    fi
    
    mkdir -p "$SITE_DIR"/{assets,docs}
    
    # Criar arquivo de configuração do site
    cat > "$SITE_DIR/site-config.json" << EOF
{
    "name": "$SITE_NAME",
    "created": "$(date -Iseconds)",
    "figma_frame": "$FIGMA_FRAME",
    "status": "generating",
    "version": "2.0"
}
EOF
    
    log_success "Estrutura criada em $SITE_DIR"
}

# Prompt para o agente MCP
get_generation_prompt() {
    cat << EOF
🤖 FIGMA MCP SITE GENERATION REQUEST

CRITICAL: Generate files in the CURRENT WORKING DIRECTORY
Working Directory: $(cd "$SITE_DIR" && pwd)
Site Name: $SITE_NAME
Figma Frame: ${FIGMA_FRAME:-"Use currently selected frame"}

REQUIREMENTS:
1. 🎯 Generate ALL files in the current directory (NOT workspace root!)
2. 📁 Use relative paths for assets: ./assets/filename.ext
3. 🌐 Create a complete, production-ready website
4. ♿ Ensure accessibility (semantic HTML, ARIA labels)
5. 📱 Mobile-first responsive design
6. ⚡ Performance optimized (CSS custom properties, efficient JS)

FILES TO CREATE:
- index.html (semantic HTML5 structure)
- styles.css (CSS with custom properties)
- script.js (vanilla JavaScript)
- README.md (site documentation)

DESIGN REQUIREMENTS:
- Use semantic HTML5 elements
- CSS custom properties for design tokens
- Vanilla JavaScript (no frameworks)
- Mobile-first responsive breakpoints
- Accessibility best practices
- Performance optimizations

Please read the selected Figma frame and generate a complete landing page now.
EOF
}

# Instruções para o usuário
show_mcp_instructions() {
    log_info "🤖 Agora você precisa usar o agente MCP para gerar o site"
    echo
    echo "INSTRUÇÕES:"
    echo "1. Certifique-se de que o Figma MCP server está rodando"
    echo "2. Selecione o frame desejado no Figma"
    echo "3. Cole o prompt abaixo no seu agente MCP:"
    echo
    echo "====== PROMPT PARA O AGENTE MCP ======"
    get_generation_prompt
    echo "======================================"
    echo
    echo "4. Aguarde a geração dos arquivos"
    echo "5. Depois execute: ./scripts/post-generate.sh $SITE_NAME"
    echo
    
    # Salvar prompt em arquivo para facilitar
    get_generation_prompt > "$SITE_DIR/mcp-prompt.txt"
    log_info "💾 Prompt salvo em $SITE_DIR/mcp-prompt.txt"
}

# Fluxo principal
main() {
    validate_setup
    create_site_structure
    
    # Mudar para o diretório do site
    cd "$SITE_DIR"
    
    show_mcp_instructions
    
    log_success "🎉 Estrutura preparada para: $SITE_NAME"
    log_info "📁 Localização: $SITE_DIR"
    log_info "🔗 Próximo passo: Use o agente MCP com o prompt fornecido"
}

main "$@"
EOF
    
    chmod +x scripts/generate-site.sh
    log_success "Script de geração v2.0 criado"
}

# Criar script de pós-geração
create_post_generate_script() {
    log_info "Criando script de pós-geração..."
    
    cat > scripts/post-generate.sh << 'EOF'
#!/bin/bash
# post-generate.sh - Validação e finalização após geração MCP

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

SITE_NAME="$1"
SITE_DIR="sites/$SITE_NAME"

if [ -z "$SITE_NAME" ]; then
    log_error "Nome do site é obrigatório"
    echo "Uso: $0 <nome-do-site>"
    exit 1
fi

if [ ! -d "$SITE_DIR" ]; then
    log_error "Site $SITE_NAME não encontrado em $SITE_DIR"
    exit 1
fi

log_info "🔍 Validando site gerado: $SITE_NAME"

# Validar arquivos obrigatórios
validate_files() {
    local required_files=("index.html" "styles.css" "script.js")
    local missing_files=()
    
    cd "$SITE_DIR"
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -ne 0 ]; then
        log_error "Arquivos faltando: ${missing_files[*]}"
        return 1
    fi
    
    log_success "Todos os arquivos obrigatórios encontrados"
    return 0
}

# Download de assets
download_assets() {
    log_info "📥 Baixando assets..."
    
    if [ -f "../../download-images.sh" ]; then
        cd ../..
        bash download-images.sh "$SITE_NAME"
        cd "$SITE_DIR"
        log_success "Assets baixados"
    else
        log_warning "Script download-images.sh não encontrado"
    fi
}

# Atualizar configuração do site
update_site_config() {
    if [ -f "site-config.json" ]; then
        if command -v jq &> /dev/null; then
            jq '.status = "completed" | .completed_at = now | .files_validated = true' site-config.json > tmp.json
            mv tmp.json site-config.json
        else
            # Fallback sem jq
            sed -i 's/"generating"/"completed"/' site-config.json
        fi
        log_success "Configuração do site atualizada"
    fi
}

# Validar HTML
validate_html() {
    log_info "🔍 Validando HTML..."
    
    if grep -q "<!DOCTYPE html>" index.html && 
       grep -q "<html" index.html && 
       grep -q "</html>" index.html; then
        log_success "Estrutura HTML válida"
    else
        log_warning "Estrutura HTML pode estar incompleta"
    fi
}

# Preview local
offer_preview() {
    log_info "🌐 Site gerado com sucesso!"
    echo
    echo "PRÓXIMOS PASSOS:"
    echo "1. 👀 Preview local: cd $SITE_DIR && python -m http.server 8000"
    echo "2. 🚀 Deploy: git add . && git commit -m 'Add $SITE_NAME' && git push"
    echo "3. 🔗 URL: https://[your-azure-swa-url]/$SITE_NAME/"
    echo
}

# Fluxo principal
main() {
    if validate_files; then
        download_assets
        update_site_config
        validate_html
        offer_preview
        log_success "🎉 Site $SITE_NAME finalizado com sucesso!"
    else
        log_error "❌ Validação falhou. Verifique se todos os arquivos foram gerados."
        exit 1
    fi
}

main "$@"
EOF
    
    chmod +x scripts/post-generate.sh
    log_success "Script de pós-geração criado"
}

# Atualizar README principal
update_main_readme() {
    log_info "Atualizando README principal..."
    
    # Fazer backup do README atual
    if [ -f "README.md" ]; then
        cp README.md README-backup.md
    fi
    
    cat > README.md << 'EOF'
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
│   ├── area-landing/        #   Example: Area landing page
│   └── your-site/           #   Your generated sites
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

## 📖 Documentation

- [Setup Guide](docs/SETUP.md) - Complete setup instructions
- [Site Generation](docs/GENERATION.md) - How to generate sites
- [Deployment Guide](docs/DEPLOYMENT.md) - Azure SWA deployment
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues

## 🌐 Live Examples

- **Area Landing**: https://[your-swa-url]/area-landing/
- **More examples**: Coming soon...

## 🤝 Contributing

This is an open-source platform for Figma-to-production workflows. Contributions welcome!

---

Built with ❤️ by [Tiago Fernandes](https://github.com/TiagoAlvesFernandes-tech)
EOF
    
    log_success "README principal atualizado"
}

# Função principal
main() {
    show_banner
    
    check_dependencies
    validate_mcp_connection
    create_directory_structure
    migrate_existing_sites
    setup_github_actions
    create_generate_script
    create_post_generate_script
    update_main_readme
    
    echo
    log_success "🎉 Setup completo!"
    echo
    echo "PRÓXIMOS PASSOS:"
    echo "1. 🔧 Configure o Azure Static Web Apps secret no GitHub"
    echo "2. 🚀 Gere seu primeiro site: ./scripts/generate-site.sh meu-site"
    echo "3. 📚 Leia a documentação em docs/"
    echo
    log_info "🌟 Plataforma Figma-to-Production pronta para uso!"
}

# Executar se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
EOF

chmod +x scripts/setup.sh
log_success "Script de setup criado"