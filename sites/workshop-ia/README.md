# Landing Page – Workshop IA

Landing page estática criada a partir do frame selecionado no Figma para divulgar o workshop "Como Escolher o Modelo Certo de IA". O projeto usa HTML5 sem dependências externas além das fontes do Google Fonts e aplica estilos com CSS custom properties.

## Estrutura

- `index.html` – marcação semântica acessível com foco em SEO.
- `styles.css` – tokens de design, layout responsivo mobile-first e efeitos visuais.
- `script.js` – interações leves (animação de entrada dos cards e tracking do CTA).
- `assets/` – imagens exportadas do Figma (logos, ilustrações, ícones) referenciadas por caminhos relativos.

## Como executar

1. Abra o diretório `sites/workshop-ia` em um servidor local simples, por exemplo:
   ```bash
   cd /c/Users/TIAGO~1.FER/Desktop/Estudo/MCP-figma/sites/workshop-ia
   python -m http.server 8080
   ```
2. Acesse `http://localhost:8080` no navegador.

## Recursos de acessibilidade

- Uso de `aria-label` em navegação decorativa e painéis informativos.
- Botões e links com foco visível e área de clique ampliada.
- Imagens com textos alternativos descritivos e `loading="lazy"` onde apropriado.
- Layout mobile-first com contraste elevado e hierarquia tipográfica clara.

## Personalização

- As cores principais estão declaradas em `:root` dentro de `styles.css`.
- Os módulos do workshop utilizam a variável `--card-image` para trocar as imagens de fundo facilmente.
- O script adiciona eventos no `window.dataLayer`; adapte o rótulo em `script.js` para integrar com sua ferramenta de analytics.
