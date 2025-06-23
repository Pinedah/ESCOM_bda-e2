# 🎬 CRUD Interface - Cine DB MongoDB

## Descripción

Interfaz gráfica minimalista para realizar operaciones CRUD básicas sobre el modelo JSON de MongoDB del sistema de gestión cinematográfica. Esta interfaz permite gestionar películas, personas (actores, directores, productores) y críticas de manera sencilla y visual.

## Características

### ✨ Funcionalidades Principales

- **Gestión de Películas**: Crear, leer, actualizar y eliminar películas
- **Gestión de Personas**: Manejar actores, directores y productores
- **Gestión de Críticas**: Administrar críticas cinematográficas
- **Búsqueda y Filtrado**: Buscar por texto y filtrar por categorías
- **Interfaz Responsiva**: Adaptable a diferentes tamaños de pantalla

### 🎨 Diseño

- **Minimalista**: Interfaz limpia y sin distracciones
- **Moderno**: Diseño glassmorphism con efectos de transparencia
- **Intuitivo**: Navegación simple y clara
- **Accesible**: Colores contrastantes y tipografía legible

## Estructura de Archivos

```
crud_interface/
├── index.html          # Estructura HTML principal
├── styles.css          # Estilos CSS con diseño moderno
├── script.js           # Lógica JavaScript para CRUD
└── README.md           # Este archivo
```

## Cómo Usar

### 1. Abrir la Interfaz

Simplemente abre el archivo `index.html` en cualquier navegador web moderno.

### 2. Navegación

La interfaz tiene tres secciones principales:

- **📽️ Películas**: Gestionar el catálogo de películas
- **👥 Personas**: Administrar actores, directores y productores  
- **📝 Críticas**: Manejar reseñas y críticas

### 3. Operaciones CRUD

#### Crear
1. Llena el formulario en la parte superior de cada sección
2. Haz clic en "💾 Guardar"

#### Leer
- Los elementos se muestran automáticamente en tarjetas
- Usa la barra de búsqueda para filtrar resultados

#### Actualizar
1. Haz clic en "✏️ Editar" en cualquier tarjeta
2. Modifica los campos en el formulario
3. Haz clic en "💾 Guardar"

#### Eliminar
1. Haz clic en "🗑️ Eliminar" en cualquier tarjeta
2. Confirma la acción en el modal

### 4. Funciones de Búsqueda

- **Películas**: Buscar por título, director o país
- **Personas**: Buscar por nombre o país, filtrar por tipo
- **Críticas**: Buscar por película, autor o medio

## Datos de Ejemplo

La interfaz viene preconfigurada con datos de ejemplo:

### Películas
- Cinema Paradiso (Giuseppe Tornatore, 1988)
- La Dolce Vita (Federico Fellini, 1960)

### Personas
- Giuseppe Tornatore (Director)
- Philippe Noiret (Actor)
- Franco Cristaldi (Productor)

### Críticas
- Críticas de las películas de ejemplo

## Validaciones

### Películas
- Título: Requerido, máximo 150 caracteres
- Resumen: Requerido, máximo 3000 caracteres
- Ranking: Entre 1.0 y 5.0
- Fecha de estreno: Requerida

### Personas
- Nombre: Requerido, máximo 100 caracteres
- Tipo: Actor, Director o Productor
- Estado civil: Opciones predefinidas
- Fecha de nacimiento: Requerida

### Críticas
- Película: Debe seleccionar una película existente
- Puntuación: Entre 1.0 y 5.0
- Autor, medio y contenido: Requeridos

## Características Técnicas

### Tecnologías Utilizadas
- **HTML5**: Estructura semántica
- **CSS3**: Estilos modernos con flexbox y grid
- **JavaScript ES6+**: Lógica de aplicación
- **Responsive Design**: Adaptable a móviles y escritorio

### Compatibilidad
- Chrome 70+
- Firefox 65+
- Safari 12+
- Edge 79+

### Funcionalidades Avanzadas
- **Persistencia Local**: Los datos se mantienen en memoria durante la sesión
- **Notificaciones**: Confirmaciones visuales de acciones
- **Modal de Confirmación**: Para acciones destructivas
- **Búsqueda en Tiempo Real**: Filtrado instantáneo
- **Animaciones Suaves**: Transiciones CSS

## Integración con MongoDB

### Nota Importante
Esta interfaz actualmente funciona con **datos simulados** en JavaScript. Para integrar con MongoDB real:

1. **Backend API**: Crear un servidor (Node.js/Express, Python/Flask, etc.)
2. **Endpoints REST**: Implementar rutas CRUD
3. **Conexión MongoDB**: Usar mongoose, pymongo, etc.
4. **AJAX/Fetch**: Reemplazar funciones de datos simulados

### Ejemplo de Integración

```javascript
// En lugar de datos simulados, usar fetch API
async function getPeliculas() {
    const response = await fetch('/api/peliculas');
    return response.json();
}

async function createPelicula(pelicula) {
    const response = await fetch('/api/peliculas', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(pelicula)
    });
    return response.json();
}
```

## Personalización

### Colores
Modificar las variables CSS en `styles.css`:

```css
:root {
    --primary-color: #667eea;
    --secondary-color: #764ba2;
    --background: #f7fafc;
}
```

### Campos del Formulario
Agregar nuevos campos modificando:
1. HTML en `index.html`
2. Validaciones en `script.js`
3. Estilos en `styles.css`

## Troubleshooting

### Problemas Comunes

1. **La interfaz no carga**
   - Verificar que todos los archivos estén en la misma carpeta
   - Usar un servidor local (Live Server, http-server, etc.)

2. **Los estilos no se aplican**
   - Verificar la ruta del archivo CSS
   - Limpiar caché del navegador

3. **JavaScript no funciona**
   - Abrir DevTools y revisar errores en consola
   - Verificar compatibilidad del navegador

## Contribuir

Para mejorar esta interfaz:

1. **Fork** el proyecto
2. **Crear** una rama para tu feature
3. **Commit** tus cambios
4. **Push** a la rama
5. **Crear** un Pull Request

## Licencia

Este proyecto está bajo la licencia MIT - ver el archivo LICENSE para detalles.

---

**Desarrollado para ESCOM - Base de Datos Avanzadas 2025-2**
