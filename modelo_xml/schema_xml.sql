-- MODELO SEMIESTRUCTURADO XML EN POSTGRESQL
-- Implementación usando tipos XML, XPath y SQL/XML

-- Crear esquema para el modelo XML
CREATE SCHEMA IF NOT EXISTS xml_cine;

-- Tabla principal para almacenar documentos XML
CREATE TABLE xml_cine.peliculas_xml (
    id_documento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    documento_xml XML NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    version INTEGER DEFAULT 1
);

-- Tabla para almacenar personas en formato XML
CREATE TABLE xml_cine.personas_xml (
    id_documento SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo_persona VARCHAR(20) NOT NULL CHECK (tipo_persona IN ('Actor', 'Director', 'Productor')),
    documento_xml XML NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para críticas en XML
CREATE TABLE xml_cine.criticas_xml (
    id_documento SERIAL PRIMARY KEY,
    id_pelicula INTEGER,
    documento_xml XML NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para premios en XML
CREATE TABLE xml_cine.premios_xml (
    id_documento SERIAL PRIMARY KEY,
    documento_xml XML NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===== FUNCIONES DE UTILIDAD XML =====

-- Función para validar documento XML contra esquema
CREATE OR REPLACE FUNCTION xml_cine.validar_xml_pelicula(doc XML)
RETURNS BOOLEAN AS $$
BEGIN
    -- Verificar elementos requeridos usando XPath
    IF xpath_exists('/pelicula/informacion_basica/titulo/text()', doc) AND
       xpath_exists('/pelicula/informacion_basica/fecha_estreno/text()', doc) AND
       xpath_exists('/pelicula/informacion_basica/ranking/text()', doc) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

-- Función para extraer información básica de película
CREATE OR REPLACE FUNCTION xml_cine.extraer_info_pelicula(doc XML)
RETURNS TABLE(
    titulo TEXT,
    fecha_estreno DATE,
    ranking NUMERIC(2,1),
    director TEXT,
    generos TEXT[]
) AS $$
DECLARE
    titulo_val TEXT;
    fecha_val TEXT;
    ranking_val TEXT;
    director_val TEXT;
    generos_val TEXT[];
BEGIN
    -- Extraer valores individualmente
    SELECT (xpath('/pelicula/informacion_basica/titulo/text()', doc))[1]::text INTO titulo_val;
    SELECT (xpath('/pelicula/informacion_basica/fecha_estreno/text()', doc))[1]::text INTO fecha_val;
    SELECT (xpath('/pelicula/informacion_basica/ranking/text()', doc))[1]::text INTO ranking_val;
    SELECT (xpath('/pelicula/direccion/director/nombre/text()', doc))[1]::text INTO director_val;
    SELECT xpath('/pelicula/clasificacion/genero/text()', doc)::text[] INTO generos_val;
    
    RETURN QUERY
    SELECT 
        titulo_val,
        fecha_val::date,
        ranking_val::numeric(2,1),
        director_val,
        generos_val;
END;
$$ LANGUAGE plpgsql;

-- Función para buscar películas por XPath
CREATE OR REPLACE FUNCTION xml_cine.buscar_peliculas_xpath(
    xpath_expression TEXT
) RETURNS TABLE(
    id INTEGER,
    titulo VARCHAR(150),
    resultado TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id_documento,
        p.titulo,
        (xpath(xpath_expression, p.documento_xml))[1]::text as resultado
    FROM xml_cine.peliculas_xml p
    WHERE xpath_exists(xpath_expression, p.documento_xml);
END;
$$ LANGUAGE plpgsql;

-- ===== TRIGGERS XML =====

-- Trigger para validar XML antes de insertar
CREATE OR REPLACE FUNCTION xml_cine.trigger_validar_xml_pelicula()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT xml_cine.validar_xml_pelicula(NEW.documento_xml) THEN
        RAISE EXCEPTION 'El documento XML no es válido para una película';
    END IF;
    
    -- Extraer y actualizar el título automáticamente
    NEW.titulo := (xpath('/pelicula/informacion_basica/titulo/text()', NEW.documento_xml))[1]::text;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validar_xml_pelicula_trigger
    BEFORE INSERT OR UPDATE ON xml_cine.peliculas_xml
    FOR EACH ROW
    EXECUTE FUNCTION xml_cine.trigger_validar_xml_pelicula();

-- ===== ÍNDICES XML =====

-- Índices GIN para búsquedas XPath (comentados por compatibilidad)
-- PostgreSQL no soporta índices GIN directos en columnas XML
-- CREATE INDEX idx_peliculas_xml_gin ON xml_cine.peliculas_xml USING gin(documento_xml);
-- CREATE INDEX idx_personas_xml_gin ON xml_cine.personas_xml USING gin(documento_xml);
-- CREATE INDEX idx_criticas_xml_gin ON xml_cine.criticas_xml USING gin(documento_xml);

-- Índices alternativos para mejorar el rendimiento
CREATE INDEX idx_peliculas_titulo ON xml_cine.peliculas_xml (titulo);
CREATE INDEX idx_personas_nombre ON xml_cine.personas_xml (nombre);
CREATE INDEX idx_personas_tipo ON xml_cine.personas_xml (tipo_persona);
CREATE INDEX idx_criticas_pelicula ON xml_cine.criticas_xml (id_pelicula);

-- Índices funcionales para búsquedas específicas (comentados por compatibilidad)
-- CREATE INDEX idx_pelicula_titulo_xpath ON xml_cine.peliculas_xml 
--     ((xpath('/pelicula/informacion_basica/titulo/text()', documento_xml))[1]::text);

-- CREATE INDEX idx_pelicula_ranking_xpath ON xml_cine.peliculas_xml 
--     ((xpath('/pelicula/informacion_basica/ranking/text()', documento_xml))[1]::text::numeric);

-- ===== VISTAS XML =====

-- Vista básica sin extracciones complejas
CREATE VIEW xml_cine.vista_peliculas_simple AS
SELECT 
    p.id_documento,
    p.titulo,
    p.documento_xml,
    p.fecha_creacion
FROM xml_cine.peliculas_xml p;

-- Vista para críticas básica
CREATE VIEW xml_cine.vista_criticas_simple AS
SELECT 
    c.id_documento,
    c.id_pelicula,
    c.documento_xml,
    c.fecha_creacion
FROM xml_cine.criticas_xml c;

-- Vista para personas básica
CREATE VIEW xml_cine.vista_personas_simple AS
SELECT 
    per.id_documento,
    per.nombre,
    per.tipo_persona,
    per.documento_xml
FROM xml_cine.personas_xml per;

-- ===== FUNCIONES DE CONSULTA ESPECÍFICAS =====

-- Función para obtener salarios de actores por película (simplificada)
CREATE OR REPLACE FUNCTION xml_cine.obtener_salarios_actores_pelicula(titulo_pelicula TEXT)
RETURNS TABLE(
    actor_nombre TEXT,
    salario NUMERIC(12,2),
    tipo_actuacion TEXT,
    personaje TEXT
) AS $$
DECLARE
    doc_xml XML;
    actor_val TEXT;
    salario_val TEXT;
    tipo_val TEXT;
    personaje_val TEXT;
BEGIN
    -- Obtener el documento XML de la película
    SELECT documento_xml INTO doc_xml
    FROM xml_cine.peliculas_xml pel
    WHERE pel.titulo = titulo_pelicula
    LIMIT 1;
    
    IF doc_xml IS NOT NULL THEN
        -- Extraer información del primer actor encontrado
        SELECT (xpath('/pelicula/reparto/participacion/actor/informacion_personal/nombre/text()', doc_xml))[1]::text INTO actor_val;
        SELECT (xpath('/pelicula/reparto/participacion/actor/informacion_financiera/salario_total/text()', doc_xml))[1]::text INTO salario_val;
        SELECT (xpath('/pelicula/reparto/participacion/tipo_actuacion/text()', doc_xml))[1]::text INTO tipo_val;
        SELECT (xpath('/pelicula/reparto/participacion/personaje/text()', doc_xml))[1]::text INTO personaje_val;
        
        RETURN QUERY
        SELECT 
            actor_val,
            salario_val::numeric(12,2),
            tipo_val,
            personaje_val;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener premios usando XMLTABLE (simplificada)
CREATE OR REPLACE FUNCTION xml_cine.obtener_premios_pelicula(titulo_pelicula TEXT)
RETURNS TABLE(
    nombre_premio TEXT,
    certamen TEXT,
    fecha_otorgamiento DATE,
    categoria TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        x.nombre_premio::text,
        x.certamen::text,
        x.fecha_otorgamiento::date,
        x.categoria::text
    FROM xml_cine.peliculas_xml p,
         XMLTABLE('/pelicula/premios/premio' 
                 PASSING p.documento_xml
                 COLUMNS 
                     nombre_premio TEXT PATH 'nombre/text()',
                     certamen TEXT PATH 'certamen/text()',
                     fecha_otorgamiento TEXT PATH 'fecha_otorgamiento/text()',
                     categoria TEXT PATH 'categoria/text()'
         ) AS x
    WHERE p.titulo = titulo_pelicula;
END;
$$ LANGUAGE plpgsql;

-- ===== PROCEDIMIENTOS DE MANTENIMIENTO XML =====

-- Procedimiento para actualizar versiones de documentos
CREATE OR REPLACE FUNCTION xml_cine.actualizar_version_documento()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version := OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_version_peliculas
    BEFORE UPDATE ON xml_cine.peliculas_xml
    FOR EACH ROW
    EXECUTE FUNCTION xml_cine.actualizar_version_documento();

-- Función para transformar XML usando XSLT (simulada con SQL/XML)
CREATE OR REPLACE FUNCTION xml_cine.transformar_xml_resumen(doc XML)
RETURNS XML AS $$
DECLARE
    titulo_val TEXT;
    director_val TEXT;
    año_val TEXT;
    ranking_val TEXT;
BEGIN
    -- Extraer valores primero
    titulo_val := (xpath('/pelicula/informacion_basica/titulo/text()', doc))[1]::text;
    director_val := (xpath('/pelicula/direccion/director/nombre/text()', doc))[1]::text;
    año_val := extract(year from (xpath('/pelicula/informacion_basica/fecha_estreno/text()', doc))[1]::text::date)::text;
    ranking_val := (xpath('/pelicula/informacion_basica/ranking/text()', doc))[1]::text;
    
    -- Crear un resumen XML simplificado
    RETURN xmlelement(
        name "resumen_pelicula",
        xmlelement(name "titulo", titulo_val),
        xmlelement(name "director", director_val),
        xmlelement(name "año", año_val),
        xmlelement(name "ranking", ranking_val)
    );
END;
$$ LANGUAGE plpgsql;

-- ===== FUNCIONES DE AGREGACIÓN XML =====

-- Función para crear un documento XML agregado de todas las películas de un director
CREATE OR REPLACE FUNCTION xml_cine.crear_filmografia_director(nombre_director TEXT)
RETURNS XML AS $$
DECLARE
    resultado XML;
BEGIN
    SELECT xmlelement(
        name "filmografia_director",
        xmlattributes(nombre_director as "nombre"),
        xmlagg(
            xmlelement(
                name "pelicula",
                xmlelement(name "titulo", sub.titulo),
                xmlelement(name "año", sub.año),
                xmlelement(name "ranking", sub.ranking)
            )
        )
    )
    INTO resultado
    FROM (
        SELECT 
            (xpath('/pelicula/informacion_basica/titulo/text()', documento_xml))[1]::text as titulo,
            extract(year from (xpath('/pelicula/informacion_basica/fecha_estreno/text()', documento_xml))[1]::text::date)::text as año,
            (xpath('/pelicula/informacion_basica/ranking/text()', documento_xml))[1]::text as ranking
        FROM xml_cine.peliculas_xml
        WHERE (xpath('/pelicula/direccion/director/nombre/text()', documento_xml))[1]::text = nombre_director
    ) sub;
    
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

-- Comentarios de documentación
COMMENT ON SCHEMA xml_cine IS 'Esquema para el modelo semiestructurado XML del sistema de cine';
COMMENT ON TABLE xml_cine.peliculas_xml IS 'Almacena documentos XML completos de películas';
COMMENT ON TABLE xml_cine.personas_xml IS 'Almacena documentos XML de personas (actores, directores, productores)';
COMMENT ON FUNCTION xml_cine.validar_xml_pelicula IS 'Valida que un documento XML tenga la estructura correcta para una película';
COMMENT ON FUNCTION xml_cine.buscar_peliculas_xpath IS 'Busca películas usando expresiones XPath personalizadas';
