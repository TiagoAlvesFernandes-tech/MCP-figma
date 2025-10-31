/**
 * Workshop LLM Landing Page - Interactive Features
 * Author: Jorge Maia - Microsoft MVP
 * Version: 1.0.0
 */

(function() {
    'use strict';

    // ============================================
    // CONSTANTS AND CONFIGURATION
    // ============================================
    const CONFIG = {
        SCROLL_OFFSET: 80,
        DEBOUNCE_DELAY: 100,
        ANIMATION_DURATION: 300,
        VIEWPORT_THRESHOLD: 0.1
    };

    // DOM Elements
    const elements = {
        ctaButtons: null,
        heroSection: null,
        sections: null,
        body: null
    };

    // ============================================
    // UTILITY FUNCTIONS
    // ============================================

    /**
     * Debounce function to limit function calls
     * @param {Function} func - Function to debounce
     * @param {number} wait - Wait time in milliseconds
     * @returns {Function} Debounced function
     */
    function debounce(func, wait) {
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

    /**
     * Smooth scroll to element with offset
     * @param {HTMLElement} target - Target element
     * @param {number} offset - Scroll offset
     */
    function smoothScrollTo(target, offset = 0) {
        const targetPosition = target.offsetTop - offset;
        
        window.scrollTo({
            top: targetPosition,
            behavior: 'smooth'
        });
    }

    /**
     * Check if element is in viewport
     * @param {HTMLElement} element - Element to check
     * @param {number} threshold - Visibility threshold (0-1)
     * @returns {boolean} Is element visible
     */
    function isInViewport(element, threshold = CONFIG.VIEWPORT_THRESHOLD) {
        if (!element) return false;
        
        const rect = element.getBoundingClientRect();
        const windowHeight = window.innerHeight || document.documentElement.clientHeight;
        const windowWidth = window.innerWidth || document.documentElement.clientWidth;
        
        const vertInView = (rect.top <= windowHeight) && ((rect.top + rect.height) >= 0);
        const horInView = (rect.left <= windowWidth) && ((rect.left + rect.width) >= 0);
        
        const visibleHeight = Math.min(rect.bottom, windowHeight) - Math.max(rect.top, 0);
        const visibleWidth = Math.min(rect.right, windowWidth) - Math.max(rect.left, 0);
        
        const visibleArea = visibleHeight * visibleWidth;
        const totalArea = rect.height * rect.width;
        
        return vertInView && horInView && (visibleArea / totalArea >= threshold);
    }

    /**
     * Add loading state to button
     * @param {HTMLElement} button - Button element
     */
    function addLoadingState(button) {
        if (!button) return;
        
        button.disabled = true;
        button.style.opacity = '0.7';
        button.style.cursor = 'not-allowed';
        
        const originalText = button.textContent;
        button.textContent = 'PROCESSANDO...';
        
        setTimeout(() => {
            button.disabled = false;
            button.style.opacity = '1';
            button.style.cursor = 'pointer';
            button.textContent = originalText;
        }, 2000);
    }

    // ============================================
    // ANALYTICS AND TRACKING
    // ============================================

    /**
     * Track user interaction events
     * @param {string} eventName - Event name
     * @param {Object} eventData - Event data
     */
    function trackEvent(eventName, eventData = {}) {
        // Google Analytics 4 tracking (if available)
        if (typeof gtag !== 'undefined') {
            gtag('event', eventName, {
                event_category: 'Workshop_LLM',
                event_label: eventData.label || '',
                value: eventData.value || 0,
                ...eventData
            });
        }

        // Facebook Pixel tracking (if available)
        if (typeof fbq !== 'undefined') {
            fbq('track', eventName, eventData);
        }

        // Console log for development
        if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
            console.log('Event tracked:', eventName, eventData);
        }
    }

    /**
     * Track scroll depth milestones
     */
    const trackScrollDepth = (() => {
        const milestones = [25, 50, 75, 90, 100];
        const tracked = new Set();

        return debounce(() => {
            const scrollPercent = Math.round(
                (window.scrollY / (document.documentElement.scrollHeight - window.innerHeight)) * 100
            );

            milestones.forEach(milestone => {
                if (scrollPercent >= milestone && !tracked.has(milestone)) {
                    tracked.add(milestone);
                    trackEvent('scroll_depth', {
                        scroll_depth: milestone,
                        label: `${milestone}%`
                    });
                }
            });
        }, CONFIG.DEBOUNCE_DELAY);
    })();

    // ============================================
    // SCROLL EFFECTS AND ANIMATIONS
    // ============================================

    /**
     * Handle scroll-based animations and effects
     */
    function handleScrollEffects() {
        // Track scroll depth
        trackScrollDepth();

        // Add scroll-based class to body
        if (window.scrollY > 100) {
            elements.body.classList.add('scrolled');
        } else {
            elements.body.classList.remove('scrolled');
        }

        // Animate sections on scroll
        if (elements.sections) {
            elements.sections.forEach(section => {
                if (isInViewport(section, 0.2)) {
                    section.classList.add('in-view');
                    
                    // Track section view
                    if (!section.dataset.viewed) {
                        section.dataset.viewed = 'true';
                        trackEvent('section_view', {
                            section_id: section.id || section.className,
                            label: section.id || 'unnamed_section'
                        });
                    }
                }
            });
        }
    }

    // ============================================
    // CTA BUTTON INTERACTIONS
    // ============================================

    /**
     * Handle CTA button clicks
     * @param {Event} event - Click event
     */
    function handleCtaClick(event) {
        const button = event.currentTarget;
        const href = button.getAttribute('href');
        
        // Track CTA click
        trackEvent('cta_click', {
            button_text: button.textContent.trim(),
            button_location: button.closest('section')?.id || 'unknown',
            label: `CTA_${button.textContent.trim().replace(/\s+/g, '_')}`
        });

        // Handle internal links (smooth scroll)
        if (href && href.startsWith('#')) {
            event.preventDefault();
            const targetId = href.substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                smoothScrollTo(targetElement, CONFIG.SCROLL_OFFSET);
                
                // Update URL without triggering page reload
                if (history.pushState) {
                    history.pushState(null, null, href);
                }
            }
        }
        // Handle external links or form submissions
        else if (href && !href.startsWith('#')) {
            // Add loading state
            addLoadingState(button);
            
            // Track conversion
            trackEvent('conversion_intent', {
                conversion_type: 'registration',
                value: 127,
                currency: 'BRL',
                label: 'Workshop_Registration'
            });
            
            // For demo purposes, prevent actual navigation
            if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
                event.preventDefault();
                alert('Demo: Em um ambiente real, isso levaria para a página de checkout.');
                return;
            }
        }
    }

    // ============================================
    // PERFORMANCE OPTIMIZATION
    // ============================================

    /**
     * Lazy load images when they come into viewport
     */
    function initLazyLoading() {
        const images = document.querySelectorAll('img[data-src]');
        
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src;
                        img.removeAttribute('data-src');
                        img.classList.add('loaded');
                        imageObserver.unobserve(img);
                    }
                });
            }, {
                rootMargin: '50px'
            });

            images.forEach(img => imageObserver.observe(img));
        } else {
            // Fallback for older browsers
            images.forEach(img => {
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
            });
        }
    }

    /**
     * Preload critical images
     */
    function preloadCriticalImages() {
        const criticalImages = [
            './assets/background-frame.png',
            './assets/digital-build-destroyed.png',
            './assets/jorge-maia-profile.png'
        ];

        criticalImages.forEach(src => {
            const link = document.createElement('link');
            link.rel = 'preload';
            link.as = 'image';
            link.href = src;
            document.head.appendChild(link);
        });
    }

    // ============================================
    // ACCESSIBILITY ENHANCEMENTS
    // ============================================

    /**
     * Add keyboard navigation support
     */
    function initKeyboardNavigation() {
        document.addEventListener('keydown', (event) => {
            // Skip links with Tab
            if (event.key === 'Tab' && event.target.classList.contains('skip-link')) {
                event.preventDefault();
                const target = document.querySelector(event.target.getAttribute('href'));
                if (target) {
                    target.focus();
                    smoothScrollTo(target, CONFIG.SCROLL_OFFSET);
                }
            }
        });
    }

    /**
     * Add focus management for modal/dropdown interactions
     */
    function initFocusManagement() {
        // Trap focus within modal elements (if any are added later)
        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape') {
                const activeModal = document.querySelector('.modal.active, .dropdown.active');
                if (activeModal) {
                    activeModal.classList.remove('active');
                    // Return focus to trigger element
                    const trigger = document.querySelector(`[data-target="#${activeModal.id}"]`);
                    if (trigger) trigger.focus();
                }
            }
        });
    }

    // ============================================
    // ERROR HANDLING AND FALLBACKS
    // ============================================

    /**
     * Global error handler
     */
    function initErrorHandling() {
        window.addEventListener('error', (event) => {
            console.error('JavaScript error:', event.error);
            
            // Track errors for debugging
            if (typeof gtag !== 'undefined') {
                gtag('event', 'exception', {
                    description: event.error?.message || 'Unknown error',
                    fatal: false
                });
            }
        });

        // Handle unhandled promise rejections
        window.addEventListener('unhandledrejection', (event) => {
            console.error('Unhandled promise rejection:', event.reason);
        });
    }

    // ============================================
    // INITIALIZATION
    // ============================================

    /**
     * Initialize all features when DOM is ready
     */
    function init() {
        try {
            // Cache DOM elements
            elements.ctaButtons = document.querySelectorAll('.cta-button');
            elements.heroSection = document.querySelector('.hero-section');
            elements.sections = document.querySelectorAll('section');
            elements.body = document.body;

            // Initialize features
            initErrorHandling();
            initLazyLoading();
            preloadCriticalImages();
            initKeyboardNavigation();
            initFocusManagement();

            // Add event listeners
            if (elements.ctaButtons) {
                elements.ctaButtons.forEach(button => {
                    button.addEventListener('click', handleCtaClick);
                });
            }

            // Throttled scroll handler
            const throttledScrollHandler = debounce(handleScrollEffects, CONFIG.DEBOUNCE_DELAY);
            window.addEventListener('scroll', throttledScrollHandler, { passive: true });

            // Initial scroll effect check
            handleScrollEffects();

            // Track page load
            trackEvent('page_view', {
                page_title: document.title,
                page_location: window.location.href,
                label: 'Workshop_LLM_Landing'
            });

            console.log('Workshop LLM Landing Page initialized successfully!');

        } catch (error) {
            console.error('Initialization error:', error);
        }
    }

    // ============================================
    // START APPLICATION
    // ============================================

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    // Export for testing purposes
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = {
            init,
            trackEvent,
            smoothScrollTo,
            isInViewport
        };
    }

})();
