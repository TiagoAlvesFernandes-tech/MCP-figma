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
    cat > "$SITE_DIR/site-config.json" << CONFIGEOF
{
    "name": "$SITE_NAME",
    "created": "$(date -Iseconds)",
    "figma_frame": "$FIGMA_FRAME",
    "status": "generating",
    "version": "2.0"
}
CONFIGEOF
    
    log_success "Estrutura criada em $SITE_DIR"
}

# Prompt para o agente MCP
get_generation_prompt() {
    cat << PROMPTEOF
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
PROMPTEOF
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
