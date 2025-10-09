# Area Landing Page

A responsive, accessible landing page for Area analytics platform built with semantic HTML5, CSS custom properties, and vanilla JavaScript.

## 🚀 Features

- **Semantic HTML5**: Proper heading hierarchy and semantic elements for accessibility
- **CSS Custom Properties**: Design tokens mapped from Figma for consistent theming
- **Vanilla JavaScript**: Smooth scrolling, animations, and interactive behaviors
- **Mobile-First Responsive**: Optimized for all screen sizes
- **Accessibility**: WCAG compliant with keyboard navigation and screen reader support
- **Performance Optimized**: Throttled scroll events, intersection observers, and smooth animations

## 🎨 Design System

The page implements Area's design system with the following tokens:

### Colors
- **Primary Accent**: `#485C11` (Area green)
- **Text Colors**: Black (`#000000`), Dark Grey (`#6F6F6F`), Captions (`#485C11`)
- **Background**: White (`#FFFFFF`)
- **Accent Colors**: Mid Green (`#8E9C78`), Light Green (`#DFECC6`)

### Typography
- **Display**: Crimson Text, 160px (Hero title)
- **Headings**: Crimson Text (60px, 40px, 18px)
- **Body**: DM Sans, 15px
- **Captions**: Roboto Mono, 12px
- **Links**: DM Sans Bold, 14px

### Spacing
- Consistent spacing scale from 8px to 240px
- Max content width: 1500px
- Border radius: 30px (images), 20px (tables), 1000px (buttons)

## 📁 Project Structure

```
├── index.html          # Main HTML file with semantic structure
├── styles.css          # CSS with custom properties and responsive design
├── script.js           # Vanilla JavaScript for interactions
└── README.md           # This file
```

## 🔧 Key Components

### Navigation
- Floating navigation pills with smooth scrolling
- Sticky behavior with scroll direction detection
- Active state indicators

### Hero Section
- Large typography treatment
- Interactive device mockup with chart visualization
- Responsive image containers

### Benefits Grid
- 4-column flexible grid layout
- Icon + text content cards
- Scroll-triggered animations

### Features Carousel
- Two-column layout with text and imagery
- Numbered feature list
- Parallax image effects

### Comparison Table
- Responsive 3-column comparison
- Check/cross icons for feature availability
- Horizontal scroll with shadow indicators

### Testimonial
- Two-column layout with image and quote
- Typography emphasis for testimonial text

### How-to Steps
- 3-column step process
- Large number indicators
- Progressive disclosure

## 🌐 Asset Management

All images are served from the MCP Figma server at `localhost:3845`:

- **Hero Chart**: Data visualization in iPad mockup
- **Logo Cloud**: 6 partner logos with proper opacity and blend modes
- **Product Images**: Mountain landscapes and 3D renders
- **Icons**: SVG icons for benefits, table indicators, and UI elements

## ♿ Accessibility Features

- **Semantic HTML**: Proper heading hierarchy, landmarks, and ARIA labels
- **Keyboard Navigation**: Full keyboard support with visible focus indicators
- **Screen Reader Support**: ARIA live regions and descriptive alt text
- **Reduced Motion**: Respects `prefers-reduced-motion` setting
- **Skip Links**: Skip to main content functionality
- **High Contrast**: Enhanced contrast mode support

## 📱 Responsive Breakpoints

- **Desktop**: 1200px+ (Full 3-column layouts)
- **Tablet**: 768px-1199px (Adapted layouts, single column features)
- **Mobile**: 480px-767px (Stacked layouts, hidden nav pills)
- **Small Mobile**: <480px (Compressed typography and spacing)

## ⚡ Performance Features

- **Intersection Observer**: Efficient scroll-triggered animations
- **Throttled Events**: Scroll and resize event optimization  
- **CSS Custom Properties**: Consistent theming without runtime calculations
- **Modern CSS**: Flexbox and Grid for efficient layouts
- **Image Optimization**: Proper aspect ratios and object-fit

## 🔧 JavaScript Features

### Core Functionality
- `AreaLandingPage` class with modular architecture
- Smooth scrolling navigation with offset calculations
- Dynamic navigation pill show/hide based on scroll direction
- Section-aware navigation with active states

### Animations
- Scroll-triggered entrance animations for cards
- Parallax effects on hero images
- Button ripple effects on interaction
- Fade-in animations for images

### Mobile Enhancements
- Touch interaction feedback
- Responsive navigation behavior
- Mobile-optimized scroll performance

## 🚀 Getting Started

1. **Open the page**: Open `index.html` in a modern web browser
2. **Local Development**: Serve from a local server for best performance
3. **Asset Server**: Ensure MCP Figma server is running on `localhost:3845`

## 🔄 Integration with Workflow

This landing page is designed to work with the Area site generation workflow:

1. **Generated Location**: Files are created in workspace root
2. **Auto-Movement**: `generate-site.sh` moves files to `site_area-landing/`
3. **Image Download**: Run `./download-images.sh site_area-landing` to download assets locally
4. **Production Ready**: Update image URLs to production CDN when deploying

## 📈 TODO: Design Token Connections

The CSS custom properties are structured to easily connect with Figma design tokens:

```css
/* TODO: Map to Figma variables */
--color-accent-primary: #485C11; /* Figma: Accent/Accent 1 */
--text-display: 160px; /* Figma: Display font size */
--spacing-lg: 40px; /* Figma: Large spacing token */
```

When Figma design tokens are exported, these CSS custom properties can be automatically updated to maintain design consistency.

## 🔧 Browser Support

- **Modern Browsers**: Chrome 88+, Firefox 85+, Safari 14+, Edge 88+
- **CSS Features**: Custom Properties, Flexbox, Grid, Intersection Observer
- **JavaScript**: ES6+ features with graceful fallbacks
- **Progressive Enhancement**: Core functionality works without JavaScript

---

Built with ❤️ using Area's design system and best practices for web accessibility and performance.