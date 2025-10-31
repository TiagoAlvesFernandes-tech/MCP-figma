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
    
    if [ -f "../../scripts/download-figma-assets.py" ]; then
        cd ../..
        python scripts/download-figma-assets.py "$SITE_DIR/index.html"
        cd "$SITE_DIR"
        log_success "Assets baixados"
    else
        log_warning "Script download-figma-assets.py não encontrado"
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
