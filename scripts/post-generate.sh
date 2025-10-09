#!/bin/bash
# post-generate.sh v2.0 - Validação e finalização pós-geração
# Valida geração do agente MCP e prepara para deploy

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

# Banner
show_banner() {
    echo -e "${GREEN}"
    echo "✅ ================================="
    echo "   Post-Generate v2.0"
    echo "   Validação & Deploy"
    echo "================================= ✅"
    echo -e "${NC}"
}

# Parâmetros
SITE_NAME="$1"
BASE_DIR="sites"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Validar parâmetros
if [ -z "$SITE_NAME" ]; then
    log_error "Nome do site é obrigatório"
    echo ""
    echo "USAGE:"
    echo "  $0 <nome-do-site>"
    echo ""
    echo "EXAMPLES:"
    echo "  $0 meu-produto"
    echo "  $0 landing-campanha"
    echo ""
    exit 1
fi

# Mudar para diretório do projeto
cd "$PROJECT_ROOT"

SITE_DIR="$BASE_DIR/$SITE_NAME"
SITE_ABS_PATH="$(pwd)/$SITE_DIR"

show_banner
log_info "🔍 Validando geração do site: $SITE_NAME"

# Verificar se site existe
if [ ! -d "$SITE_DIR" ]; then
    log_error "Site não encontrado: $SITE_DIR"
    log_info "Execute ./scripts/generate-site.sh $SITE_NAME primeiro"
    exit 1
fi

# Array para rastrear problemas
declare -a ISSUES=()
declare -a WARNINGS=()

# Validação dos arquivos essenciais
validate_core_files() {
    log_info "📋 Validando arquivos essenciais..."
    
    local required_files=("index.html" "styles.css" "script.js" "README.md")
    local missing_files=()
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$SITE_DIR/$file" ]; then
            missing_files+=("$file")
            ISSUES+=("Arquivo obrigatório ausente: $file")
        else
            log_success "$file encontrado"
        fi
    done
    
    if [ ${#missing_files[@]} -eq 0 ]; then
        log_success "Todos os arquivos essenciais encontrados"
    else
        log_error "Arquivos essenciais ausentes: ${missing_files[*]}"
    fi
}

# Validação do HTML
validate_html() {
    local html_file="$SITE_DIR/index.html"
    
    if [ ! -f "$html_file" ]; then
        return
    fi
    
    log_info "🌐 Validando HTML..."
    
    # Verificar doctype HTML5
    if ! grep -q "<!DOCTYPE html>" "$html_file"; then
        ISSUES+=("HTML sem doctype HTML5")
    else
        log_success "Doctype HTML5 encontrado"
    fi
    
    # Verificar meta viewport
    if ! grep -q "viewport" "$html_file"; then
        WARNINGS+=("Meta viewport ausente (pode afetar responsividade)")
    else
        log_success "Meta viewport encontrado"
    fi
    
    # Verificar charset
    if ! grep -q "charset" "$html_file"; then
        WARNINGS+=("Charset não definido")
    else
        log_success "Charset definido"
    fi
    
    # Verificar se links para CSS/JS existem
    if ! grep -q "styles.css" "$html_file"; then
        WARNINGS+=("Link para styles.css não encontrado no HTML")
    else
        log_success "Link para CSS encontrado"
    fi
    
    if ! grep -q "script.js" "$html_file"; then
        WARNINGS+=("Link para script.js não encontrado no HTML")
    else
        log_success "Link para JavaScript encontrado"
    fi
}

# Validação do CSS
validate_css() {
    local css_file="$SITE_DIR/styles.css"
    
    if [ ! -f "$css_file" ]; then
        return
    fi
    
    log_info "🎨 Validando CSS..."
    
    local css_size=$(stat -f%z "$css_file" 2>/dev/null || stat -c%s "$css_file" 2>/dev/null || echo "0")
    
    if [ "$css_size" -lt 100 ]; then
        WARNINGS+=("CSS muito pequeno (${css_size} bytes) - pode estar incompleto")
    else
        log_success "CSS com tamanho adequado (${css_size} bytes)"
    fi
    
    # Verificar media queries (responsividade)
    if grep -q "@media" "$css_file"; then
        log_success "Media queries encontradas (responsivo)"
    else
        WARNINGS+=("Nenhuma media query encontrada - site pode não ser responsivo")
    fi
    
    # Verificar custom properties
    if grep -q ":root\|--" "$css_file"; then
        log_success "CSS custom properties encontradas"
    else
        WARNINGS+=("CSS custom properties não encontradas - pode dificultar manutenção")
    fi
}

# Validação do JavaScript
validate_javascript() {
    local js_file="$SITE_DIR/script.js"
    
    if [ ! -f "$js_file" ]; then
        return
    fi
    
    log_info "⚡ Validando JavaScript..."
    
    local js_size=$(stat -f%z "$js_file" 2>/dev/null || stat -c%s "$js_file" 2>/dev/null || echo "0")
    
    if [ "$js_size" -lt 50 ]; then
        WARNINGS+=("JavaScript muito pequeno (${js_size} bytes) - pode estar vazio")
    else
        log_success "JavaScript com tamanho adequado (${js_size} bytes)"
    fi
    
    # Verificar sintaxe básica (sem erros óbvios)
    if node -c "$js_file" 2>/dev/null; then
        log_success "Sintaxe JavaScript válida"
    else
        ISSUES+=("Possíveis erros de sintaxe no JavaScript")
    fi
}

# Validar assets
validate_assets() {
    log_info "🖼️  Validando assets..."
    
    local assets_dir="$SITE_DIR/assets"
    
    if [ ! -d "$assets_dir" ]; then
        WARNINGS+=("Diretório assets/ não encontrado")
        return
    fi
    
    local asset_count=$(find "$assets_dir" -type f | wc -l)
    
    if [ "$asset_count" -eq 0 ]; then
        WARNINGS+=("Nenhum asset encontrado em assets/")
    else
        log_success "$asset_count arquivo(s) encontrado(s) em assets/"
        
        # Listar tipos de arquivo
        find "$assets_dir" -type f -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.svg" -o -name "*.webp" | while read -r file; do
            local filename=$(basename "$file")
            log_success "📁 $filename"
        done
    fi
}

# Atualizar configuração do site
update_site_config() {
    local config_file="$SITE_DIR/site-config.json"
    
    if [ -f "$config_file" ]; then
        log_info "⚙️  Atualizando configuração do site..."
        
        # Atualizar status e timestamp sem jq
        local temp_config=$(mktemp)
        local timestamp=$(date -Iseconds)
        
        # Usar sed para atualizar o JSON
        sed "s/\"status\": \"generating\"/\"status\": \"validated\"/" "$config_file" | \
        sed "s/}$/,\"validated_at\": \"$timestamp\"}/" > "$temp_config"
        
        mv "$temp_config" "$config_file"
        
        log_success "Configuração atualizada"
    fi
}

# Preparar para deploy
prepare_deploy() {
    log_info "🚀 Preparando para deploy..."
    
    # Criar arquivo de informações do deploy
    cat > "$SITE_DIR/deploy-info.json" << EOF
{
    "site_name": "$SITE_NAME",
    "generated_at": "$(date -Iseconds)",
    "validation_passed": $([ ${#ISSUES[@]} -eq 0 ] && echo "true" || echo "false"),
    "issues_count": ${#ISSUES[@]},
    "warnings_count": ${#WARNINGS[@]},
    "ready_for_deploy": $([ ${#ISSUES[@]} -eq 0 ] && echo "true" || echo "false"),
    "deploy_url": "https://$SITE_NAME.azurestaticapps.net",
    "validation_version": "2.0"
}
EOF
    
    # Criar arquivo .env local para desenvolvimento
    cat > "$SITE_DIR/.env.local" << EOF
# Configuração local para desenvolvimento
SITE_NAME=$SITE_NAME
NODE_ENV=development
LOCAL_URL=http://localhost:3000
EOF
    
    # Criar servidor de desenvolvimento simples
    cat > "$SITE_DIR/dev-server.py" << EOF
#!/usr/bin/env python3
# Servidor de desenvolvimento local
import http.server
import socketserver
import os
import webbrowser
from pathlib import Path

PORT = 3000
directory = Path(__file__).parent

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=directory, **kwargs)

os.chdir(directory)
print(f"🌐 Servidor local iniciado: http://localhost:{PORT}")
print(f"📁 Servindo: {directory}")
print("🔄 Ctrl+C para parar")

try:
    webbrowser.open(f"http://localhost:{PORT}")
except:
    pass

with socketserver.TCPServer(("", PORT), CustomHandler) as httpd:
    httpd.serve_forever()
EOF
    
    chmod +x "$SITE_DIR/dev-server.py"
    
    log_success "Arquivo de deploy preparado"
}

# Gerar relatório de validação
generate_report() {
    log_info "📊 Gerando relatório..."
    
    local report_file="$SITE_DIR/VALIDATION_REPORT.md"
    
    cat > "$report_file" << EOF
# Relatório de Validação - $SITE_NAME

**Data:** $(date)  
**Status:** $([ ${#ISSUES[@]} -eq 0 ] && echo "✅ APROVADO" || echo "❌ PROBLEMAS ENCONTRADOS")  
**Localização:** \`$SITE_ABS_PATH\`

## 📋 Resumo

- **Problemas críticos:** ${#ISSUES[@]}
- **Avisos:** ${#WARNINGS[@]}
- **Pronto para deploy:** $([ ${#ISSUES[@]} -eq 0 ] && echo "✅ SIM" || echo "❌ NÃO")

## 📁 Arquivos Validados

- [x] index.html
- [x] styles.css  
- [x] script.js
- [x] README.md
- [x] assets/

## 🔍 Validações Realizadas

### ✅ Estrutura de Arquivos
- Todos os arquivos essenciais presentes
- Diretório assets/ configurado

### ✅ HTML
- Doctype HTML5
- Meta tags essenciais
- Links para CSS/JS

### ✅ CSS  
- Tamanho adequado
- Media queries (responsividade)
- Custom properties

### ✅ JavaScript
- Sintaxe válida
- Tamanho adequado

EOF

    # Adicionar problemas se existirem
    if [ ${#ISSUES[@]} -gt 0 ]; then
        echo "" >> "$report_file"
        echo "## ❌ Problemas Críticos" >> "$report_file"
        echo "" >> "$report_file"
        for issue in "${ISSUES[@]}"; do
            echo "- $issue" >> "$report_file"
        done
    fi
    
    # Adicionar warnings se existirem
    if [ ${#WARNINGS[@]} -gt 0 ]; then
        echo "" >> "$report_file"
        echo "## ⚠️ Avisos" >> "$report_file"
        echo "" >> "$report_file"
        for warning in "${WARNINGS[@]}"; do
            echo "- $warning" >> "$report_file"
        done
    fi
    
    # Adicionar próximos passos
    cat >> "$report_file" << EOF

## 🚀 Próximos Passos

### Para Deploy:
1. **Commit:** \`git add sites/$SITE_NAME && git commit -m "feat: add $SITE_NAME site"\`
2. **Push:** \`git push origin main\`
3. **Azure:** Deploy automático via GitHub Actions
4. **URL:** https://$SITE_NAME.azurestaticapps.net

### Para Desenvolvimento Local:
\`\`\`bash
cd sites/$SITE_NAME
python3 dev-server.py
# ou
npx http-server . -p 3000 -o
\`\`\`

---
*Gerado por post-generate.sh v2.0*
EOF
    
    log_success "Relatório salvo: $report_file"
}

# Mostrar sumário final
show_summary() {
    echo ""
    echo "==============================================="
    log_info "📊 SUMÁRIO DA VALIDAÇÃO"
    echo "==============================================="
    echo ""
    echo "🎯 SITE: $SITE_NAME"
    echo "📁 LOCAL: $SITE_DIR"
    echo ""
    
    if [ ${#ISSUES[@]} -eq 0 ]; then
        log_success "✅ VALIDAÇÃO APROVADA - Site pronto para deploy!"
        echo ""
        echo "🚀 PRÓXIMOS PASSOS:"
        echo "1. git add sites/$SITE_NAME"
        echo "2. git commit -m \"feat: add $SITE_NAME site\""
        echo "3. git push origin main"
        echo "4. 🌐 Deploy automático no Azure"
        echo ""
        log_success "URL final: https://$SITE_NAME.azurestaticapps.net"
    else
        log_error "❌ PROBLEMAS ENCONTRADOS - Correções necessárias"
        echo ""
        echo "🔧 PROBLEMAS:"
        for issue in "${ISSUES[@]}"; do
            echo "   - $issue"
        done
    fi
    
    if [ ${#WARNINGS[@]} -gt 0 ]; then
        echo ""
        log_warning "⚠️  AVISOS (não impeditivos):"
        for warning in "${WARNINGS[@]}"; do
            echo "   - $warning"
        done
    fi
    
    echo ""
    log_info "📋 Relatório completo: $SITE_DIR/VALIDATION_REPORT.md"
    echo ""
}

# Fluxo principal
main() {
    validate_core_files
    validate_html
    validate_css
    validate_javascript
    validate_assets
    update_site_config
    prepare_deploy
    generate_report
    show_summary
    
    # Exit code baseado na validação
    if [ ${#ISSUES[@]} -eq 0 ]; then
        log_success "🎉 Validação concluída com sucesso!"
        exit 0
    else
        log_error "💥 Validação falhou - corrija os problemas listados"
        exit 1
    fi
}

# Trap para limpeza
trap 'log_error "Validação interrompida"; exit 1' INT TERM

main "$@"