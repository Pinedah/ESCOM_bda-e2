-- CONSULTAS DE NEGOCIO PARA MODELO MULTIDIMENSIONAL
-- Implementación de las 5 consultas requeridas usando SQL/MDX

-- A. Total de salarios pagados a los actores de "Cinema Paradiso", dirigida por "Giuseppe Tornatore"
SELECT 
    p.titulo as pelicula,
    dir.nombre as director,
    SUM(hp.salario_actor) as total_salarios_actores,
    COUNT(DISTINCT CASE WHEN hp.salario_actor > 0 THEN hp.id_persona END) as total_actores,
    AVG(hp.salario_actor) FILTER (WHERE hp.salario_actor > 0) as salario_promedio
FROM dw_cine.dim_pelicula p
JOIN dw_cine.hechos_participacion hp ON p.id_pelicula = hp.id_pelicula
JOIN dw_cine.dim_persona dir ON hp.id_persona = dir.id_persona AND dir.tipo_persona = 'Director'
WHERE p.titulo = 'Cinema Paradiso'
  AND dir.nombre = 'Giuseppe Tornatore'
  AND hp.salario_actor > 0
GROUP BY p.titulo, dir.nombre;

-- B. Premios recibidos por "Cinema Paradiso", con ranking (descendente), nombre del premio y lugar del certamen
SELECT 
    p.titulo as pelicula,
    p.ranking,
    pr.nombre as premio,
    c.tipo_certamen as certamen,
    c.alcance as lugar_certamen,
    pr.importancia as importancia_premio,
    t.fecha as fecha_otorgamiento
FROM dw_cine.dim_pelicula p
JOIN dw_cine.hechos_premios hp ON p.id_pelicula = hp.id_pelicula
JOIN dw_cine.dim_premio pr ON hp.id_premio = pr.id_premio
JOIN dw_cine.dim_certamen c ON hp.id_certamen = c.id_certamen
JOIN dw_cine.dim_tiempo t ON hp.id_tiempo_otorgamiento = t.id_tiempo
WHERE p.titulo = 'Cinema Paradiso'
ORDER BY p.ranking DESC, pr.importancia DESC, t.fecha DESC;

-- C. Total de aportes económicos del productor "Franco Cristaldi"
SELECT 
    prod.nombre as productor,
    SUM(hp.aportacion_productor) as total_aportes,
    COUNT(DISTINCT hp.id_pelicula) as total_peliculas_producidas,
    AVG(hp.aportacion_productor) FILTER (WHERE hp.aportacion_productor > 0) as aporte_promedio_por_pelicula,
    MIN(hp.aportacion_productor) FILTER (WHERE hp.aportacion_productor > 0) as menor_aporte,
    MAX(hp.aportacion_productor) as mayor_aporte
FROM dw_cine.dim_persona prod
JOIN dw_cine.hechos_participacion hp ON prod.id_persona = hp.id_persona
WHERE prod.nombre = 'Franco Cristaldi'
  AND prod.tipo_persona = 'Productor'
  AND hp.aportacion_productor > 0
GROUP BY prod.nombre;

-- D. Críticas de "Cinema Paradiso" entre el 15 y el 30 de agosto de 1990, incluyendo medio, fecha y autor, ordenadas por fecha descendente
SELECT 
    p.titulo as pelicula,
    m.nombre_medio as medio,
    m.tipo_medio,
    t.fecha as fecha_critica,
    t.nombre_dia as dia_semana,
    hc.longitud_critica as longitud_palabras,
    hc.sentimiento_critica as sentimiento,
    m.credibilidad as credibilidad_medio,
    'Crítico de ' || m.nombre_medio as autor -- Simulando autor basado en medio
FROM dw_cine.dim_pelicula p
JOIN dw_cine.hechos_criticas hc ON p.id_pelicula = hc.id_pelicula
JOIN dw_cine.dim_medio_critica m ON hc.id_medio = m.id_medio
JOIN dw_cine.dim_tiempo t ON hc.id_tiempo_critica = t.id_tiempo
WHERE p.titulo = 'Cinema Paradiso'
  AND t.fecha BETWEEN '1990-08-15' AND '1990-08-30'
ORDER BY t.fecha DESC, m.credibilidad DESC;

-- E. Personas involucradas en la filmación de "Cinema Paradiso", mostrando nombre, rol, edad actual, estado civil y teléfono
SELECT 
    per.nombre,
    per.tipo_persona as rol,
    per.edad_actual,
    per.estado_civil,
    per.telefono,
    per.generacion,
    per.rango_edad,
    CASE 
        WHEN per.tipo_persona = 'Actor' THEN hp.salario_actor
        WHEN per.tipo_persona = 'Productor' THEN hp.aportacion_productor
        ELSE 0
    END as compensacion_economica,
    CASE 
        WHEN per.tipo_persona = 'Actor' THEN ta.descripcion
        ELSE NULL
    END as tipo_actuacion
FROM dw_cine.dim_pelicula p
JOIN dw_cine.hechos_participacion hp ON p.id_pelicula = hp.id_pelicula
JOIN dw_cine.dim_persona per ON hp.id_persona = per.id_persona
LEFT JOIN dw_cine.dim_tipo_actuacion ta ON hp.id_tipo_actuacion = ta.id_tipo_actuacion
WHERE p.titulo = 'Cinema Paradiso'
ORDER BY 
    CASE per.tipo_persona 
        WHEN 'Director' THEN 1
        WHEN 'Productor' THEN 2
        WHEN 'Actor' THEN 3
        ELSE 4
    END,
    CASE 
        WHEN per.tipo_persona = 'Actor' THEN hp.salario_actor
        WHEN per.tipo_persona = 'Productor' THEN hp.aportacion_productor
        ELSE 0
    END DESC;

-- CONSULTAS ADICIONALES DE ANÁLISIS MULTIDIMENSIONAL

-- Análisis por dimensión tiempo: Evolución de salarios por año
SELECT 
    t.anio,
    COUNT(DISTINCT hp.id_pelicula) as total_peliculas,
    SUM(hp.salario_actor) as total_salarios,
    AVG(hp.salario_actor) FILTER (WHERE hp.salario_actor > 0) as salario_promedio,
    SUM(hp.aportacion_productor) as total_aportaciones,
    AVG(hp.aportacion_productor) FILTER (WHERE hp.aportacion_productor > 0) as aportacion_promedio
FROM dw_cine.dim_tiempo t
JOIN dw_cine.hechos_participacion hp ON t.id_tiempo = hp.id_tiempo_estreno
GROUP BY t.anio
ORDER BY t.anio;

-- Análisis por dimensión persona: Top 10 actores mejor pagados
SELECT 
    per.nombre,
    per.edad_actual,
    per.estado_civil,
    COUNT(DISTINCT hp.id_pelicula) as total_peliculas,
    SUM(hp.salario_actor) as salario_total,
    AVG(hp.salario_actor) as salario_promedio,
    MAX(hp.salario_actor) as salario_maximo
FROM dw_cine.dim_persona per
JOIN dw_cine.hechos_participacion hp ON per.id_persona = hp.id_persona
WHERE per.tipo_persona = 'Actor' AND hp.salario_actor > 0
GROUP BY per.id_persona, per.nombre, per.edad_actual, per.estado_civil
ORDER BY salario_total DESC
LIMIT 10;

-- Análisis por dimensión película: Películas con más premios
SELECT 
    p.titulo,
    p.anio_estreno,
    p.ranking,
    COUNT(DISTINCT hpr.id_premio) as total_premios,
    STRING_AGG(DISTINCT c.tipo_certamen, ', ') as certamenes,
    SUM(hpr.valor_estimado_premio) as valor_total_premios
FROM dw_cine.dim_pelicula p
JOIN dw_cine.hechos_premios hpr ON p.id_pelicula = hpr.id_pelicula
JOIN dw_cine.dim_certamen c ON hpr.id_certamen = c.id_certamen
GROUP BY p.id_pelicula, p.titulo, p.anio_estreno, p.ranking
ORDER BY total_premios DESC, valor_total_premios DESC
LIMIT 10;

-- Consulta OLAP: Cubo de análisis por Año, Tipo de Persona y Rango de Edad
SELECT 
    t.anio,
    per.tipo_persona,
    per.rango_edad,
    COUNT(DISTINCT hp.id_pelicula) as total_peliculas,
    COUNT(DISTINCT per.id_persona) as total_personas,
    SUM(COALESCE(hp.salario_actor, 0) + COALESCE(hp.aportacion_productor, 0)) as total_compensacion,
    AVG(COALESCE(hp.salario_actor, 0) + COALESCE(hp.aportacion_productor, 0)) as compensacion_promedio
FROM dw_cine.dim_tiempo t
JOIN dw_cine.hechos_participacion hp ON t.id_tiempo = hp.id_tiempo_estreno
JOIN dw_cine.dim_persona per ON hp.id_persona = per.id_persona
GROUP BY CUBE(t.anio, per.tipo_persona, per.rango_edad)
ORDER BY t.anio NULLS LAST, per.tipo_persona NULLS LAST, per.rango_edad NULLS LAST;

-- Consulta con Ranking (Window Functions) para análisis avanzado
SELECT 
    p.titulo,
    p.anio_estreno,
    SUM(hp.salario_actor) as total_salarios,
    SUM(hp.aportacion_productor) as total_aportaciones,
    RANK() OVER (ORDER BY SUM(hp.salario_actor) DESC) as ranking_salarios,
    RANK() OVER (ORDER BY SUM(hp.aportacion_productor) DESC) as ranking_aportaciones,
    DENSE_RANK() OVER (PARTITION BY p.anio_estreno ORDER BY SUM(hp.salario_actor) DESC) as ranking_por_año
FROM dw_cine.dim_pelicula p
JOIN dw_cine.hechos_participacion hp ON p.id_pelicula = hp.id_pelicula
GROUP BY p.id_pelicula, p.titulo, p.anio_estreno
ORDER BY total_salarios DESC;
