(function () {
  const CTA_EVENT = "cta_inscricao";

  const dispatchAnalytics = (label) => {
    if (!label) {
      return;
    }

    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({
      event: CTA_EVENT,
      label,
      timestamp: Date.now()
    });
  };

  document.querySelectorAll('[data-track="cta-inscricao"]').forEach((cta) => {
    cta.addEventListener("click", () => dispatchAnalytics("hero_cta"), {
      passive: true
    });
  });

  const revealCards = (entries, observer) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("module-card--visible");
        observer.unobserve(entry.target);
      }
    });
  };

  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver(revealCards, {
      threshold: 0.2
    });

    document.querySelectorAll(".module-card").forEach((card) => {
      observer.observe(card);
    });
  } else {
    document.querySelectorAll(".module-card").forEach((card) => {
      card.classList.add("module-card--visible");
    });
  }
})();
