# Deploy de sites estáticos para Azure Static Web Apps

Este repositório agora entrega cada site em `sites/<nome>` através de uma instância dedicada de **Azure Static Web Apps (SWA)**. Assim, um site pode ser pausado ou removido sem afetar os demais.

## Visão geral do pipeline

- Workflow: `.github/workflows/deploy-sites.yml`
- Disparos: push que altera `sites/**` ou `workflow_dispatch`
- Etapas:
  1. `discover`: varre as pastas de `sites/` e lê o arquivo `site-config.json`.
  2. Gera uma matriz (matrix) apenas com sites cujo campo `deploy` está definido como `true`.
  3. Para cada site da matriz, copia os arquivos necessários para `dist/<site>` e invoca `Azure/static-web-apps-deploy@v1`.

## Configuração de secrets

Crie um token por instância de SWA e cadastre como secret do repositório: `AZURE_STATIC_WEB_APPS_API_TOKEN_<NOME_DO_SITE>` (maiúsculo, hífen preservado). Exemplo:

```
Site: sites/meu-site     → Secret: AZURE_STATIC_WEB_APPS_API_TOKEN_MEU-SITE
Site: sites/workshop-ia  → Secret: AZURE_STATIC_WEB_APPS_API_TOKEN_WORKSHOP-IA
```

> O token pode ser obtido no portal Azure em **Static Web Apps → Manage Deployment Token**.

## Habilitar ou desabilitar deploy

Use o campo `deploy` em `sites/<nome>/site-config.json`:

```json
{
  "name": "workshop-ia",
  "deploy": true
}
```

- `true`: o site entra na matriz e será implantado no próximo push.
- `false`: o site é ignorado, permanecendo indisponível até reativação.

## Convenções para novos sites

1. Utilize `./scripts/generate-site.sh <nome>` para criar uma nova pasta; o script já grava `"deploy": true` por padrão.
2. Conclua a geração com o agente MCP e adicione os arquivos necessários.
3. Ajuste `site-config.json` se quiser impedir deploy automático antes da conclusão (ex.: `"deploy": false`).
4. Commit/push: o workflow cuidará do deploy dos sites habilitados.

## Boas práticas

- Cada SWA pode ter domínio customizado próprio; configure no portal da instância específica.
- Monitore latência e status via Azure Monitor/Log Analytics de cada instância.
- Para manutenção emergencial, altere `deploy` para `false` e faça push — o workflow deixa de publicar novas atualizações. Para derrubar o site atual, use a funcionalidade "Disable" ou "Delete" da instância correspondente no portal.
- Mantenha os artefatos confidenciais (como `mcp-prompt.txt`) fora da área publicada; o workflow já remove `docs/` e arquivos auxiliares antes do deploy.

## Automação de Provisionamento (End-to-End)

Além do workflow de deploy, foi adicionado o workflow `provision-static-web-apps.yml` que automatiza a criação de uma instância **Azure Static Web App** por pasta em `sites/` e registra/atualiza o secret com o token de deployment correspondente.

### Fluxo completo
1. Você cria/gera um novo site com `./scripts/generate-site.sh <nome>` (o arquivo `site-config.json` inclui `"deploy": true`).
2. Executa manualmente o workflow **Provision Static Web Apps** (Actions → Provision Static Web Apps → Run workflow).
3. O workflow:
   - Faz login no Azure usando Service Principal (`AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`).
   - Verifica cada pasta em `sites/` com `deploy=true`.
   - Cria a SWA (caso ainda não exista) usando o resource group `ctl-digital-pages` e região `East Us`.
   - Busca o _deployment token_ e atualiza (ou cria) o secret `AZURE_STATIC_WEB_APPS_API_TOKEN_<SITE>` no repositório.
4. Em seguida, execute o workflow **Deploy Sites** para publicar o conteúdo.

### Criando o Service Principal
Execute uma vez (substitua `<SUBSCRIPTION_ID>`):
```bash
az ad sp create-for-rbac \
  --name "ctl-digital-pages-sp" \
  --role Contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/ctl-digital-pages \
  --sdk-auth
```
Saída contém campos como `clientId`, `clientSecret`, `tenantId`. Mapear para secrets:

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

### Personal Access Token (GitHub)
Criar PAT com escopos mínimos: `repo`, `workflow`. Se for organização com políticas restritivas, incluir `admin:repo_hook`. Salvar como secret: `PERSONAL_TOKEN`.

### Desativar um site
- Definir `"deploy": false` em `sites/<nome>/site-config.json` e fazer commit (site deixa de receber updates; instância permanece). 
- Para remoção: deletar a instância no portal Azure ou acrescentar uma rota de manutenção (status 410) via `staticwebapp.config.json`.

### Rotação de Token
Se necessário:
1. Portal Azure → Static Web App → Manage Deployment Token → Regenerate.
2. Rodar workflow **Provision Static Web Apps** para atualizar o secret.
3. Rodar **Deploy Sites** para validar.

### Script local opcional
Você pode criar `scripts/provision-swa.sh` para rodar manualmente fora do CI (exemplo disponível mediante solicitação) usando a mesma lógica da Action.

### Observabilidade / Próximos Passos
- Adicionar Application Insights por instância, usando tag `site` para correlação.
- Definir `staticwebapp.config.json` com headers de cache e páginas de erro personalizadas.
- Escalar planos (Standard) apenas quando métricas de tráfego justificarem.
