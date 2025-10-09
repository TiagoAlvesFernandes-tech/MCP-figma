// Interactive functionality for AI Workshop Landing Page

document.addEventListener('DOMContentLoaded', function() {
    
    // Smooth scroll for anchor links
    const ctaButtons = document.querySelectorAll('.cta-button');
    
    ctaButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            // Add click animation
            this.style.transform = 'scale(0.98)';
            setTimeout(() => {
                this.style.transform = '';
            }, 150);
        });
    });

    // Intersection Observer for fade-in animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe learning cards
    const learningCards = document.querySelectorAll('.learning-card');
    learningCards.forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(card);
    });

    // Observe cycle stages
    const cycleStages = document.querySelectorAll('.cycle-stage');
    cycleStages.forEach((stage, index) => {
        stage.style.opacity = '0';
        stage.style.transform = 'translateX(-30px)';
        stage.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
        observer.observe(stage);
    });

    // Observe credential items
    const credentialItems = document.querySelectorAll('.credential-item');
    credentialItems.forEach((item, index) => {
        item.style.opacity = '0';
        item.style.transform = 'translateX(30px)';
        item.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
        observer.observe(item);
    });

    // Add parallax effect to background images (subtle)
    let ticking = false;
    
    window.addEventListener('scroll', function() {
        if (!ticking) {
            window.requestAnimationFrame(function() {
                const scrolled = window.pageYOffset;
                const parallaxElements = document.querySelectorAll('.hero-decoration, .logo-gpt, .logo-gemini');
                
                parallaxElements.forEach(element => {
                    const speed = 0.3;
                    element.style.transform = `translateY(${scrolled * speed}px)`;
                });
                
                ticking = false;
            });
            
            ticking = true;
        }
    });

    // Add hover effect for journey steps
    const journeySteps = document.querySelectorAll('.journey-step');
    journeySteps.forEach(step => {
        step.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.05)';
            this.style.transition = 'transform 0.3s ease';
        });
        
        step.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    });

    // Track CTA button clicks for analytics (placeholder)
    ctaButtons.forEach(button => {
        button.addEventListener('click', function() {
            const buttonText = this.querySelector('span').textContent;
            console.log('CTA Clicked:', buttonText);
            // TODO: Add analytics tracking here (Google Analytics, Meta Pixel, etc.)
            // Example: gtag('event', 'cta_click', { 'button_text': buttonText });
        });
    });

    // Add loading state management
    window.addEventListener('load', function() {
        document.body.classList.add('loaded');
        console.log('Page fully loaded and interactive');
    });

    // Performance monitoring (optional)
    if ('PerformanceObserver' in window) {
        const perfObserver = new PerformanceObserver((list) => {
            for (const entry of list.getEntries()) {
                if (entry.entryType === 'largest-contentful-paint') {
                    console.log('LCP:', entry.startTime);
                }
            }
        });
        
        try {
            perfObserver.observe({ entryTypes: ['largest-contentful-paint'] });
        } catch (e) {
            console.log('Performance monitoring not supported');
        }
    }

    // Add error handling for images
    const images = document.querySelectorAll('img');
    images.forEach(img => {
        img.addEventListener('error', function() {
            console.warn('Failed to load image:', this.src);
            // TODO: Add fallback image or placeholder
            this.style.display = 'none';
        });
    });

    // Accessibility: Focus management
    const focusableElements = document.querySelectorAll('a, button, [tabindex]:not([tabindex="-1"])');
    
    focusableElements.forEach(element => {
        element.addEventListener('focus', function() {
            this.style.outline = '3px solid rgba(8, 51, 28, 0.5)';
            this.style.outlineOffset = '4px';
        });
        
        element.addEventListener('blur', function() {
            this.style.outline = '';
            this.style.outlineOffset = '';
        });
    });

    // Add keyboard navigation for cards
    learningCards.forEach(card => {
        card.setAttribute('tabindex', '0');
        card.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                this.click();
            }
        });
    });

    console.log('AI Workshop Landing Page initialized successfully');
});

// Export functions for external use (if needed)
window.workshopLanding = {
    version: '1.0.0',
    init: function() {
        console.log('Workshop Landing Page v' + this.version);
    }
};