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
BEGIN
    RETURN QUERY
    SELECT 
        (xpath('/pelicula/informacion_basica/titulo/text()', doc))[1]::text,
        (xpath('/pelicula/informacion_basica/fecha_estreno/text()', doc))[1]::text::date,
        (xpath('/pelicula/informacion_basica/ranking/text()', doc))[1]::text::numeric(2,1),
        (xpath('/pelicula/direccion/director/nombre/text()', doc))[1]::text,
        xpath('/pelicula/clasificacion/genero/text()', doc)::text[]
    ;
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

-- Índice GIN para búsquedas XPath eficientes
CREATE INDEX idx_peliculas_xml_gin ON xml_cine.peliculas_xml USING gin(documento_xml);
CREATE INDEX idx_personas_xml_gin ON xml_cine.personas_xml USING gin(documento_xml);
CREATE INDEX idx_criticas_xml_gin ON xml_cine.criticas_xml USING gin(documento_xml);

-- Índices funcionales para búsquedas específicas
CREATE INDEX idx_pelicula_titulo_xpath ON xml_cine.peliculas_xml 
    ((xpath('/pelicula/informacion_basica/titulo/text()', documento_xml))[1]::text);

CREATE INDEX idx_pelicula_ranking_xpath ON xml_cine.peliculas_xml 
    ((xpath('/pelicula/informacion_basica/ranking/text()', documento_xml))[1]::text::numeric);

-- ===== VISTAS XML =====

-- Vista para extraer información básica de películas
CREATE VIEW xml_cine.vista_peliculas_basica AS
SELECT 
    p.id_documento,
    (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text as titulo,
    (xpath('/pelicula/informacion_basica/fecha_estreno/text()', p.documento_xml))[1]::text::date as fecha_estreno,
    (xpath('/pelicula/informacion_basica/ranking/text()', p.documento_xml))[1]::text::numeric(2,1) as ranking,
    (xpath('/pelicula/direccion/director/nombre/text()', p.documento_xml))[1]::text as director,
    xpath('/pelicula/clasificacion/genero/text()', p.documento_xml) as generos
FROM xml_cine.peliculas_xml p;

-- Vista para críticas extraídas
CREATE VIEW xml_cine.vista_criticas_extraidas AS
SELECT 
    c.id_documento,
    c.id_pelicula,
    (xpath('/criticas/critica/@fecha', c.documento_xml))[1]::text::date as fecha,
    (xpath('/criticas/critica/autor/text()', c.documento_xml))[1]::text as autor,
    (xpath('/criticas/critica/medio/text()', c.documento_xml))[1]::text as medio,
    (xpath('/criticas/critica/puntuacion/text()', c.documento_xml))[1]::text::numeric(2,1) as puntuacion,
    (xpath('/criticas/critica/contenido/text()', c.documento_xml))[1]::text as contenido
FROM xml_cine.criticas_xml c;

-- Vista para análisis de actores
CREATE VIEW xml_cine.vista_actores_salarios AS
SELECT 
    per.id_documento,
    (xpath('/persona/informacion_basica/nombre/text()', per.documento_xml))[1]::text as nombre,
    (xpath('/persona/informacion_financiera/salario_total/text()', per.documento_xml))[1]::text::numeric(12,2) as salario_total,
    xpath('/persona/filmografia/pelicula/titulo/text()', per.documento_xml) as peliculas
FROM xml_cine.personas_xml per
WHERE per.tipo_persona = 'Actor';

-- ===== FUNCIONES DE CONSULTA ESPECÍFICAS =====

-- Función para obtener salarios de actores por película (usando XQuery-like)
CREATE OR REPLACE FUNCTION xml_cine.obtener_salarios_actores_pelicula(titulo_pelicula TEXT)
RETURNS TABLE(
    actor_nombre TEXT,
    salario NUMERIC(12,2),
    tipo_actuacion TEXT,
    personaje TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (xpath('/persona/informacion_basica/nombre/text()', per.documento_xml))[1]::text,
        (xpath('/persona/filmografia/pelicula[titulo="' || titulo_pelicula || '"]/salario/text()', per.documento_xml))[1]::text::numeric(12,2),
        (xpath('/persona/filmografia/pelicula[titulo="' || titulo_pelicula || '"]/tipo_actuacion/text()', per.documento_xml))[1]::text,
        (xpath('/persona/filmografia/pelicula[titulo="' || titulo_pelicula || '"]/personaje/text()', per.documento_xml))[1]::text
    FROM xml_cine.personas_xml per
    WHERE per.tipo_persona = 'Actor'
      AND xpath_exists('/persona/filmografia/pelicula[titulo="' || titulo_pelicula || '"]', per.documento_xml);
END;
$$ LANGUAGE plpgsql;

-- Función para obtener premios usando XMLTABLE
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
    WHERE (xpath('/pelicula/informacion_basica/titulo/text()', p.documento_xml))[1]::text = titulo_pelicula;
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
BEGIN
    -- Crear un resumen XML simplificado
    RETURN xmlelement(
        name "resumen_pelicula",
        xmlelement(name "titulo", (xpath('/pelicula/informacion_basica/titulo/text()', doc))[1]),
        xmlelement(name "director", (xpath('/pelicula/direccion/director/nombre/text()', doc))[1]),
        xmlelement(name "año", extract(year from (xpath('/pelicula/informacion_basica/fecha_estreno/text()', doc))[1]::text::date)),
        xmlelement(name "ranking", (xpath('/pelicula/informacion_basica/ranking/text()', doc))[1])
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
                xmlelement(name "titulo", (xpath('/pelicula/informacion_basica/titulo/text()', documento_xml))[1]),
                xmlelement(name "año", extract(year from (xpath('/pelicula/informacion_basica/fecha_estreno/text()', documento_xml))[1]::text::date)),
                xmlelement(name "ranking", (xpath('/pelicula/informacion_basica/ranking/text()', documento_xml))[1])
            )
        )
    )
    INTO resultado
    FROM xml_cine.peliculas_xml
    WHERE (xpath('/pelicula/direccion/director/nombre/text()', documento_xml))[1]::text = nombre_director;
    
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

-- Comentarios de documentación
COMMENT ON SCHEMA xml_cine IS 'Esquema para el modelo semiestructurado XML del sistema de cine';
COMMENT ON TABLE xml_cine.peliculas_xml IS 'Almacena documentos XML completos de películas';
COMMENT ON TABLE xml_cine.personas_xml IS 'Almacena documentos XML de personas (actores, directores, productores)';
COMMENT ON FUNCTION xml_cine.validar_xml_pelicula IS 'Valida que un documento XML tenga la estructura correcta para una película';
COMMENT ON FUNCTION xml_cine.buscar_peliculas_xpath IS 'Busca películas usando expresiones XPath personalizadas';
