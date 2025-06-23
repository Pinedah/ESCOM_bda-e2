-- MODELO MULTIDIMENSIONAL (ESTRELLA) - POSTGRESQL
-- Esquema de estrella para análisis de películas

-- Crear esquema específico para el modelo multidimensional
CREATE SCHEMA IF NOT EXISTS dw_cine;

-- Dimensión Tiempo
CREATE TABLE dw_cine.dim_tiempo (
    id_tiempo SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    anio SMALLINT NOT NULL,
    mes SMALLINT NOT NULL,
    dia SMALLINT NOT NULL,
    trimestre SMALLINT NOT NULL,
    semestre SMALLINT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    nombre_dia VARCHAR(20) NOT NULL,
    es_fin_semana BOOLEAN NOT NULL,
    es_festivo BOOLEAN DEFAULT FALSE
);

-- Dimensión Persona (Actor, Director, Productor)
CREATE TABLE dw_cine.dim_persona (
    id_persona SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    edad_actual INTEGER NOT NULL,
    estado_civil VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    tipo_persona VARCHAR(20) NOT NULL CHECK (tipo_persona IN ('Actor', 'Director', 'Productor')),
    rango_edad VARCHAR(20) NOT NULL,
    generacion VARCHAR(20) NOT NULL
);

-- Dimensión Película
CREATE TABLE dw_cine.dim_pelicula (
    id_pelicula SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    resumen TEXT,
    fecha_estreno DATE,
    anio_estreno SMALLINT,
    ranking DECIMAL(2,1) CHECK (ranking BETWEEN 1.0 AND 5.0),
    categoria_ranking VARCHAR(20) NOT NULL,
    duracion_resumen INTEGER NOT NULL, -- número de palabras
    decada VARCHAR(10) NOT NULL
);

-- Dimensión Tipo Actuación
CREATE TABLE dw_cine.dim_tipo_actuacion (
    id_tipo_actuacion SERIAL PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    jerarquia SMALLINT NOT NULL,
    es_principal BOOLEAN NOT NULL
);

-- Dimensión Certamen
CREATE TABLE dw_cine.dim_certamen (
    id_certamen SERIAL PRIMARY KEY,
    tipo_certamen VARCHAR(50) NOT NULL,
    prestigio VARCHAR(20) NOT NULL,
    alcance VARCHAR(20) NOT NULL
);

-- Dimensión Premio
CREATE TABLE dw_cine.dim_premio (
    id_premio SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    importancia VARCHAR(20) NOT NULL
);

-- Dimensión Medio de Crítica
CREATE TABLE dw_cine.dim_medio_critica (
    id_medio SERIAL PRIMARY KEY,
    nombre_medio VARCHAR(100) NOT NULL,
    tipo_medio VARCHAR(30) NOT NULL,
    credibilidad VARCHAR(20) NOT NULL
);

-- TABLA DE HECHOS PRINCIPAL: Participación en Películas
CREATE TABLE dw_cine.hechos_participacion (
    id_hecho SERIAL PRIMARY KEY,
    id_pelicula INTEGER NOT NULL,
    id_persona INTEGER NOT NULL,
    id_tiempo_estreno INTEGER NOT NULL,
    id_tipo_actuacion INTEGER,
    
    -- Medidas/Métricas
    salario_actor DECIMAL(12,2) DEFAULT 0,
    aportacion_productor DECIMAL(12,2) DEFAULT 0,
    numero_peliculas_persona INTEGER DEFAULT 1,
    
    -- Claves foráneas
    FOREIGN KEY (id_pelicula) REFERENCES dw_cine.dim_pelicula(id_pelicula),
    FOREIGN KEY (id_persona) REFERENCES dw_cine.dim_persona(id_persona),
    FOREIGN KEY (id_tiempo_estreno) REFERENCES dw_cine.dim_tiempo(id_tiempo),
    FOREIGN KEY (id_tipo_actuacion) REFERENCES dw_cine.dim_tipo_actuacion(id_tipo_actuacion)
);

-- TABLA DE HECHOS SECUNDARIA: Premios
CREATE TABLE dw_cine.hechos_premios (
    id_hecho_premio SERIAL PRIMARY KEY,
    id_pelicula INTEGER NOT NULL,
    id_premio INTEGER NOT NULL,
    id_certamen INTEGER NOT NULL,
    id_tiempo_otorgamiento INTEGER NOT NULL,
    
    -- Medidas/Métricas
    numero_premios INTEGER DEFAULT 1,
    valor_estimado_premio DECIMAL(10,2) DEFAULT 0,
    
    -- Claves foráneas
    FOREIGN KEY (id_pelicula) REFERENCES dw_cine.dim_pelicula(id_pelicula),
    FOREIGN KEY (id_premio) REFERENCES dw_cine.dim_premio(id_premio),
    FOREIGN KEY (id_certamen) REFERENCES dw_cine.dim_certamen(id_certamen),
    FOREIGN KEY (id_tiempo_otorgamiento) REFERENCES dw_cine.dim_tiempo(id_tiempo)
);

-- TABLA DE HECHOS TERCIARIA: Críticas
CREATE TABLE dw_cine.hechos_criticas (
    id_hecho_critica SERIAL PRIMARY KEY,
    id_pelicula INTEGER NOT NULL,
    id_medio INTEGER NOT NULL,
    id_tiempo_critica INTEGER NOT NULL,
    
    -- Medidas/Métricas
    numero_criticas INTEGER DEFAULT 1,
    longitud_critica INTEGER DEFAULT 0,
    sentimiento_critica VARCHAR(20) DEFAULT 'Neutral',
    
    -- Claves foráneas
    FOREIGN KEY (id_pelicula) REFERENCES dw_cine.dim_pelicula(id_pelicula),
    FOREIGN KEY (id_medio) REFERENCES dw_cine.dim_medio_critica(id_medio),
    FOREIGN KEY (id_tiempo_critica) REFERENCES dw_cine.dim_tiempo(id_tiempo)
);

-- Índices para optimizar consultas
CREATE INDEX idx_hechos_participacion_pelicula ON dw_cine.hechos_participacion(id_pelicula);
CREATE INDEX idx_hechos_participacion_persona ON dw_cine.hechos_participacion(id_persona);
CREATE INDEX idx_hechos_participacion_tiempo ON dw_cine.hechos_participacion(id_tiempo_estreno);

CREATE INDEX idx_hechos_premios_pelicula ON dw_cine.hechos_premios(id_pelicula);
CREATE INDEX idx_hechos_premios_tiempo ON dw_cine.hechos_premios(id_tiempo_otorgamiento);

CREATE INDEX idx_hechos_criticas_pelicula ON dw_cine.hechos_criticas(id_pelicula);
CREATE INDEX idx_hechos_criticas_tiempo ON dw_cine.hechos_criticas(id_tiempo_critica);

-- Vista materializada para análisis rápido
CREATE MATERIALIZED VIEW dw_cine.resumen_peliculas AS
SELECT 
    p.titulo,
    p.anio_estreno,
    p.ranking,
    COUNT(DISTINCT hp.id_persona) as total_personas_involucradas,
    SUM(hp.salario_actor) as total_salarios,
    SUM(hp.aportacion_productor) as total_aportaciones,
    COUNT(DISTINCT hpr.id_premio) as total_premios,
    COUNT(DISTINCT hc.id_medio) as total_medios_critica
FROM dw_cine.dim_pelicula p
LEFT JOIN dw_cine.hechos_participacion hp ON p.id_pelicula = hp.id_pelicula
LEFT JOIN dw_cine.hechos_premios hpr ON p.id_pelicula = hpr.id_pelicula
LEFT JOIN dw_cine.hechos_criticas hc ON p.id_pelicula = hc.id_pelicula
GROUP BY p.id_pelicula, p.titulo, p.anio_estreno, p.ranking;

-- Comentarios de documentación
COMMENT ON SCHEMA dw_cine IS 'Esquema del Data Warehouse para análisis de películas';
COMMENT ON TABLE dw_cine.hechos_participacion IS 'Tabla de hechos principal que registra la participación de personas en películas';
COMMENT ON TABLE dw_cine.hechos_premios IS 'Tabla de hechos que registra los premios otorgados a películas';
COMMENT ON TABLE dw_cine.hechos_criticas IS 'Tabla de hechos que registra las críticas realizadas a películas';
