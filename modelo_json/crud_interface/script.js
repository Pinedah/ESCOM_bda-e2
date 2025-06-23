// CRUD Interface JavaScript - MongoDB Cinema DB
// Simulación de datos para demostración (en producción se conectaría a MongoDB)

// Datos simulados
let peliculasData = [
    {
        id: "1",
        titulo: "Cinema Paradiso",
        resumen: "Un hombre maduro recuerda su infancia en un pequeño pueblo siciliano, donde desarrolló una amistad especial con el proyeccionista del cine local. A través de flashbacks, la película explora temas de nostalgia, pérdida de la inocencia y el poder transformador del cine.",
        fecha_estreno: "1988-11-17",
        ranking: 4.8,
        director: "Giuseppe Tornatore",
        pais: "Italia"
    },
    {
        id: "2",
        titulo: "La Dolce Vita",
        resumen: "Marcello Rubini, un periodista romano, vive una vida hedonista entre la alta sociedad romana, buscando historias para revistas de chismes. La película retrata la decadencia moral de la sociedad italiana de los años 60.",
        fecha_estreno: "1960-02-05",
        ranking: 4.7,
        director: "Federico Fellini",
        pais: "Italia"
    }
];

let personasData = [
    {
        id: "1",
        tipo_persona: "Director",
        nombre: "Giuseppe Tornatore",
        fecha_nacimiento: "1956-05-27",
        estado_civil: "Casado",
        telefono: "+39-091-123456",
        pais: "Italia"
    },
    {
        id: "2",
        tipo_persona: "Actor",
        nombre: "Philippe Noiret",
        fecha_nacimiento: "1930-10-01",
        estado_civil: "Casado",
        telefono: "+33-01-444555",
        pais: "Francia"
    },
    {
        id: "3",
        tipo_persona: "Productor",
        nombre: "Franco Cristaldi",
        fecha_nacimiento: "1924-10-03",
        estado_civil: "Casado",
        telefono: "+39-06-111222",
        pais: "Italia"
    }
];

let criticasData = [
    {
        id: "1",
        pelicula_id: "1",
        pelicula_titulo: "Cinema Paradiso",
        autor: "Mario Sesti",
        medio: "La Gazzetta dello Sport",
        fecha: "1990-08-20",
        contenido: "Una obra maestra del cine italiano que captura la esencia de la nostalgia con una maestría técnica excepcional.",
        puntuacion: 4.8
    },
    {
        id: "2",
        pelicula_id: "2",
        pelicula_titulo: "La Dolce Vita",
        autor: "Tullio Kezich",
        medio: "La Repubblica",
        fecha: "1961-03-15",
        contenido: "Fellini crea un retrato magistral de la sociedad italiana con una narrativa visual extraordinaria.",
        puntuacion: 4.7
    }
];

// Estado de la aplicación
let currentEditingId = null;
let currentSection = 'peliculas';

// Inicialización
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
    setupEventListeners();
    loadData();
});

function initializeApp() {
    showSection('peliculas');
    loadPeliculasSelect();
}

function setupEventListeners() {
    // Formularios
    document.getElementById('peliculaForm').addEventListener('submit', handlePeliculaSubmit);
    document.getElementById('personaForm').addEventListener('submit', handlePersonaSubmit);
    document.getElementById('criticaForm').addEventListener('submit', handleCriticaSubmit);
    
    // Búsquedas
    document.getElementById('searchPeliculas').addEventListener('input', filterPeliculas);
    document.getElementById('searchPersonas').addEventListener('input', filterPersonas);
    document.getElementById('searchCriticas').addEventListener('input', filterCriticas);
    document.getElementById('filterTipo').addEventListener('change', filterPersonas);
    
    // Modal
    document.getElementById('confirmYes').addEventListener('click', confirmDelete);
    document.getElementById('confirmNo').addEventListener('click', closeModal);
}

// Navegación
function showSection(sectionName) {
    // Ocultar todas las secciones
    document.querySelectorAll('.section').forEach(section => {
        section.classList.remove('active');
    });
    
    // Mostrar sección seleccionada
    document.getElementById(sectionName).classList.add('active');
    
    // Actualizar botones de navegación
    document.querySelectorAll('.nav-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    
    event.target.classList.add('active');
    currentSection = sectionName;
}

// Utilidades
function generateId() {
    return Date.now().toString() + Math.random().toString(36).substr(2, 9);
}

function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString('es-ES');
}

function clearForm(formId) {
    document.getElementById(formId).reset();
    currentEditingId = null;
    
    // Limpiar campos ocultos
    const hiddenInputs = document.querySelectorAll(`#${formId} input[type="hidden"]`);
    hiddenInputs.forEach(input => input.value = '');
}

// CRUD Películas
function handlePeliculaSubmit(e) {
    e.preventDefault();
    
    const formData = {
        titulo: document.getElementById('titulo').value,
        resumen: document.getElementById('resumen').value,
        fecha_estreno: document.getElementById('fechaEstreno').value,
        ranking: parseFloat(document.getElementById('ranking').value),
        director: document.getElementById('director').value,
        pais: document.getElementById('pais').value
    };
    
    if (currentEditingId) {
        // Editar película existente
        const index = peliculasData.findIndex(p => p.id === currentEditingId);
        if (index !== -1) {
            peliculasData[index] = { ...peliculasData[index], ...formData };
            showNotification('Película actualizada correctamente', 'success');
        }
    } else {
        // Agregar nueva película
        const newPelicula = {
            id: generateId(),
            ...formData
        };
        peliculasData.push(newPelicula);
        showNotification('Película agregada correctamente', 'success');
    }
    
    clearForm('peliculaForm');
    renderPeliculas();
    loadPeliculasSelect();
}

function renderPeliculas() {
    const container = document.getElementById('peliculasList');
    
    if (peliculasData.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <h3>No hay películas</h3>
                <p>Agrega la primera película usando el formulario de arriba</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = peliculasData.map(pelicula => `
        <div class="item-card">
            <div class="item-header">
                <div class="item-title">${pelicula.titulo}</div>
                <div class="item-type">⭐ ${pelicula.ranking}</div>
            </div>
            <div class="item-details">
                <strong>Director:</strong> ${pelicula.director}<br>
                <strong>Estreno:</strong> ${formatDate(pelicula.fecha_estreno)}<br>
                <strong>País:</strong> ${pelicula.pais}<br>
                <strong>Resumen:</strong> ${pelicula.resumen.substring(0, 200)}...
            </div>
            <div class="item-actions">
                <button class="btn btn-edit" onclick="editPelicula('${pelicula.id}')">
                    ✏️ Editar
                </button>
                <button class="btn btn-delete" onclick="deletePelicula('${pelicula.id}')">
                    🗑️ Eliminar
                </button>
            </div>
        </div>
    `).join('');
}

function editPelicula(id) {
    const pelicula = peliculasData.find(p => p.id === id);
    if (!pelicula) return;
    
    currentEditingId = id;
    
    // Llenar formulario
    document.getElementById('peliculaId').value = id;
    document.getElementById('titulo').value = pelicula.titulo;
    document.getElementById('resumen').value = pelicula.resumen;
    document.getElementById('fechaEstreno').value = pelicula.fecha_estreno;
    document.getElementById('ranking').value = pelicula.ranking;
    document.getElementById('director').value = pelicula.director;
    document.getElementById('pais').value = pelicula.pais;
    
    // Scroll al formulario
    document.querySelector('.form-container').scrollIntoView({ behavior: 'smooth' });
}

function deletePelicula(id) {
    const pelicula = peliculasData.find(p => p.id === id);
    if (!pelicula) return;
    
    showConfirmModal(
        `¿Estás seguro de que deseas eliminar la película "${pelicula.titulo}"?`,
        () => {
            peliculasData = peliculasData.filter(p => p.id !== id);
            renderPeliculas();
            loadPeliculasSelect();
            showNotification('Película eliminada correctamente', 'success');
        }
    );
}

function filterPeliculas() {
    const searchTerm = document.getElementById('searchPeliculas').value.toLowerCase();
    const filteredPeliculas = peliculasData.filter(pelicula => 
        pelicula.titulo.toLowerCase().includes(searchTerm) ||
        pelicula.director.toLowerCase().includes(searchTerm) ||
        pelicula.pais.toLowerCase().includes(searchTerm)
    );
    
    renderFilteredPeliculas(filteredPeliculas);
}

function renderFilteredPeliculas(peliculas) {
    const container = document.getElementById('peliculasList');
    
    if (peliculas.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <h3>No se encontraron películas</h3>
                <p>Intenta con otros términos de búsqueda</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = peliculas.map(pelicula => `
        <div class="item-card">
            <div class="item-header">
                <div class="item-title">${pelicula.titulo}</div>
                <div class="item-type">⭐ ${pelicula.ranking}</div>
            </div>
            <div class="item-details">
                <strong>Director:</strong> ${pelicula.director}<br>
                <strong>Estreno:</strong> ${formatDate(pelicula.fecha_estreno)}<br>
                <strong>País:</strong> ${pelicula.pais}<br>
                <strong>Resumen:</strong> ${pelicula.resumen.substring(0, 200)}...
            </div>
            <div class="item-actions">
                <button class="btn btn-edit" onclick="editPelicula('${pelicula.id}')">
                    ✏️ Editar
                </button>
                <button class="btn btn-delete" onclick="deletePelicula('${pelicula.id}')">
                    🗑️ Eliminar
                </button>
            </div>
        </div>
    `).join('');
}

// CRUD Personas
function handlePersonaSubmit(e) {
    e.preventDefault();
    
    const formData = {
        tipo_persona: document.getElementById('tipoPersona').value,
        nombre: document.getElementById('nombrePersona').value,
        fecha_nacimiento: document.getElementById('fechaNacimiento').value,
        estado_civil: document.getElementById('estadoCivil').value,
        telefono: document.getElementById('telefono').value,
        pais: document.getElementById('paisPersona').value
    };
    
    if (currentEditingId) {
        // Editar persona existente
        const index = personasData.findIndex(p => p.id === currentEditingId);
        if (index !== -1) {
            personasData[index] = { ...personasData[index], ...formData };
            showNotification('Persona actualizada correctamente', 'success');
        }
    } else {
        // Agregar nueva persona
        const newPersona = {
            id: generateId(),
            ...formData
        };
        personasData.push(newPersona);
        showNotification('Persona agregada correctamente', 'success');
    }
    
    clearForm('personaForm');
    renderPersonas();
}

function renderPersonas() {
    const container = document.getElementById('personasList');
    
    if (personasData.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <h3>No hay personas</h3>
                <p>Agrega la primera persona usando el formulario de arriba</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = personasData.map(persona => `
        <div class="item-card">
            <div class="item-header">
                <div class="item-title">${persona.nombre}</div>
                <div class="item-type">${getPersonaIcon(persona.tipo_persona)} ${persona.tipo_persona}</div>
            </div>
            <div class="item-details">
                <strong>Nacimiento:</strong> ${formatDate(persona.fecha_nacimiento)}<br>
                <strong>Estado Civil:</strong> ${persona.estado_civil}<br>
                <strong>Teléfono:</strong> ${persona.telefono}<br>
                <strong>País:</strong> ${persona.pais}
            </div>
            <div class="item-actions">
                <button class="btn btn-edit" onclick="editPersona('${persona.id}')">
                    ✏️ Editar
                </button>
                <button class="btn btn-delete" onclick="deletePersona('${persona.id}')">
                    🗑️ Eliminar
                </button>
            </div>
        </div>
    `).join('');
}

function getPersonaIcon(tipo) {
    switch(tipo) {
        case 'Actor': return '🎭';
        case 'Director': return '🎬';
        case 'Productor': return '🎪';
        default: return '👤';
    }
}

function editPersona(id) {
    const persona = personasData.find(p => p.id === id);
    if (!persona) return;
    
    currentEditingId = id;
    
    // Llenar formulario
    document.getElementById('personaId').value = id;
    document.getElementById('tipoPersona').value = persona.tipo_persona;
    document.getElementById('nombrePersona').value = persona.nombre;
    document.getElementById('fechaNacimiento').value = persona.fecha_nacimiento;
    document.getElementById('estadoCivil').value = persona.estado_civil;
    document.getElementById('telefono').value = persona.telefono;
    document.getElementById('paisPersona').value = persona.pais;
    
    // Scroll al formulario
    document.querySelector('#personas .form-container').scrollIntoView({ behavior: 'smooth' });
}

function deletePersona(id) {
    const persona = personasData.find(p => p.id === id);
    if (!persona) return;
    
    showConfirmModal(
        `¿Estás seguro de que deseas eliminar a "${persona.nombre}"?`,
        () => {
            personasData = personasData.filter(p => p.id !== id);
            renderPersonas();
            showNotification('Persona eliminada correctamente', 'success');
        }
    );
}

function filterPersonas() {
    const searchTerm = document.getElementById('searchPersonas').value.toLowerCase();
    const tipoFilter = document.getElementById('filterTipo').value;
    
    let filteredPersonas = personasData.filter(persona => {
        const matchesSearch = persona.nombre.toLowerCase().includes(searchTerm) ||
                             persona.pais.toLowerCase().includes(searchTerm);
        const matchesType = !tipoFilter || persona.tipo_persona === tipoFilter;
        
        return matchesSearch && matchesType;
    });
    
    renderFilteredPersonas(filteredPersonas);
}

function renderFilteredPersonas(personas) {
    const container = document.getElementById('personasList');
    
    if (personas.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <h3>No se encontraron personas</h3>
                <p>Intenta con otros términos de búsqueda</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = personas.map(persona => `
        <div class="item-card">
            <div class="item-header">
                <div class="item-title">${persona.nombre}</div>
                <div class="item-type">${getPersonaIcon(persona.tipo_persona)} ${persona.tipo_persona}</div>
            </div>
            <div class="item-details">
                <strong>Nacimiento:</strong> ${formatDate(persona.fecha_nacimiento)}<br>
                <strong>Estado Civil:</strong> ${persona.estado_civil}<br>
                <strong>Teléfono:</strong> ${persona.telefono}<br>
                <strong>País:</strong> ${persona.pais}
            </div>
            <div class="item-actions">
                <button class="btn btn-edit" onclick="editPersona('${persona.id}')">
                    ✏️ Editar
                </button>
                <button class="btn btn-delete" onclick="deletePersona('${persona.id}')">
                    🗑️ Eliminar
                </button>
            </div>
        </div>
    `).join('');
}

// CRUD Críticas
function handleCriticaSubmit(e) {
    e.preventDefault();
    
    const peliculaId = document.getElementById('peliculaCritica').value;
    const pelicula = peliculasData.find(p => p.id === peliculaId);
    
    const formData = {
        pelicula_id: peliculaId,
        pelicula_titulo: pelicula ? pelicula.titulo : 'Película no encontrada',
        autor: document.getElementById('autor').value,
        medio: document.getElementById('medio').value,
        fecha: document.getElementById('fechaCritica').value,
        contenido: document.getElementById('contenido').value,
        puntuacion: parseFloat(document.getElementById('puntuacion').value)
    };
    
    if (currentEditingId) {
        // Editar crítica existente
        const index = criticasData.findIndex(c => c.id === currentEditingId);
        if (index !== -1) {
            criticasData[index] = { ...criticasData[index], ...formData };
            showNotification('Crítica actualizada correctamente', 'success');
        }
    } else {
        // Agregar nueva crítica
        const newCritica = {
            id: generateId(),
            ...formData
        };
        criticasData.push(newCritica);
        showNotification('Crítica agregada correctamente', 'success');
    }
    
    clearForm('criticaForm');
    renderCriticas();
}

function renderCriticas() {
    const container = document.getElementById('criticasList');
    
    if (criticasData.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <h3>No hay críticas</h3>
                <p>Agrega la primera crítica usando el formulario de arriba</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = criticasData.map(critica => `
        <div class="item-card">
            <div class="item-header">
                <div class="item-title">${critica.pelicula_titulo}</div>
                <div class="item-type">⭐ ${critica.puntuacion}</div>
            </div>
            <div class="item-details">
                <strong>Autor:</strong> ${critica.autor}<br>
                <strong>Medio:</strong> ${critica.medio}<br>
                <strong>Fecha:</strong> ${formatDate(critica.fecha)}<br>
                <strong>Contenido:</strong> ${critica.contenido.substring(0, 200)}...
            </div>
            <div class="item-actions">
                <button class="btn btn-edit" onclick="editCritica('${critica.id}')">
                    ✏️ Editar
                </button>
                <button class="btn btn-delete" onclick="deleteCritica('${critica.id}')">
                    🗑️ Eliminar
                </button>
            </div>
        </div>
    `).join('');
}

function editCritica(id) {
    const critica = criticasData.find(c => c.id === id);
    if (!critica) return;
    
    currentEditingId = id;
    
    // Llenar formulario
    document.getElementById('criticaId').value = id;
    document.getElementById('peliculaCritica').value = critica.pelicula_id;
    document.getElementById('autor').value = critica.autor;
    document.getElementById('medio').value = critica.medio;
    document.getElementById('fechaCritica').value = critica.fecha;
    document.getElementById('contenido').value = critica.contenido;
    document.getElementById('puntuacion').value = critica.puntuacion;
    
    // Scroll al formulario
    document.querySelector('#criticas .form-container').scrollIntoView({ behavior: 'smooth' });
}

function deleteCritica(id) {
    const critica = criticasData.find(c => c.id === id);
    if (!critica) return;
    
    showConfirmModal(
        `¿Estás seguro de que deseas eliminar la crítica de "${critica.pelicula_titulo}"?`,
        () => {
            criticasData = criticasData.filter(c => c.id !== id);
            renderCriticas();
            showNotification('Crítica eliminada correctamente', 'success');
        }
    );
}

function filterCriticas() {
    const searchTerm = document.getElementById('searchCriticas').value.toLowerCase();
    const filteredCriticas = criticasData.filter(critica => 
        critica.pelicula_titulo.toLowerCase().includes(searchTerm) ||
        critica.autor.toLowerCase().includes(searchTerm) ||
        critica.medio.toLowerCase().includes(searchTerm)
    );
    
    renderFilteredCriticas(filteredCriticas);
}

function renderFilteredCriticas(criticas) {
    const container = document.getElementById('criticasList');
    
    if (criticas.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <h3>No se encontraron críticas</h3>
                <p>Intenta con otros términos de búsqueda</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = criticas.map(critica => `
        <div class="item-card">
            <div class="item-header">
                <div class="item-title">${critica.pelicula_titulo}</div>
                <div class="item-type">⭐ ${critica.puntuacion}</div>
            </div>
            <div class="item-details">
                <strong>Autor:</strong> ${critica.autor}<br>
                <strong>Medio:</strong> ${critica.medio}<br>
                <strong>Fecha:</strong> ${formatDate(critica.fecha)}<br>
                <strong>Contenido:</strong> ${critica.contenido.substring(0, 200)}...
            </div>
            <div class="item-actions">
                <button class="btn btn-edit" onclick="editCritica('${critica.id}')">
                    ✏️ Editar
                </button>
                <button class="btn btn-delete" onclick="deleteCritica('${critica.id}')">
                    🗑️ Eliminar
                </button>
            </div>
        </div>
    `).join('');
}

// Funciones auxiliares
function loadPeliculasSelect() {
    const select = document.getElementById('peliculaCritica');
    select.innerHTML = '<option value="">Seleccionar película...</option>';
    
    peliculasData.forEach(pelicula => {
        const option = document.createElement('option');
        option.value = pelicula.id;
        option.textContent = pelicula.titulo;
        select.appendChild(option);
    });
}

function loadData() {
    renderPeliculas();
    renderPersonas();
    renderCriticas();
}

// Modal de confirmación
function showConfirmModal(message, callback) {
    document.getElementById('confirmMessage').textContent = message;
    document.getElementById('confirmModal').style.display = 'block';
    
    // Guardar callback para usar en confirmDelete
    window.confirmCallback = callback;
}

function confirmDelete() {
    if (window.confirmCallback) {
        window.confirmCallback();
        window.confirmCallback = null;
    }
    closeModal();
}

function closeModal() {
    document.getElementById('confirmModal').style.display = 'none';
    window.confirmCallback = null;
}

// Notificaciones
function showNotification(message, type = 'info') {
    // Crear elemento de notificación
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    
    // Estilos
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? '#48bb78' : '#f56565'};
        color: white;
        padding: 15px 25px;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        z-index: 1001;
        animation: slideIn 0.3s ease-out;
    `;
    
    document.body.appendChild(notification);
    
    // Remover después de 3 segundos
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-out forwards';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Agregar estilos de animación
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
`;
document.head.appendChild(style);

// Cerrar modal al hacer clic fuera
window.onclick = function(event) {
    const modal = document.getElementById('confirmModal');
    if (event.target === modal) {
        closeModal();
    }
}
