# 🔄 Guia de Transferência para Novo Repositório

Este documento contém os comandos para transferir este projeto para um novo repositório GitHub.

## 📋 Pré-requisitos

1. ✅ Novo repositório criado no GitHub
2. ✅ URL do novo repositório em mãos
3. ✅ Acesso de escrita ao novo repositário

## 🚀 Comandos de Transferência

### Passo 1: Commit das mudanças locais
```bash
git add .
git commit -m "docs: prepare for repository transfer - remove GitHub Pages"
```

### Passo 2: Adicionar novo remote
```bash
# Substitua pela URL do seu novo repositório
git remote add new-origin https://github.com/SEU-USUARIO/NOVO-REPOSITORIO.git
```

### Passo 3: Push para novo repositório
```bash
git push new-origin main
```

### Passo 4: Verificar transferência
```bash
git remote -v
# Deve mostrar tanto origin quanto new-origin
```

### Passo 5: Remover antigo remote (opcional)
```bash
git remote remove origin
git remote rename new-origin origin
```

### Passo 6: Verificar configuração final
```bash
git remote -v
# Deve mostrar apenas o novo repositório
```

## 🧹 Limpeza Realizada

- ❌ Removido `.github/workflows/deploy.yml` (GitHub Pages)
- ❌ Removido diretório `.github/` completo
- ✅ Atualizado README.md (removido links do GitHub Pages)
- ✅ Mantidos todos os sites gerados
- ✅ Mantidos scripts de geração
- ✅ Mantida estrutura do projeto

## 📁 Estrutura Final

```
├── sites/                  # Sites gerados mantidos
├── scripts/               # Scripts de automação mantidos
├── config/                # Configurações mantidas
├── README.md              # Atualizado sem GitHub Pages
├── .gitignore             # Limpo e otimizado
└── TRANSFER.md            # Este arquivo (pode ser removido após transfer)
```

## 🎯 Próximos Passos Após Transferência

1. **Atualizar README.md** com nova URL do repositório
2. **Configurar novo sistema de deploy** (se necessário)
3. **Atualizar links** em documentação
4. **Remover este arquivo** (`TRANSFER.md`) após transferência completa

---

**Nota**: Este arquivo pode ser removido após a transferência bem-sucedida.