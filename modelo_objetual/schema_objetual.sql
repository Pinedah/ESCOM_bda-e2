-- MODELO RELACIONAL-OBJETUAL EN POSTGRESQL
-- Implementación usando tipos compuestos, herencia, dominios y funciones PL/pgSQL

-- Crear esquema para el modelo objetual
CREATE SCHEMA IF NOT EXISTS obj_cine;

-- ===== DOMINIOS PERSONALIZADOS =====

-- Dominio para salarios de actores
CREATE DOMAIN obj_cine.salario_actor AS NUMERIC(12,2)
    CHECK (VALUE BETWEEN 600000.00 AND 4900000.00);

-- Dominio para aportaciones económicas
CREATE DOMAIN obj_cine.aportacion_economica AS NUMERIC(12,2)
    CHECK (VALUE > 0);

-- Dominio para ranking de películas
CREATE DOMAIN obj_cine.ranking_pelicula AS NUMERIC(2,1)
    CHECK (VALUE BETWEEN 1.0 AND 5.0);

-- Dominio para teléfonos
CREATE DOMAIN obj_cine.telefono AS VARCHAR(20)
    CHECK (VALUE ~ '^[+]?[0-9\-\s()]+$');

-- Dominio para resumen de películas (250-450 palabras)
CREATE DOMAIN obj_cine.resumen_pelicula AS TEXT
    CHECK (array_length(string_to_array(VALUE, ' '), 1) BETWEEN 250 AND 450);

-- ===== TIPOS COMPUESTOS =====

-- Tipo para información de contacto
CREATE TYPE obj_cine.tipo_contacto AS (
    telefono obj_cine.telefono,
    email VARCHAR(100),
    direccion TEXT
);

-- Tipo para información personal
CREATE TYPE obj_cine.tipo_info_personal AS (
    fecha_nacimiento DATE,
    lugar_nacimiento VARCHAR(100),
    estado_civil VARCHAR(50),
    contacto obj_cine.tipo_contacto
);

-- Tipo para información financiera
CREATE TYPE obj_cine.tipo_info_financiera AS (
    salario obj_cine.salario_actor,
    bonificaciones NUMERIC(10,2),
    total_ganado NUMERIC(12,2)
);

-- Tipo para información de producción
CREATE TYPE obj_cine.tipo_info_produccion AS (
    aportacion obj_cine.aportacion_economica,
    porcentaje_participacion NUMERIC(5,2),
    tipo_inversion VARCHAR(50)
);

-- Tipo para crítica completa
CREATE TYPE obj_cine.tipo_critica AS (
    autor VARCHAR(100),
    medio VARCHAR(100),
    fecha DATE,
    contenido TEXT,
    puntuacion NUMERIC(2,1),
    sentimiento VARCHAR(20)
);

-- Tipo para premio completo
CREATE TYPE obj_cine.tipo_premio AS (
    nombre VARCHAR(100),
    certamen VARCHAR(100),
    fecha_otorgamiento DATE,
    categoria VARCHAR(50),
    prestigio VARCHAR(20)
);

-- ===== TABLAS CON HERENCIA =====

-- Tabla padre: Persona
CREATE TABLE obj_cine.persona (
    id_persona SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    info_personal obj_cine.tipo_info_personal NOT NULL,
    biografia TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla hija: Actor (hereda de persona)
CREATE TABLE obj_cine.actor (
    info_financiera obj_cine.tipo_info_financiera,
    especialidad VARCHAR(50),
    años_experiencia INTEGER,
    tipo_actuacion VARCHAR(50)[] -- Array de tipos de actuación
) INHERITS (obj_cine.persona);

-- Tabla hija: Director (hereda de persona)
CREATE TABLE obj_cine.director (
    estilo_direccion VARCHAR(100),
    peliculas_dirigidas INTEGER DEFAULT 0,
    premios_direccion VARCHAR(100)[],
    escuela_cine VARCHAR(100)
) INHERITS (obj_cine.persona);

-- Tabla hija: Productor (hereda de persona)
CREATE TABLE obj_cine.productor (
    info_produccion obj_cine.tipo_info_produccion,
    empresa_productora VARCHAR(100),
    tipo_productor VARCHAR(50),
    proyectos_activos INTEGER DEFAULT 0
) INHERITS (obj_cine.persona);

-- ===== TABLAS PRINCIPALES =====

-- Tabla de películas con tipos compuestos
CREATE TABLE obj_cine.pelicula (
    id_pelicula SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    resumen obj_cine.resumen_pelicula,
    fecha_estreno DATE,
    ranking obj_cine.ranking_pelicula,
    duracion_minutos INTEGER,
    genero VARCHAR(50)[],
    idioma_original VARCHAR(50),
    pais_origen VARCHAR(50),
    presupuesto NUMERIC(12,2),
    recaudacion NUMERIC(12,2),
    id_director INTEGER REFERENCES obj_cine.director(id_persona),
    criticas obj_cine.tipo_critica[],
    premios obj_cine.tipo_premio[],
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de participación (relación many-to-many mejorada)
CREATE TABLE obj_cine.participacion (
    id_participacion SERIAL PRIMARY KEY,
    id_actor INTEGER REFERENCES obj_cine.actor(id_persona),
    id_pelicula INTEGER REFERENCES obj_cine.pelicula(id_pelicula),
    tipo_participacion VARCHAR(50) NOT NULL,
    personaje VARCHAR(100),
    info_financiera obj_cine.tipo_info_financiera,
    fecha_inicio_rodaje DATE,
    fecha_fin_rodaje DATE,
    notas TEXT,
    UNIQUE(id_actor, id_pelicula, tipo_participacion)
);

-- Tabla de producción (relación many-to-many mejorada)
CREATE TABLE obj_cine.produccion (
    id_produccion SERIAL PRIMARY KEY,
    id_productor INTEGER REFERENCES obj_cine.productor(id_persona),
    id_pelicula INTEGER REFERENCES obj_cine.pelicula(id_pelicula),
    info_produccion obj_cine.tipo_info_produccion,
    rol_produccion VARCHAR(50),
    fecha_inicio DATE,
    fecha_fin DATE,
    UNIQUE(id_productor, id_pelicula)
);

-- ===== FUNCIONES EN PL/pgSQL =====

-- Función para calcular la edad de una persona
CREATE OR REPLACE FUNCTION obj_cine.calcular_edad(info_personal obj_cine.tipo_info_personal)
RETURNS INTEGER AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM AGE(CURRENT_DATE, info_personal.fecha_nacimiento));
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Función para obtener el salario total de un actor
CREATE OR REPLACE FUNCTION obj_cine.obtener_salario_total_actor(actor_id INTEGER)
RETURNS NUMERIC(12,2) AS $$
DECLARE
    total_salario NUMERIC(12,2) := 0;
    participacion_record RECORD;
BEGIN
    FOR participacion_record IN 
        SELECT (info_financiera).total_ganado 
        FROM obj_cine.participacion 
        WHERE id_actor = actor_id
    LOOP
        total_salario := total_salario + COALESCE(participacion_record.total_ganado, 0);
    END LOOP;
    
    RETURN total_salario;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener el total de aportaciones de un productor
CREATE OR REPLACE FUNCTION obj_cine.obtener_aportaciones_productor(productor_id INTEGER)
RETURNS NUMERIC(12,2) AS $$
DECLARE
    total_aportacion NUMERIC(12,2) := 0;
    produccion_record RECORD;
BEGIN
    FOR produccion_record IN 
        SELECT (info_produccion).aportacion 
        FROM obj_cine.produccion 
        WHERE id_productor = productor_id
    LOOP
        total_aportacion := total_aportacion + COALESCE(produccion_record.aportacion, 0);
    END LOOP;
    
    RETURN total_aportacion;
END;
$$ LANGUAGE plpgsql;

-- Función para agregar una crítica a una película
CREATE OR REPLACE FUNCTION obj_cine.agregar_critica(
    pelicula_id INTEGER,
    nueva_critica obj_cine.tipo_critica
) RETURNS VOID AS $$
BEGIN
    UPDATE obj_cine.pelicula 
    SET criticas = COALESCE(criticas, '{}') || nueva_critica
    WHERE id_pelicula = pelicula_id;
END;
$$ LANGUAGE plpgsql;

-- Función para agregar un premio a una película
CREATE OR REPLACE FUNCTION obj_cine.agregar_premio(
    pelicula_id INTEGER,
    nuevo_premio obj_cine.tipo_premio
) RETURNS VOID AS $$
BEGIN
    UPDATE obj_cine.pelicula 
    SET premios = COALESCE(premios, '{}') || nuevo_premio
    WHERE id_pelicula = pelicula_id;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener todas las personas de un tipo específico
CREATE OR REPLACE FUNCTION obj_cine.obtener_personas_por_tipo(tipo_persona TEXT)
RETURNS TABLE(
    id INTEGER,
    nombre VARCHAR(100),
    edad INTEGER,
    telefono VARCHAR(20),
    estado_civil VARCHAR(50)
) AS $$
BEGIN
    CASE tipo_persona
        WHEN 'actor' THEN
            RETURN QUERY
            SELECT 
                a.id_persona,
                a.nombre,
                obj_cine.calcular_edad(a.info_personal),
                (a.info_personal).contacto.telefono,
                (a.info_personal).estado_civil
            FROM obj_cine.actor a;
        
        WHEN 'director' THEN
            RETURN QUERY
            SELECT 
                d.id_persona,
                d.nombre,
                obj_cine.calcular_edad(d.info_personal),
                (d.info_personal).contacto.telefono,
                (d.info_personal).estado_civil
            FROM obj_cine.director d;
        
        WHEN 'productor' THEN
            RETURN QUERY
            SELECT 
                p.id_persona,
                p.nombre,
                obj_cine.calcular_edad(p.info_personal),
                (p.info_personal).contacto.telefono,
                (p.info_personal).estado_civil
            FROM obj_cine.productor p;
        
        ELSE
            RETURN QUERY
            SELECT 
                per.id_persona,
                per.nombre,
                obj_cine.calcular_edad(per.info_personal),
                (per.info_personal).contacto.telefono,
                (per.info_personal).estado_civil
            FROM obj_cine.persona per;
    END CASE;
END;
$$ LANGUAGE plpgsql;

-- Función para buscar películas por criterios
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
        p.ranking,
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

-- ===== TRIGGERS =====

-- Trigger para actualizar automáticamente el número de películas dirigidas
CREATE OR REPLACE FUNCTION obj_cine.actualizar_peliculas_dirigidas()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE obj_cine.director 
        SET peliculas_dirigidas = peliculas_dirigidas + 1
        WHERE id_persona = NEW.id_director;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE obj_cine.director 
        SET peliculas_dirigidas = peliculas_dirigidas - 1
        WHERE id_persona = OLD.id_director;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_peliculas_dirigidas
    AFTER INSERT OR DELETE ON obj_cine.pelicula
    FOR EACH ROW
    EXECUTE FUNCTION obj_cine.actualizar_peliculas_dirigidas();

-- Trigger para validar datos antes de insertar
CREATE OR REPLACE FUNCTION obj_cine.validar_persona()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que la fecha de nacimiento no sea futura
    IF (NEW.info_personal).fecha_nacimiento > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de nacimiento no puede ser futura';
    END IF;
    
    -- Validar que tenga al menos 18 años
    IF obj_cine.calcular_edad(NEW.info_personal) < 18 THEN
        RAISE EXCEPTION 'La persona debe tener al menos 18 años';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_actor
    BEFORE INSERT OR UPDATE ON obj_cine.actor
    FOR EACH ROW
    EXECUTE FUNCTION obj_cine.validar_persona();

CREATE TRIGGER trigger_validar_director
    BEFORE INSERT OR UPDATE ON obj_cine.director
    FOR EACH ROW
    EXECUTE FUNCTION obj_cine.validar_persona();

CREATE TRIGGER trigger_validar_productor
    BEFORE INSERT OR UPDATE ON obj_cine.productor
    FOR EACH ROW
    EXECUTE FUNCTION obj_cine.validar_persona();

-- ===== ÍNDICES =====

-- Índices para optimizar consultas
CREATE INDEX idx_actor_nombre ON obj_cine.actor(nombre);
CREATE INDEX idx_director_nombre ON obj_cine.director(nombre);
CREATE INDEX idx_productor_nombre ON obj_cine.productor(nombre);
CREATE INDEX idx_pelicula_titulo ON obj_cine.pelicula(titulo);
CREATE INDEX idx_pelicula_fecha_estreno ON obj_cine.pelicula(fecha_estreno);
CREATE INDEX idx_pelicula_ranking ON obj_cine.pelicula(ranking);

-- Índice funcional para búsqueda de texto
CREATE INDEX idx_pelicula_titulo_texto ON obj_cine.pelicula USING gin(to_tsvector('spanish', titulo));

-- ===== VISTAS =====

-- Vista para obtener información completa de actores
CREATE VIEW obj_cine.vista_actores_completa AS
SELECT 
    a.id_persona,
    a.nombre,
    obj_cine.calcular_edad(a.info_personal) as edad,
    (a.info_personal).estado_civil,
    (a.info_personal).contacto.telefono,
    (a.info_financiera).salario,
    a.especialidad,
    a.años_experiencia,
    obj_cine.obtener_salario_total_actor(a.id_persona) as salario_total_carrera
FROM obj_cine.actor a;

-- Vista para obtener información completa de películas
CREATE VIEW obj_cine.vista_peliculas_completa AS
SELECT 
    p.id_pelicula,
    p.titulo,
    p.fecha_estreno,
    EXTRACT(YEAR FROM p.fecha_estreno) as año,
    p.ranking,
    d.nombre as director,
    array_length(p.premios, 1) as total_premios,
    array_length(p.criticas, 1) as total_criticas,
    p.presupuesto,
    p.recaudacion,
    CASE 
        WHEN p.recaudacion > p.presupuesto THEN 'Rentable'
        ELSE 'No Rentable'
    END as rentabilidad
FROM obj_cine.pelicula p
LEFT JOIN obj_cine.director d ON p.id_director = d.id_persona;

-- Comentarios de documentación
COMMENT ON SCHEMA obj_cine IS 'Esquema del modelo relacional-objetual para el sistema de cine';
COMMENT ON TABLE obj_cine.persona IS 'Tabla base para todas las personas del sistema usando herencia';
COMMENT ON TABLE obj_cine.actor IS 'Tabla de actores que hereda de persona';
COMMENT ON TABLE obj_cine.director IS 'Tabla de directores que hereda de persona';
COMMENT ON TABLE obj_cine.productor IS 'Tabla de productores que hereda de persona';
