# 🚀 Plataforma Figma-para-Produção

Gere sites profissionais diretamente de designs do Figma usando IA. Deploy flexível para qualquer plataforma de hospedagem.

## ⚡ Início Rápido

### 1. **Configuração Inicial**

1. **Clone o repositório e navegue até a pasta:**
   ```bash
   git clone https://github.com/TiagoAlvesFernandes-tech/MCP-figma.git
   cd MCP-figma
   ```

2. **Execute o script de configuração:**
   ```bash
   # Caminhe para a pasta raiz do projeto (se não estiver)
   cd MCP-figma
   
   # Execute a configuração inicial
   ./scripts/setup.sh
   ```

### 2. **Gere Seu Primeiro Site**

1. **Execute o gerador de sites:**
   ```bash
   # Substitua "meu-site-incrivel" pelo nome desejado
   ./scripts/generate-site.sh "meu-site-incrivel"
   ```

2. **Siga as instruções do prompt MCP que aparecerem no terminal**

3. **Execute a validação pós-geração:**
   ```bash
   # Valide e otimize o site gerado
   ./scripts/post-generate.sh "meu-site-incrivel"
   ```

### 3. **Deploy Automático**

1. **Adicione os arquivos ao Git:**
   ```bash
   git add .
   git commit -m "Adicionar novo site: meu-site-incrivel"
   git push
   ```

2. **O GitHub Actions fará o deploy automaticamente!**
   - Acesse: `https://seu-usuario.github.io/MCP-figma/sites/meu-site-incrivel/`

## 🏗️ Estrutura do Projeto

```
├── sites/                    # 🌐 Sites gerados
│   ├── area-landing/        #   ✅ Página de landing da Area
│   ├── ai-llm-workshop/     #   ✅ Site do Workshop de IA
│   ├── ai-llm-workshop-v2/  #   ✅ Versão 2.0 do Workshop
│   └── seu-site/            #   🆕 Seus novos sites aqui
├── scripts/                 # 🔧 Scripts de automação
│   ├── setup.sh            #   Configuração inicial
│   ├── generate-site.sh    #   Geração de sites v2.0
│   └── post-generate.sh    #   Validação pós-geração
├── config/                  # ⚙️  Arquivos de configuração
│   └── project.yml         #   Configuração do projeto
├── .github/workflows/       # 🚀 Automação CI/CD
│   └── deploy.yml          #   Deploy para GitHub Pages
└── .gitignore              # 🚫 Arquivos ignorados pelo Git
```

## 🎯 Funcionalidades

- **🎨 Integração com Figma**: Conexão direta com o Figma Dev Mode
- **🤖 Geração por IA**: Agente MCP cria HTML/CSS/JS semântico
- **📱 Responsivo**: Design mobile-first responsivo
- **♿ Acessível**: Compatível com WCAG e HTML semântico
- **⚡ Performance**: CSS custom properties otimizado e JavaScript vanilla
- **🚀 Deploy Flexível**: Pronto para qualquer plataforma de hospedagem
- **🔧 Profissional**: Geração de código pronto para produção

## 🔧 Requisitos

- **Figma**: Acesso ao Dev Mode e configuração do servidor MCP
- **Node.js**: Versão 18+ para ferramentas
- **GitHub**: Repositório com Actions habilitado
- **Git**: Para controle de versão

## 🌐 Sites Gerados

- **🆕 Página de Landing Area**: `sites/area-landing/`
- **Workshop de IA**: `sites/ai-llm-workshop/`
- **Workshop de IA v2.0**: `sites/ai-llm-workshop-v2/`

> 💡 **Dica**: Execute `python -m http.server 8000` dentro de qualquer pasta de site para testar localmente

## � Passo a Passo Detalhado

### Primeira Utilização

1. **Abra o terminal e navegue para onde quer clonar o projeto:**
   ```bash
   cd C:\Users\SeuUsuario\Desktop\Projetos
   ```

2. **Clone e entre na pasta:**
   ```bash
   git clone https://github.com/TiagoAlvesFernandes-tech/MCP-figma.git
   cd MCP-figma
   ```

3. **Torne os scripts executáveis (Linux/Mac):**
   ```bash
   chmod +x scripts/*.sh
   ```

4. **Execute a configuração:**
   ```bash
   ./scripts/setup.sh
   ```

### Gerando um Novo Site

1. **Caminhe para a pasta do projeto:**
   ```bash
   cd caminho/para/MCP-figma
   ```

2. **Execute o gerador:**
   ```bash
   ./scripts/generate-site.sh "nome-do-meu-site"
   ```

3. **O script criará a pasta:**
   ```
   sites/nome-do-meu-site/
   ```

4. **Siga as instruções que aparecerem no terminal**

5. **Após a geração, valide o site:**
   ```bash
   ./scripts/post-generate.sh "nome-do-meu-site"
   ```

6. **Verifique se os arquivos foram criados:**
   ```bash
   ls -la sites/nome-do-meu-site/
   ```

### Fazendo Deploy

1. **Verifique o status do Git:**
   ```bash
   git status
   ```

2. **Adicione todos os arquivos:**
   ```bash
   git add .
   ```

3. **Faça o commit:**
   ```bash
   git commit -m "feat: adicionar site nome-do-meu-site"
   ```

4. **Envie para o GitHub:**
   ```bash
   git push origin main
   ```

5. **Acompanhe o deploy no GitHub:**
   - Vá para seu repositório no GitHub
   - Clique na aba "Actions"
   - Veja o progresso do deploy

6. **Teste seu site localmente:**
   ```bash
   cd sites/nome-do-meu-site
   python -m http.server 8000
   # Acesse: http://localhost:8000
   ```

## 🛠️ Comandos Úteis

```bash
# Ver todos os sites gerados
ls -la sites/

# Executar servidor local para testar
cd sites/nome-do-site
python -m http.server 8000

# Ver logs do Git
git log --oneline

# Ver diferenças antes do commit
git diff

# Desfazer último commit (mantendo arquivos)
git reset --soft HEAD~1
```

## 📖 Próximos Passos

Veja [NEXT_STEPS.md](NEXT_STEPS.md) para o roadmap completo para transformar isso em uma plataforma totalmente automatizada.

## 🤝 Contribuindo

Esta é uma plataforma open-source para workflows Figma-para-produção. Contribuições são bem-vindas!

### Como Contribuir

1. **Faça um fork do projeto**
2. **Crie uma branch para sua feature:**
   ```bash
   git checkout -b feature/minha-nova-feature
   ```
3. **Faça commit das suas mudanças:**
   ```bash
   git commit -m "feat: adicionar nova feature incrível"
   ```
4. **Envie para sua branch:**
   ```bash
   git push origin feature/minha-nova-feature
   ```
5. **Abra um Pull Request**

---

Construído com ❤️ por [Tiago Fernandes](https://github.com/TiagoAlvesFernandes-tech)