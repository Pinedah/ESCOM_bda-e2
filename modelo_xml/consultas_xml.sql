-- CONSULTAS DE NEGOCIO PARA MODELO XML
-- Implementación usando XPath, SQL/XML y XMLTABLE

-- A. Total de salarios pagados a los actores de "Cinema Paradiso", dirigida por "Giuseppe Tornatore"
WITH salarios_actores AS (
    SELECT 
        -- Extraer título de la película
        (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text as titulo_pelicula,
        -- Extraer nombre del director
        (xpath('/pelicula/direccion/director/informacion_personal/nombre/text()', p.documento_xml))[1]::text as director,
        -- Usar XMLTABLE para extraer información de cada actor
        act.nombre_actor,
        act.salario_total,
        act.personaje,
        act.tipo_actuacion
    FROM xml_cine.peliculas_xml p,
         XMLTABLE('/pelicula/reparto/participacion' 
                 PASSING p.documento_xml
                 COLUMNS 
                     nombre_actor TEXT PATH 'actor/informacion_personal/nombre/text()',
                     salario_base NUMERIC PATH 'actor/informacion_financiera/salario_base/text()',
                     bonificaciones NUMERIC PATH 'actor/informacion_financiera/bonificaciones/text()',
                     salario_total NUMERIC PATH 'actor/informacion_financiera/salario_total/text()',
                     personaje TEXT PATH 'personaje/text()',
                     tipo_actuacion TEXT PATH 'tipo_actuacion/text()'
         ) AS act
    WHERE (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text = 'Cinema Paradiso'
      AND (xpath('/pelicula/direccion/director/informacion_personal/nombre/text()', p.documento_xml))[1]::text = 'Giuseppe Tornatore'
)
SELECT 
    titulo_pelicula as pelicula,
    director,
    COUNT(*) as total_actores,
    SUM(salario_total) as total_salarios_pagados,
    AVG(salario_total) as salario_promedio,
    MAX(salario_total) as salario_maximo,
    MIN(salario_total) as salario_minimo,
    STRING_AGG(
        nombre_actor || ' (' || tipo_actuacion || ' - ' || personaje || '): $' || salario_total::text, 
        ', ' 
        ORDER BY salario_total DESC
    ) as detalle_actores_salarios
FROM salarios_actores
GROUP BY titulo_pelicula, director;

-- B. Premios recibidos por "Cinema Paradiso", con ranking (descendente), nombre del premio y lugar del certamen
SELECT 
    (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text as pelicula,
    (xpath('/pelicula/informacion_basica/ranking/text()', p.documento_xml))[1]::text::numeric(2,1) as ranking,
    prem.nombre_premio,
    prem.certamen,
    prem.categoria,
    prem.fecha_otorgamiento::date,
    prem.tipo_certamen,
    prem.prestigio,
    -- Calcular días desde el estreno hasta el premio
    prem.fecha_otorgamiento::date - (xpath('/pelicula/informacion_basica/fecha_estreno/text()', p.documento_xml))[1]::text::date as dias_desde_estreno
FROM xml_cine.peliculas_xml p,
     XMLTABLE('/pelicula/premios/premio' 
             PASSING p.documento_xml
             COLUMNS 
                 nombre_premio TEXT PATH 'nombre/text()',
                 certamen TEXT PATH 'certamen/text()',
                 categoria TEXT PATH 'categoria/text()',
                 fecha_otorgamiento TEXT PATH 'fecha_otorgamiento/text()',
                 tipo_certamen TEXT PATH '@tipo_certamen',
                 prestigio TEXT PATH 'prestigio/text()',
                 descripcion TEXT PATH 'descripcion/text()'
     ) AS prem
WHERE (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text = 'Cinema Paradiso'
ORDER BY 
    (xpath('/pelicula/informacion_basica/ranking/text()', p.documento_xml))[1]::text::numeric(2,1) DESC,
    CASE prem.prestigio 
        WHEN 'Muy Alto' THEN 1 
        WHEN 'Alto' THEN 2 
        ELSE 3 
    END,
    prem.fecha_otorgamiento::date DESC;

-- C. Total de aportes económicos del productor "Franco Cristaldi"
WITH aportaciones_productor AS (
    SELECT 
        -- Información del productor
        prod.nombre_productor,
        prod.telefono,
        prod.estado_civil,
        prod.empresa_productora,
        prod.tipo_productor,
        -- Información de la película
        (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text as titulo_pelicula,
        (xpath('/pelicula/informacion_basica/fecha_estreno/text()', p.documento_xml))[1]::text::date as fecha_estreno,
        -- Información financiera
        prod.aportacion,
        prod.porcentaje_participacion,
        prod.tipo_inversion
    FROM xml_cine.peliculas_xml p,
         XMLTABLE('/pelicula/produccion/productor' 
                 PASSING p.documento_xml
                 COLUMNS 
                     nombre_productor TEXT PATH 'informacion_personal/nombre/text()',
                     telefono TEXT PATH 'informacion_personal/contacto/telefono/text()',
                     estado_civil TEXT PATH 'informacion_personal/estado_civil/text()',
                     empresa_productora TEXT PATH 'empresa_productora/text()',
                     tipo_productor TEXT PATH 'tipo_productor/text()',
                     aportacion NUMERIC PATH 'informacion_produccion/aportacion/text()',
                     porcentaje_participacion NUMERIC PATH 'informacion_produccion/porcentaje_participacion/text()',
                     tipo_inversion TEXT PATH 'informacion_produccion/tipo_inversion/text()'
         ) AS prod
    WHERE prod.nombre_productor = 'Franco Cristaldi'
    
    UNION ALL
    
    -- También buscar en documentos de personas separados
    SELECT 
        (xpath('/persona/productor/informacion_personal/nombre/text()', per.documento_xml))[1]::text as nombre_productor,
        (xpath('/persona/productor/informacion_personal/contacto/telefono/text()', per.documento_xml))[1]::text as telefono,
        (xpath('/persona/productor/informacion_personal/estado_civil/text()', per.documento_xml))[1]::text as estado_civil,
        (xpath('/persona/productor/empresa_productora/text()', per.documento_xml))[1]::text as empresa_productora,
        (xpath('/persona/productor/tipo_productor/text()', per.documento_xml))[1]::text as tipo_productor,
        -- Información de filmografía
        film.titulo_pelicula,
        NULL::date as fecha_estreno,
        film.aportacion,
        film.porcentaje_participacion,
        'Información de filmografía' as tipo_inversion
    FROM xml_cine.personas_xml per,
         XMLTABLE('/persona/productor/filmografia/pelicula' 
                 PASSING per.documento_xml
                 COLUMNS 
                     titulo_pelicula TEXT PATH 'titulo/text()',
                     aportacion NUMERIC PATH 'aportacion/text()',
                     porcentaje_participacion NUMERIC PATH 'porcentaje/text()'
         ) AS film
    WHERE per.nombre = 'Franco Cristaldi' 
      AND per.tipo_persona = 'Productor'
)
SELECT 
    nombre_productor as productor,
    estado_civil,
    telefono,
    empresa_productora,
    tipo_productor,
    COUNT(DISTINCT titulo_pelicula) as total_peliculas_producidas,
    SUM(aportacion) as total_aportes_economicos,
    AVG(aportacion) as aporte_promedio_por_pelicula,
    MAX(aportacion) as mayor_aportacion,
    MIN(aportacion) as menor_aportacion,
    SUM(porcentaje_participacion) as porcentaje_total_participacion,
    AVG(porcentaje_participacion) as porcentaje_promedio,
    STRING_AGG(
        titulo_pelicula || ' ($' || aportacion::text || ' - ' || porcentaje_participacion::text || '%)',
        ', ' 
        ORDER BY aportacion DESC
    ) as detalle_inversiones
FROM aportaciones_productor
GROUP BY nombre_productor, estado_civil, telefono, empresa_productora, tipo_productor;

-- D. Críticas de "Cinema Paradiso" entre el 15 y el 30 de agosto de 1990, 
-- incluyendo medio, fecha y autor, ordenadas por fecha descendente
SELECT 
    -- Información de la película
    (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text as pelicula,
    -- Información de las críticas usando XMLTABLE
    crit.fecha_critica,
    TO_CHAR(crit.fecha_critica, 'Day, DD "de" Month "de" YYYY') as fecha_formateada,
    crit.autor,
    crit.medio,
    crit.puntuacion,
    crit.sentimiento,
    LENGTH(crit.contenido) as longitud_critica,
    CASE 
        WHEN crit.puntuacion >= 4.5 THEN 'Excelente'
        WHEN crit.puntuacion >= 4.0 THEN 'Muy Buena'
        WHEN crit.puntuacion >= 3.5 THEN 'Buena'
        WHEN crit.puntuacion >= 3.0 THEN 'Regular'
        ELSE 'Mala'
    END as categoria_puntuacion,
    crit.contenido
FROM xml_cine.peliculas_xml p,
     XMLTABLE('/pelicula/criticas/critica' 
             PASSING p.documento_xml
             COLUMNS 
                 fecha_critica DATE PATH '@fecha',
                 autor TEXT PATH 'autor/text()',
                 medio TEXT PATH 'medio/text()',
                 contenido TEXT PATH 'contenido/text()',
                 puntuacion NUMERIC PATH 'puntuacion/text()',
                 sentimiento TEXT PATH 'sentimiento/text()'
     ) AS crit
WHERE (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text = 'Cinema Paradiso'
  AND crit.fecha_critica BETWEEN '1990-08-15' AND '1990-08-30'

UNION ALL

-- También buscar en documentos de críticas separados
SELECT 
    c.pelicula_referencia as pelicula,
    crit2.fecha_critica,
    TO_CHAR(crit2.fecha_critica, 'Day, DD "de" Month "de" YYYY') as fecha_formateada,
    crit2.autor,
    crit2.medio,
    crit2.puntuacion,
    crit2.sentimiento,
    LENGTH(crit2.contenido) as longitud_critica,
    CASE 
        WHEN crit2.puntuacion >= 4.5 THEN 'Excelente'
        WHEN crit2.puntuacion >= 4.0 THEN 'Muy Buena'
        WHEN crit2.puntuacion >= 3.5 THEN 'Buena'
        WHEN crit2.puntuacion >= 3.0 THEN 'Regular'
        ELSE 'Mala'
    END as categoria_puntuacion,
    crit2.contenido
FROM xml_cine.criticas_xml c,
     XMLTABLE('/criticas/critica' 
             PASSING c.documento_xml
             COLUMNS 
                 fecha_critica DATE PATH '@fecha',
                 autor TEXT PATH 'autor/text()',
                 medio TEXT PATH 'medio/text()',
                 contenido TEXT PATH 'contenido/text()',
                 puntuacion NUMERIC PATH 'puntuacion/text()',
                 sentimiento TEXT PATH 'sentimiento/text()'
     ) AS crit2,
     LATERAL (
         SELECT (xpath('/criticas/pelicula_referencia/text()', c.documento_xml))[1]::text as pelicula_referencia
     ) c
WHERE c.pelicula_referencia = 'Cinema Paradiso'
  AND crit2.fecha_critica BETWEEN '1990-08-15' AND '1990-08-30'

ORDER BY fecha_critica DESC, puntuacion DESC;

-- E. Personas involucradas en la filmación de "Cinema Paradiso", 
-- mostrando nombre, rol, edad actual, estado civil y teléfono
WITH personas_cinema_paradiso AS (
    -- Directores
    SELECT 
        dir.nombre,
        'Director' as rol,
        dir.especialidad,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, dir.fecha_nacimiento)) as edad_actual,
        dir.estado_civil,
        dir.telefono,
        dir.pais,
        0::numeric as compensacion_economica,
        'Dirección cinematográfica' as tipo_participacion
    FROM xml_cine.peliculas_xml p,
         XMLTABLE('/pelicula/direccion/director' 
                 PASSING p.documento_xml
                 COLUMNS 
                     nombre TEXT PATH 'informacion_personal/nombre/text()',
                     fecha_nacimiento DATE PATH 'informacion_personal/fecha_nacimiento/text()',
                     estado_civil TEXT PATH 'informacion_personal/estado_civil/text()',
                     telefono TEXT PATH 'informacion_personal/contacto/telefono/text()',
                     pais TEXT PATH 'informacion_personal/contacto/pais/text()',
                     especialidad TEXT PATH 'estilo_direccion/text()'
         ) AS dir
    WHERE (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text = 'Cinema Paradiso'
    
    UNION ALL
    
    -- Actores
    SELECT 
        act.nombre,
        'Actor' as rol,
        act.especialidad,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, act.fecha_nacimiento)) as edad_actual,
        act.estado_civil,
        act.telefono,
        act.pais,
        act.salario_total as compensacion_economica,
        act.tipo_actuacion || ' (' || act.personaje || ')' as tipo_participacion
    FROM xml_cine.peliculas_xml p,
         XMLTABLE('/pelicula/reparto/participacion' 
                 PASSING p.documento_xml
                 COLUMNS 
                     nombre TEXT PATH 'actor/informacion_personal/nombre/text()',
                     fecha_nacimiento DATE PATH 'actor/informacion_personal/fecha_nacimiento/text()',
                     estado_civil TEXT PATH 'actor/informacion_personal/estado_civil/text()',
                     telefono TEXT PATH 'actor/informacion_personal/contacto/telefono/text()',
                     pais TEXT PATH 'actor/informacion_personal/contacto/pais/text()',
                     especialidad TEXT PATH 'actor/especialidad/text()',
                     salario_total NUMERIC PATH 'actor/informacion_financiera/salario_total/text()',
                     tipo_actuacion TEXT PATH 'tipo_actuacion/text()',
                     personaje TEXT PATH 'personaje/text()'
         ) AS act
    WHERE (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text = 'Cinema Paradiso'
    
    UNION ALL
    
    -- Productores
    SELECT 
        prod.nombre,
        'Productor' as rol,
        prod.tipo_productor as especialidad,
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, prod.fecha_nacimiento)) as edad_actual,
        prod.estado_civil,
        prod.telefono,
        prod.pais,
        prod.aportacion as compensacion_economica,
        prod.empresa_productora as tipo_participacion
    FROM xml_cine.peliculas_xml p,
         XMLTABLE('/pelicula/produccion/productor' 
                 PASSING p.documento_xml
                 COLUMNS 
                     nombre TEXT PATH 'informacion_personal/nombre/text()',
                     fecha_nacimiento DATE PATH 'informacion_personal/fecha_nacimiento/text()',
                     estado_civil TEXT PATH 'informacion_personal/estado_civil/text()',
                     telefono TEXT PATH 'informacion_personal/contacto/telefono/text()',
                     pais TEXT PATH 'informacion_personal/contacto/pais/text()',
                     tipo_productor TEXT PATH 'tipo_productor/text()',
                     empresa_productora TEXT PATH 'empresa_productora/text()',
                     aportacion NUMERIC PATH 'informacion_produccion/aportacion/text()'
         ) AS prod
    WHERE (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text = 'Cinema Paradiso'
)
SELECT 
    nombre,
    rol,
    especialidad,
    edad_actual,
    CASE 
        WHEN edad_actual < 30 THEN 'Joven'
        WHEN edad_actual < 50 THEN 'Adulto'
        WHEN edad_actual < 65 THEN 'Maduro'
        ELSE 'Veterano'
    END as categoria_edad,
    estado_civil,
    telefono,
    pais,
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

-- CONSULTAS ADICIONALES USANDO CARACTERÍSTICAS XML AVANZADAS

-- Consulta usando XPath con predicados: Películas con ranking superior a 4.5
SELECT 
    (xpath('/pelicula/informacion_basica/titulo/text()', documento_xml))[1]::text as titulo,
    (xpath('/pelicula/informacion_basica/ranking/text()', documento_xml))[1]::text::numeric(2,1) as ranking,
    (xpath('/pelicula/direccion/director/informacion_personal/nombre/text()', documento_xml))[1]::text as director,
    (xpath('/pelicula/informacion_basica/fecha_estreno/text()', documento_xml))[1]::text::date as fecha_estreno
FROM xml_cine.peliculas_xml
WHERE xpath_exists('/pelicula/informacion_basica[ranking > 4.5]', documento_xml)
ORDER BY (xpath('/pelicula/informacion_basica/ranking/text()', documento_xml))[1]::text::numeric(2,1) DESC;

-- Consulta usando funciones XML personalizadas
SELECT 
    titulo,
    xml_cine.extraer_info_pelicula(documento_xml) as info_extraida
FROM xml_cine.peliculas_xml
WHERE titulo LIKE '%Cinema%';

-- Consulta de agregación XML: Total de premios por tipo de certamen
SELECT 
    prem.tipo_certamen,
    COUNT(*) as total_premios,
    STRING_AGG(prem.nombre_premio, ', ') as premios_otorgados,
    AVG(prem.prestigio_numerico) as prestigio_promedio
FROM xml_cine.peliculas_xml p,
     XMLTABLE('/pelicula/premios/premio' 
             PASSING p.documento_xml
             COLUMNS 
                 tipo_certamen TEXT PATH '@tipo_certamen',
                 nombre_premio TEXT PATH 'nombre/text()',
                 prestigio TEXT PATH 'prestigio/text()',
                 prestigio_numerico NUMERIC PATH 'CASE prestigio/text() 
                                                   WHEN "Muy Alto" THEN 3 
                                                   WHEN "Alto" THEN 2 
                                                   ELSE 1 END'
     ) AS prem
GROUP BY prem.tipo_certamen
ORDER BY total_premios DESC;

-- Consulta usando transformación XML: Crear resumen de película
SELECT 
    titulo,
    xml_cine.transformar_xml_resumen(documento_xml) as resumen_xml
FROM xml_cine.peliculas_xml
WHERE titulo = 'Cinema Paradiso';

-- Consulta usando XMLAGG: Crear filmografía completa de un director
SELECT xml_cine.crear_filmografia_director('Giuseppe Tornatore') as filmografia_completa;
