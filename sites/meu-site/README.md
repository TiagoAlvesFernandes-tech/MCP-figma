# Workshop: Como Escolher o LLM Certo

> **Landing Page para Workshop de IA com Jorge Maia - Microsoft MVP**

Uma landing page moderna, responsiva e otimizada para conversão, desenvolvida para promover o workshop "Como Escolher o LLM Certo - O Primeiro Bloco do Seu Projeto de IA".

## ��� Sobre o Workshop

Este workshop ensina desenvolvedores e profissionais de tecnologia a tomar a decisão mais importante em projetos de IA: **a escolha do LLM (Large Language Model) adequado**. Com Jorge Maia, arquiteto de software e Microsoft MVP, você aprenderá:

- **Os Blocos Fundamentais**: Entenda o que são LLMs e conheça os principais modelos
- **A Escolha Estratégica**: Critérios práticos para selecionar o LLM ideal
- **Implementação Prática**: Demonstrações reais de integração e uso

## ��� Características Técnicas

### ���️ Arquitetura
- **HTML5 Semântico**: Estrutura acessível e SEO-friendly
- **CSS Custom Properties**: Sistema de design tokens para consistência
- **JavaScript Vanilla**: Performance otimizada sem dependências
- **Mobile-First**: Design responsivo com breakpoints otimizados

### ��� Design System
- **Cores Principais**: 
  - Dark Blue: `#111827`
  - Accent Blue: `#38bdf8`
  - Accent Red: `#e5273c`
- **Tipografia**: Montserrat (Primary), Montserrat Alternates (Headers)
- **Gradientes**: Aplicados em textos de destaque e CTAs
- **Espaçamento**: Sistema baseado em múltiplos de 8px

### ♿ Acessibilidade
- **ARIA Labels**: Navegação assistiva otimizada
- **Contraste**: Cores com ratio adequado (WCAG AA)
- **Navegação por Teclado**: Suporte completo a keyboard navigation
- **Screen Readers**: Estrutura semântica compatível
- **Reduced Motion**: Respeita preferências de animação do usuário

### ��� Responsividade
- **Mobile**: 320px - 767px
- **Tablet**: 768px - 1023px  
- **Desktop**: 1024px+
- **Images**: Otimizadas para diferentes densidades de tela

## ��� Estrutura de Arquivos

```
meu-site/
├── index.html              # Página principal
├── styles.css              # Estilos CSS com design tokens
├── script.js               # JavaScript vanilla com funcionalidades
├── README.md               # Documentação do projeto
└── assets/                 # Recursos de mídia
    ├── background-frame.png
    ├── digital-build-destroyed.png
    ├── jorge-maia-profile.png
    ├── company-logo-*.png
    └── icon-*.svg
```

## ��� Funcionalidades JavaScript

### ��� Analytics & Tracking
- **Google Analytics 4**: Eventos personalizados
- **Facebook Pixel**: Integração para remarketing  
- **Scroll Depth**: Monitoramento de engajamento
- **Conversion Tracking**: Acompanhamento de CTAs

### ��� Interatividade
- **Smooth Scrolling**: Navegação suave entre seções
- **Loading States**: Feedback visual em botões
- **Viewport Detection**: Animações baseadas na visibilidade
- **Debounced Events**: Performance otimizada em scroll

### ⚡ Performance
- **Lazy Loading**: Carregamento otimizado de imagens
- **Image Preloading**: Recursos críticos pré-carregados
- **Event Delegation**: Gerenciamento eficiente de eventos
- **Error Handling**: Tratamento robusto de erros

## ��� Seções da Landing Page

### 1. **Hero Section**
- Título principal com gradient text
- Subtitle com proposta de valor
- CTA principal proeminente
- Background visual com elementos de IA

### 2. **Problem Section** 
- Identificação da dor: "A Fundação Com Falhas"
- Estatística de impacto: 90% dos projetos falham
- Urgência na tomada de decisão

### 3. **Solution Section**
- Apresentação do conteúdo do workshop
- 3 pilares principais com ícones
- Segunda oportunidade de conversão

### 4. **Expert Profile**
- Credenciais do instrutor Jorge Maia
- Conquistas e experiência relevante
- Logos de empresas parceiras
- Social proof visual

### 5. **Pricing Section**
- Oferta com desconto (de R$ 297 por R$ 127)
- Opções de pagamento
- CTA principal de conversão
- Elementos visuais de urgência

### 6. **Footer**
- Informações da marca
- Copyright e direitos reservados

## ���️ Como Usar

### Instalação Local
```bash
# Clone ou baixe os arquivos
cd meu-site

# Abra em um servidor local (recomendado)
python -m http.server 8000
# ou
npx live-server

# Acesse: http://localhost:8000
```

### Customização

#### Cores e Branding
Edite as CSS Custom Properties em `styles.css`:
```css
:root {
  --color-primary-dark: #111827;
  --color-accent-blue: #38bdf8;
  --color-accent-red: #e5273c;
  /* ... outras variáveis */
}
```

#### Conteúdo
Modifique o texto diretamente no `index.html` mantendo a estrutura semântica.

#### Imagens
Substitua as imagens na pasta `assets/` mantendo os mesmos nomes ou atualize as referências no HTML/CSS.

## ��� Métricas e Analytics

### Eventos Rastreados
- **Page View**: Carregamento da página
- **Section View**: Visualização de cada seção
- **CTA Click**: Cliques nos botões de ação
- **Scroll Depth**: Profundidade de rolagem (25%, 50%, 75%, 90%, 100%)
- **Conversion Intent**: Intenção de conversão

### Configuração do Google Analytics
```html
<!-- Adicione no <head> do index.html -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

## ��� Otimizações de Performance

### Images
- **Formatos**: PNG para fotos, SVG para ícones
- **Compressão**: Otimizadas para web (< 500KB cada)
- **Lazy Loading**: Carregamento sob demanda
- **Preloading**: Recursos críticos pré-carregados

### CSS
- **Critical CSS**: Estilos inline para above-the-fold
- **Minificação**: Remover espaços e comentários em produção
- **Custom Properties**: Evita repetição de valores

### JavaScript
- **Vanilla JS**: Sem dependências externas
- **Debouncing**: Otimização de eventos de scroll
- **Error Handling**: Tratamento robusto de falhas

## ��� SEO e Meta Tags

### Meta Tags Incluídas
```html
<meta name="description" content="Workshop prático sobre LLMs e IA">
<meta name="keywords" content="LLM, IA, Workshop, Machine Learning">
<meta property="og:title" content="Workshop: Como Escolher o LLM Certo">
<meta property="og:description" content="...">
<meta property="og:image" content="./assets/jorge-maia-profile.png">
```

### Schema Markup (Recomendado)
Adicione schema.org markup para melhor indexação:
```json
{
  "@context": "https://schema.org",
  "@type": "Event",
  "name": "Workshop: Como Escolher o LLM Certo",
  "description": "...",
  "startDate": "2025-XX-XX",
  "location": "Online",
  "organizer": {
    "@type": "Person",
    "name": "Jorge Maia"
  }
}
```

## ��� Testes e Compatibilidade

### Browsers Suportados
- **Chrome**: 70+
- **Firefox**: 65+
- **Safari**: 12+
- **Edge**: 79+
- **Mobile**: iOS Safari 12+, Chrome Mobile 70+

### Testes Recomendados
- **Lighthouse**: Performance, Accessibility, SEO
- **PageSpeed Insights**: Core Web Vitals
- **WAVE**: Teste de acessibilidade
- **Mobile-Friendly Test**: Google Search Console

## ��� Deploy e Produção

### Checklist de Deploy
- [ ] Minificar CSS e JavaScript
- [ ] Otimizar imagens (WebP quando possível)
- [ ] Configurar cache headers
- [ ] Testar em diferentes dispositivos
- [ ] Validar HTML/CSS
- [ ] Configurar Analytics
- [ ] Testar formulários e CTAs
- [ ] Configurar HTTPS
- [ ] Adicionar sitemap.xml
- [ ] Configurar robots.txt

### Hosting Recomendado
- **Netlify**: Deploy automático via Git
- **Vercel**: Otimizado para performance
- **GitHub Pages**: Gratuito para projetos públicos
- **AWS S3 + CloudFront**: Máxima performance

## ���‍��� Sobre o Instrutor

**Jorge Maia** - Arquiteto de Software | Microsoft MVP
- +20 anos de experiência em arquitetura de software
- 10x Microsoft MVP consecutivo
- Membro do Digital Twin Consortium
- Especialista em projetos de IA, IoT e Digital Twins
- Mestre em Sistemas Mecatrônicos

## ��� Licença

Este projeto foi desenvolvido para fins educacionais e promocionais. Todos os direitos reservados a CrazyTechLabs - Labinar IA 2025.

---

**Desenvolvido com ♥️ por IA Assistant**  
*Landing page otimizada para conversão e performance*
