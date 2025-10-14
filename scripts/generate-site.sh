#!/bin/bash
# generate-site.sh v2.0 - Geração automática e organizada
# SOLUÇÃO: Cria pasta ANTES, agente gera arquivos no local correto

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
log_prompt() { echo -e "${PURPLE}🤖 $1${NC}"; }

# Banner
show_banner() {
    echo -e "${PURPLE}"
    echo "🚀 ================================="
    echo "   Generate Site v2.0"
    echo "   Figma → Production"
    echo "================================= 🚀"
    echo -e "${NC}"
}

# Parâmetros
SITE_NAME="$1"
FIGMA_FRAME="${2:-}"
BASE_DIR="sites"
CONFIG_FILE="config/project.yml"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Validar parâmetros
if [ -z "$SITE_NAME" ]; then
    log_error "Nome do site é obrigatório"
    echo ""
    echo "USAGE:"
    echo "  $0 <nome-do-site> [figma-frame-id]"
    echo ""
    echo "EXAMPLES:"
    echo "  $0 meu-produto"
    echo "  $0 landing-campanha"
    echo "  $0 portfolio-designer"
    echo ""
    exit 1
fi

# Validar nome do site (sem caracteres especiais)
if [[ ! "$SITE_NAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
    log_error "Nome do site deve conter apenas letras, números e hífens"
    log_info "Exemplos válidos: meu-site, produto123, landing-page"
    exit 1
fi

# Mudar para diretório do projeto
cd "$PROJECT_ROOT"

show_banner
log_info "🚀 Iniciando geração do site: $SITE_NAME"

# Validações iniciais
validate_setup() {
    log_info "🔍 Validando setup..."
    
    # Verificar estrutura do projeto
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "Arquivo de configuração não encontrado: $CONFIG_FILE"
        log_info "Execute ./scripts/setup.sh primeiro"
        exit 1
    fi
    
    # Criar diretório base se não existir
    if [ ! -d "$BASE_DIR" ]; then
        mkdir -p "$BASE_DIR"
        log_info "Criado diretório: $BASE_DIR/"
    fi
    
    # Verificar conexão MCP (não-bloqueante)
    log_info "Testando conexão MCP..."
    if curl -s --max-time 3 "http://localhost:3845/health" &> /dev/null; then
        log_success "Conexão MCP validada (localhost:3845)"
    else
        log_warning "MCP server não responde em localhost:3845"
        log_info "Certifique-se de que o Figma MCP server esteja rodando"
        echo ""
        read -p "Continuar mesmo assim? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Operação cancelada"
            exit 0
        fi
    fi
}

# Criar estrutura do site
create_site_structure() {
    SITE_DIR="$BASE_DIR/$SITE_NAME"
    SITE_ABS_PATH="$(cd "$PROJECT_ROOT" && pwd)/$SITE_DIR"
    
    log_info "📁 Preparando estrutura: $SITE_DIR"
    
    # Verificar se site já existe
    if [ -d "$SITE_DIR" ]; then
        log_warning "Site '$SITE_NAME' já existe em $SITE_DIR"
        echo ""
        echo "OPÇÕES:"
        echo "1. (s) Sobrescrever (faz backup automático)"
        echo "2. (n) Cancelar operação"
        echo ""
        read -p "Sobrescrever site existente? (s/N): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            # Fazer backup com timestamp
            BACKUP_NAME="$SITE_DIR.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$SITE_DIR" "$BACKUP_NAME"
            log_success "Backup criado: $BACKUP_NAME"
        else
            log_info "Operação cancelada pelo usuário"
            exit 0
        fi
    fi
    
    # Criar estrutura completa
    mkdir -p "$SITE_DIR"/{assets,docs,src}
    
    # Arquivo de configuração do site
    cat > "$SITE_DIR/site-config.json" << EOF
{
    "name": "$SITE_NAME",
    "created": "$(date -Iseconds)",
    "figma_frame": "$FIGMA_FRAME",
    "status": "generating",
    "version": "2.0",
    "generator": "figma-mcp-v2",
    "location": "$SITE_ABS_PATH"
}
EOF

    # Arquivo .gitkeep para assets
    touch "$SITE_DIR/assets/.gitkeep"
    
    log_success "Estrutura criada: $SITE_DIR/"
    log_info "📍 Localização absoluta: $SITE_ABS_PATH"
}

# Prompt melhorado para o agente MCP
get_generation_prompt() {
    local abs_path="$(cd "$PROJECT_ROOT" && pwd)/$SITE_DIR"
    
    cat << EOF

🤖 ===============================================
   FIGMA MCP SITE GENERATION REQUEST v2.0
===============================================

⚠️  CRITICAL INSTRUCTION: 
Generate ALL files in the CURRENT WORKING DIRECTORY
DO NOT generate files in workspace root!

📍 WORKING DIRECTORY: $abs_path
📝 SITE NAME: $SITE_NAME
🎨 FIGMA FRAME: ${FIGMA_FRAME:-"Use currently selected frame in Figma"}

🎯 GENERATION REQUIREMENTS:

1. 📁 FILE LOCATION (CRITICAL):
   - Generate ALL files in current directory: $abs_path
   - DO NOT generate in workspace root
   - Use relative paths for assets: ./assets/filename.ext

2. 🌐 WEBSITE STRUCTURE:
   - index.html (semantic HTML5 structure)
   - styles.css (CSS with custom properties) 
   - script.js (vanilla JavaScript)
   - README.md (site documentation)

3. 🎨 DESIGN REQUIREMENTS:
   - Read selected Figma frame via MCP
   - Semantic HTML5 elements (nav, main, section, article, etc.)
   - CSS custom properties for design tokens
   - Vanilla JavaScript (no frameworks)
   - Mobile-first responsive design
   - Accessibility best practices (ARIA labels, proper headings)

4. ⚡ PERFORMANCE & QUALITY:
   - Optimized CSS (custom properties, efficient selectors)
   - Throttled scroll events and intersection observers
   - Proper image loading and alt attributes
   - SEO meta tags and structured data

5. 📱 RESPONSIVE BREAKPOINTS:
   - Mobile: 320px+
   - Tablet: 768px+  
   - Desktop: 1024px+
   - Large: 1440px+

🔧 TECHNICAL SPECIFICATIONS:
- HTML5 doctype and semantic structure
- CSS Grid and Flexbox for layouts
- ES6+ JavaScript with graceful fallbacks
- Progressive enhancement approach
- WCAG 2.1 AA accessibility compliance

📋 POST-GENERATION CHECKLIST:
□ All files created in correct directory
□ Assets use relative paths (./assets/)
□ HTML validates and has proper structure
□ CSS uses custom properties for consistency  
□ JavaScript is vanilla and optimized
□ Site is responsive across all breakpoints
□ Accessibility features implemented

🚀 READY TO GENERATE!

Please read the selected Figma frame via MCP and generate a complete, production-ready landing page following all requirements above.

EOF
}

# Instruções detalhadas para o usuário
show_mcp_instructions() {
    echo ""
    log_prompt "🤖 PRÓXIMO PASSO: Geração com Agente MCP"
    echo ""
    echo "INSTRUÇÕES PASSO A PASSO:"
    echo ""
    echo "1. 🖥️  Certifique-se de que o Figma MCP server está rodando"
    echo "   - Deve responder em: localhost:3845"
    echo ""
    echo "2. 🎨 No Figma:"
    echo "   - Abra o arquivo do seu projeto"
    echo "   - Selecione o frame/página que deseja converter"
    echo "   - Certifique-se de que está no Dev Mode"
    echo ""
    echo "3. 🤖 No seu agente MCP (GitHub Copilot, Claude, etc.):"
    echo "   - Cole o prompt abaixo"
    echo "   - Aguarde a geração completa dos arquivos"
    echo ""
    echo "4. ✅ Após a geração:"
    echo "   - Execute: ./scripts/post-generate.sh $SITE_NAME"
    echo ""
    
    echo -e "${PURPLE}====== PROMPT PARA O AGENTE MCP ======${NC}"
    get_generation_prompt
    echo -e "${PURPLE}=====================================${NC}"
    echo ""
    
    # Salvar prompt em arquivo
    get_generation_prompt > "$SITE_DIR/mcp-prompt.txt"
    log_success "💾 Prompt salvo em: $SITE_DIR/mcp-prompt.txt"
    
    # Criar arquivo de instrucoes
    cat > "$SITE_DIR/INSTRUCTIONS.md" << EOF
# $SITE_NAME - Instruções de Geração

## Status: AGUARDANDO GERAÇÃO MCP

### Próximos Passos:

1. **Use o agente MCP** com o prompt em \`mcp-prompt.txt\`
2. **Aguarde a geração** de todos os arquivos
3. **Execute validação**: \`../scripts/post-generate.sh $SITE_NAME\`
4. **Deploy**: commit e push para GitHub

### Arquivos Esperados:
- [ ] index.html
- [ ] styles.css  
- [ ] script.js
- [ ] README.md
- [ ] assets/ (com imagens baixadas)

### Configuração:
$(cat "$SITE_DIR/site-config.json")

---
Gerado em: $(date)
EOF

    echo ""
    log_info "📋 Instruções salvas em: $SITE_DIR/INSTRUCTIONS.md"
}

# Fluxo principal
main() {
    validate_setup
    create_site_structure
    show_mcp_instructions
    
    echo ""
    log_success "🎉 Site '$SITE_NAME' preparado com sucesso!"
    echo ""
    echo "📁 LOCALIZAÇÃO: $SITE_DIR"
    echo "🤖 PRÓXIMO: Use o agente MCP com o prompt fornecido"
    echo "✅ DEPOIS: ./scripts/post-generate.sh $SITE_NAME"
    echo ""
}

# Trap para limpeza em caso de erro
trap 'log_error "Script interrompido"; exit 1' INT TERM

main "$@"