-- POBLACIÓN DE TABLAS DE HECHOS PARA MODELO MULTIDIMENSIONAL

-- Poblar tabla de hechos participación
-- Cinema Paradiso (id_pelicula = 1)
INSERT INTO dw_cine.hechos_participacion (id_pelicula, id_persona, id_tiempo_estreno, id_tipo_actuacion, salario_actor, aportacion_productor) VALUES
-- Director
(1, 1, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), NULL, 0, 0),
-- Actores principales
(1, 6, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 1, 1200000.00, 0), -- Salvatore Cascio - Protagonista
(1, 7, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 1, 1800000.00, 0), -- Marco Leonardi - Protagonista
(1, 8, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 1, 2500000.00, 0), -- Jacques Perrin - Protagonista
(1, 9, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 1, 3200000.00, 0), -- Philippe Noiret - Protagonista
-- Actores secundarios
(1, 10, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 2, 850000.00, 0), -- Brigitte Fossey - Secundario
(1, 11, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 2, 750000.00, 0), -- Antonella Attili - Secundario
(1, 12, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 2, 680000.00, 0), -- Enzo Cannavale - Secundario
(1, 13, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 2, 620000.00, 0), -- Isa Danieli - Secundario
-- Actores de reparto
(1, 14, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 3, 600000.00, 0), -- Leo Gullotta - De reparto
(1, 15, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), 3, 600000.00, 0), -- Pupella Maggio - De reparto
-- Productores
(1, 16, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), NULL, 0, 8500000.00), -- Franco Cristaldi
(1, 17, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1988-11-17'), NULL, 0, 3200000.00); -- Giovanna Romagnoli

-- Poblar más participaciones para otras películas
-- La Dolce Vita (id_pelicula = 2)
INSERT INTO dw_cine.hechos_participacion (id_pelicula, id_persona, id_tiempo_estreno, id_tipo_actuacion, salario_actor, aportacion_productor) VALUES
(2, 2, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-02-05'), NULL, 0, 0), -- Federico Fellini - Director
(2, 18, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-02-05'), NULL, 0, 7800000.00), -- Dino De Laurentiis - Productor
(2, 21, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-02-05'), 1, 2800000.00, 0), -- Actor principal
(2, 22, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-02-05'), 1, 2200000.00, 0), -- Actriz principal
(2, 23, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-02-05'), 2, 1200000.00, 0), -- Actor secundario
(2, 24, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-02-05'), 2, 950000.00, 0); -- Actriz secundaria

-- Continuar poblando para más películas...
INSERT INTO dw_cine.hechos_participacion (id_pelicula, id_persona, id_tiempo_estreno, id_tipo_actuacion, salario_actor, aportacion_productor)
SELECT 
    p.id_pelicula,
    (6 + (p.id_pelicula * 3 + row_number() OVER ()) % 95) as id_persona, -- Distribuir personas
    t.id_tiempo,
    CASE (row_number() OVER ()) % 4 
        WHEN 0 THEN 1 -- Protagonista
        WHEN 1 THEN 2 -- Secundario  
        WHEN 2 THEN 3 -- De reparto
        ELSE NULL -- Director/Productor
    END as id_tipo_actuacion,
    CASE (row_number() OVER ()) % 4
        WHEN 0 THEN 1500000 + (random() * 2000000)::numeric(12,2) -- Protagonista
        WHEN 1 THEN 800000 + (random() * 700000)::numeric(12,2)   -- Secundario
        WHEN 2 THEN 600000 + (random() * 200000)::numeric(12,2)   -- De reparto
        ELSE 0 -- Director/Productor
    END as salario_actor,
    CASE (row_number() OVER ()) % 4
        WHEN 3 THEN 2000000 + (random() * 6000000)::numeric(12,2) -- Productor
        ELSE 0 -- Actor/Director
    END as aportacion_productor
FROM dw_cine.dim_pelicula p
CROSS JOIN LATERAL (
    SELECT * FROM generate_series(1, 5) -- 5 personas por película
) personas(num)
JOIN dw_cine.dim_tiempo t ON t.fecha = p.fecha_estreno
WHERE p.id_pelicula BETWEEN 3 AND 50;

-- Poblar tabla de hechos premios
INSERT INTO dw_cine.hechos_premios (id_pelicula, id_premio, id_certamen, id_tiempo_otorgamiento, numero_premios, valor_estimado_premio) VALUES
-- Cinema Paradiso premios
(1, 1, 1, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1989-05-23'), 1, 500000.00), -- Palma de Oro en Cannes
(1, 6, 3, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-03-30'), 1, 1000000.00), -- Oscar Mejor Película Extranjera
(1, 9, 6, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1989-07-15'), 1, 50000.00), -- David di Donatello

-- La Dolce Vita premios
(2, 1, 1, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1960-05-20'), 1, 500000.00), -- Palma de Oro en Cannes
(2, 9, 6, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1961-02-10'), 1, 50000.00), -- David di Donatello

-- 8½ premios
(3, 6, 3, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1964-04-13'), 1, 1000000.00), -- Oscar Mejor Película Extranjera
(3, 7, 2, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1963-09-05'), 1, 300000.00); -- Leone d'Oro en Venecia

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
WHERE p.id_pelicula BETWEEN 4 AND 30 AND random() > 0.7; -- Solo algunas películas tienen premios

-- Poblar tabla de hechos críticas
INSERT INTO dw_cine.hechos_criticas (id_pelicula, id_medio, id_tiempo_critica, numero_criticas, longitud_critica, sentimiento_critica) VALUES
-- Cinema Paradiso críticas
(1, 1, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-20'), 1, 450, 'Positivo'),
(1, 2, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-25'), 1, 380, 'Muy Positivo'),
(1, 3, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-28'), 1, 520, 'Positivo'),
(1, 4, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-22'), 1, 340, 'Positivo'),
(1, 5, (SELECT id_tiempo FROM dw_cine.dim_tiempo WHERE fecha = '1990-08-30'), 1, 280, 'Neutral');

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
WHERE p.id_pelicula BETWEEN 2 AND 50;

-- Refrescar vista materializada
REFRESH MATERIALIZED VIEW dw_cine.resumen_peliculas;
