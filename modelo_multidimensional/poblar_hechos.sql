-- POBLACIÓN DE TABLAS DE HECHOS PARA MODELO MULTIDIMENSIONAL

-- Poblar tabla de hechos participación
-- Cinema Paradiso (buscar ID real)
INSERT INTO dw_cine.hechos_participacion (id_pelicula, id_persona, id_tiempo_estreno, id_tipo_actuacion, salario_actor, aportacion_productor) VALUES
-- Director
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Giuseppe Tornatore'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), NULL, 0, 0),
-- Actores principales
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Salvatore Cascio'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 1, 1200000.00, 0),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Marco Leonardi'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 1, 1800000.00, 0),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Jacques Perrin'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 1, 2500000.00, 0),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Philippe Noiret'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 1, 3200000.00, 0),
-- Actores secundarios
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Brigitte Fossey'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 2, 850000.00, 0),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Antonella Attili'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 2, 750000.00, 0),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Enzo Cannavale'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 2, 680000.00, 0),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Isa Danieli'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 2, 620000.00, 0),
-- Actores de reparto
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Leo Gullotta'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 3, 600000.00, 0),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Pupella Maggio'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 3, 600000.00, 0),
-- Productores
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Franco Cristaldi'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), NULL, 0, 8500000.00),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Giovanna Romagnoli'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), NULL, 0, 3200000.00);

-- Poblar más participaciones para otras películas
-- La Dolce Vita
INSERT INTO dw_cine.hechos_participacion (id_pelicula, id_persona, id_tiempo_estreno, id_tipo_actuacion, salario_actor, aportacion_productor) VALUES
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'La Dolce Vita'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Federico Fellini'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-02-05'), NULL, 0, 0),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'La Dolce Vita'), (SELECT id_persona FROM dw_cine.dim_persona WHERE nombre = 'Dino De Laurentiis'), (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-02-05'), NULL, 0, 7800000.00);

-- Continuar poblando para más películas...
INSERT INTO dw_cine.hechos_participacion (id_pelicula, id_persona, id_tiempo_estreno, id_tipo_actuacion, salario_actor, aportacion_productor)
SELECT 
    p.id_pelicula,
    (1 + (p.id_pelicula * 3 + personas.num) % 100) as id_persona, -- Usar personas existentes
    t.id_tiempo,
    CASE personas.num % 4 
        WHEN 1 THEN 1 -- Protagonista
        WHEN 2 THEN 2 -- Secundario  
        WHEN 3 THEN 3 -- De reparto
        ELSE NULL -- Director/Productor
    END as id_tipo_actuacion,
    CASE personas.num % 4
        WHEN 1 THEN 1500000 + (random() * 2000000)::numeric(12,2) -- Protagonista
        WHEN 2 THEN 800000 + (random() * 700000)::numeric(12,2)   -- Secundario
        WHEN 3 THEN 600000 + (random() * 200000)::numeric(12,2)   -- De reparto
        ELSE 0 -- Director/Productor
    END as salario_actor,
    CASE personas.num % 4
        WHEN 0 THEN 2000000 + (random() * 6000000)::numeric(12,2) -- Productor
        ELSE 0 -- Actor/Director
    END as aportacion_productor
FROM dw_cine.dim_pelicula p
CROSS JOIN LATERAL (
    SELECT * FROM generate_series(1, 5) -- 5 personas por película
) personas(num)
JOIN dw_cine.dim_tiempo t ON t.fecha = p.fecha_estreno
WHERE p.titulo LIKE 'Película %' AND p.id_pelicula <= 50;

-- Poblar tabla de hechos premios
INSERT INTO dw_cine.hechos_premios (id_pelicula, id_premio, id_certamen, id_tiempo_otorgamiento, numero_premios, valor_estimado_premio) VALUES
-- Cinema Paradiso premios
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), 1, 1, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1989-05-23'), 1, 500000.00),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), 6, 3, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-03-30'), 1, 1000000.00),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), 9, 6, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1989-07-15'), 1, 50000.00),

-- La Dolce Vita premios
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'La Dolce Vita'), 1, 1, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-05-20'), 1, 500000.00),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'La Dolce Vita'), 9, 6, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1961-02-10'), 1, 50000.00),

-- 8½ premios
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = '8½'), 6, 3, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1964-04-13'), 1, 1000000.00),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = '8½'), 7, 2, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1963-09-05'), 1, 300000.00);

-- Poblar más premios aleatoriamente
INSERT INTO dw_cine.hechos_premios (id_pelicula, id_premio, id_certamen, id_tiempo_otorgamiento, numero_premios, valor_estimado_premio)
SELECT 
    p.id_pelicula,
    (1 + p.id_pelicula % 10) as id_premio,
    (1 + p.id_pelicula % 7) as id_certamen,
    t.id_tiempo,
    1,
    (10000 + random() * 490000)::numeric(10,2)
FROM dw_cine.dim_pelicula p
JOIN dw_cine.dim_tiempo t ON t.fecha = p.fecha_estreno + interval '6 months'
WHERE p.titulo LIKE 'Película %' AND p.id_pelicula <= 30 AND random() > 0.7;

-- Poblar tabla de hechos críticas
INSERT INTO dw_cine.hechos_criticas (id_pelicula, id_medio, id_tiempo_critica, numero_criticas, longitud_critica, sentimiento_critica) VALUES
-- Cinema Paradiso críticas
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), 1, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-20'), 1, 450, 'Positivo'),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), 2, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-25'), 1, 380, 'Muy Positivo'),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), 3, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-28'), 1, 520, 'Positivo'),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), 4, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-22'), 1, 340, 'Positivo'),
((SELECT id_pelicula FROM dw_cine.dim_pelicula WHERE titulo = 'Cinema Paradiso'), 5, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-30'), 1, 280, 'Neutral');

-- Poblar más críticas para otras películas
INSERT INTO dw_cine.hechos_criticas (id_pelicula, id_medio, id_tiempo_critica, numero_criticas, longitud_critica, sentimiento_critica)
SELECT 
    p.id_pelicula,
    (1 + (p.id_pelicula * 3 + row_number() OVER ()) % 10) as id_medio,
    t.id_tiempo,
    1,
    200 + (random() * 400)::integer,
    CASE (random() * 10)::integer % 5
        WHEN 0 THEN 'Muy Positivo'
        WHEN 1 THEN 'Positivo'
        WHEN 2 THEN 'Neutral'
        WHEN 3 THEN 'Negativo'
        ELSE 'Muy Negativo'
    END
FROM dw_cine.dim_pelicula p
CROSS JOIN LATERAL (
    SELECT * FROM generate_series(1, 3) -- 3 críticas por película
) criticas(num)
JOIN dw_cine.dim_tiempo t ON t.fecha = p.fecha_estreno + interval '1 month' + (criticas.num * interval '5 days')
WHERE p.titulo LIKE 'Película %';

-- Refrescar vista materializada
REFRESH MATERIALIZED VIEW dw_cine.resumen_peliculas;
