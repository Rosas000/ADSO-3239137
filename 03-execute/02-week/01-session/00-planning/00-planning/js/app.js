/**
 * Modelado y Gestion de Bases de Datos - Roadmap Gamificado
 * CORHUILA - Corporacion Universitaria del Huila
 *
 * @description Ruta de aprendizaje hacia el proyecto final
 * @version 2.0.0
 * @methodology Tradicional (Clase + Trabajo Autonomo)
 */

// ===== DATOS DEL CURSO =====
const COURSE_DATA = {
    name: "Modelado y Gestion de Bases de Datos",
    totalWeeks: 16,
    methodology: "tradicional", // tradicional | agil
    cortes: [
        { id: 1, name: "Primer Corte", weeks: [1, 2, 3, 4, 5], percentage: 30, fase: "Fundamentos y Modelado" },
        { id: 2, name: "Segundo Corte", weeks: [6, 7, 8, 9, 10], percentage: 30, fase: "SQL y Optimizacion" },
        { id: 3, name: "Tercer Corte", weeks: [11, 12, 13, 14, 15, 16], percentage: 40, fase: "Administracion y Proyecto" }
    ],
    weeks: [
        {
            num: 1,
            title: "Fundamentos de BD",
            topic: "Conceptos basicos y SGBD",
            type: "normal",
            content: {
                clase: "Presentacion del curso, conceptos de datos, informacion, SGBD, arquitectura de BD",
                autonomo: "Foro: Diferencias entre SGBD relacionales y NoSQL, casos de uso"
            },
            tags: ["SGBD", "Conceptos", "Arquitectura"],
            activity: "foro"
        },
        {
            num: 2,
            title: "Modelo Entidad-Relacion",
            topic: "Diagramas ER basicos",
            type: "normal",
            content: {
                clase: "Entidades, atributos (simples, compuestos, derivados), relaciones, cardinalidad",
                autonomo: "Taller: Diseno de diagrama ER para sistema de biblioteca universitaria"
            },
            tags: ["ER", "Entidades", "Cardinalidad"],
            activity: "taller"
        },
        {
            num: 3,
            title: "Modelo ER Extendido",
            topic: "EER y Especializacion",
            type: "normal",
            content: {
                clase: "Jerarquias de generalizacion/especializacion, herencia, restricciones disjoint/overlap",
                autonomo: "Taller: Modelado EER para sistema de gestion hospitalaria"
            },
            tags: ["EER", "Herencia", "Jerarquias"],
            activity: "taller"
        },
        {
            num: 4,
            title: "Modelo Relacional",
            topic: "Conversion ER a Tablas",
            type: "normal",
            content: {
                clase: "Reglas de conversion de entidades, relaciones 1:1, 1:N, N:M, atributos multivaluados",
                autonomo: "Quiz: Conversion de diagramas ER a esquemas relacionales"
            },
            tags: ["Relacional", "Claves", "FK"],
            activity: "quiz"
        },
        {
            num: 5,
            title: "Primer Parcial",
            topic: "Evaluacion Corte 1",
            type: "parcial",
            content: {
                clase: "Evaluacion teorico-practica: fundamentos, modelo ER y conversion al modelo relacional",
                autonomo: "Revision individual de resultados y analisis de errores"
            },
            tags: ["Parcial", "Evaluacion"],
            activity: "parcial"
        },
        {
            num: 6,
            title: "Normalizacion 1FN-2FN",
            topic: "Formas Normales Basicas",
            type: "normal",
            content: {
                clase: "Dependencias funcionales, anomalias de actualizacion, aplicacion de 1FN y 2FN",
                autonomo: "Foro: Cuando es aceptable la desnormalizacion en bases de datos empresariales"
            },
            tags: ["1FN", "2FN", "Dependencias"],
            activity: "foro"
        },
        {
            num: 7,
            title: "Normalizacion 3FN-FNBC",
            topic: "Formas Normales Avanzadas",
            type: "normal",
            content: {
                clase: "Dependencias transitivas, Tercera Forma Normal, Forma Normal de Boyce-Codd",
                autonomo: "Taller: Normalizacion completa de esquema de base de datos e-commerce"
            },
            tags: ["3FN", "FNBC", "Normalizacion"],
            activity: "taller"
        },
        {
            num: 8,
            title: "SQL: Joins y Subconsultas",
            topic: "Consultas Avanzadas",
            type: "normal",
            content: {
                clase: "Subconsultas correlacionadas, INNER/LEFT/RIGHT/FULL JOIN, CROSS JOIN",
                autonomo: "Taller: Consultas complejas con multiples joins y subconsultas anidadas"
            },
            tags: ["SQL", "JOIN", "Subconsultas"],
            activity: "taller"
        },
        {
            num: 9,
            title: "Vistas e Indices",
            topic: "Optimizacion de Consultas",
            type: "normal",
            content: {
                clase: "Creacion de vistas, indices B-tree y hash, planes de ejecucion con EXPLAIN",
                autonomo: "Quiz: Optimizacion de consultas SQL mediante indices"
            },
            tags: ["Vistas", "Indices", "EXPLAIN"],
            activity: "quiz"
        },
        {
            num: 10,
            title: "Segundo Parcial",
            topic: "Evaluacion Corte 2",
            type: "parcial",
            content: {
                clase: "Evaluacion teorico-practica: normalizacion, SQL avanzado y optimizacion",
                autonomo: "Revision comparativa con rubrica y discusion de resultados"
            },
            tags: ["Parcial", "Evaluacion"],
            activity: "parcial"
        },
        {
            num: 11,
            title: "Procedures y Triggers",
            topic: "Logica en la BD",
            type: "normal",
            content: {
                clase: "Procedimientos almacenados, triggers BEFORE/AFTER, funciones definidas por usuario",
                autonomo: "Foro: Ventajas y desventajas de logica de negocio en BD vs aplicacion"
            },
            tags: ["Procedures", "Triggers", "Funciones"],
            activity: "foro"
        },
        {
            num: 12,
            title: "Transacciones ACID",
            topic: "Control de Concurrencia",
            type: "normal",
            content: {
                clase: "Propiedades ACID, niveles de aislamiento, bloqueos (locks), manejo de deadlocks",
                autonomo: "Taller: Implementacion de transacciones con BEGIN, COMMIT, ROLLBACK"
            },
            tags: ["ACID", "Transacciones", "Locks"],
            activity: "taller"
        },
        {
            num: 13,
            title: "Administracion de SGBD",
            topic: "Seguridad y Respaldo",
            type: "normal",
            content: {
                clase: "Gestion de usuarios, roles, privilegios GRANT/REVOKE, copias de seguridad",
                autonomo: "Taller: Configuracion de usuarios, roles y politicas de backup en PostgreSQL"
            },
            tags: ["Seguridad", "Backup", "Roles"],
            activity: "taller"
        },
        {
            num: 14,
            title: "Bases de Datos NoSQL",
            topic: "MongoDB",
            type: "normal",
            content: {
                clase: "Bases de datos documentales, modelado NoSQL, operaciones CRUD con MongoDB",
                autonomo: "Quiz: Comparacion modelado relacional vs documental, casos de uso MongoDB"
            },
            tags: ["NoSQL", "MongoDB", "Documentos"],
            activity: "quiz"
        },
        {
            num: 15,
            title: "Proyecto Final + Parcial",
            topic: "Evaluacion Final",
            type: "parcial",
            content: {
                clase: "Presentacion de proyectos: sistema con diseno ER, normalizacion, SQL y NoSQL. Tercer Parcial.",
                autonomo: "Entrega de proyecto final con documentacion tecnica completa"
            },
            tags: ["Proyecto", "Parcial", "Integracion"],
            activity: "proyecto"
        },
        {
            num: 16,
            title: "Cierre del Curso",
            topic: "Retroalimentacion Final",
            type: "cierre",
            content: {
                clase: "Revision de notas, retroalimentacion individual, recomendaciones de certificacion",
                autonomo: "Reflexion sobre el aprendizaje y plan de desarrollo profesional"
            },
            tags: ["Cierre", "Certificacion"],
            activity: "cierre"
        }
    ],
    badges: [
        { id: "starter", icon: "🚀", name: "Iniciador", desc: "Primer paso en la ruta", requirement: 1 },
        { id: "modeler", icon: "📐", name: "Modelador ER", desc: "Domina el modelo ER", requirement: 4 },
        { id: "normalizer", icon: "🔧", name: "Normalizador", desc: "Experto en formas normales", requirement: 7 },
        { id: "sqlmaster", icon: "💾", name: "SQL Master", desc: "Consultas avanzadas dominadas", requirement: 10 },
        { id: "dba", icon: "🛡️", name: "DBA Junior", desc: "Administrador de BD", requirement: 14 },
        { id: "master", icon: "🎓", name: "Master BD", desc: "Ruta completada", requirement: 16 }
    ]
};

// ===== ESTADO DE LA APLICACION =====
const STORAGE_KEY = 'mgbd_roadmap_v2';
let state = {
    completedWeeks: new Set(),
    currentFilter: 'all'
};

// ===== FUNCIONES DE PERSISTENCIA =====
function loadState() {
    try {
        const saved = localStorage.getItem(STORAGE_KEY);
        if (saved) {
            const parsed = JSON.parse(saved);
            state.completedWeeks = new Set(parsed.completedWeeks || []);
        }
    } catch (error) {
        console.error('Error loading state:', error);
    }
}

function saveState() {
    try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify({
            completedWeeks: Array.from(state.completedWeeks)
        }));
    } catch (error) {
        console.error('Error saving state:', error);
    }
}

// ===== FUNCIONES DE CALCULO =====
function getProgress() {
    return {
        completed: state.completedWeeks.size,
        total: COURSE_DATA.totalWeeks,
        percentage: Math.round((state.completedWeeks.size / COURSE_DATA.totalWeeks) * 100)
    };
}

function getCorteProgress(corte) {
    const completedInCorte = corte.weeks.filter(w => state.completedWeeks.has(w)).length;
    return {
        completed: completedInCorte,
        total: corte.weeks.length,
        percentage: Math.round((completedInCorte / corte.weeks.length) * 100)
    };
}

function getUnlockedBadges() {
    const completed = state.completedWeeks.size;
    return COURSE_DATA.badges.filter(b => completed >= b.requirement);
}

// ===== FUNCIONES DE TOGGLE =====
function toggleWeek(weekNum) {
    if (state.completedWeeks.has(weekNum)) {
        state.completedWeeks.delete(weekNum);
    } else {
        state.completedWeeks.add(weekNum);
    }
    saveState();
    render();
    checkBadgeUnlock(weekNum);
}

function checkBadgeUnlock(weekNum) {
    const badge = COURSE_DATA.badges.find(b => b.requirement === weekNum);
    if (badge && state.completedWeeks.has(weekNum)) {
        showBadgeModal(badge);
    }
}

function resetProgress() {
    state.completedWeeks = new Set();
    saveState();
    render();
    closeModal();
}

// ===== FUNCIONES DE FILTRADO =====
function setFilter(filter) {
    state.currentFilter = filter;
    render();
}

// ===== RENDERIZADO =====
function renderProgress() {
    const progress = getProgress();
    const progressFill = document.getElementById('progressFill');
    const progressValue = document.getElementById('progressValue');
    const progressText = document.getElementById('progressText');

    if (progressFill) progressFill.style.width = `${progress.percentage}%`;
    if (progressValue) progressValue.textContent = `${progress.percentage}%`;
    if (progressText) progressText.textContent = `${progress.completed} de ${progress.total} semanas completadas`;
}

function renderHeroStats() {
    const progress = getProgress();
    const badges = getUnlockedBadges();

    document.getElementById('statWeeks').textContent = progress.completed;
    document.getElementById('statBadges').textContent = badges.length;
    document.getElementById('statProgress').textContent = `${progress.percentage}%`;
}

function renderRoadmap() {
    const container = document.getElementById('roadmapContainer');
    if (!container) return;

    let html = '';

    COURSE_DATA.cortes.forEach(corte => {
        const corteProgress = getCorteProgress(corte);
        const corteWeeks = COURSE_DATA.weeks.filter(w => corte.weeks.includes(w.num));
        const filteredWeeks = corteWeeks.filter(w => {
            if (state.currentFilter === 'all') return true;
            if (state.currentFilter === 'parcial') return w.type === 'parcial';
            if (state.currentFilter === 'pending') return !state.completedWeeks.has(w.num);
            if (state.currentFilter === 'completed') return state.completedWeeks.has(w.num);
            return true;
        });

        if (filteredWeeks.length === 0) return;

        html += `
            <div class="corte-section">
                <div class="corte-header">
                    <span class="corte-badge corte-badge--${corte.id}">Corte ${corte.id}</span>
                    <div class="corte-info">
                        <h3>${corte.name}</h3>
                        <span>${corte.fase} | Semanas ${corte.weeks[0]} - ${corte.weeks[corte.weeks.length - 1]} | ${corte.percentage}%</span>
                    </div>
                    <div class="corte-progress">
                        <div class="corte-progress__value">${corteProgress.percentage}%</div>
                        <div class="corte-progress__label">${corteProgress.completed}/${corteProgress.total} semanas</div>
                    </div>
                </div>
                <div class="weeks-grid">
                    ${filteredWeeks.map(week => renderWeekCard(week)).join('')}
                </div>
            </div>
        `;
    });

    container.innerHTML = html;

    // Anadir event listeners
    document.querySelectorAll('.week-card').forEach(card => {
        card.addEventListener('click', () => {
            const weekNum = parseInt(card.dataset.week);
            toggleWeek(weekNum);
        });
    });
}

function renderWeekCard(week) {
    const isCompleted = state.completedWeeks.has(week.num);
    const typeClass = week.type === 'parcial' ? 'week-card--parcial' :
                      week.type === 'cierre' ? 'week-card--cierre' : '';
    const completedClass = isCompleted ? 'week-card--completed' : '';

    // Icono segun tipo de actividad
    const activityIcons = {
        foro: '💬',
        taller: '🔧',
        quiz: '❓',
        parcial: '📝',
        proyecto: '🎯',
        cierre: '🎓'
    };

    return `
        <div class="week-card ${typeClass} ${completedClass}" data-week="${week.num}">
            <div class="week-card__header">
                <div class="week-card__number">${isCompleted ? '✓' : week.num}</div>
                <div class="week-card__title">
                    <h4>${week.title}</h4>
                    <span>${week.topic}</span>
                </div>
                <div class="week-card__check">
                    ${isCompleted ? '✓' : ''}
                </div>
            </div>
            <div class="week-card__body">
                <div class="week-card__content">
                    <div class="content-item content-item--clase">
                        <span class="content-item__label">📚 Clase</span>
                        <p class="content-item__text">${week.content.clase}</p>
                    </div>
                    <div class="content-item content-item--autonomo">
                        <span class="content-item__label">${activityIcons[week.activity] || '📖'} Autonomo</span>
                        <p class="content-item__text">${week.content.autonomo}</p>
                    </div>
                </div>
                <div class="week-card__tags">
                    ${week.tags.map(tag => `<span class="tech-tag">${tag}</span>`).join('')}
                </div>
            </div>
        </div>
    `;
}

function renderBadges() {
    const container = document.getElementById('badgesContainer');
    if (!container) return;

    const unlockedIds = getUnlockedBadges().map(b => b.id);

    container.innerHTML = COURSE_DATA.badges.map(badge => {
        const isUnlocked = unlockedIds.includes(badge.id);
        return `
            <div class="badge-card ${isUnlocked ? 'badge-card--unlocked' : 'badge-card--locked'}">
                <div class="badge-card__icon">${badge.icon}</div>
                <h4 class="badge-card__title">${badge.name}</h4>
                <p class="badge-card__desc">${badge.desc}</p>
                <span class="badge-card__status">${isUnlocked ? '✓ Desbloqueado' : '🔒 Bloqueado'}</span>
            </div>
        `;
    }).join('');
}

function renderFilters() {
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.filter === state.currentFilter);
    });
}

function render() {
    renderProgress();
    renderHeroStats();
    renderRoadmap();
    renderBadges();
    renderFilters();
}

// ===== MODAL =====
function openResetModal() {
    const modal = document.getElementById('resetModal');
    if (modal) modal.classList.add('open');
}

function closeModal() {
    document.querySelectorAll('.modal').forEach(m => m.classList.remove('open'));
}

function showBadgeModal(badge) {
    const modal = document.getElementById('badgeModal');
    if (!modal) return;

    document.getElementById('badgeModalIcon').textContent = badge.icon;
    document.getElementById('badgeModalTitle').textContent = `¡${badge.name} Desbloqueado!`;
    document.getElementById('badgeModalDesc').textContent = badge.desc;

    modal.classList.add('open');

    setTimeout(() => {
        modal.classList.remove('open');
    }, 3000);
}

// ===== SCROLL TOP =====
function initScrollTop() {
    const btn = document.getElementById('scrollTopBtn');
    if (!btn) return;

    window.addEventListener('scroll', () => {
        btn.classList.toggle('visible', window.scrollY > 300);
    });

    btn.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}

// ===== NAVEGACION ACTIVA =====
function initActiveNav() {
    const navLinks = document.querySelectorAll('.header__nav a');
    const sections = document.querySelectorAll('section[id]');

    window.addEventListener('scroll', () => {
        let current = '';
        sections.forEach(section => {
            const sectionTop = section.offsetTop - 100;
            if (window.scrollY >= sectionTop) {
                current = section.getAttribute('id');
            }
        });

        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${current}`) {
                link.classList.add('active');
            }
        });
    });
}

// ===== EVENT LISTENERS =====
function initEventListeners() {
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            setFilter(btn.dataset.filter);
        });
    });

    const resetBtn = document.getElementById('btnReset');
    if (resetBtn) {
        resetBtn.addEventListener('click', openResetModal);
    }

    document.getElementById('modalCancel')?.addEventListener('click', closeModal);
    document.getElementById('modalConfirm')?.addEventListener('click', resetProgress);
    document.getElementById('badgeModalClose')?.addEventListener('click', closeModal);

    document.querySelectorAll('.modal').forEach(modal => {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) closeModal();
        });
    });
}

// ===== INICIALIZACION =====
document.addEventListener('DOMContentLoaded', () => {
    loadState();
    render();
    initScrollTop();
    initActiveNav();
    initEventListeners();

    console.log('🗄️ Modelado y Gestion de BD - Ruta de Aprendizaje v2.0');
});
