// AI LLM Workshop v2.0 - Modern JavaScript with Performance Optimization
// Vanilla JS with ES6+ features and accessibility enhancements

(function() {
    'use strict';
    
    // Configuration
    const CONFIG = {
        // Animation settings
        scrollThreshold: 0.1,
        animationDuration: 600,
        staggerDelay: 100,
        
        // Performance settings
        throttleDelay: 16,
        debounceDelay: 250,
        
        // Intersection observer settings
        rootMargin: '0px 0px -50px 0px',
        threshold: [0, 0.25, 0.5, 0.75, 1]
    };
    
    // Utility functions
    const utils = {
        // Throttle function for performance
        throttle(func, delay) {
            let timeoutId;
            let lastExecTime = 0;
            
            return function(...args) {
                const currentTime = Date.now();
                
                if (currentTime - lastExecTime > delay) {
                    func.apply(this, args);
                    lastExecTime = currentTime;
                } else {
                    clearTimeout(timeoutId);
                    timeoutId = setTimeout(() => {
                        func.apply(this, args);
                        lastExecTime = Date.now();
                    }, delay - (currentTime - lastExecTime));
                }
            };
        },
        
        // Debounce function
        debounce(func, delay) {
            let timeoutId;
            return function(...args) {
                clearTimeout(timeoutId);
                timeoutId = setTimeout(() => func.apply(this, args), delay);
            };
        },
        
        // Selector helpers
        $(selector) {
            return document.querySelector(selector);
        },
        
        $$(selector) {
            return document.querySelectorAll(selector);
        },
        
        // Element visibility checker
        isElementVisible(element) {
            const rect = element.getBoundingClientRect();
            return rect.top < window.innerHeight && rect.bottom > 0;
        },
        
        // Smooth scroll to element
        scrollToElement(element, offset = 0) {
            const targetPosition = element.offsetTop - offset;
            
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        },
        
        // Random number generator
        random(min, max) {
            return Math.random() * (max - min) + min;
        }
    };
    
    // Performance monitor
    class PerformanceMonitor {
        constructor() {
            this.metrics = {};
            this.init();
        }
        
        init() {
            if (typeof performance !== 'undefined') {
                this.measurePageLoad();
                this.measureWebVitals();
            }
        }
        
        measurePageLoad() {
            window.addEventListener('load', () => {
                const loadTime = performance.now();
                this.metrics.pageLoad = loadTime;
                
                if (loadTime > 3000) {
                    console.warn(`⚠️ Slow page load: ${loadTime.toFixed(2)}ms`);
                } else {
                    console.log(`🚀 Page loaded in: ${loadTime.toFixed(2)}ms`);
                }
            });
        }
        
        measureWebVitals() {
            // Measure Largest Contentful Paint
            if ('PerformanceObserver' in window) {
                try {
                    const observer = new PerformanceObserver((list) => {
                        const entries = list.getEntries();
                        const lastEntry = entries[entries.length - 1];
                        this.metrics.lcp = lastEntry.startTime;
                    });
                    observer.observe({ entryTypes: ['largest-contentful-paint'] });
                } catch (e) {
                    console.warn('LCP measurement not supported');
                }
            }
        }
        
        logMetrics() {
            console.table(this.metrics);
        }
    }
    
    // Scroll animations with Intersection Observer
    class ScrollAnimations {
        constructor() {
            this.observer = null;
            this.animatedElements = new Set();
            this.init();
        }
        
        init() {
            if (!('IntersectionObserver' in window)) {
                console.warn('IntersectionObserver not supported, skipping scroll animations');
                return;
            }
            
            this.setupObserver();
            this.observeElements();
        }
        
        setupObserver() {
            this.observer = new IntersectionObserver(
                this.handleIntersection.bind(this),
                {
                    rootMargin: CONFIG.rootMargin,
                    threshold: CONFIG.threshold
                }
            );
        }
        
        observeElements() {
            const elements = utils.$$('.module-card, .credential-item, .timeline-step, .instructor-profile');
            
            elements.forEach((element, index) => {
                // Add initial styles for animation
                element.style.opacity = '0';
                element.style.transform = 'translateY(30px)';
                element.style.transition = `opacity ${CONFIG.animationDuration}ms ease, transform ${CONFIG.animationDuration}ms ease`;
                element.style.transitionDelay = `${index * CONFIG.staggerDelay}ms`;
                
                this.observer.observe(element);
            });
        }
        
        handleIntersection(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting && !this.animatedElements.has(entry.target)) {
                    this.animateElement(entry.target);
                    this.animatedElements.add(entry.target);
                }
            });
        }
        
        animateElement(element) {
            element.style.opacity = '1';
            element.style.transform = 'translateY(0)';
            
            // Add a subtle scale animation for emphasis
            setTimeout(() => {
                element.style.transform = 'translateY(0) scale(1.02)';
                setTimeout(() => {
                    element.style.transform = 'translateY(0) scale(1)';
                }, 200);
            }, CONFIG.animationDuration / 2);
        }
        
        destroy() {
            if (this.observer) {
                this.observer.disconnect();
            }
        }
    }
    
    // Interactive elements enhancement
    class InteractiveElements {
        constructor() {
            this.init();
        }
        
        init() {
            this.enhanceCTAButtons();
            this.addHoverEffects();
            this.setupKeyboardNavigation();
            this.addClickAnalytics();
        }
        
        enhanceCTAButtons() {
            const ctaButtons = utils.$$('.cta-button');
            
            ctaButtons.forEach(button => {
                // Add ripple effect
                button.addEventListener('click', this.createRippleEffect.bind(this));
                
                // Add loading state simulation
                button.addEventListener('click', (e) => {
                    if (button.dataset.loading === 'true') return;
                    
                    const originalText = button.innerHTML;
                    button.dataset.loading = 'true';
                    button.innerHTML = '<span>Redirecionando...</span>';
                    button.style.opacity = '0.7';
                    
                    // Reset after a short delay (in case redirect fails)
                    setTimeout(() => {
                        button.innerHTML = originalText;
                        button.style.opacity = '1';
                        button.dataset.loading = 'false';
                    }, 3000);
                });
            });
        }
        
        createRippleEffect(event) {
            const button = event.currentTarget;
            const rect = button.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = event.clientX - rect.left - size / 2;
            const y = event.clientY - rect.top - size / 2;
            
            const ripple = document.createElement('span');
            ripple.style.cssText = `
                position: absolute;
                width: ${size}px;
                height: ${size}px;
                left: ${x}px;
                top: ${y}px;
                background: rgba(255, 255, 255, 0.3);
                border-radius: 50%;
                transform: scale(0);
                animation: ripple 0.6s ease-out;
                pointer-events: none;
            `;
            
            // Add keyframe if not exists
            if (!document.querySelector('#ripple-animation')) {
                const style = document.createElement('style');
                style.id = 'ripple-animation';
                style.textContent = `
                    @keyframes ripple {
                        to {
                            transform: scale(2);
                            opacity: 0;
                        }
                    }
                `;
                document.head.appendChild(style);
            }
            
            button.style.position = 'relative';
            button.style.overflow = 'hidden';
            button.appendChild(ripple);
            
            setTimeout(() => ripple.remove(), 600);
        }
        
        addHoverEffects() {
            const cards = utils.$$('.module-card, .credential-item');
            
            cards.forEach(card => {
                card.addEventListener('mouseenter', () => {
                    card.style.filter = 'saturate(1.1) brightness(1.05)';
                });
                
                card.addEventListener('mouseleave', () => {
                    card.style.filter = '';
                });
            });
        }
        
        setupKeyboardNavigation() {
            // Enhanced focus management
            const focusableElements = utils.$$('a, button, [tabindex]:not([tabindex="-1"])');
            
            focusableElements.forEach(element => {
                element.addEventListener('keydown', (e) => {
                    if (e.key === 'Enter' || e.key === ' ') {
                        if (element.href) {
                            window.open(element.href, '_blank', 'noopener');
                            e.preventDefault();
                        }
                    }
                });
            });
        }
        
        addClickAnalytics() {
            const ctaButtons = utils.$$('.cta-button');
            
            ctaButtons.forEach((button, index) => {
                button.addEventListener('click', () => {
                    // Simple analytics logging
                    console.log(`CTA Click: Button ${index + 1}`, {
                        timestamp: new Date().toISOString(),
                        buttonText: button.textContent.trim(),
                        section: this.getSectionName(button)
                    });
                    
                    // Send to analytics service (placeholder)
                    this.sendAnalyticsEvent('cta_click', {
                        button_position: index + 1,
                        button_text: button.textContent.trim(),
                        section: this.getSectionName(button)
                    });
                });
            });
        }
        
        getSectionName(element) {
            const section = element.closest('section, header');
            return section ? section.className.split(' ')[0] : 'unknown';
        }
        
        sendAnalyticsEvent(eventName, data) {
            // Placeholder for analytics integration
            // Could integrate with Google Analytics, Mixpanel, etc.
            if (typeof gtag !== 'undefined') {
                gtag('event', eventName, data);
            }
        }
    }
    
    // Dynamic background animations
    class BackgroundAnimations {
        constructor() {
            this.animationFrame = null;
            this.init();
        }
        
        init() {
            this.setupFloatingElements();
            this.setupGradientAnimation();
        }
        
        setupFloatingElements() {
            const logos = utils.$$('.ai-logo');
            
            logos.forEach((logo, index) => {
                // Add subtle floating animation with different timing
                const delay = index * 500;
                const duration = 3000 + utils.random(-500, 500);
                
                logo.style.animationDelay = `${delay}ms`;
                logo.style.animationDuration = `${duration}ms`;
                
                // Add mouse interaction
                logo.addEventListener('mouseenter', () => {
                    logo.style.animationPlayState = 'paused';
                    logo.style.transform = 'scale(1.2) rotate(10deg)';
                });
                
                logo.addEventListener('mouseleave', () => {
                    logo.style.animationPlayState = 'running';
                    logo.style.transform = '';
                });
            });
        }
        
        setupGradientAnimation() {
            const heroSection = utils.$('.hero-section');
            if (!heroSection) return;
            
            let hue = 0;
            
            const animateGradient = () => {
                hue = (hue + 0.5) % 360;
                
                const bg1 = heroSection.querySelector('.hero-bg-1');
                const bg2 = heroSection.querySelector('.hero-bg-2');
                
                if (bg1) {
                    bg1.style.filter = `hue-rotate(${hue}deg)`;
                }
                if (bg2) {
                    bg2.style.filter = `hue-rotate(${-hue}deg)`;
                }
                
                this.animationFrame = requestAnimationFrame(animateGradient);
            };
            
            // Start animation only if user hasn't set reduced motion preference
            if (!window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
                animateGradient();
            }
        }
        
        destroy() {
            if (this.animationFrame) {
                cancelAnimationFrame(this.animationFrame);
            }
        }
    }
    
    // Smooth scrolling for anchor links
    class SmoothScrolling {
        constructor() {
            this.init();
        }
        
        init() {
            // Handle anchor links (if any are added later)
            document.addEventListener('click', (e) => {
                const link = e.target.closest('a[href^="#"]');
                if (link) {
                    e.preventDefault();
                    const targetId = link.getAttribute('href').substring(1);
                    const targetElement = utils.$(`#${targetId}`);
                    
                    if (targetElement) {
                        utils.scrollToElement(targetElement, 80);
                    }
                }
            });
        }
    }
    
    // Accessibility enhancements
    class AccessibilityEnhancements {
        constructor() {
            this.init();
        }
        
        init() {
            this.addSkipLinks();
            this.enhanceKeyboardNavigation();
            this.addAriaLabels();
            this.setupFocusManagement();
        }
        
        addSkipLinks() {
            const skipLink = document.createElement('a');
            skipLink.href = '#main-content';
            skipLink.textContent = 'Pular para o conteúdo principal';
            skipLink.className = 'skip-link';
            skipLink.style.cssText = `
                position: absolute;
                top: -40px;
                left: 6px;
                background: #000;
                color: #fff;
                padding: 8px;
                text-decoration: none;
                border-radius: 4px;
                z-index: 1000;
                transition: top 0.3s;
            `;
            
            skipLink.addEventListener('focus', () => {
                skipLink.style.top = '6px';
            });
            
            skipLink.addEventListener('blur', () => {
                skipLink.style.top = '-40px';
            });
            
            document.body.insertBefore(skipLink, document.body.firstChild);
        }
        
        enhanceKeyboardNavigation() {
            // Add visible focus indicators
            const style = document.createElement('style');
            style.textContent = `
                .enhanced-focus:focus-visible {
                    outline: 3px solid #00ff79;
                    outline-offset: 4px;
                    border-radius: 4px;
                }
            `;
            document.head.appendChild(style);
            
            // Add enhanced focus class to interactive elements
            const interactiveElements = utils.$$('a, button, [tabindex]:not([tabindex="-1"])');
            interactiveElements.forEach(element => {
                element.classList.add('enhanced-focus');
            });
        }
        
        addAriaLabels() {
            // Add aria-labels to images without alt text
            const images = utils.$$('img:not([alt])');
            images.forEach(img => {
                img.setAttribute('alt', '');
                img.setAttribute('aria-hidden', 'true');
            });
            
            // Add labels to CTA buttons
            const ctaButtons = utils.$$('.cta-button');
            ctaButtons.forEach((button, index) => {
                button.setAttribute('aria-label', `Inscrever-se no Workshop IA - Botão ${index + 1}`);
            });
        }
        
        setupFocusManagement() {
            // Trap focus in modals (if any are added later)
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Tab') {
                    const focusableElements = utils.$$('[tabindex]:not([tabindex="-1"]), a, button, input, select, textarea');
                    const firstFocusable = focusableElements[0];
                    const lastFocusable = focusableElements[focusableElements.length - 1];
                    
                    if (e.shiftKey && document.activeElement === firstFocusable) {
                        e.preventDefault();
                        lastFocusable.focus();
                    } else if (!e.shiftKey && document.activeElement === lastFocusable) {
                        e.preventDefault();
                        firstFocusable.focus();
                    }
                }
            });
        }
    }
    
    // Error handling
    class ErrorHandler {
        constructor() {
            this.init();
        }
        
        init() {
            window.addEventListener('error', this.handleError.bind(this));
            window.addEventListener('unhandledrejection', this.handleRejection.bind(this));
        }
        
        handleError(event) {
            console.error('JavaScript Error:', {
                message: event.message,
                filename: event.filename,
                lineno: event.lineno,
                colno: event.colno,
                error: event.error
            });
            
            // Send to error tracking service (placeholder)
            this.reportError('javascript_error', {
                message: event.message,
                stack: event.error?.stack
            });
        }
        
        handleRejection(event) {
            console.error('Unhandled Promise Rejection:', event.reason);
            
            this.reportError('promise_rejection', {
                reason: event.reason
            });
        }
        
        reportError(type, data) {
            // Placeholder for error reporting service
            // Could integrate with Sentry, LogRocket, etc.
            if (typeof window.errorTracker !== 'undefined') {
                window.errorTracker.report(type, data);
            }
        }
    }
    
    // Main application initialization
    class WorkshopApp {
        constructor() {
            this.components = [];
            this.init();
        }
        
        init() {
            // Wait for DOM to be ready
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', this.bootstrap.bind(this));
            } else {
                this.bootstrap();
            }
        }
        
        bootstrap() {
            console.log('🚀 Workshop IA v2.0 - Initializing...');
            
            try {
                // Initialize all components
                this.components.push(new PerformanceMonitor());
                this.components.push(new ScrollAnimations());
                this.components.push(new InteractiveElements());
                this.components.push(new BackgroundAnimations());
                this.components.push(new SmoothScrolling());
                this.components.push(new AccessibilityEnhancements());
                this.components.push(new ErrorHandler());
                
                // Mark main content for accessibility
                const heroSection = utils.$('.hero-section');
                if (heroSection) {
                    heroSection.id = 'main-content';
                    heroSection.setAttribute('role', 'main');
                }
                
                console.log('✅ Workshop IA v2.0 - Initialization complete!');
                
                // Performance logging
                if (typeof performance !== 'undefined') {
                    setTimeout(() => {
                        console.log(`📊 Total initialization time: ${performance.now().toFixed(2)}ms`);
                    }, 1000);
                }
                
            } catch (error) {
                console.error('❌ Initialization failed:', error);
            }
        }
        
        destroy() {
            // Cleanup all components
            this.components.forEach(component => {
                if (typeof component.destroy === 'function') {
                    component.destroy();
                }
            });
            
            console.log('🧹 Workshop IA v2.0 - Cleaned up');
        }
    }
    
    // Initialize the application
    const app = new WorkshopApp();
    
    // Expose app instance for debugging
    window.WorkshopApp = app;
    
    // Cleanup on page unload
    window.addEventListener('beforeunload', () => {
        app.destroy();
    });
    
})();