# AI LLM Workshop v2.0 - Landing Page

Uma landing page moderna e profissional para o **Workshop IA: Como escolher o modelo certo de IA**, ministrado por Jorge Maia, Microsoft MVP e Arquiteto de Software.

## 🎯 Sobre o Workshop

**O futuro do seu projeto de IA é uma bomba-relógio prestes a explodir.**

A maioria dos projetos de IA custa muito mais do que o necessário por usar o modelo errado. Este workshop ensina na prática como calcular o custo real vs. ideal e tomar a decisão que garanta a saúde financeira da sua aplicação.

### 📅 Informações do Evento
- **Data**: Sábado, 18/10/2025
- **Horário**: 09:00
- **Formato**: Online
- **Investimento**: R$ 297,00
- **Instrutor**: Jorge Maia (Microsoft MVP)

## 🚀 Funcionalidades da Landing Page

### ✨ Design & UX
- **Design Responsivo**: Mobile-first com breakpoints otimizados
- **Animações Fluidas**: Scroll animations e micro-interações
- **Performance Otimizada**: Carregamento rápido e experiência suave
- **Acessibilidade**: WCAG 2.1 AA compliance
- **SEO Otimizado**: Meta tags, structured data e semântica correta

### 🎨 Tecnologias Utilizadas
- **HTML5**: Semântico com ARIA labels
- **CSS3**: Custom properties, Grid, Flexbox
- **JavaScript ES6+**: Vanilla JS com performance otimizada
- **Google Fonts**: Montserrat typography system
- **Progressive Enhancement**: Funciona sem JavaScript

### 🔧 Recursos Técnicos
- **CSS Custom Properties**: Sistema de design consistente
- **Intersection Observer**: Animações de scroll performáticas
- **Throttling/Debouncing**: Otimização de eventos
- **Error Handling**: Tratamento robusto de erros
- **Analytics Ready**: Integração preparada para GA4

## 📁 Estrutura de Arquivos

```
ai-llm-workshop-v2/
├── index.html              # Página principal
├── styles.css              # Estilos completos com design system
├── script.js               # Funcionalidades JavaScript
├── README.md               # Esta documentação
├── assets/                 # Recursos visuais
│   ├── jorge-maia-photo.jpg      # Foto do instrutor
│   ├── gpt-logo.png              # Logo ChatGPT
│   ├── gemini-logo.png           # Logo Google Gemini
│   ├── claude-logo.png           # Logo Claude AI
│   ├── meta-logo.png             # Logo Meta AI
│   ├── llama-logo.png            # Logo Llama
│   ├── arrow-1.png               # Seta decorativa 1
│   ├── arrow-2.png               # Seta decorativa 2
│   ├── problem-illustration.jpg   # Ilustração dos problemas
│   ├── module-1-icon.jpg         # Ícone módulo 1
│   ├── module-2-icon.jpg         # Ícone módulo 2
│   ├── module-3-icon.jpg         # Ícone módulo 3
│   ├── module-4-icon.jpg         # Ícone módulo 4
│   ├── module-5-icon.jpg         # Ícone módulo 5
│   ├── module-6-icon.jpg         # Ícone módulo 6
│   ├── module-7-icon.jpg         # Ícone módulo 7
│   └── workshop-preview.jpg      # Preview para redes sociais
├── docs/                   # Documentação adicional
└── src/                    # Código fonte (se necessário)
```

## 🎨 Design System

### Cores
```css
--color-primary: #09311c      /* Verde escuro principal */
--color-secondary: #ae0808    /* Vermelho de destaque */
--color-success: #00ff79      /* Verde sucesso */
--color-danger: #ff0000       /* Vermelho perigo */
--color-white: #ffffff        /* Branco */
--color-text-light: rgba(255, 255, 255, 0.9)  /* Texto claro */
```

### Tipografia
- **Font Family**: Montserrat
- **Weights**: 200 (Light) a 800 (ExtraBold)
- **Sizes**: 14px a 100px (sistema responsivo)

### Espaçamento
- **Sistema**: 8px base unit
- **Range**: 8px a 128px
- **Responsive**: Adapta por breakpoint

## 📱 Breakpoints Responsivos

- **Mobile**: 320px - 479px
- **Mobile Large**: 480px - 767px
- **Tablet**: 768px - 1023px
- **Desktop**: 1024px - 1439px
- **Large Desktop**: 1440px+

## 🔧 Desenvolvimento Local

### Servidor Python
```bash
cd sites/ai-llm-workshop-v2/
python3 -m http.server 3000
```

### Servidor Node.js
```bash
npx http-server . -p 3000 -o
```

### Live Server (VS Code)
Use a extensão Live Server para desenvolvimento em tempo real.

## 🚀 Deploy

### Azure Static Web Apps
Esta landing page está configurada para deploy automático no Azure Static Web Apps via GitHub Actions.

#### URL de Produção
```
https://ai-llm-workshop-v2.azurestaticapps.net
```

#### Pipeline CI/CD
1. Push para branch `main`
2. GitHub Actions executa build
3. Deploy automático no Azure
4. URL ativa em minutos

## 📊 Performance

### Objetivos de Performance
- **Lighthouse Score**: 100/100
- **First Contentful Paint**: < 1.2s
- **Largest Contentful Paint**: < 2.5s
- **Time to Interactive**: < 3s
- **Cumulative Layout Shift**: < 0.1

### Otimizações Implementadas
- **Critical CSS**: Inline para above-the-fold
- **Image Optimization**: WebP com fallbacks
- **Font Loading**: Preload e font-display: swap
- **JavaScript**: Lazy loading e code splitting
- **Caching**: Service Worker ready

## ♿ Acessibilidade

### Recursos Implementados
- **Navegação por Teclado**: Tab order otimizado
- **Screen Reader**: ARIA labels e semantic HTML
- **Alto Contraste**: Suporte a prefers-contrast
- **Redução de Movimento**: Respeita prefers-reduced-motion
- **Focus Management**: Indicadores visuais claros

### Testes Realizados
- ✅ Lighthouse Accessibility: 100/100
- ✅ axe-core: Zero violações
- ✅ Keyboard Navigation: Completa
- ✅ Screen Reader: NVDA/JAWS compatível

## 🔍 SEO

### Meta Tags Implementadas
```html
<meta name="description" content="Workshop IA - Como escolher o modelo certo de IA">
<meta name="keywords" content="workshop IA, inteligência artificial, LLM">
<meta name="author" content="Jorge Maia">
```

### Open Graph
```html
<meta property="og:title" content="Workshop IA - Como escolher o modelo certo de IA">
<meta property="og:description" content="O futuro do seu projeto de IA é uma bomba-relógio prestes a explodir">
<meta property="og:image" content="./assets/workshop-preview.jpg">
```

### Structured Data
- Schema.org Event markup
- Breadcrumbs navigation
- Author information
- Organization details

## 📈 Analytics

### Eventos Rastreados
- **CTA Clicks**: Botões de inscrição
- **Scroll Depth**: 25%, 50%, 75%, 100%
- **Section Views**: Visualização de seções
- **Error Tracking**: JavaScript errors
- **Performance**: Core Web Vitals

### Integrações Preparadas
- Google Analytics 4
- Google Tag Manager
- Facebook Pixel
- Hotjar/Microsoft Clarity

## 🛠️ Manutenção

### Atualizações de Conteúdo
1. **Preços**: Editar seção `.pricing-section`
2. **Data do Evento**: Atualizar `.pricing-date`
3. **Módulos**: Modificar `.workshop-modules`
4. **Instrutor**: Alterar `.instructor-section`

### Monitoramento
- **Performance**: Core Web Vitals
- **Errors**: Console errors e exceptions
- **Uptime**: Status do site
- **Conversions**: Taxa de cliques CTAs

## 🎓 Sobre o Instrutor

**Jorge Maia** - Arquiteto de Software & Microsoft MVP

- +20 anos de experiência em arquitetura de software
- 10x Microsoft MVP (Most Valuable Professional)
- Mestre em Sistemas Mecatrônicos
- Especialista em IA e Internet das Coisas
- Consultor para projetos de alta tecnologia

Com mais de duas décadas de experiência, Jorge é o especialista que empresas chamam quando precisam construir tecnologia de ponta que não apenas funcione, mas que gere resultados e impacto real.

## 📞 Suporte

### Para Dúvidas sobre o Workshop
- **Site**: [Link do evento](https://payment.ticto.app/OF6CA9F23)
- **Email**: [contato do instrutor]

### Para Questões Técnicas
- **Repositório**: GitHub Issues
- **Documentação**: Ver arquivos em `/docs`
- **Updates**: Acompanhar releases

## 📄 Licença

© 2025 Workshop IA - Jorge Maia. Todos os direitos reservados.

Este projeto foi desenvolvido para fins educacionais e promocionais do Workshop IA.

---

**Powered by MCP Figma v2.0** 🚀

*Gerado automaticamente a partir do design Figma usando o sistema MCP Figma v2.0 - Conversão de design para código production-ready.*