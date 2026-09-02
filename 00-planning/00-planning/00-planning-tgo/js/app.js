/* ==============================================
   SENA Landing Page - Ficha ADSO 3413974
   Datos del Programa y Lógica de Gamificación
   ============================================== */

// === DATOS DEL PROGRAMA ===
const COURSE_DATA = {
    // === METADATA ===
    name: "Análisis y Desarrollo de Software",
    codigo: "228106",
    ficha: "3413974",
    centro: "Centro de la Tecnología del Diseño y la Productividad Empresarial",
    totalWeeks: 18,
    methodology: "competencias",

    // === COMPETENCIAS Y RAP ===
    competencias: [
        {
            id: 1,
            codigo: "220501046",
            nombre: "Construir el sistema de información que cumpla con los requisitos de la solución informática",
            duracion: 680,
            rap: [
                {
                    id: "RAP-001",
                    nombre: "Interpretar el informe de requerimientos para determinar las necesidades tecnológicas",
                    criterios: ["Análisis de requisitos", "Casos de uso", "Historias de usuario"]
                },
                {
                    id: "RAP-002",
                    nombre: "Construir la base de datos según el modelo de datos",
                    criterios: ["Modelo E-R", "SQL", "Normalización"]
                },
                {
                    id: "RAP-003",
                    nombre: "Desarrollar el sistema de información según diseño y metodología",
                    criterios: ["Programación OOP", "Patrones de diseño", "Frameworks"]
                }
            ]
        },
        {
            id: 2,
            codigo: "220501047",
            nombre: "Implementar la arquitectura tecnológica según las necesidades de la organización",
            duracion: 440,
            rap: [
                {
                    id: "RAP-004",
                    nombre: "Definir la arquitectura del software según requerimientos técnicos",
                    criterios: ["Arquitectura MVC", "Microservicios", "APIs REST"]
                },
                {
                    id: "RAP-005",
                    nombre: "Integrar componentes de software según especificaciones técnicas",
                    criterios: ["Integración continua", "Control de versiones", "Testing"]
                }
            ]
        },
        {
            id: 3,
            codigo: "220501048",
            nombre: "Gestionar la calidad del software según estándares y normas establecidas",
            duracion: 360,
            rap: [
                {
                    id: "RAP-006",
                    nombre: "Ejecutar pruebas de software según plan de pruebas",
                    criterios: ["Pruebas unitarias", "Pruebas de integración", "QA"]
                },
                {
                    id: "RAP-007",
                    nombre: "Documentar el proceso de desarrollo según metodología",
                    criterios: ["Documentación técnica", "Manuales", "Estándares IEEE"]
                }
            ]
        },
        {
            id: 4,
            codigo: "220501049",
            nombre: "Participar en el proceso de negociación tecnológica para establecer alianzas estratégicas",
            duracion: 200,
            rap: [
                {
                    id: "RAP-008",
                    nombre: "Evaluar soluciones tecnológicas según criterios de selección",
                    criterios: ["Análisis de costos", "Evaluación técnica", "Viabilidad"]
                }
            ]
        },
        {
            id: 5,
            codigo: "220501050",
            nombre: "Aplicar buenas prácticas de seguridad de la información según políticas de la organización",
            duracion: 280,
            rap: [
                {
                    id: "RAP-009",
                    nombre: "Implementar controles de seguridad según políticas establecidas",
                    criterios: ["Autenticación", "Autorización", "Encriptación"]
                },
                {
                    id: "RAP-010",
                    nombre: "Gestionar riesgos de seguridad según metodología",
                    criterios: ["Análisis de riesgos", "OWASP", "Hardening"]
                }
            ]
        }
    ],

    // === SEMANAS ===
    weeks: [
        {
            num: 1,
            title: "Fundamentos de Desarrollo de Software",
            topic: "Introducción al ciclo de vida del software",
            competencia: 1,
            rap: "RAP-001",
            type: "normal",
            presencial: ["Conceptos de ingeniería de software", "Metodologías ágiles vs tradicionales"],
            virtual: ["Investigación de modelos de desarrollo", "Comparativa Scrum vs Waterfall"],
            autonomo: ["Lectura del SWEBOK", "Video: Historia del desarrollo de software"],
            evidencias: [
                { tipo: "conocimiento", descripcion: "Quiz metodologías" },
                { tipo: "producto", descripcion: "Mapa conceptual ciclo de vida" }
            ],
            tags: ["SDLC", "Scrum", "Waterfall", "Metodologías"]
        },
        {
            num: 2,
            title: "Levantamiento de Requerimientos",
            topic: "Técnicas de recolección y análisis de requisitos",
            competencia: 1,
            rap: "RAP-001",
            type: "normal",
            presencial: ["Técnicas de entrevistas", "Casos de uso UML"],
            virtual: ["Práctica de historias de usuario", "Formato SRS IEEE 830"],
            autonomo: ["Documento de ejemplo SRS", "Plantillas de casos de uso"],
            evidencias: [
                { tipo: "desempeno", descripcion: "Simulación de entrevista" },
                { tipo: "producto", descripcion: "Documento de casos de uso" }
            ],
            tags: ["UML", "Requisitos", "IEEE 830", "Casos de uso"]
        },
        {
            num: 3,
            title: "Especificación de Requisitos",
            topic: "Documentación formal del SRS",
            competencia: 1,
            rap: "RAP-001",
            type: "normal",
            presencial: ["Estructura del documento SRS", "Requisitos funcionales y no funcionales"],
            virtual: ["Elaboración de SRS proyecto formativo"],
            autonomo: ["Revisión de estándares IEEE"],
            evidencias: [
                { tipo: "producto", descripcion: "Documento SRS completo" }
            ],
            tags: ["SRS", "Documentación", "IEEE 830"]
        },
        {
            num: 4,
            title: "Evaluación RAP Requisitos",
            topic: "Sustentación del documento de requisitos",
            competencia: 1,
            rap: "RAP-001",
            type: "evaluacion",
            presencial: ["Sustentación de SRS", "Retroalimentación"],
            virtual: ["Correcciones al documento"],
            autonomo: ["Preparación de sustentación"],
            evidencias: [
                { tipo: "conocimiento", descripcion: "Evaluación escrita requisitos" },
                { tipo: "desempeno", descripcion: "Sustentación oral SRS" },
                { tipo: "producto", descripcion: "SRS validado" }
            ],
            tags: ["Evaluación", "SRS", "Sustentación"]
        },
        {
            num: 5,
            title: "Modelado de Datos",
            topic: "Diseño de bases de datos relacionales",
            competencia: 1,
            rap: "RAP-002",
            type: "normal",
            presencial: ["Modelo Entidad-Relación", "Cardinalidad y tipos de relaciones"],
            virtual: ["Práctica en MySQL Workbench", "Diseño de modelo proyecto"],
            autonomo: ["Tutorial normalización de datos"],
            evidencias: [
                { tipo: "producto", descripcion: "Diagrama E-R" }
            ],
            tags: ["E-R", "MySQL", "Modelado", "Base de datos"]
        },
        {
            num: 6,
            title: "SQL y Normalización",
            topic: "Implementación de bases de datos",
            competencia: 1,
            rap: "RAP-002",
            type: "normal",
            presencial: ["DDL: CREATE, ALTER, DROP", "Normalización 1FN, 2FN, 3FN"],
            virtual: ["Creación de base de datos proyecto", "Scripts SQL"],
            autonomo: ["Ejercicios de normalización"],
            evidencias: [
                { tipo: "conocimiento", descripcion: "Quiz normalización" },
                { tipo: "producto", descripcion: "Script DDL base de datos" }
            ],
            tags: ["SQL", "DDL", "Normalización", "PostgreSQL"]
        },
        {
            num: 7,
            title: "Consultas SQL Avanzadas",
            topic: "DML y consultas complejas",
            competencia: 1,
            rap: "RAP-002",
            type: "normal",
            presencial: ["SELECT, INSERT, UPDATE, DELETE", "JOINs y subconsultas"],
            virtual: ["Ejercicios prácticos de queries", "Stored procedures"],
            autonomo: ["Plataforma de práctica SQL"],
            evidencias: [
                { tipo: "desempeno", descripcion: "Resolución de queries en vivo" },
                { tipo: "producto", descripcion: "Banco de consultas SQL" }
            ],
            tags: ["DML", "JOINs", "Queries", "SQL"]
        },
        {
            num: 8,
            title: "Evaluación RAP Base de Datos",
            topic: "Evaluación práctica de implementación BD",
            competencia: 1,
            rap: "RAP-002",
            type: "evaluacion",
            presencial: ["Evaluación práctica SQL", "Sustentación modelo de datos"],
            virtual: ["Documentación del modelo"],
            autonomo: ["Repaso general BD"],
            evidencias: [
                { tipo: "conocimiento", descripcion: "Evaluación teórica BD" },
                { tipo: "desempeno", descripcion: "Evaluación práctica SQL" },
                { tipo: "producto", descripcion: "BD proyecto implementada" }
            ],
            tags: ["Evaluación", "SQL", "Base de datos"]
        },
        {
            num: 9,
            title: "Programación Orientada a Objetos",
            topic: "Fundamentos de POO con Java",
            competencia: 1,
            rap: "RAP-003",
            type: "normal",
            presencial: ["Clases, objetos, atributos, métodos", "Encapsulamiento"],
            virtual: ["Ejercicios prácticos en Java", "IDE IntelliJ/Eclipse"],
            autonomo: ["Tutorial POO básico"],
            evidencias: [
                { tipo: "producto", descripcion: "Ejercicios POO resueltos" }
            ],
            tags: ["Java", "POO", "Clases", "Objetos"]
        },
        {
            num: 10,
            title: "Herencia y Polimorfismo",
            topic: "Pilares avanzados de POO",
            competencia: 1,
            rap: "RAP-003",
            type: "normal",
            presencial: ["Herencia simple y múltiple (interfaces)", "Polimorfismo"],
            virtual: ["Ejercicios de abstracción", "Interfaces y clases abstractas"],
            autonomo: ["Patrones de diseño básicos"],
            evidencias: [
                { tipo: "conocimiento", descripcion: "Quiz POO avanzada" },
                { tipo: "producto", descripcion: "Proyecto POO mini aplicación" }
            ],
            tags: ["Herencia", "Polimorfismo", "Interfaces", "Java"]
        },
        {
            num: 11,
            title: "Desarrollo Backend",
            topic: "APIs REST con Spring Boot",
            competencia: 2,
            rap: "RAP-004",
            type: "normal",
            presencial: ["Introducción a Spring Boot", "Arquitectura MVC"],
            virtual: ["Creación de API REST básica", "Endpoints CRUD"],
            autonomo: ["Documentación Spring Boot"],
            evidencias: [
                { tipo: "producto", descripcion: "API REST funcional" }
            ],
            tags: ["Spring Boot", "REST", "API", "Backend"]
        },
        {
            num: 12,
            title: "Desarrollo Frontend",
            topic: "Interfaces web con React",
            competencia: 2,
            rap: "RAP-004",
            type: "normal",
            presencial: ["Fundamentos de React", "Componentes y props"],
            virtual: ["Desarrollo de interfaz proyecto", "Consumo de API"],
            autonomo: ["Tutorial React oficial"],
            evidencias: [
                { tipo: "producto", descripcion: "Interfaz React conectada a API" }
            ],
            tags: ["React", "Frontend", "JavaScript", "UI"]
        },
        {
            num: 13,
            title: "Integración de Sistemas",
            topic: "Conexión Frontend-Backend",
            competencia: 2,
            rap: "RAP-005",
            type: "normal",
            presencial: ["CORS y seguridad", "Manejo de estados"],
            virtual: ["Integración completa del proyecto", "Git y GitHub"],
            autonomo: ["Control de versiones avanzado"],
            evidencias: [
                { tipo: "desempeno", descripcion: "Demostración de integración" },
                { tipo: "producto", descripcion: "Sistema integrado funcional" }
            ],
            tags: ["Integración", "Git", "GitHub", "Full Stack"]
        },
        {
            num: 14,
            title: "Evaluación Competencia Desarrollo",
            topic: "Evaluación integral del sistema desarrollado",
            competencia: 2,
            rap: "RAP-005",
            type: "evaluacion",
            presencial: ["Sustentación del proyecto", "Revisión de código"],
            virtual: ["Documentación técnica"],
            autonomo: ["Preparación demo"],
            evidencias: [
                { tipo: "conocimiento", descripcion: "Evaluación arquitectura" },
                { tipo: "desempeno", descripcion: "Sustentación proyecto" },
                { tipo: "producto", descripcion: "Sistema completo desplegado" }
            ],
            tags: ["Evaluación", "Sustentación", "Demo"]
        },
        {
            num: 15,
            title: "Pruebas de Software",
            topic: "Testing y aseguramiento de calidad",
            competencia: 3,
            rap: "RAP-006",
            type: "normal",
            presencial: ["Tipos de pruebas", "JUnit y testing unitario"],
            virtual: ["Implementación de tests", "Coverage de código"],
            autonomo: ["TDD - Test Driven Development"],
            evidencias: [
                { tipo: "producto", descripcion: "Suite de pruebas unitarias" }
            ],
            tags: ["Testing", "JUnit", "QA", "TDD"]
        },
        {
            num: 16,
            title: "Documentación y Seguridad",
            topic: "Documentación técnica y buenas prácticas de seguridad",
            competencia: 3,
            rap: "RAP-007",
            type: "normal",
            presencial: ["Documentación con Swagger/OpenAPI", "Principios OWASP"],
            virtual: ["Generación de documentación API", "Implementación JWT"],
            autonomo: ["Top 10 OWASP"],
            evidencias: [
                { tipo: "producto", descripcion: "Documentación API Swagger" },
                { tipo: "conocimiento", descripcion: "Quiz seguridad" }
            ],
            tags: ["Swagger", "OWASP", "JWT", "Documentación"]
        },
        {
            num: 17,
            title: "Despliegue y DevOps",
            topic: "Containerización y despliegue en la nube",
            competencia: 5,
            rap: "RAP-009",
            type: "normal",
            presencial: ["Docker básico", "Conceptos de CI/CD"],
            virtual: ["Dockerización del proyecto", "GitHub Actions"],
            autonomo: ["Tutorial Docker"],
            evidencias: [
                { tipo: "producto", descripcion: "Proyecto dockerizado" },
                { tipo: "desempeno", descripcion: "Demostración de despliegue" }
            ],
            tags: ["Docker", "DevOps", "CI/CD", "Cloud"]
        },
        {
            num: 18,
            title: "Evaluación Final y Cierre",
            topic: "Evaluación integral de competencias",
            competencia: 5,
            rap: "RAP-010",
            type: "cierre",
            presencial: ["Sustentación final del proyecto", "Evaluación de competencias"],
            virtual: ["Entrega de documentación final"],
            autonomo: ["Preparación presentación final"],
            evidencias: [
                { tipo: "conocimiento", descripcion: "Evaluación integral" },
                { tipo: "desempeno", descripcion: "Sustentación final" },
                { tipo: "producto", descripcion: "Proyecto completo desplegado" }
            ],
            tags: ["Evaluación Final", "Cierre", "Sustentación"]
        }
    ],

    // === BADGES POR COMPETENCIAS ===
    badges: [
        {
            id: "starter",
            icon: "🚀",
            name: "Iniciador ADSO",
            desc: "Primer paso en formación",
            requirement: 1,
            type: "general"
        },
        {
            id: "analyst",
            icon: "🔍",
            name: "Analista de Requisitos",
            desc: "RAP Requisitos completado",
            requirement: 4,
            competencia: 1,
            rap: "RAP-001",
            type: "rap"
        },
        {
            id: "db-architect",
            icon: "🗄️",
            name: "Arquitecto de BD",
            desc: "RAP Bases de Datos completado",
            requirement: 8,
            competencia: 1,
            rap: "RAP-002",
            type: "rap"
        },
        {
            id: "developer",
            icon: "💻",
            name: "Desarrollador POO",
            desc: "RAP Desarrollo completado",
            requirement: 10,
            competencia: 1,
            rap: "RAP-003",
            type: "rap"
        },
        {
            id: "full-stack",
            icon: "🌐",
            name: "Full Stack Junior",
            desc: "Competencia arquitectura alcanzada",
            requirement: 14,
            competencia: 2,
            type: "competencia"
        },
        {
            id: "quality-master",
            icon: "✅",
            name: "Experto en Calidad",
            desc: "Competencia calidad alcanzada",
            requirement: 16,
            competencia: 3,
            type: "competencia"
        },
        {
            id: "devops-pro",
            icon: "🐳",
            name: "DevOps Practitioner",
            desc: "Despliegue completado",
            requirement: 17,
            competencia: 5,
            type: "rap"
        },
        {
            id: "tecnologo",
            icon: "🎓",
            name: "Tecnólogo ADSO",
            desc: "Todas las competencias alcanzadas",
            requirement: 18,
            type: "general"
        }
    ]
};

// === ESTADO DE LA APLICACIÓN ===
const STORAGE_KEY = 'sena_ficha_3413974_roadmap_progress';

let state = {
    completedWeeks: [],
    unlockedBadges: [],
    rapProgress: {},
    competenciasProgress: {}
};

// Inicializar progreso de RAP
COURSE_DATA.competencias.forEach(comp => {
    comp.rap.forEach(rap => {
        state.rapProgress[rap.id] = false;
    });
    state.competenciasProgress[comp.id] = 0;
});

// === FUNCIONES DE PERSISTENCIA ===
function loadState() {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
        const parsed = JSON.parse(saved);
        state = { ...state, ...parsed };
    }
}

function saveState() {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
}

// === FUNCIONES DE PROGRESO ===
function updateRAPProgress(rapId, completed) {
    state.rapProgress[rapId] = completed;
    updateCompetenciaProgress();
    saveState();
}

function updateCompetenciaProgress() {
    COURSE_DATA.competencias.forEach(comp => {
        const totalRAP = comp.rap.length;
        const completedRAP = comp.rap.filter(r => state.rapProgress[r.id]).length;
        state.competenciasProgress[comp.id] = Math.round((completedRAP / totalRAP) * 100);
    });
}

function toggleWeekComplete(weekNum) {
    const index = state.completedWeeks.indexOf(weekNum);
    if (index === -1) {
        state.completedWeeks.push(weekNum);
    } else {
        state.completedWeeks.splice(index, 1);
    }
    
    checkBadges();
    saveState();
    renderAll();
}

function checkBadges() {
    const completedCount = state.completedWeeks.length;
    
    COURSE_DATA.badges.forEach(badge => {
        if (completedCount >= badge.requirement && !state.unlockedBadges.includes(badge.id)) {
            state.unlockedBadges.push(badge.id);
            showBadgeNotification(badge);
        }
    });
}

function showBadgeNotification(badge) {
    const notification = document.createElement('div');
    notification.className = 'badge-notification';
    notification.innerHTML = `
        <div class="badge-notification__content">
            <span class="badge-notification__icon">${badge.icon}</span>
            <div>
                <h4>¡Nuevo Badge Desbloqueado!</h4>
                <p>${badge.name}</p>
            </div>
        </div>
    `;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// === FUNCIONES DE RENDERIZADO ===
function renderProgress() {
    const progressFill = document.getElementById('progressFill');
    const completedCount = document.getElementById('completedCount');
    const totalCount = document.getElementById('totalCount');
    
    const completed = state.completedWeeks.length;
    const total = COURSE_DATA.totalWeeks;
    const percentage = Math.round((completed / total) * 100);
    
    progressFill.style.width = `${percentage}%`;
    progressFill.textContent = `${percentage}%`;
    completedCount.textContent = completed;
    totalCount.textContent = total;
}

function renderBadges() {
    const badgesGrid = document.getElementById('badgesGrid');
    badgesGrid.innerHTML = '';
    
    COURSE_DATA.badges.forEach(badge => {
        const isUnlocked = state.unlockedBadges.includes(badge.id);
        const card = document.createElement('div');
        card.className = `badge-card ${isUnlocked ? 'badge-card--unlocked' : 'badge-card--locked'}`;
        card.innerHTML = `
            <div class="badge-card__icon">${badge.icon}</div>
            <div class="badge-card__name">${badge.name}</div>
            <div class="badge-card__desc">${badge.desc}</div>
            ${!isUnlocked ? '<span class="badge-card__lock">🔒</span>' : ''}
        `;
        badgesGrid.appendChild(card);
    });
}

function renderWeeks() {
    const roadmapGrid = document.getElementById('roadmapGrid');
    roadmapGrid.innerHTML = '';
    
    COURSE_DATA.weeks.forEach(week => {
        const isCompleted = state.completedWeeks.includes(week.num);
        const card = document.createElement('div');
        card.className = `week-card week-card--${week.type} ${isCompleted ? 'week-card--completed' : ''}`;
        card.dataset.week = week.num;
        card.dataset.type = week.type;
        card.dataset.competencia = week.competencia;
        card.dataset.rap = week.rap;
        
        const typeIcon = week.type === 'evaluacion' ? '⭐' : week.type === 'cierre' ? '🏆' : '';
        
        card.innerHTML = `
            <div class="week-card__header">
                <span class="week-number">Semana ${week.num}</span>
                <span class="week-badge">${typeIcon}</span>
                <span class="week-card__competencia">C${week.competencia}</span>
            </div>
            
            <h3 class="week-card__title">${week.title}</h3>
            <p class="week-card__topic">${week.topic}</p>
            
            <div class="week-card__content">
                <div class="content-section">
                    <h4>🏫 Presencial</h4>
                    <ul>
                        ${week.presencial.map(item => `<li>${item}</li>`).join('')}
                    </ul>
                </div>
                <div class="content-section">
                    <h4>💻 Virtual</h4>
                    <ul>
                        ${week.virtual.map(item => `<li>${item}</li>`).join('')}
                    </ul>
                </div>
                <div class="content-section">
                    <h4>📚 Autónomo</h4>
                    <ul>
                        ${week.autonomo.map(item => `<li>${item}</li>`).join('')}
                    </ul>
                </div>
            </div>
            
            <div class="week-card__evidencias">
                <h4>Evidencias:</h4>
                <div>
                    ${week.evidencias.map(ev => `
                        <span class="evidencia-item">
                            ${ev.tipo === 'conocimiento' ? '📝' : ev.tipo === 'desempeno' ? '🎭' : '📦'}
                            ${ev.descripcion}
                        </span>
                    `).join('')}
                </div>
            </div>
            
            <div class="week-card__tags">
                ${week.tags.map(tag => `<span class="tag">${tag}</span>`).join('')}
            </div>
            
            <button class="week-card__complete-btn" onclick="toggleWeekComplete(${week.num})">
                ${isCompleted ? '✓ Completada' : 'Marcar como completada'}
            </button>
        `;
        
        roadmapGrid.appendChild(card);
    });
}

function renderAll() {
    renderProgress();
    renderBadges();
    renderWeeks();
}

// === FILTROS ===
function filterWeeks(filter) {
    const weekCards = document.querySelectorAll('.week-card');
    
    // Actualizar botones activos
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.filter === filter);
    });
    
    weekCards.forEach(card => {
        let show = true;
        const weekNum = parseInt(card.dataset.week);
        const type = card.dataset.type;
        const competencia = card.dataset.competencia;
        const isCompleted = state.completedWeeks.includes(weekNum);
        
        switch(filter) {
            case 'all':
                show = true;
                break;
            case 'evaluacion':
                show = type === 'evaluacion' || type === 'cierre';
                break;
            case 'pending':
                show = !isCompleted;
                break;
            case 'completed':
                show = isCompleted;
                break;
            default:
                if (filter.startsWith('competencia-')) {
                    const compId = filter.split('-')[1];
                    show = competencia === compId;
                }
        }
        
        card.style.display = show ? '' : 'none';
    });
}

// === INICIALIZACIÓN ===
document.addEventListener('DOMContentLoaded', () => {
    loadState();
    checkBadges();
    renderAll();
    
    // Event listeners para filtros
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            filterWeeks(btn.dataset.filter);
        });
    });
});

// === ESTILOS ADICIONALES PARA NOTIFICACIONES ===
const notificationStyles = document.createElement('style');
notificationStyles.textContent = `
    .badge-notification {
        position: fixed;
        top: 20px;
        right: 20px;
        background: linear-gradient(135deg, #FF5200, #CC4200);
        padding: 1rem 1.5rem;
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(255, 82, 0, 0.4);
        transform: translateX(120%);
        transition: transform 0.3s ease;
        z-index: 1000;
    }
    
    .badge-notification.show {
        transform: translateX(0);
    }
    
    .badge-notification__content {
        display: flex;
        align-items: center;
        gap: 1rem;
        color: white;
    }
    
    .badge-notification__icon {
        font-size: 2.5rem;
    }
    
    .badge-notification h4 {
        font-size: 0.9rem;
        margin-bottom: 0.25rem;
    }
    
    .badge-notification p {
        font-size: 1.1rem;
        font-weight: 600;
    }
`;
document.head.appendChild(notificationStyles);
