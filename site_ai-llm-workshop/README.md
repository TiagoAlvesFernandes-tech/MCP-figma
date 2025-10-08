# AI LLM Workshop Landing Page

Generated from Figma design via MCP on October 8, 2025

## 📋 Overview

This is a semantic, accessible landing page for an AI/LLM Workshop event featuring Jorge Maia (Microsoft MVP). The page is designed to convert visitors into workshop attendees by highlighting the common pitfalls of AI implementation and offering practical solutions.

## 🎯 Key Sections

1. **Hero Section** - Event date, main value proposition, and primary CTA
2. **Journey Section** - The 3-step cycle (Implement → Works → Celebrate)
3. **Problem Section** - The nightmare scenario (costs, hallucinations, pressure)
4. **Cycle Repeats** - The 4 stages of denial (Surprise, Denial, Pressure, Ultimatum)
5. **Learning Section** - 7 key topics covered in the workshop
6. **Instructor Section** - Jorge Maia's credentials and experience

## 🎨 Design Tokens

All design values are mapped to CSS custom properties in `styles.css`:

### Colors
- `--color-primary`: #08331c (Dark green)
- `--color-secondary`: #09311c (Dark green variant)
- `--color-accent`: #ae0808 (Red)
- `--color-danger`: #980f0f (Dark red)
- `--color-white`: #ffffff

### Typography
- Font Family: Montserrat (weights: 300, 400, 600, 700)
- Font sizes: 22px - 64px (xs to 4xl)
- Line heights: 1.2 - 65px

### Spacing
- System: 8px base (xs) to 96px (3xl)

### Border Radius
- System: 50px (sm) to 129.5px (full)

## 📁 File Structure

```
site_ai-llm-workshop/
├── index.html       # Semantic HTML5 structure
├── styles.css       # CSS with custom properties
├── script.js        # Interactive enhancements
└── README.md        # This file
```

## 🚀 Features

### Accessibility
- Semantic HTML5 elements
- ARIA attributes where needed
- Keyboard navigation support
- Focus management
- Alt text for images (TODO: Add descriptive alt text)

### Performance
- Vanilla CSS (no framework dependencies)
- Vanilla JavaScript (no library dependencies)
- External images served from localhost:3845
- Optimized image loading
- Performance monitoring included

### Interactivity
- Smooth scroll animations
- Intersection Observer for fade-in effects
- Parallax scrolling (subtle)
- Hover states on interactive elements
- Click tracking (placeholder for analytics)

## 🔧 Setup & Usage

### Local Development

1. Ensure the Figma MCP server is running (for image assets):
   ```bash
   # Images are served from: http://localhost:3845/assets/
   ```

2. Open `index.html` in a browser:
   ```bash
   # Using Python
   python -m http.server 8000
   
   # Using Node.js
   npx serve
   
   # Or simply open the file
   open index.html
   ```

### Deployment

#### Option 1: GitHub Pages

1. Commit files to repository
2. Push to main branch
3. Enable GitHub Pages in repo settings
4. Note: You'll need to download and host images separately

#### Option 2: Vercel

1. Connect GitHub repository
2. Deploy automatically on push
3. Preview URLs for each branch/PR

#### Option 3: Netlify

1. Connect GitHub repository  
2. Configure build settings (none needed for static site)
3. Deploy with drag-and-drop or Git integration

## 📝 TODO Items

### High Priority
- [ ] Download and self-host image assets (currently on localhost:3845)
- [ ] Add instructor profile image
- [ ] Add descriptive alt text for all images
- [ ] Test responsiveness on real devices
- [ ] Add analytics tracking (Google Analytics, Meta Pixel)

### Medium Priority
- [ ] Optimize images (WebP format, compression)
- [ ] Add Open Graph meta tags for social sharing
- [ ] Add structured data (JSON-LD) for SEO
- [ ] Create favicon and app icons
- [ ] Add loading spinner/skeleton

### Low Priority
- [ ] Add more animation polish
- [ ] Create dark mode variant (if needed)
- [ ] Add language switcher (PT/EN)
- [ ] Create mobile-specific interactions
- [ ] Add email capture form

## 🎨 Figma Variable Mapping

Currently, no Figma variables were detected in the design file. When variables are added to Figma:

1. Colors → Map to CSS custom properties
2. Typography → Map to font-size/line-height variables
3. Spacing → Map to spacing scale
4. Border radius → Map to radius scale

## 🔗 External Links

All CTA buttons currently link to: `https://www.crazytechlabs.com.br`

Update these in `index.html` when the actual registration page is ready.

## 📊 Asset List

Images used in this landing page (currently served from localhost):

1. `fundo high3 1` - Background gradient
2. `iii 1` - Hero decoration
3. `meta`, `gpt`, `gemini` - AI provider logos
4. `ChatGPT Image` - Illustration
5. `seta 1`, `seta2 1` - Arrow graphics
6. `imagem (15) 1` - Chart/graph image
7. `fundo lp 5-20` - Background decorations

**Action Required**: Download these assets and host them in a `/assets` folder before deployment.

## 📱 Responsive Breakpoints

- Desktop: 1920px (base)
- Laptop: 1600px
- Tablet: 1200px
- Mobile: 768px

## 🤝 Credits

- **Design**: Figma design file
- **Development**: Generated via Figma MCP + AI
- **Fonts**: Google Fonts (Montserrat)
- **Generated**: October 8, 2025

## 📞 Support

For questions about this implementation, refer to the main project README or contact the development team.

---

**Version**: 1.0.0  
**Last Updated**: October 8, 2025  
**Status**: Ready for review and testing