-- CONSULTAS DE NEGOCIO PARA MODELO OBJETUAL
-- Implementación usando funciones, tipos compuestos y características objetuales

-- A. Total de salarios pagados a los actores de "Cinema Paradiso", dirigida por "Giuseppe Tornatore"
WITH cinema_paradiso AS (
    SELECT p.id_pelicula, p.titulo
    FROM obj_cine.pelicula p
    JOIN obj_cine.director d ON p.id_director = d.id_persona
    WHERE p.titulo = 'Cinema Paradiso' 
      AND d.nombre = 'Giuseppe Tornatore'
)
SELECT 
    cp.titulo as pelicula,
    d.nombre as director,
    COUNT(DISTINCT part.id_actor) as total_actores,
    SUM((part.info_financiera).salario) as total_salarios_base,
    SUM((part.info_financiera).bonificaciones) as total_bonificaciones,
    SUM((part.info_financiera).total_ganado) as total_salarios_pagados,
    AVG((part.info_financiera).total_ganado) as salario_promedio,
    STRING_AGG(
        a.nombre || ' (' || part.tipo_participacion || '): $' || 
        (part.info_financiera).total_ganado::text, 
        ', ' ORDER BY (part.info_financiera).total_ganado DESC
    ) as detalle_actores
FROM cinema_paradiso cp
JOIN obj_cine.pelicula p ON cp.id_pelicula = p.id_pelicula
JOIN obj_cine.director d ON p.id_director = d.id_persona
JOIN obj_cine.participacion part ON p.id_pelicula = part.id_pelicula
JOIN obj_cine.actor a ON part.id_actor = a.id_persona
GROUP BY cp.titulo, d.nombre;

-- B. Premios recibidos por "Cinema Paradiso", con ranking (descendente), nombre del premio y lugar del certamen
SELECT 
    p.titulo as pelicula,
    p.ranking,
    premio.nombre as nombre_premio,
    premio.certamen as certamen,
    premio.categoria as categoria_premio,
    premio.prestigio as nivel_prestigio,
    premio.fecha_otorgamiento,
    EXTRACT(YEAR FROM premio.fecha_otorgamiento) as año_premio,
    -- Usar función para calcular días desde el estreno
    premio.fecha_otorgamiento - p.fecha_estreno as dias_desde_estreno
FROM obj_cine.pelicula p,
     UNNEST(p.premios) AS premio
WHERE p.titulo = 'Cinema Paradiso'
ORDER BY p.ranking DESC, 
         CASE premio.prestigio 
             WHEN 'Muy Alto' THEN 1 
             WHEN 'Alto' THEN 2 
             ELSE 3 
         END,
         premio.fecha_otorgamiento DESC;

-- C. Total de aportes económicos del productor "Franco Cristaldi"
SELECT 
    prod.nombre as productor,
    (prod.info_personal).estado_civil as estado_civil,
    (prod.info_personal).contacto.telefono as telefono,
    prod.empresa_productora,
    COUNT(DISTINCT produc.id_pelicula) as total_peliculas_producidas,
    SUM((produc.info_produccion).aportacion) as total_aportes_directos,
    AVG((produc.info_produccion).aportacion) as aporte_promedio_por_pelicula,
    SUM((produc.info_produccion).porcentaje_participacion) as porcentaje_total_participacion,
    AVG((produc.info_produccion).porcentaje_participacion) as porcentaje_promedio,
    -- Usar función personalizada
    obj_cine.obtener_aportaciones_productor(prod.id_persona) as total_calculado_por_funcion,
    STRING_AGG(
        pel.titulo || ' ($' || (produc.info_produccion).aportacion::text || 
        ' - ' || (produc.info_produccion).porcentaje_participacion::text || '%)',
        ', ' ORDER BY (produc.info_produccion).aportacion DESC
    ) as detalle_inversiones
FROM obj_cine.productor prod
JOIN obj_cine.produccion produc ON prod.id_persona = produc.id_productor
JOIN obj_cine.pelicula pel ON produc.id_pelicula = pel.id_pelicula
WHERE prod.nombre = 'Franco Cristaldi'
GROUP BY prod.id_persona, prod.nombre, prod.info_personal, prod.empresa_productora;

-- D. Críticas de "Cinema Paradiso" entre el 15 y el 30 de agosto de 1990, 
-- incluyendo medio, fecha y autor, ordenadas por fecha descendente
SELECT 
    p.titulo as pelicula,
    critica.medio as medio,
    critica.autor as autor,
    critica.fecha as fecha_critica,
    TO_CHAR(critica.fecha, 'Day, DD "de" Month "de" YYYY') as fecha_formateada,
    critica.puntuacion as puntuacion,
    critica.sentimiento as sentimiento,
    LENGTH(critica.contenido) as longitud_critica,
    CASE 
        WHEN critica.puntuacion >= 4.5 THEN 'Excelente'
        WHEN critica.puntuacion >= 4.0 THEN 'Muy Buena'
        WHEN critica.puntuacion >= 3.5 THEN 'Buena'
        WHEN critica.puntuacion >= 3.0 THEN 'Regular'
        ELSE 'Mala'
    END as categoria_puntuacion,
    critica.contenido as contenido_critica
FROM obj_cine.pelicula p,
     UNNEST(p.criticas) AS critica
WHERE p.titulo = 'Cinema Paradiso'
  AND critica.fecha BETWEEN '1990-08-15' AND '1990-08-30'
ORDER BY critica.fecha DESC, critica.puntuacion DESC;

-- E. Personas involucradas en la filmación de "Cinema Paradiso", 
-- mostrando nombre, rol, edad actual, estado civil y teléfono
WITH personas_cinema_paradiso AS (
    -- Directores
    SELECT 
        d.id_persona,
        d.nombre,
        'Director' as rol,
        obj_cine.calcular_edad(d.info_personal) as edad_actual,
        (d.info_personal).estado_civil as estado_civil,
        (d.info_personal).contacto.telefono as telefono,
        d.estilo_direccion as especialidad,
        0::numeric(12,2) as compensacion_economica,
        NULL as tipo_participacion
    FROM obj_cine.pelicula p
    JOIN obj_cine.director d ON p.id_director = d.id_persona
    WHERE p.titulo = 'Cinema Paradiso'
    
    UNION ALL
    
    -- Actores
    SELECT 
        a.id_persona,
        a.nombre,
        'Actor' as rol,
        obj_cine.calcular_edad(a.info_personal) as edad_actual,
        (a.info_personal).estado_civil as estado_civil,
        (a.info_personal).contacto.telefono as telefono,
        a.especialidad,
        (part.info_financiera).total_ganado as compensacion_economica,
        part.tipo_participacion
    FROM obj_cine.pelicula p
    JOIN obj_cine.participacion part ON p.id_pelicula = part.id_pelicula
    JOIN obj_cine.actor a ON part.id_actor = a.id_persona
    WHERE p.titulo = 'Cinema Paradiso'
    
    UNION ALL
    
    -- Productores
    SELECT 
        prod.id_persona,
        prod.nombre,
        'Productor' as rol,
        obj_cine.calcular_edad(prod.info_personal) as edad_actual,
        (prod.info_personal).estado_civil as estado_civil,
        (prod.info_personal).contacto.telefono as telefono,
        prod.tipo_productor as especialidad,
        (produc.info_produccion).aportacion as compensacion_economica,
        produc.rol_produccion as tipo_participacion
    FROM obj_cine.pelicula p
    JOIN obj_cine.produccion produc ON p.id_pelicula = produc.id_pelicula
    JOIN obj_cine.productor prod ON produc.id_productor = prod.id_persona
    WHERE p.titulo = 'Cinema Paradiso'
)
SELECT 
    nombre,
    rol,
    edad_actual,
    CASE 
        WHEN edad_actual < 30 THEN 'Joven'
        WHEN edad_actual < 50 THEN 'Adulto'
        WHEN edad_actual < 65 THEN 'Maduro'
        ELSE 'Veterano'
    END as categoria_edad,
    estado_civil,
    telefono,
    especialidad,
    tipo_participacion,
    compensacion_economica,
    CASE rol
        WHEN 'Director' THEN 1
        WHEN 'Productor' THEN 2
        WHEN 'Actor' THEN 3
        ELSE 4
    END as orden_jerarquia
FROM personas_cinema_paradiso
ORDER BY orden_jerarquia, compensacion_economica DESC;

-- CONSULTAS ADICIONALES USANDO CARACTERÍSTICAS OBJETUALES

-- Consulta usando herencia: Obtener todas las personas de todos los tipos
SELECT 
    'Actor' as tipo_persona,
    nombre,
    obj_cine.calcular_edad(info_personal) as edad,
    (info_personal).estado_civil as estado_civil,
    obj_cine.obtener_salario_total_actor(id_persona) as total_ingresos
FROM obj_cine.actor
WHERE activo = TRUE

UNION ALL

SELECT 
    'Director' as tipo_persona,
    nombre,
    obj_cine.calcular_edad(info_personal) as edad,
    (info_personal).estado_civil as estado_civil,
    0 as total_ingresos
FROM obj_cine.director
WHERE activo = TRUE

UNION ALL

SELECT 
    'Productor' as tipo_persona,
    nombre,
    obj_cine.calcular_edad(info_personal) as edad,
    (info_personal).estado_civil as estado_civil,
    obj_cine.obtener_aportaciones_productor(id_persona) as total_ingresos
FROM obj_cine.productor
WHERE activo = TRUE

ORDER BY total_ingresos DESC;

-- Consulta usando arrays: Películas por género
SELECT 
    p.titulo,
    p.genero as generos,
    array_length(p.genero, 1) as numero_generos,
    CASE 
        WHEN 'Drama' = ANY(p.genero) THEN 'Es Drama'
        ELSE 'No es Drama'
    END as es_drama,
    array_length(p.criticas, 1) as numero_criticas,
    array_length(p.premios, 1) as numero_premios
FROM obj_cine.pelicula p
WHERE p.genero && ARRAY['Drama', 'Romance'] -- Operador de intersección de arrays
ORDER BY array_length(p.premios, 1) DESC NULLS LAST;

-- Consulta usando funciones de usuario: Buscar películas
SELECT * 
FROM obj_cine.buscar_peliculas(
    titulo_busqueda := 'Cinema',
    año_inicio := 1980,
    año_fin := 1990,
    ranking_minimo := 4.0
);

-- Consulta usando tipos compuestos complejos: Análisis financiero detallado
SELECT 
    a.nombre as actor,
    a.especialidad,
    (a.info_financiera).salario as salario_base,
    (a.info_financiera).bonificaciones as bonificaciones,
    (a.info_financiera).total_ganado as total_actor,
    COUNT(part.id_pelicula) as peliculas_participadas,
    AVG((part.info_financiera).total_ganado) as promedio_por_pelicula,
    SUM((part.info_financiera).total_ganado) as total_carrera,
    STDDEV((part.info_financiera).total_ganado) as desviacion_salarios
FROM obj_cine.actor a
LEFT JOIN obj_cine.participacion part ON a.id_persona = part.id_actor
GROUP BY 
    a.id_persona, 
    a.nombre, 
    a.especialidad, 
    a.info_financiera
HAVING COUNT(part.id_pelicula) > 0
ORDER BY total_carrera DESC
LIMIT 10;
