-- POBLACIÓN DE DATOS PARA MODELO MULTIDIMENSIONAL
-- Insertamos datos de ejemplo basados en "Cinema Paradiso" y otras películas

-- Poblar dimensión tiempo (años 1960-1998 para cubrir todas las películas)
INSERT INTO dw_cine.dim_tiempo (fecha, anio, mes, dia, trimestre, semestre, nombre_mes, nombre_dia, es_fin_semana, es_festivo)
SELECT 
    fecha_serie,
    EXTRACT(YEAR FROM fecha_serie) as anio,
    EXTRACT(MONTH FROM fecha_serie) as mes,
    EXTRACT(DAY FROM fecha_serie) as dia,
    CASE 
        WHEN EXTRACT(MONTH FROM fecha_serie) <= 3 THEN 1
        WHEN EXTRACT(MONTH FROM fecha_serie) <= 6 THEN 2
        WHEN EXTRACT(MONTH FROM fecha_serie) <= 9 THEN 3
        ELSE 4
    END as trimestre,
    CASE 
        WHEN EXTRACT(MONTH FROM fecha_serie) <= 6 THEN 1
        ELSE 2
    END as semestre,
    TO_CHAR(fecha_serie, 'Month') as nombre_mes,
    TO_CHAR(fecha_serie, 'Day') as nombre_dia,
    CASE WHEN EXTRACT(DOW FROM fecha_serie) IN (0, 6) THEN TRUE ELSE FALSE END as es_fin_semana,
    FALSE as es_festivo
FROM generate_series('1960-01-01'::date, '1998-12-31'::date, '1 day') as fecha_serie;

-- Poblar dimensión personas (100+ registros)
INSERT INTO dw_cine.dim_persona (nombre, fecha_nacimiento, edad_actual, estado_civil, telefono, tipo_persona, rango_edad, generacion) VALUES
-- Directores famosos
('Giuseppe Tornatore', '1956-05-27', 68, 'Casado', '+39-091-123456', 'Director', '60-69', 'Baby Boomer'),
('Federico Fellini', '1920-01-20', 73, 'Casado', '+39-06-234567', 'Director', '70-79', 'Silenciosa'),
('Roberto Benigni', '1952-10-27', 72, 'Casado', '+39-055-345678', 'Director', '70-79', 'Baby Boomer'),
('Sergio Leone', '1929-01-03', 60, 'Casado', '+39-06-456789', 'Director', '60-69', 'Silenciosa'),
('Luchino Visconti', '1906-11-02', 70, 'Soltero', '+39-02-567890', 'Director', '70-79', 'Silenciosa'),

-- Actores principales
('Salvatore Cascio', '1979-11-08', 45, 'Casado', '+39-090-111222', 'Actor', '40-49', 'Generación X'),
('Marco Leonardi', '1971-11-14', 53, 'Divorciado', '+39-06-222333', 'Actor', '50-59', 'Generación X'),
('Jacques Perrin', '1941-07-13', 83, 'Casado', '+33-01-333444', 'Actor', '80-89', 'Silenciosa'),
('Philippe Noiret', '1930-10-01', 66, 'Casado', '+33-01-444555', 'Actor', '60-69', 'Silenciosa'),
('Brigitte Fossey', '1946-06-15', 78, 'Casada', '+33-01-555666', 'Actor', '70-79', 'Baby Boomer'),
('Antonella Attili', '1963-05-23', 61, 'Casada', '+39-090-666777', 'Actor', '60-69', 'Baby Boomer'),
('Enzo Cannavale', '1928-04-05', 65, 'Casado', '+39-081-777888', 'Actor', '60-69', 'Silenciosa'),
('Isa Danieli', '1944-12-13', 80, 'Casada', '+39-081-888999', 'Actor', '80-89', 'Silenciosa'),
('Leo Gullotta', '1946-01-09', 78, 'Casado', '+39-095-999000', 'Actor', '70-79', 'Baby Boomer'),
('Pupella Maggio', '1910-04-24', 89, 'Viuda', '+39-081-000111', 'Actor', '80-89', 'Silenciosa'),

-- Productores
('Franco Cristaldi', '1924-10-03', 68, 'Casado', '+39-06-111222', 'Productor', '60-69', 'Silenciosa'),
('Giovanna Romagnoli', '1935-09-15', 89, 'Casada', '+39-06-222333', 'Productor', '80-89', 'Silenciosa'),
('Dino De Laurentiis', '1919-08-08', 91, 'Casado', '+39-06-333444', 'Productor', '90-99', 'Silenciosa'),
('Carlo Ponti', '1912-12-11', 95, 'Casado', '+39-06-444555', 'Productor', '90-99', 'Silenciosa'),
('Alberto Grimaldi', '1925-03-28', 94, 'Casado', '+39-06-555666', 'Productor', '90-99', 'Silenciosa');

-- Continuar con más registros para completar 100+
INSERT INTO dw_cine.dim_persona (nombre, fecha_nacimiento, edad_actual, estado_civil, telefono, tipo_persona, rango_edad, generacion)
SELECT 
    'Actor ' || generate_series,
    '1950-01-01'::date + (generate_series * interval '200 days'),
    74 - (generate_series / 5),
    CASE (generate_series % 4) 
        WHEN 0 THEN 'Soltero'
        WHEN 1 THEN 'Casado'
        WHEN 2 THEN 'Divorciado'
        ELSE 'Viudo'
    END,
    '+39-06-' || LPAD(generate_series::text, 6, '0'),
    'Actor',
    CASE 
        WHEN (74 - (generate_series / 5)) < 30 THEN '20-29'
        WHEN (74 - (generate_series / 5)) < 40 THEN '30-39'
        WHEN (74 - (generate_series / 5)) < 50 THEN '40-49'
        WHEN (74 - (generate_series / 5)) < 60 THEN '50-59'
        WHEN (74 - (generate_series / 5)) < 70 THEN '60-69'
        ELSE '70-79'
    END,
    CASE 
        WHEN (74 - (generate_series / 5)) > 60 THEN 'Baby Boomer'
        WHEN (74 - (generate_series / 5)) > 40 THEN 'Generación X'
        ELSE 'Millennial'
    END
FROM generate_series(21, 100);

-- Poblar dimensión películas
INSERT INTO dw_cine.dim_pelicula (titulo, resumen, fecha_estreno, anio_estreno, ranking, categoria_ranking, duracion_resumen, decada) VALUES
('Cinema Paradiso', 'Un hombre maduro recuerda su infancia en un pequeño pueblo siciliano, donde desarrolló una amistad especial con el proyeccionista del cine local. A través de flashbacks, la película explora temas de nostalgia, pérdida de la inocencia y el poder transformador del cine. La historia sigue a Salvatore desde su juventud hasta la edad adulta, mostrando cómo el cine influyó en su vida y cómo las relaciones humanas dan forma a nuestro destino. Es una reflexión poética sobre el paso del tiempo, el amor y la memoria, envuelta en la magia del séptimo arte que conecta generaciones y culturas diferentes.', '1988-11-17', 1988, 4.8, 'Excelente', 85, '1980s'),
('La Dolce Vita', 'Marcello Mastroianni interpreta a un periodista romano que vive una vida hedonista en la alta sociedad de Roma, buscando historias escandalosas mientras navega por relaciones superficiales y encuentros vacíos. La película retrata la decadencia moral de la sociedad italiana de la época, explorando temas de alienación, búsqueda de significado y la corrupción del alma humana. A través de episodios interconectados, Fellini construye un fresco social que critica el materialismo y la pérdida de valores espirituales en la modernidad, utilizando imágenes surrealistas y simbólicas que han marcado la historia del cine mundial.', '1960-02-05', 1960, 4.7, 'Excelente', 92, '1960s'),
('8½', 'Un director de cine en crisis creativa lucha por completar su próxima película mientras lidia con problemas personales, recuerdos de la infancia y fantasías. La obra maestra de Fellini es una reflexión meta-cinematográfica sobre el proceso creativo, donde realidad y fantasía se entrelazan de manera magistral. El protagonista enfrenta presiones de productores, críticos y su propia conciencia artística, mientras explora sus relaciones con mujeres que representan diferentes aspectos de su psique. La película se convierte en una meditación profunda sobre el arte, la inspiración y la condición humana, utilizando técnicas narrativas innovadoras que influenciaron generaciones de cineastas posteriores.', '1963-02-14', 1963, 4.9, 'Excelente', 89, '1960s'),
('La Vita è Bella', 'Durante la Segunda Guerra Mundial, un padre judío usa su imaginación y humor para proteger a su hijo de los horrores del Holocausto, convirtiendo su experiencia en un campo de concentración en un juego elaborado. Roberto Benigni crea una obra maestra que combina comedia y drama de manera única, explorando temas de amor paternal, resistencia humana y el poder de la fantasía para superar las tragedias más profundas. La película demuestra cómo el amor puede transformar incluso las circunstancias más terribles, ofreciendo esperanza y dignidad en medio de la desesperación más absoluta, convirtiéndose en un himno a la vida y al espíritu humano indomable.', '1997-12-20', 1997, 4.6, 'Excelente', 94, '1990s'),
('Il Postino', 'Un cartero simple en una isla italiana desarrolla una amistad con el poeta Pablo Neruda, quien está exiliado allí, y aprende sobre la poesía y el amor a través de esta relación transformadora. La película explora cómo el arte puede cambiar vidas ordinarias, mostrando el despertar cultural y emocional del protagonista a medida que descubre el poder de las palabras y la expresión poética. Es una historia tierna sobre la conexión humana, la inspiración artística y cómo la belleza de la literatura puede tocar los corazones más humildes, creando puentes entre diferentes clases sociales y culturas, celebrando la universalidad del lenguaje poético y su capacidad para enriquecer la experiencia humana.', '1994-06-17', 1994, 4.5, 'Excelente', 88, '1990s');

-- Continuar con más películas para completar 100+
INSERT INTO dw_cine.dim_pelicula (titulo, resumen, fecha_estreno, anio_estreno, ranking, categoria_ranking, duracion_resumen, decada)
SELECT 
    'Película ' || generate_series,
    'Descripción detallada de la película número ' || generate_series || ' que cuenta una historia fascinante llena de emociones, aventuras y personajes memorables que han marcado la historia del cine italiano. Esta obra cinematográfica explora temas universales como el amor, la familia, la amistad, el sacrificio y la redención, ofreciendo al espectador una experiencia única que combina entretenimiento de calidad con reflexiones profundas sobre la condición humana y la sociedad contemporánea, utilizando técnicas narrativas innovadoras y una cinematografía excepcional que ha sido reconocida por críticos y audiencias de todo el mundo, convirtiéndose en un referente del séptimo arte.',
    '1988-01-01'::date + (generate_series * interval '30 days'),
    1988 + (generate_series / 12),
    1.0 + (generate_series % 4) + (random() * 0.9),
    CASE 
        WHEN (1.0 + (generate_series % 4) + (random() * 0.9)) >= 4.5 THEN 'Excelente'
        WHEN (1.0 + (generate_series % 4) + (random() * 0.9)) >= 3.5 THEN 'Buena'
        WHEN (1.0 + (generate_series % 4) + (random() * 0.9)) >= 2.5 THEN 'Regular'
        ELSE 'Mala'
    END,
    75 + (generate_series % 25),
    CASE 
        WHEN (1988 + (generate_series / 12)) < 1990 THEN '1980s'
        ELSE '1990s'
    END
FROM generate_series(6, 100);

-- Poblar dimensión tipo actuación
INSERT INTO dw_cine.dim_tipo_actuacion (descripcion, jerarquia, es_principal) VALUES
('Protagonista', 1, TRUE),
('Secundario', 2, FALSE),
('De reparto', 3, FALSE),
('Extra', 4, FALSE);

-- Poblar dimensión certamen
INSERT INTO dw_cine.dim_certamen (tipo_certamen, prestigio, alcance) VALUES
('Festival de Cannes', 'Muy Alto', 'Internacional'),
('Festival de Venecia', 'Muy Alto', 'Internacional'),
('Premios Oscar', 'Muy Alto', 'Internacional'),
('Festival de Roma', 'Alto', 'Nacional'),
('Festival de Taormina', 'Medio', 'Nacional'),
('Premios David di Donatello', 'Alto', 'Nacional'),
('Premios Nastro d''Argento', 'Medio', 'Nacional');

-- Poblar dimensión premio
INSERT INTO dw_cine.dim_premio (nombre, categoria, importancia) VALUES
('Palma de Oro', 'Mejor Película', 'Muy Alta'),
('Gran Premio del Jurado', 'Mejor Película', 'Alta'),
('Premio al Mejor Actor', 'Actuación', 'Alta'),
('Premio a la Mejor Dirección', 'Dirección', 'Alta'),
('Premio a la Mejor Fotografía', 'Técnico', 'Media'),
('Premio Oscar a Mejor Película Extranjera', 'Película', 'Muy Alta'),
('Leone d''Oro', 'Mejor Película', 'Muy Alta'),
('Copa Volpi', 'Actuación', 'Alta'),
('David di Donatello Mejor Película', 'Película', 'Alta'),
('Nastro d''Argento Mejor Director', 'Dirección', 'Media');

-- Poblar dimensión medio crítica
INSERT INTO dw_cine.dim_medio_critica (nombre_medio, tipo_medio, credibilidad) VALUES
('La Gazzetta dello Sport', 'Periódico', 'Alta'),
('Corriere della Sera', 'Periódico', 'Muy Alta'),
('La Repubblica', 'Periódico', 'Muy Alta'),
('Cinema Italiano', 'Revista Especializada', 'Alta'),
('Ciak', 'Revista Especializada', 'Media'),
('RAI 1', 'Televisión', 'Alta'),
('Mediaset', 'Televisión', 'Media'),
('Film TV', 'Revista Especializada', 'Media'),
('Variety Italia', 'Revista Especializada', 'Alta'),
('The Hollywood Reporter Italia', 'Revista Especializada', 'Alta');

-- Continuar con más medios para completar 50+
INSERT INTO dw_cine.dim_medio_critica (nombre_medio, tipo_medio, credibilidad)
SELECT 
    'Medio ' || generate_series,
    CASE (generate_series % 3)
        WHEN 0 THEN 'Periódico'
        WHEN 1 THEN 'Revista Especializada'
        ELSE 'Televisión'
    END,
    CASE (generate_series % 3)
        WHEN 0 THEN 'Alta'
        WHEN 1 THEN 'Media'
        ELSE 'Muy Alta'
    END
FROM generate_series(11, 60);
