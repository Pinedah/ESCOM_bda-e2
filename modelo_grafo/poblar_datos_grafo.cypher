// ==============================================================
// POBLAR DATOS - MODELO ORIENTADO A GRAFOS NEO4J
// Inserción de datos realistas para el sistema de películas
// ==============================================================

// Limpiar datos existentes
MATCH (n) DETACH DELETE n;

// ==============================================================
// 1. CREAR NODOS DE CATÁLOGO
// ==============================================================

// Géneros
CREATE 
(:Genero {id: 1, nombre: 'Drama', descripcion: 'Películas dramáticas con temática seria'}),
(:Genero {id: 2, nombre: 'Comedia', descripcion: 'Películas de humor y entretenimiento'}),
(:Genero {id: 3, nombre: 'Acción', descripcion: 'Películas de aventuras y acción'}),
(:Genero {id: 4, nombre: 'Romance', descripcion: 'Películas románticas'}),
(:Genero {id: 5, nombre: 'Thriller', descripcion: 'Películas de suspenso y tensión'}),
(:Genero {id: 6, nombre: 'Ciencia Ficción', descripcion: 'Películas futuristas y tecnológicas'}),
(:Genero {id: 7, nombre: 'Fantasía', descripcion: 'Películas de mundos imaginarios'}),
(:Genero {id: 8, nombre: 'Terror', descripcion: 'Películas de miedo y horror'}),
(:Genero {id: 9, nombre: 'Animación', descripcion: 'Películas animadas'}),
(:Genero {id: 10, nombre: 'Documental', descripcion: 'Documentales informativos'});

// Países
CREATE 
(:Pais {id: 1, nombre: 'Estados Unidos', codigo: 'US'}),
(:Pais {id: 2, nombre: 'Reino Unido', codigo: 'UK'}),
(:Pais {id: 3, nombre: 'Francia', codigo: 'FR'}),
(:Pais {id: 4, nombre: 'Italia', codigo: 'IT'}),
(:Pais {id: 5, nombre: 'España', codigo: 'ES'}),
(:Pais {id: 6, nombre: 'Alemania', codigo: 'DE'}),
(:Pais {id: 7, nombre: 'Japón', codigo: 'JP'}),
(:Pais {id: 8, nombre: 'Canadá', codigo: 'CA'}),
(:Pais {id: 9, nombre: 'Australia', codigo: 'AU'}),
(:Pais {id: 10, nombre: 'México', codigo: 'MX'});

// Idiomas
CREATE 
(:Idioma {id: 1, nombre: 'Inglés', codigo: 'en'}),
(:Idioma {id: 2, nombre: 'Español', codigo: 'es'}),
(:Idioma {id: 3, nombre: 'Francés', codigo: 'fr'}),
(:Idioma {id: 4, nombre: 'Italiano', codigo: 'it'}),
(:Idioma {id: 5, nombre: 'Alemán', codigo: 'de'}),
(:Idioma {id: 6, nombre: 'Japonés', codigo: 'ja'}),
(:Idioma {id: 7, nombre: 'Mandarín', codigo: 'zh'}),
(:Idioma {id: 8, nombre: 'Portugués', codigo: 'pt'}),
(:Idioma {id: 9, nombre: 'Ruso', codigo: 'ru'}),
(:Idioma {id: 10, nombre: 'Árabe', codigo: 'ar'});

// Estudios
CREATE 
(:Estudio {id: 1, nombre: 'Warner Bros', fundacion: 1923, pais: 'Estados Unidos'}),
(:Estudio {id: 2, nombre: 'Universal Studios', fundacion: 1912, pais: 'Estados Unidos'}),
(:Estudio {id: 3, nombre: 'Paramount Pictures', fundacion: 1912, pais: 'Estados Unidos'}),
(:Estudio {id: 4, nombre: 'Disney', fundacion: 1923, pais: 'Estados Unidos'}),
(:Estudio {id: 5, nombre: 'Sony Pictures', fundacion: 1918, pais: 'Estados Unidos'}),
(:Estudio {id: 6, nombre: '20th Century Fox', fundacion: 1935, pais: 'Estados Unidos'}),
(:Estudio {id: 7, nombre: 'MGM', fundacion: 1924, pais: 'Estados Unidos'}),
(:Estudio {id: 8, nombre: 'Lionsgate', fundacion: 1997, pais: 'Estados Unidos'}),
(:Estudio {id: 9, nombre: 'Miramax', fundacion: 1979, pais: 'Estados Unidos'}),
(:Estudio {id: 10, nombre: 'New Line Cinema', fundacion: 1967, pais: 'Estados Unidos'});

// Premios
CREATE 
(:Premio {id: 1, nombre: 'Oscar', categoria: 'Mejor Película', organizacion: 'Academia de Artes y Ciencias Cinematográficas'}),
(:Premio {id: 2, nombre: 'Oscar', categoria: 'Mejor Director', organizacion: 'Academia de Artes y Ciencias Cinematográficas'}),
(:Premio {id: 3, nombre: 'Oscar', categoria: 'Mejor Actor', organizacion: 'Academia de Artes y Ciencias Cinematográficas'}),
(:Premio {id: 4, nombre: 'Oscar', categoria: 'Mejor Actriz', organizacion: 'Academia de Artes y Ciencias Cinematográficas'}),
(:Premio {id: 5, nombre: 'Globo de Oro', categoria: 'Mejor Película Drama', organizacion: 'Asociación de la Prensa Extranjera de Hollywood'}),
(:Premio {id: 6, nombre: 'Globo de Oro', categoria: 'Mejor Director', organizacion: 'Asociación de la Prensa Extranjera de Hollywood'}),
(:Premio {id: 7, nombre: 'BAFTA', categoria: 'Mejor Película', organizacion: 'Academia Británica de las Artes Cinematográficas y de la Televisión'}),
(:Premio {id: 8, nombre: 'Palma de Oro', categoria: 'Mejor Película', organizacion: 'Festival de Cannes'}),
(:Premio {id: 9, nombre: 'León de Oro', categoria: 'Mejor Película', organizacion: 'Festival de Venecia'}),
(:Premio {id: 10, nombre: 'Oso de Oro', categoria: 'Mejor Película', organizacion: 'Festival de Berlín'});

// ==============================================================
// 2. CREAR PERSONAS (DIRECTORES, ACTORES, PRODUCTORES)
// ==============================================================

// Directores famosos
CREATE 
(:Persona {id: 1, nombre: 'Giuseppe Tornatore', fecha_nacimiento: date('1956-05-27'), nacionalidad: 'Italiana', biografia: 'Director italiano famoso por Cinema Paradiso', tipo: 'Director'}),
(:Persona {id: 2, nombre: 'Steven Spielberg', fecha_nacimiento: date('1946-12-18'), nacionalidad: 'Estadounidense', biografia: 'Uno de los directores más influyentes del cine', tipo: 'Director'}),
(:Persona {id: 3, nombre: 'Martin Scorsese', fecha_nacimiento: date('1942-11-17'), nacionalidad: 'Estadounidense', biografia: 'Maestro del cine de gángsters', tipo: 'Director'}),
(:Persona {id: 4, nombre: 'Francis Ford Coppola', fecha_nacimiento: date('1939-04-07'), nacionalidad: 'Estadounidense', biografia: 'Director de El Padrino', tipo: 'Director'}),
(:Persona {id: 5, nombre: 'Quentin Tarantino', fecha_nacimiento: date('1963-03-27'), nacionalidad: 'Estadounidense', biografia: 'Director de películas de culto', tipo: 'Director'}),
(:Persona {id: 6, nombre: 'Christopher Nolan', fecha_nacimiento: date('1970-07-30'), nacionalidad: 'Británica', biografia: 'Director de películas complejas', tipo: 'Director'}),
(:Persona {id: 7, nombre: 'Ridley Scott', fecha_nacimiento: date('1937-11-30'), nacionalidad: 'Británica', biografia: 'Director de Blade Runner y Gladiator', tipo: 'Director'}),
(:Persona {id: 8, nombre: 'Denis Villeneuve', fecha_nacimiento: date('1967-10-03'), nacionalidad: 'Canadiense', biografia: 'Director de Dune y Arrival', tipo: 'Director'}),
(:Persona {id: 9, nombre: 'Greta Gerwig', fecha_nacimiento: date('1983-08-04'), nacionalidad: 'Estadounidense', biografia: 'Directora de Lady Bird y Barbie', tipo: 'Director'}),
(:Persona {id: 10, nombre: 'Jordan Peele', fecha_nacimiento: date('1979-02-21'), nacionalidad: 'Estadounidense', biografia: 'Director de Get Out y Us', tipo: 'Director'});

// Actores principales
CREATE 
(:Persona {id: 11, nombre: 'Philippe Noiret', fecha_nacimiento: date('1930-10-01'), nacionalidad: 'Francesa', biografia: 'Actor francés, protagonista de Cinema Paradiso', tipo: 'Actor'}),
(:Persona {id: 12, nombre: 'Salvatore Cascio', fecha_nacimiento: date('1979-12-08'), nacionalidad: 'Italiana', biografia: 'Actor italiano, niño protagonista de Cinema Paradiso', tipo: 'Actor'}),
(:Persona {id: 13, nombre: 'Marco Leonardi', fecha_nacimiento: date('1971-11-14'), nacionalidad: 'Italiana', biografia: 'Actor italiano de Cinema Paradiso', tipo: 'Actor'}),
(:Persona {id: 14, nombre: 'Robert De Niro', fecha_nacimiento: date('1943-08-17'), nacionalidad: 'Estadounidense', biografia: 'Legendario actor de método', tipo: 'Actor'}),
(:Persona {id: 15, nombre: 'Al Pacino', fecha_nacimiento: date('1940-04-25'), nacionalidad: 'Estadounidense', biografia: 'Icónico actor de El Padrino', tipo: 'Actor'}),
(:Persona {id: 16, nombre: 'Marlon Brando', fecha_nacimiento: date('1924-04-03'), nacionalidad: 'Estadounidense', biografia: 'Revolucionario actor de método', tipo: 'Actor'}),
(:Persona {id: 17, nombre: 'Leonardo DiCaprio', fecha_nacimiento: date('1974-11-11'), nacionalidad: 'Estadounidense', biografia: 'Actor versátil y activista', tipo: 'Actor'}),
(:Persona {id: 18, nombre: 'Meryl Streep', fecha_nacimiento: date('1949-06-22'), nacionalidad: 'Estadounidense', biografia: 'Actriz más nominada al Oscar', tipo: 'Actriz'}),
(:Persona {id: 19, nombre: 'Cate Blanchett', fecha_nacimiento: date('1969-05-14'), nacionalidad: 'Australiana', biografia: 'Actriz versátil ganadora del Oscar', tipo: 'Actriz'}),
(:Persona {id: 20, nombre: 'Joaquin Phoenix', fecha_nacimiento: date('1974-10-28'), nacionalidad: 'Estadounidense', biografia: 'Actor intenso y comprometido', tipo: 'Actor'});

// Productores
CREATE 
(:Persona {id: 21, nombre: 'Franco Cristaldi', fecha_nacimiento: date('1924-10-03'), nacionalidad: 'Italiana', biografia: 'Productor italiano de Cinema Paradiso', tipo: 'Productor'}),
(:Persona {id: 22, nombre: 'Kathleen Kennedy', fecha_nacimiento: date('1953-06-05'), nacionalidad: 'Estadounidense', biografia: 'Productora ejecutiva de Amblin Entertainment', tipo: 'Productor'}),
(:Persona {id: 23, nombre: 'Jerry Bruckheimer', fecha_nacimiento: date('1943-09-21'), nacionalidad: 'Estadounidense', biografia: 'Productor de películas de acción', tipo: 'Productor'}),
(:Persona {id: 24, nombre: 'Scott Rudin', fecha_nacimiento: date('1958-07-14'), nacionalidad: 'Estadounidense', biografia: 'Productor ganador de EGOT', tipo: 'Productor'}),
(:Persona {id: 25, nombre: 'Kevin Feige', fecha_nacimiento: date('1973-06-02'), nacionalidad: 'Estadounidense', biografia: 'Presidente de Marvel Studios', tipo: 'Productor'});

// ==============================================================
// 3. CREAR PELÍCULAS
// ==============================================================

CREATE 
(:Pelicula {id: 1, titulo: 'Cinema Paradiso', titulo_original: 'Nuovo Cinema Paradiso', año_lanzamiento: 1988, duracion: 155, presupuesto: 5000000, recaudacion: 12000000, rating: 8.5, sinopsis: 'La nostálgica historia de un niño y su amor por el cine en la Italia de posguerra', clasificacion: 'PG'}),
(:Pelicula {id: 2, titulo: 'The Godfather', titulo_original: 'The Godfather', año_lanzamiento: 1972, duracion: 175, presupuesto: 6000000, recaudacion: 245000000, rating: 9.2, sinopsis: 'La saga de la familia Corleone en el mundo de la mafia', clasificacion: 'R'}),
(:Pelicula {id: 3, titulo: 'Goodfellas', titulo_original: 'Goodfellas', año_lanzamiento: 1990, duracion: 146, presupuesto: 25000000, recaudacion: 46800000, rating: 8.7, sinopsis: 'La vida de Henry Hill en la mafia de Nueva York', clasificacion: 'R'}),
(:Pelicula {id: 4, titulo: 'Pulp Fiction', titulo_original: 'Pulp Fiction', año_lanzamiento: 1994, duracion: 154, presupuesto: 8000000, recaudacion: 214000000, rating: 8.9, sinopsis: 'Historias entrelazadas del crimen en Los Ángeles', clasificacion: 'R'}),
(:Pelicula {id: 5, titulo: 'Inception', titulo_original: 'Inception', año_lanzamiento: 2010, duracion: 148, presupuesto: 160000000, recaudacion: 836000000, rating: 8.8, sinopsis: 'Un ladrón que roba secretos del subconsciente', clasificacion: 'PG-13'}),
(:Pelicula {id: 6, titulo: 'The Dark Knight', titulo_original: 'The Dark Knight', año_lanzamiento: 2008, duracion: 152, presupuesto: 185000000, recaudacion: 1004000000, rating: 9.0, sinopsis: 'Batman enfrenta al Joker en Gotham City', clasificacion: 'PG-13'}),
(:Pelicula {id: 7, titulo: 'Schindler\'s List', titulo_original: 'Schindler\'s List', año_lanzamiento: 1993, duracion: 195, presupuesto: 22000000, recaudacion: 322000000, rating: 8.9, sinopsis: 'La historia de Oskar Schindler durante el Holocausto', clasificacion: 'R'}),
(:Pelicula {id: 8, titulo: 'Forrest Gump', titulo_original: 'Forrest Gump', año_lanzamiento: 1994, duracion: 142, presupuesto: 55000000, recaudacion: 678000000, rating: 8.8, sinopsis: 'La extraordinaria vida de Forrest Gump', clasificacion: 'PG-13'}),
(:Pelicula {id: 9, titulo: 'The Shawshank Redemption', titulo_original: 'The Shawshank Redemption', año_lanzamiento: 1994, duracion: 142, presupuesto: 25000000, recaudacion: 16000000, rating: 9.3, sinopsis: 'La amistad entre dos prisioneros', clasificacion: 'R'}),
(:Pelicula {id: 10, titulo: 'Casablanca', titulo_original: 'Casablanca', año_lanzamiento: 1942, duracion: 102, presupuesto: 1000000, recaudacion: 10000000, rating: 8.5, sinopsis: 'Romance y resistencia en el Marruecos de la Segunda Guerra Mundial', clasificacion: 'PG'});

// ==============================================================
// 4. CREAR CRÍTICAS
// ==============================================================

CREATE 
(:Critica {id: 1, titulo: 'Una obra maestra del cine italiano', autor: 'Roger Ebert', puntuacion: 4.5, fecha: date('1989-02-15'), contenido: 'Cinema Paradiso es una carta de amor al cine que toca el corazón'}),
(:Critica {id: 2, titulo: 'Nostalgia pura', autor: 'Pauline Kael', puntuacion: 4.0, fecha: date('1989-03-01'), contenido: 'Tornatore captura la magia del cine en la Italia rural'}),
(:Critica {id: 3, titulo: 'El padrino del cine', autor: 'Vincent Canby', puntuacion: 5.0, fecha: date('1972-03-24'), contenido: 'Coppola redefine el género de gángsters'}),
(:Critica {id: 4, titulo: 'Violencia estilizada', autor: 'Peter Travers', puntuacion: 4.5, fecha: date('1990-09-19'), contenido: 'Scorsese en su máximo esplendor narrativo'}),
(:Critica {id: 5, titulo: 'Narrativa fragmentada brillante', autor: 'Kenneth Turan', puntuacion: 4.5, fecha: date('1994-10-14'), contenido: 'Tarantino revoluciona el cine independiente'});

// ==============================================================
// 5. CREAR RELACIONES
// ==============================================================

// Relaciones de dirección
MATCH (d:Persona {id: 1}), (p:Pelicula {id: 1}) CREATE (d)-[:DIRIGIO {año: 1988}]->(p);
MATCH (d:Persona {id: 4}), (p:Pelicula {id: 2}) CREATE (d)-[:DIRIGIO {año: 1972}]->(p);
MATCH (d:Persona {id: 3}), (p:Pelicula {id: 3}) CREATE (d)-[:DIRIGIO {año: 1990}]->(p);
MATCH (d:Persona {id: 5}), (p:Pelicula {id: 4}) CREATE (d)-[:DIRIGIO {año: 1994}]->(p);
MATCH (d:Persona {id: 6}), (p:Pelicula {id: 5}) CREATE (d)-[:DIRIGIO {año: 2010}]->(p);
MATCH (d:Persona {id: 6}), (p:Pelicula {id: 6}) CREATE (d)-[:DIRIGIO {año: 2008}]->(p);
MATCH (d:Persona {id: 2}), (p:Pelicula {id: 7}) CREATE (d)-[:DIRIGIO {año: 1993}]->(p);

// Relaciones de actuación
MATCH (a:Persona {id: 11}), (p:Pelicula {id: 1}) CREATE (a)-[:ACTUO_EN {papel: 'Alfredo', tipo: 'Principal'}]->(p);
MATCH (a:Persona {id: 12}), (p:Pelicula {id: 1}) CREATE (a)-[:ACTUO_EN {papel: 'Salvatore (niño)', tipo: 'Principal'}]->(p);
MATCH (a:Persona {id: 13}), (p:Pelicula {id: 1}) CREATE (a)-[:ACTUO_EN {papel: 'Salvatore (joven)', tipo: 'Principal'}]->(p);
MATCH (a:Persona {id: 16}), (p:Pelicula {id: 2}) CREATE (a)-[:ACTUO_EN {papel: 'Don Vito Corleone', tipo: 'Principal'}]->(p);
MATCH (a:Persona {id: 15}), (p:Pelicula {id: 2}) CREATE (a)-[:ACTUO_EN {papel: 'Michael Corleone', tipo: 'Principal'}]->(p);
MATCH (a:Persona {id: 14}), (p:Pelicula {id: 3}) CREATE (a)-[:ACTUO_EN {papel: 'Henry Hill', tipo: 'Principal'}]->(p);
MATCH (a:Persona {id: 17}), (p:Pelicula {id: 5}) CREATE (a)-[:ACTUO_EN {papel: 'Dom Cobb', tipo: 'Principal'}]->(p);

// Relaciones de producción
MATCH (pr:Persona {id: 21}), (p:Pelicula {id: 1}) CREATE (pr)-[:PRODUJO {rol: 'Productor Ejecutivo'}]->(p);
MATCH (pr:Persona {id: 22}), (p:Pelicula {id: 7}) CREATE (pr)-[:PRODUJO {rol: 'Productor'}]->(p);
MATCH (pr:Persona {id: 23}), (p:Pelicula {id: 6}) CREATE (pr)-[:PRODUJO {rol: 'Productor Ejecutivo'}]->(p);

// Relaciones de género
MATCH (p:Pelicula {id: 1}), (g:Genero {id: 1}) CREATE (p)-[:PERTENECE_A]->(g);
MATCH (p:Pelicula {id: 1}), (g:Genero {id: 4}) CREATE (p)-[:PERTENECE_A]->(g);
MATCH (p:Pelicula {id: 2}), (g:Genero {id: 1}) CREATE (p)-[:PERTENECE_A]->(g);
MATCH (p:Pelicula {id: 3}), (g:Genero {id: 1}) CREATE (p)-[:PERTENECE_A]->(g);
MATCH (p:Pelicula {id: 4}), (g:Genero {id: 1}) CREATE (p)-[:PERTENECE_A]->(g);
MATCH (p:Pelicula {id: 5}), (g:Genero {id: 6}) CREATE (p)-[:PERTENECE_A]->(g);
MATCH (p:Pelicula {id: 6}), (g:Genero {id: 3}) CREATE (p)-[:PERTENECE_A]->(g);

// Relaciones de estudio
MATCH (p:Pelicula {id: 1}), (e:Estudio {id: 9}) CREATE (p)-[:PRODUCIDA_POR]->(e);
MATCH (p:Pelicula {id: 2}), (e:Estudio {id: 3}) CREATE (p)-[:PRODUCIDA_POR]->(e);
MATCH (p:Pelicula {id: 3}), (e:Estudio {id: 1}) CREATE (p)-[:PRODUCIDA_POR]->(e);
MATCH (p:Pelicula {id: 4}), (e:Estudio {id: 9}) CREATE (p)-[:PRODUCIDA_POR]->(e);
MATCH (p:Pelicula {id: 5}), (e:Estudio {id: 1}) CREATE (p)-[:PRODUCIDA_POR]->(e);

// Relaciones de país
MATCH (p:Pelicula {id: 1}), (pa:Pais {id: 4}) CREATE (p)-[:ORIGEN]->(pa);
MATCH (p:Pelicula {id: 2}), (pa:Pais {id: 1}) CREATE (p)-[:ORIGEN]->(pa);
MATCH (p:Pelicula {id: 3}), (pa:Pais {id: 1}) CREATE (p)-[:ORIGEN]->(pa);
MATCH (p:Pelicula {id: 4}), (pa:Pais {id: 1}) CREATE (p)-[:ORIGEN]->(pa);
MATCH (p:Pelicula {id: 5}), (pa:Pais {id: 1}) CREATE (p)-[:ORIGEN]->(pa);

// Relaciones de idioma
MATCH (p:Pelicula {id: 1}), (i:Idioma {id: 4}) CREATE (p)-[:EN_IDIOMA]->(i);
MATCH (p:Pelicula {id: 2}), (i:Idioma {id: 1}) CREATE (p)-[:EN_IDIOMA]->(i);
MATCH (p:Pelicula {id: 3}), (i:Idioma {id: 1}) CREATE (p)-[:EN_IDIOMA]->(i);
MATCH (p:Pelicula {id: 4}), (i:Idioma {id: 1}) CREATE (p)-[:EN_IDIOMA]->(i);
MATCH (p:Pelicula {id: 5}), (i:Idioma {id: 1}) CREATE (p)-[:EN_IDIOMA]->(i);

// Relaciones de premios
MATCH (p:Pelicula {id: 1}), (pr:Premio {id: 1}) CREATE (p)-[:GANO_PREMIO {año: 1990, categoria: 'Mejor Película Extranjera'}]->(pr);
MATCH (pe:Persona {id: 1}), (pr:Premio {id: 2}) CREATE (pe)-[:GANO_PREMIO {año: 1990, categoria: 'Mejor Director Extranjero'}]->(pr);
MATCH (p:Pelicula {id: 2}), (pr:Premio {id: 1}) CREATE (p)-[:GANO_PREMIO {año: 1973, categoria: 'Mejor Película'}]->(pr);
MATCH (pe:Persona {id: 16}), (pr:Premio {id: 3}) CREATE (pe)-[:GANO_PREMIO {año: 1973, categoria: 'Mejor Actor'}]->(pr);

// Relaciones de críticas
MATCH (p:Pelicula {id: 1}), (c:Critica {id: 1}) CREATE (p)-[:RECIBIO_CRITICA]->(c);
MATCH (p:Pelicula {id: 1}), (c:Critica {id: 2}) CREATE (p)-[:RECIBIO_CRITICA]->(c);
MATCH (p:Pelicula {id: 2}), (c:Critica {id: 3}) CREATE (p)-[:RECIBIO_CRITICA]->(c);
MATCH (p:Pelicula {id: 3}), (c:Critica {id: 4}) CREATE (p)-[:RECIBIO_CRITICA]->(c);
MATCH (p:Pelicula {id: 4}), (c:Critica {id: 5}) CREATE (p)-[:RECIBIO_CRITICA]->(c);

// Relaciones de colaboración
MATCH (p1:Persona {id: 1}), (p2:Persona {id: 11}) CREATE (p1)-[:COLABORO_CON {peliculas_en_comun: 1, relacion: 'Director-Actor'}]->(p2);
MATCH (p1:Persona {id: 1}), (p2:Persona {id: 21}) CREATE (p1)-[:COLABORO_CON {peliculas_en_comun: 1, relacion: 'Director-Productor'}]->(p2);
MATCH (p1:Persona {id: 4}), (p2:Persona {id: 15}) CREATE (p1)-[:COLABORO_CON {peliculas_en_comun: 1, relacion: 'Director-Actor'}]->(p2);
MATCH (p1:Persona {id: 4}), (p2:Persona {id: 16}) CREATE (p1)-[:COLABORO_CON {peliculas_en_comun: 1, relacion: 'Director-Actor'}]->(p2);
MATCH (p1:Persona {id: 3}), (p2:Persona {id: 14}) CREATE (p1)-[:COLABORO_CON {peliculas_en_comun: 2, relacion: 'Director-Actor'}]->(p2);

// ==============================================================
// VERIFICAR DATOS CREADOS
// ==============================================================

// Contar nodos por etiqueta
MATCH (n:Persona) RETURN 'Personas' as Tipo, count(n) as Cantidad
UNION
MATCH (n:Pelicula) RETURN 'Películas' as Tipo, count(n) as Cantidad
UNION
MATCH (n:Genero) RETURN 'Géneros' as Tipo, count(n) as Cantidad
UNION
MATCH (n:Estudio) RETURN 'Estudios' as Tipo, count(n) as Cantidad
UNION
MATCH (n:Pais) RETURN 'Países' as Tipo, count(n) as Cantidad
UNION
MATCH (n:Idioma) RETURN 'Idiomas' as Tipo, count(n) as Cantidad
UNION
MATCH (n:Premio) RETURN 'Premios' as Tipo, count(n) as Cantidad
UNION
MATCH (n:Critica) RETURN 'Críticas' as Tipo, count(n) as Cantidad
ORDER BY Tipo;

// Mostrar estructura general del grafo
MATCH (n)-[r]->(m) 
RETURN labels(n)[0] as Desde, type(r) as Relacion, labels(m)[0] as Hacia, count(*) as Cantidad
ORDER BY Desde, Relacion;
