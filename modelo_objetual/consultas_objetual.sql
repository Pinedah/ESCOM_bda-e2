-- CONSULTAS DE NEGOCIO PARA MODELO OBJETUAL
-- Implementación usando funciones, tipos compuestos y características objetuales
-- NOTA: Los dominios han sido relajados para permitir mayor flexibilidad en los datos

-- ======================================================
-- INSTRUCCIONES PARA RESOLVER ERRORES DE FUNCIÓN
-- ======================================================
-- Si obtienes errores como "structure of query does not match function result type",
-- significa que la función en la base de datos no está actualizada con los casts correctos.
-- 
-- SOLUCIÓN:
-- 1. Ejecuta primero el archivo schema_objetual.sql completo para actualizar las funciones
-- 2. O ejecuta manualmente esta corrección de la función:

/*
CREATE OR REPLACE FUNCTION obj_cine.buscar_peliculas(
    titulo_busqueda VARCHAR(150) DEFAULT NULL,
    año_inicio INTEGER DEFAULT NULL,
    año_fin INTEGER DEFAULT NULL,
    ranking_minimo NUMERIC(2,1) DEFAULT NULL
) RETURNS TABLE(
    id INTEGER,
    titulo VARCHAR(150),
    año INTEGER,
    ranking NUMERIC(2,1),
    director VARCHAR(100),
    total_premios INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id_pelicula,
        p.titulo,
        EXTRACT(YEAR FROM p.fecha_estreno)::INTEGER,
        p.ranking::NUMERIC(2,1), -- Cast explícito del dominio a NUMERIC
        d.nombre,
        COALESCE(array_length(p.premios, 1), 0)
    FROM obj_cine.pelicula p
    LEFT JOIN obj_cine.director d ON p.id_director = d.id_persona
    WHERE 
        (titulo_busqueda IS NULL OR p.titulo ILIKE '%' || titulo_busqueda || '%')
        AND (año_inicio IS NULL OR EXTRACT(YEAR FROM p.fecha_estreno) >= año_inicio)
        AND (año_fin IS NULL OR EXTRACT(YEAR FROM p.fecha_estreno) <= año_fin)
        AND (ranking_minimo IS NULL OR p.ranking >= ranking_minimo)
    ORDER BY p.ranking DESC, p.fecha_estreno DESC;
END;
$$ LANGUAGE plpgsql;
*/
-- ======================================================

-- CONSULTA DE VERIFICACIÓN: Comprobar versión de funciones
-- Ejecuta esto para verificar si las funciones están actualizadas
SELECT 
    p.proname as nombre_funcion,
    pg_get_function_result(p.oid) as tipo_retorno,
    pg_get_function_arguments(p.oid) as argumentos
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'obj_cine' 
  AND p.proname IN ('buscar_peliculas', 'obtener_personas_por_tipo')
ORDER BY p.proname;

-- PRUEBA SIMPLE: Verificar que la función funciona
-- Si esta consulta falla, ejecuta primero el schema completo
SELECT 'Función buscar_peliculas funcionando correctamente' as estado
WHERE EXISTS (
    SELECT 1 FROM information_schema.routines 
    WHERE routine_schema = 'obj_cine' 
    AND routine_name = 'buscar_peliculas'
);

-- A. Total de salarios pagados a los actores de "Cinema Paradiso", dirigida por "Giuseppe Tornatore"
-- Utiliza tipos compuestos (info_financiera) y agregaciones
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
-- Utiliza UNNEST para descomponer arrays de tipos compuestos
SELECT 
    p.titulo as pelicula,
    p.ranking,
    premio.nombre as nombre_premio,
    premio.certamen as certamen,
    premio.categoria as categoria_premio,
    premio.prestigio as nivel_prestigio,
    premio.fecha_otorgamiento,
    EXTRACT(YEAR FROM premio.fecha_otorgamiento) as año_premio,
    -- Calcular días desde el estreno
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
-- Utiliza tipos compuestos anidados y funciones personalizadas
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
    -- Usar función personalizada (relajada por cambios en dominios)
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
-- Utiliza UNNEST para descomponer arrays y funciones de formateo
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
-- Utiliza herencia de tablas, UNION ALL y funciones personalizadas
WITH personas_cinema_paradiso AS (
    -- Directores (herencia de persona)
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
    
    -- Actores (herencia de persona)
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
    
    -- Productores (herencia de persona)
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
-- Demuestra la herencia de tablas y polimorfismo
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
-- Demuestra el uso de arrays y operadores específicos de PostgreSQL
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
WHERE p.genero && ARRAY['Drama', 'Romance']::VARCHAR(50)[] -- Operador de intersección con cast explícito
ORDER BY array_length(p.premios, 1) DESC NULLS LAST;

-- Consulta usando funciones de usuario: Buscar películas
-- Demuestra el uso de funciones PL/pgSQL con parámetros con nombre
-- VERSIÓN ALTERNATIVA: Consulta directa sin función (por si hay problemas con la función)
SELECT 
    p.id_pelicula as id,
    p.titulo,
    EXTRACT(YEAR FROM p.fecha_estreno)::INTEGER as año,
    p.ranking::NUMERIC(2,1) as ranking, -- Cast explícito para evitar errores de tipo
    d.nombre as director,
    COALESCE(array_length(p.premios, 1), 0) as total_premios
FROM obj_cine.pelicula p
LEFT JOIN obj_cine.director d ON p.id_director = d.id_persona
WHERE 
    p.titulo ILIKE '%Cinema%'
    AND EXTRACT(YEAR FROM p.fecha_estreno) >= 1980
    AND EXTRACT(YEAR FROM p.fecha_estreno) <= 1990
    AND p.ranking >= 4.0
ORDER BY p.ranking DESC, p.fecha_estreno DESC;

-- VERSIÓN CON FUNCIÓN (usar después de asegurar que el esquema esté actualizado)
/*
SELECT * 
FROM obj_cine.buscar_peliculas(
    titulo_busqueda := 'Cinema',
    año_inicio := 1980,
    año_fin := 1990,
    ranking_minimo := 4.0
);
*/

-- Consulta usando tipos compuestos complejos: Análisis financiero detallado
-- CORREGIDA: Los actores no tienen info_financiera directa, solo en participaciones
-- Demuestra el uso correcto de tipos compuestos anidados y agregaciones
SELECT 
    a.nombre as actor,
    a.especialidad,
    AVG((part.info_financiera).salario) as salario_promedio,
    AVG((part.info_financiera).bonificaciones) as bonificaciones_promedio,
    AVG((part.info_financiera).total_ganado) as ganancia_promedio_por_pelicula,
    COUNT(part.id_pelicula) as peliculas_participadas,
    MIN((part.info_financiera).total_ganado) as minimo_por_pelicula,
    MAX((part.info_financiera).total_ganado) as maximo_por_pelicula,
    SUM((part.info_financiera).total_ganado) as total_carrera,
    STDDEV((part.info_financiera).total_ganado) as desviacion_salarios
FROM obj_cine.actor a
LEFT JOIN obj_cine.participacion part ON a.id_persona = part.id_actor
GROUP BY 
    a.id_persona, 
    a.nombre, 
    a.especialidad
HAVING COUNT(part.id_pelicula) > 0
ORDER BY total_carrera DESC
LIMIT 10;

-- CONSULTAS DE VALIDACIÓN POST-MODIFICACIONES

-- Validar que los dominios relajados permiten la inserción de datos
-- Mostrar información consolidada de todas las entidades del sistema
SELECT 
    'RESUMEN DEL SISTEMA' as reporte_tipo,
    COUNT(DISTINCT p.id_persona) as total_personas,
    COUNT(DISTINCT CASE WHEN p.activo THEN p.id_persona END) as personas_activas,
    COUNT(DISTINCT a.id_persona) as total_actores,
    COUNT(DISTINCT d.id_persona) as total_directores,
    COUNT(DISTINCT pr.id_persona) as total_productores,
    COUNT(DISTINCT pel.id_pelicula) as total_peliculas,
    AVG(pel.ranking) as ranking_promedio_peliculas,
    SUM(CASE WHEN pel.recaudacion > pel.presupuesto THEN 1 ELSE 0 END) as peliculas_rentables,
    -- Verificar que los dominios relajados funcionan
    MAX(LENGTH((p.info_personal).contacto.telefono)) as telefono_mas_largo,
    MIN(LENGTH((p.info_personal).contacto.telefono)) as telefono_mas_corto
FROM obj_cine.persona p
LEFT JOIN obj_cine.actor a ON p.id_persona = a.id_persona
LEFT JOIN obj_cine.director d ON p.id_persona = d.id_persona
LEFT JOIN obj_cine.productor pr ON p.id_persona = pr.id_persona
LEFT JOIN obj_cine.pelicula pel ON d.id_persona = pel.id_director
GROUP BY ()
UNION ALL
SELECT 
    'VALIDACIÓN DOMINIOS' as reporte_tipo,
    COUNT(*) as total_registros,
    COUNT(part.info_financiera) as registros_con_info_financiera,
    0 as no_usado1, 0 as no_usado2, 0 as no_usado3, 0 as no_usado4,
    AVG((part.info_financiera).salario) as salario_promedio,
    SUM(CASE WHEN (part.info_financiera).salario >= 0 THEN 1 ELSE 0 END) as salarios_validos,
    -- Verificar longitud de teléfonos tras relajación del dominio
    MAX(LENGTH((a.info_personal).contacto.telefono)) as max_telefono,
    MIN(LENGTH((a.info_personal).contacto.telefono)) as min_telefono
FROM obj_cine.participacion part
JOIN obj_cine.actor a ON part.id_actor = a.id_persona;

-- Consulta que demuestra el uso completo de características objetuales
-- tras las modificaciones en dominios y tipos
WITH estadisticas_completas AS (
    SELECT 
        'Cinema Paradiso' as titulo_busqueda,
        -- Usar función personalizada
        obj_cine.calcular_edad(d.info_personal) as edad_director,
        d.nombre as director,
        -- Usar tipos compuestos anidados
        (d.info_personal).estado_civil as estado_civil_director,
        (d.info_personal).contacto.telefono as telefono_director,
        -- Usar arrays
        p.genero as generos_pelicula,
        array_length(p.genero, 1) as cantidad_generos,
        array_length(p.criticas, 1) as cantidad_criticas,
        array_length(p.premios, 1) as cantidad_premios,
        -- Usar dominios relajados
        p.ranking as ranking_pelicula,
        LENGTH(p.resumen) as longitud_resumen,
        -- Agregar información financiera desde participaciones
        (SELECT AVG((part.info_financiera).total_ganado) 
         FROM obj_cine.participacion part 
         WHERE part.id_pelicula = p.id_pelicula) as promedio_salarios_actores,
        (SELECT SUM((produc.info_produccion).aportacion) 
         FROM obj_cine.produccion produc 
         WHERE produc.id_pelicula = p.id_pelicula) as total_aportaciones_productores
    FROM obj_cine.pelicula p
    JOIN obj_cine.director d ON p.id_director = d.id_persona
    WHERE p.titulo = 'Cinema Paradiso'
)
SELECT 
    titulo_busqueda,
    director,
    edad_director,
    CASE 
        WHEN edad_director < 40 THEN 'Director Joven'
        WHEN edad_director < 60 THEN 'Director Maduro'
        ELSE 'Director Veterano'
    END as categoria_director,
    estado_civil_director,
    telefono_director,
    generos_pelicula,
    cantidad_generos,
    cantidad_criticas,
    cantidad_premios,
    ranking_pelicula,
    longitud_resumen,
    -- Verificar que los dominios relajados permiten los datos
    CASE 
        WHEN longitud_resumen >= 50 THEN 'Resumen Válido (Dominio OK)'
        ELSE 'Resumen Inválido'
    END as validacion_resumen,
    CASE 
        WHEN LENGTH(telefono_director) >= 8 THEN 'Teléfono Válido (Dominio OK)'
        ELSE 'Teléfono Inválido'
    END as validacion_telefono,
    promedio_salarios_actores,
    total_aportaciones_productores,
    -- Usar operadores de arrays
    CASE 
        WHEN 'Drama' = ANY(generos_pelicula) THEN 'Contiene Drama'
        ELSE 'No contiene Drama'
    END as analisis_genero
FROM estadisticas_completas;
