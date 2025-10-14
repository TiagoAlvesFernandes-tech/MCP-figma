// Area Landing Page JavaScript - Vanilla ES6+
// TODO: Add smooth scrolling animations and interactions

class AreaLandingPage {
    constructor() {
        this.init();
    }

    init() {
        this.setupSmoothScrolling();
        this.setupNavigationPills();
        this.setupScrollAnimations();
        this.setupMobileNavigation();
        this.setupAccessibility();
        
        // Initialize when DOM is loaded
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.onDOMReady());
        } else {
            this.onDOMReady();
        }
    }

    onDOMReady() {
        console.log('Area Landing Page initialized');
        this.observeScrollPosition();
        this.setupIntersectionObserver();
    }

    // Smooth scrolling for navigation links
    setupSmoothScrolling() {
        const scrollToTarget = (targetId) => {
            const target = document.getElementById(targetId);
            if (target) {
                const headerOffset = 100; // Account for floating nav
                const elementPosition = target.getBoundingClientRect().top;
                const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                window.scrollTo({
                    top: offsetPosition,
                    behavior: 'smooth'
                });
            }
        };

        // Navigation pills smooth scrolling
        document.querySelectorAll('.nav-pill').forEach(pill => {
            pill.addEventListener('click', (e) => {
                e.preventDefault();
                const target = pill.getAttribute('data-target');
                scrollToTarget(target);
            });
        });

        // Footer navigation smooth scrolling
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const target = link.getAttribute('data-target');
                scrollToTarget(target);
            });
        });
    }

    // Navigation pills show/hide and active states
    setupNavigationPills() {
        const navPills = document.getElementById('navPills');
        let lastScrollY = window.scrollY;

        const updateNavPills = () => {
            const currentScrollY = window.scrollY;
            
            // Show/hide based on scroll direction
            if (currentScrollY > lastScrollY && currentScrollY > 100) {
                navPills.style.transform = 'translateX(-50%) translateY(-100%)';
                navPills.style.opacity = '0';
            } else {
                navPills.style.transform = 'translateX(-50%) translateY(0)';
                navPills.style.opacity = '1';
            }
            
            lastScrollY = currentScrollY;
        };

        window.addEventListener('scroll', this.throttle(updateNavPills, 16));
    }

    // Scroll-triggered animations
    setupScrollAnimations() {
        // Add entrance animations for benefit cards
        const benefitCards = document.querySelectorAll('.benefit-card');
        benefitCards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';
            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            card.style.transitionDelay = `${index * 0.1}s`;
        });

        // Add entrance animations for step cards
        const stepCards = document.querySelectorAll('.step-card');
        stepCards.forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';
            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            card.style.transitionDelay = `${index * 0.2}s`;
        });

        // Add fade-in animation for images
        const heroImages = document.querySelectorAll('.hero-image img, .features-image img, .final-hero-image img');
        heroImages.forEach(img => {
            img.style.opacity = '0';
            img.style.transition = 'opacity 0.8s ease';
        });
    }

    // Intersection Observer for scroll animations
    setupIntersectionObserver() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    if (entry.target.classList.contains('benefit-card') || 
                        entry.target.classList.contains('step-card')) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                    
                    // Animate images
                    const img = entry.target.querySelector('img');
                    if (img && (entry.target.classList.contains('hero-image') || 
                              entry.target.classList.contains('features-image') ||
                              entry.target.classList.contains('final-hero-image'))) {
                        img.style.opacity = '1';
                    }

                    // Add parallax effect to hero images
                    if (entry.target.classList.contains('hero-image-container')) {
                        this.setupParallax(entry.target);
                    }
                }
            });
        }, observerOptions);

        // Observe elements for animation
        document.querySelectorAll('.benefit-card, .step-card, .hero-image, .features-image, .final-hero-image, .hero-image-container').forEach(el => {
            observer.observe(el);
        });
    }

    // Parallax effect for hero images
    setupParallax(element) {
        const updateParallax = () => {
            const rect = element.getBoundingClientRect();
            const speed = 0.5;
            const yPos = -(rect.top * speed);
            
            const heroDevice = element.querySelector('.hero-device');
            if (heroDevice) {
                heroDevice.style.transform = `translate(-50%, calc(-50% + ${yPos}px))`;
            }
        };

        window.addEventListener('scroll', this.throttle(updateParallax, 16));
    }

    // Mobile navigation enhancements
    setupMobileNavigation() {
        const isMobile = () => window.innerWidth <= 768;
        
        // Hide navigation pills on mobile
        const updateMobileNav = () => {
            const navPills = document.getElementById('navPills');
            if (isMobile()) {
                navPills.style.display = 'none';
            } else {
                navPills.style.display = 'flex';
            }
        };

        updateMobileNav();
        window.addEventListener('resize', this.throttle(updateMobileNav, 100));

        // Mobile-specific touch interactions
        if ('ontouchstart' in window) {
            this.setupTouchInteractions();
        }
    }

    // Touch interactions for mobile
    setupTouchInteractions() {
        // Add touch feedback for buttons
        const buttons = document.querySelectorAll('button, a, .benefit-card, .step-card');
        
        buttons.forEach(button => {
            button.addEventListener('touchstart', () => {
                button.style.transform = 'scale(0.98)';
            });
            
            button.addEventListener('touchend', () => {
                button.style.transform = '';
            });
        });
    }

    // Observe scroll position for active navigation states
    observeScrollPosition() {
        const sections = document.querySelectorAll('#benefits, #specifications, #how-to, #contact');
        const navPills = document.querySelectorAll('.nav-pill');
        
        const observerOptions = {
            threshold: 0.3,
            rootMargin: '-100px 0px -60% 0px'
        };

        const sectionObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const sectionId = entry.target.id;
                    
                    // Update active navigation pill
                    navPills.forEach(pill => {
                        if (pill.getAttribute('data-target') === sectionId) {
                            pill.classList.add('active');
                        } else {
                            pill.classList.remove('active');
                        }
                    });
                }
            });
        }, observerOptions);

        sections.forEach(section => {
            sectionObserver.observe(section);
        });
    }

    // Accessibility enhancements
    setupAccessibility() {
        // Keyboard navigation for custom elements
        document.querySelectorAll('.nav-pill, .nav-link').forEach(element => {
            element.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    element.click();
                }
            });
        });

        // Skip to main content link
        this.addSkipLink();

        // Announce dynamic content changes to screen readers
        this.setupAriaLiveRegions();

        // Respect reduced motion preferences
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
            this.disableAnimations();
        }
    }

    // Add skip to main content link for accessibility
    addSkipLink() {
        const skipLink = document.createElement('a');
        skipLink.href = '#main';
        skipLink.textContent = 'Skip to main content';
        skipLink.className = 'skip-link';
        skipLink.style.cssText = `
            position: absolute;
            top: -40px;
            left: 6px;
            background: var(--color-accent-primary);
            color: var(--color-text-on-accent);
            padding: 8px;
            text-decoration: none;
            border-radius: 4px;
            z-index: 1001;
            transition: top 0.3s;
        `;
        
        skipLink.addEventListener('focus', () => {
            skipLink.style.top = '6px';
        });
        
        skipLink.addEventListener('blur', () => {
            skipLink.style.top = '-40px';
        });

        document.body.insertBefore(skipLink, document.body.firstChild);

        // Add id to main element
        const main = document.querySelector('main');
        if (main && !main.id) {
            main.id = 'main';
            main.tabIndex = -1; // Make it focusable
        }
    }

    // Setup ARIA live regions for dynamic content
    setupAriaLiveRegions() {
        const liveRegion = document.createElement('div');
        liveRegion.setAttribute('aria-live', 'polite');
        liveRegion.setAttribute('aria-label', 'Status updates');
        liveRegion.style.cssText = `
            position: absolute;
            left: -10000px;
            width: 1px;
            height: 1px;
            overflow: hidden;
        `;
        document.body.appendChild(liveRegion);

        // Store reference for future announcements
        this.liveRegion = liveRegion;
    }

    // Announce content to screen readers
    announce(message) {
        if (this.liveRegion) {
            this.liveRegion.textContent = message;
            setTimeout(() => {
                this.liveRegion.textContent = '';
            }, 1000);
        }
    }

    // Disable animations for users who prefer reduced motion
    disableAnimations() {
        const style = document.createElement('style');
        style.textContent = `
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
                scroll-behavior: auto !important;
            }
        `;
        document.head.appendChild(style);
    }

    // Utility: Throttle function for performance
    throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    }

    // Utility: Debounce function for performance
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    // Enhanced button interactions
    setupButtonInteractions() {
        const buttons = document.querySelectorAll('.nav-cta, .primary-button, .secondary-button');
        
        buttons.forEach(button => {
            // Add ripple effect
            button.addEventListener('click', (e) => {
                const ripple = document.createElement('span');
                const rect = button.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.cssText = `
                    position: absolute;
                    width: ${size}px;
                    height: ${size}px;
                    left: ${x}px;
                    top: ${y}px;
                    background: rgba(255, 255, 255, 0.3);
                    border-radius: 50%;
                    transform: scale(0);
                    animation: ripple 0.6s linear;
                    pointer-events: none;
                `;
                
                button.style.position = 'relative';
                button.style.overflow = 'hidden';
                button.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });

        // Add ripple animation keyframes
        if (!document.getElementById('ripple-styles')) {
            const style = document.createElement('style');
            style.id = 'ripple-styles';
            style.textContent = `
                @keyframes ripple {
                    to {
                        transform: scale(4);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
        }
    }

    // Performance monitoring
    setupPerformanceMonitoring() {
        // Monitor Core Web Vitals
        if ('web-vital' in window) {
            // This would integrate with web-vitals library if included
            console.log('Performance monitoring initialized');
        }

        // Basic performance logging
        window.addEventListener('load', () => {
            setTimeout(() => {
                const perfData = performance.getEntriesByType('navigation')[0];
                console.log('Page Load Performance:', {
                    domContentLoaded: perfData.domContentLoadedEventEnd - perfData.domContentLoadedEventStart,
                    loadComplete: perfData.loadEventEnd - perfData.loadEventStart,
                    totalTime: perfData.loadEventEnd - perfData.fetchStart
                });
            }, 0);
        });
    }
}

// Initialize the application
const areaApp = new AreaLandingPage();

// Export for module usage if needed
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AreaLandingPage;
}

// Add additional interactive features
document.addEventListener('DOMContentLoaded', () => {
    // Add scroll progress indicator
    const addScrollProgress = () => {
        const progressBar = document.createElement('div');
        progressBar.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 0%;
            height: 3px;
            background: var(--color-accent-primary);
            z-index: 1002;
            transition: width 0.1s ease;
        `;
        document.body.appendChild(progressBar);

        const updateProgress = () => {
            const scrollHeight = document.documentElement.scrollHeight - window.innerHeight;
            const scrollProgress = (window.scrollY / scrollHeight) * 100;
            progressBar.style.width = `${Math.min(scrollProgress, 100)}%`;
        };

        window.addEventListener('scroll', areaApp.throttle(updateProgress, 16));
    };

    addScrollProgress();

    // Add table horizontal scroll indicators
    const tables = document.querySelectorAll('.comparison-table');
    tables.forEach(table => {
        const wrapper = document.createElement('div');
        wrapper.style.position = 'relative';
        table.parentNode.insertBefore(wrapper, table);
        wrapper.appendChild(table);

        // Add scroll shadows
        const leftShadow = document.createElement('div');
        const rightShadow = document.createElement('div');
        
        const shadowStyles = `
            position: absolute;
            top: 0;
            bottom: 0;
            width: 20px;
            pointer-events: none;
            z-index: 1;
            transition: opacity 0.3s ease;
        `;
        
        leftShadow.style.cssText = shadowStyles + `
            left: 0;
            background: linear-gradient(to right, rgba(0,0,0,0.1), transparent);
            opacity: 0;
        `;
        
        rightShadow.style.cssText = shadowStyles + `
            right: 0;
            background: linear-gradient(to left, rgba(0,0,0,0.1), transparent);
            opacity: 1;
        `;
        
        wrapper.appendChild(leftShadow);
        wrapper.appendChild(rightShadow);

        table.addEventListener('scroll', () => {
            const scrollLeft = table.scrollLeft;
            const maxScroll = table.scrollWidth - table.clientWidth;
            
            leftShadow.style.opacity = scrollLeft > 10 ? '1' : '0';
            rightShadow.style.opacity = scrollLeft < maxScroll - 10 ? '1' : '0';
        });
    });
});

// Add CSS for active navigation states
const activeNavStyles = document.createElement('style');
activeNavStyles.textContent = `
    .nav-pill.active {
        background: rgba(72, 92, 17, 0.1);
        color: var(--color-accent-primary);
    }
    
    .nav-pill.active::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 50%;
        transform: translateX(-50%);
        width: 20px;
        height: 2px;
        background: var(--color-accent-primary);
        border-radius: 1px;
    }
    
    .nav-pill {
        position: relative;
    }
`;
document.head.appendChild(activeNavStyles);