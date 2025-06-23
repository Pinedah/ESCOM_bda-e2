// ==============================================================
// MODELO ORIENTADO A GRAFOS - NEO4J
// Esquema de Nodos y Relaciones para el Sistema de Películas
// ==============================================================

// Crear índices únicos para nodos principales
CREATE CONSTRAINT persona_id IF NOT EXISTS FOR (p:Persona) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT pelicula_id IF NOT EXISTS FOR (p:Pelicula) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT estudio_id IF NOT EXISTS FOR (e:Estudio) REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT genero_id IF NOT EXISTS FOR (g:Genero) REQUIRE g.id IS UNIQUE;
CREATE CONSTRAINT pais_id IF NOT EXISTS FOR (p:Pais) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT idioma_id IF NOT EXISTS FOR (i:Idioma) REQUIRE i.id IS UNIQUE;
CREATE CONSTRAINT premio_id IF NOT EXISTS FOR (p:Premio) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT critica_id IF NOT EXISTS FOR (c:Critica) REQUIRE c.id IS UNIQUE;

// Crear índices para búsquedas frecuentes
CREATE INDEX persona_nombre IF NOT EXISTS FOR (p:Persona) ON (p.nombre);
CREATE INDEX pelicula_titulo IF NOT EXISTS FOR (p:Pelicula) ON (p.titulo);
CREATE INDEX pelicula_año IF NOT EXISTS FOR (p:Pelicula) ON (p.año_lanzamiento);
CREATE INDEX pelicula_rating IF NOT EXISTS FOR (p:Pelicula) ON (p.rating);
CREATE INDEX estudio_nombre IF NOT EXISTS FOR (e:Estudio) ON (e.nombre);
CREATE INDEX genero_nombre IF NOT EXISTS FOR (g:Genero) ON (g.nombre);

// ==============================================================
// ESTRUCTURA DEL GRAFO:
//
// NODOS:
// - Persona (directores, actores, productores)
// - Pelicula
// - Estudio
// - Genero
// - Pais
// - Idioma
// - Premio
// - Critica
//
// RELACIONES:
// - DIRIGIO (Persona -> Pelicula)
// - ACTUO_EN (Persona -> Pelicula) {papel}
// - PRODUJO (Persona -> Pelicula)
// - PERTENECE_A (Pelicula -> Genero)
// - PRODUCIDA_POR (Pelicula -> Estudio)
// - ORIGEN (Pelicula -> Pais)
// - EN_IDIOMA (Pelicula -> Idioma)
// - GANO_PREMIO (Persona/Pelicula -> Premio) {año, categoria}
// - RECIBIO_CRITICA (Pelicula -> Critica)
// - COLABORO_CON (Persona -> Persona) {peliculas_en_comun}
// ==============================================================

// Mostrar esquema creado
CALL db.schema.visualization();
