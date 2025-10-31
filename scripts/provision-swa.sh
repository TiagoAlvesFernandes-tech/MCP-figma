#!/usr/bin/env bash
# provision-swa.sh - Provisiona Azure Static Web Apps para cada site com deploy=true
# Uso: ./scripts/provision-swa.sh <resource-group> <location>
# Ex:  ./scripts/provision-swa.sh ctl-digital-pages brazilsouth

set -euo pipefail

RG="${1:-ctl-digital-pages}"
LOCATION="${2:-brazilsouth}"

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI não encontrado. Instale primeiro." >&2
  exit 1
fi

# Validar login
if ! az account show >/dev/null 2>&1; then
  echo "Você precisa executar: az login" >&2
  exit 1
fi

echo "Resource Group: $RG"; echo "Location: $LOCATION"; echo

# Adicionar extensão se necessário
az extension add --name staticwebapp >/dev/null 2>&1 || echo "Extensão já instalada"

changed_any=false
for d in sites/*; do
  [ -d "$d" ] || continue
  cfg="$d/site-config.json"
  if [ ! -f "$cfg" ]; then
    echo "[skip] $d (faltando site-config.json)"; continue
  fi
  deploy=$(jq -r '.deploy // "true"' "$cfg")
  name=$(jq -r '.name // empty' "$cfg")
  [ -n "$name" ] || name=$(basename "$d")
  if [ "$deploy" != "true" ]; then
    echo "[skip] $name (deploy=false)"; continue
  fi
  swa_name="mcp-${name}-prod"
  exists=$(az staticwebapp list --query "[?name=='$swa_name'] | length(@)")
  if [ "$exists" = "0" ]; then
    echo "[create] $swa_name"
    az staticwebapp create \
      --name "$swa_name" \
      --resource-group "$RG" \
      --location "$LOCATION" \
      --sku Free \
      --app-location "$d" \
      --skip-app-build true \
      --tags site="$name" env=prod owner=local-script
    changed_any=true
  else
    echo "[exists] $swa_name"
  fi
  token=$(az staticwebapp secrets list --name "$swa_name" --resource-group "$RG" --query "properties.apiKey" -o tsv)
  printf "[token] %s => %s\n" "$name" "$token"
  echo "Crie/Atualize secret: AZURE_STATIC_WEB_APPS_API_TOKEN_${name^^}"
  echo
  
  # Mostrar URL
  url=$(az staticwebapp show --name "$swa_name" --resource-group "$RG" --query "defaultHostname" -o tsv)
  echo "URL: https://${url}"; echo
  
  # Opcional: gerar arquivo de referência
  echo "{" > "$d/swa-info.json"
  echo "  \"swa_name\": \"$swa_name\"," >> "$d/swa-info.json"
  echo "  \"default_hostname\": \"$url\"," >> "$d/swa-info.json"
  echo "  \"resource_group\": \"$RG\"" >> "$d/swa-info.json"
  echo "}" >> "$d/swa-info.json"
  echo "[info] Arquivo $d/swa-info.json gerado"
  echo "---------------------------------------"
 done

if [ "$changed_any" = true ]; then
  echo "Provisionamento concluído. Execute o workflow Deploy Sites para publicar." 
else
  echo "Nenhuma nova SWA criada. Tokens listados para referência." 
fi
