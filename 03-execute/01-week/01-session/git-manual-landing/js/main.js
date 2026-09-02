/**
 * main.js — Guía Git + GitHub ADSO-3239137
 * Funcionalidades: copiar comandos, nav responsive,
 * scroll suave, acordeones, progreso de scroll y checklist.
 */

document.addEventListener('DOMContentLoaded', () => {
  initCopyButtons();
  initMobileNav();
  initScrollProgress();
  initChecklist();
  initSmoothScrollLinks();
});

/* ============================================
   1. Botón "Copiar" en bloques de código
   ============================================ */
function initCopyButtons() {
  const copyButtons = document.querySelectorAll('.copy-btn');

  copyButtons.forEach((btn) => {
    btn.addEventListener('click', async () => {
      const codeBlock = btn.closest('.code-block');
      const codeEl = codeBlock.querySelector('code');
      const text = codeEl.textContent.trim();

      try {
        await navigator.clipboard.writeText(text);
        btn.textContent = '¡Copiado!';
        btn.classList.add('copied');

        setTimeout(() => {
          btn.textContent = 'Copiar';
          btn.classList.remove('copied');
        }, 2000);
      } catch {
        // Fallback para navegadores que no soportan clipboard API
        fallbackCopy(text);
        btn.textContent = '¡Copiado!';
        btn.classList.add('copied');

        setTimeout(() => {
          btn.textContent = 'Copiar';
          btn.classList.remove('copied');
        }, 2000);
      }
    });
  });
}

/**
 * Fallback de copia para navegadores sin clipboard API
 */
function fallbackCopy(text) {
  const textarea = document.createElement('textarea');
  textarea.value = text;
  textarea.setAttribute('readonly', '');
  textarea.style.position = 'absolute';
  textarea.style.left = '-9999px';
  document.body.appendChild(textarea);
  textarea.select();
  document.execCommand('copy');
  document.body.removeChild(textarea);
}

/* ============================================
   2. Navegación móvil (hamburger)
   ============================================ */
function initMobileNav() {
  const toggle = document.getElementById('navToggle');
  const navLinks = document.getElementById('navLinks');

  if (!toggle || !navLinks) return;

  toggle.addEventListener('click', () => {
    const isOpen = toggle.getAttribute('aria-expanded') === 'true';
    toggle.setAttribute('aria-expanded', String(!isOpen));
    navLinks.classList.toggle('active');
  });

  // Cerrar menú al hacer clic en un enlace
  navLinks.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => {
      toggle.setAttribute('aria-expanded', 'false');
      navLinks.classList.remove('active');
    });
  });

  // Cerrar menú al hacer clic fuera
  document.addEventListener('click', (e) => {
    if (!toggle.contains(e.target) && !navLinks.contains(e.target)) {
      toggle.setAttribute('aria-expanded', 'false');
      navLinks.classList.remove('active');
    }
  });
}

/* ============================================
   3. Barra de progreso al hacer scroll
   ============================================ */
function initScrollProgress() {
  const progressBar = document.getElementById('progressBar');
  if (!progressBar) return;

  function updateProgress() {
    const scrollTop = window.scrollY;
    const docHeight = document.documentElement.scrollHeight - window.innerHeight;
    const progress = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;

    progressBar.style.width = progress + '%';
    progressBar.setAttribute('aria-valuenow', Math.round(progress));
  }

  window.addEventListener('scroll', updateProgress, { passive: true });
  updateProgress();
}

/* ============================================
   4. Checklist con progreso
   ============================================ */
function initChecklist() {
  const form = document.getElementById('checklistForm');
  const progressBarEl = document.getElementById('checklistProgressBar');
  const statusEl = document.getElementById('checklistStatus');

  if (!form) return;

  const checkboxes = form.querySelectorAll('input[type="checkbox"]');
  const total = checkboxes.length;

  // Restaurar estado desde localStorage
  checkboxes.forEach((cb) => {
    const saved = localStorage.getItem('checklist_' + cb.value);
    if (saved === 'true') {
      cb.checked = true;
    }
  });

  function updateChecklistProgress() {
    const checked = form.querySelectorAll('input[type="checkbox"]:checked').length;
    const percent = total > 0 ? (checked / total) * 100 : 0;

    if (progressBarEl) {
      progressBarEl.style.width = percent + '%';
    }

    if (statusEl) {
      if (checked === total) {
        statusEl.textContent = '🎉 ¡Todo listo! Entrega completada';
        statusEl.style.color = '#065f46';
      } else {
        statusEl.textContent = checked + ' de ' + total + ' completados';
        statusEl.style.color = '';
      }
    }
  }

  checkboxes.forEach((cb) => {
    cb.addEventListener('change', () => {
      localStorage.setItem('checklist_' + cb.value, cb.checked);
      updateChecklistProgress();
    });
  });

  // Inicializar
  updateChecklistProgress();
}

/* ============================================
   5. Scroll suave para enlaces con ancla
   ============================================ */
function initSmoothScrollLinks() {
  document.querySelectorAll('a[href^="#"]').forEach((link) => {
    link.addEventListener('click', (e) => {
      const targetId = link.getAttribute('href');
      if (targetId === '#') return;

      const target = document.querySelector(targetId);
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });

        // Actualizar URL sin recargar
        history.pushState(null, '', targetId);
      }
    });
  });
}
