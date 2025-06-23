# 📊 PROYECTO BASES DE DATOS AVANZADAS - IPN ESCOM

## 🎯 Descripción del Proyecto

Este proyecto implementa la **transformación de un modelo Entidad-Relación (ER) de películas** a **cinco diferentes paradigmas de bases de datos**, cumpliendo con los requisitos del examen de Bases de Datos Avanzadas del Instituto Politécnico Nacional - Escuela Superior de Cómputo (IPN-ESCOM).

## 🏗️ Arquitectura del Sistema

```
Sistema de Películas (Cinema Paradiso)
├── 🌟 Modelo Multidimensional (Estrella) - PostgreSQL
├── 🧱 Modelo Relacional-Objetual - PostgreSQL  
├── 🗂️ Modelo Semiestructurado XML - PostgreSQL
├── 🧾 Modelo Semiestructurado JSON - MongoDB
└── 🧠 Modelo Orientado a Grafos - Neo4j
```

## 📂 Estructura del Proyecto

```
ESCOM_bda-e2/
├── docker-compose.yml              # Orquestación de servicios
├── modelo_multidimensional/        # Esquema estrella (PostgreSQL)
│   ├── schema_multidimensional.sql
│   ├── poblar_dimensiones.sql
│   ├── poblar_hechos.sql
│   └── consultas_negocio.sql
├── modelo_objetual/                # Modelo relacional-objetual (PostgreSQL)
│   ├── schema_objetual.sql
│   ├── poblar_datos_objetual.sql
│   └── consultas_objetual.sql
├── modelo_xml/                     # Modelo XML (PostgreSQL)
│   ├── schema_xml.sql
│   ├── schema_cine.xsd
│   ├── poblar_datos_xml.sql
│   └── consultas_xml.sql
├── modelo_json/                    # Modelo JSON (MongoDB)
│   ├── schema_cine.json
│   └── crear_poblar_mongodb.js
├── modelo_grafo/                   # Modelo de grafos (Neo4j)
│   ├── schema_grafo.cypher
│   ├── poblar_datos_grafo.cypher
│   ├── consultas_negocio_grafo.cypher
│   └── README.md
└── scripts/                       # Scripts de ejecución
    ├── ejecutar_proyecto.sh       # Script maestro (Linux/Mac)
    ├── ejecutar_proyecto.ps1      # Script maestro (Windows)
    ├── ejecutar_multidimensional.sh
    ├── ejecutar_objetual.sh
    ├── ejecutar_xml.sh
    ├── ejecutar_mongodb.sh
    └── ejecutar_neo4j.sh
```

## 🚀 Inicio Rápido

### Prerrequisitos
- Docker & Docker Compose
- Git

### Ejecución Completa

1. **Clonar el repositorio:**
```bash
git clone <repository-url>
cd ESCOM_bda-e2
```

2. **Ejecutar el proyecto:**

**Linux/Mac:**
```bash
cd scripts
chmod +x ejecutar_proyecto.sh
./ejecutar_proyecto.sh
```

**Windows:**
```powershell
cd scripts
.\ejecutar_proyecto.ps1
```

3. **Usar el menú interactivo** para ejecutar modelos individuales o todos juntos.

## 🐳 Servicios Docker

El archivo `docker-compose.yml` incluye:

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| PostgreSQL | 5432 | Base de datos principal |
| pgAdmin | 8080 | Interfaz web PostgreSQL |
| MongoDB | 27017 | Base de datos NoSQL |
| Mongo Express | 8081 | Interfaz web MongoDB |
| Neo4j | 7474/7687 | Base de datos de grafos |

### Credenciales por Defecto

- **PostgreSQL**: `postgres` / `postgres123`
- **pgAdmin**: `admin@admin.com` / `admin123`
- **MongoDB**: Sin autenticación
- **Neo4j**: `neo4j` / `password123`

## 📋 Consultas de Negocio Implementadas

Todas las consultas están implementadas en los **5 modelos**:

### A. Salarios de Actores
> Total de salarios pagados a los actores de "Cinema Paradiso", dirigida por "Giuseppe Tornatore"

### B. Premios Recibidos
> Premios recibidos por "Cinema Paradiso", con ranking, nombre del premio y lugar del certamen

### C. Aportes del Productor
> Total de aportes económicos del productor "Franco Cristaldi"

### D. Críticas por Período
> Críticas de "Cinema Paradiso" entre fechas específicas, con medio, fecha y autor

### E. Personas Involucradas
> Personas involucradas en la filmación, con nombre, rol, edad actual, estado civil y teléfono

## 🔧 Modelos Implementados

### 1. 🌟 Modelo Multidimensional (PostgreSQL)
- **Esquema Estrella** con tabla de hechos y dimensiones
- **Vistas materializadas** para consultas analíticas
- **Índices optimizados** para OLAP
- **+100 registros** en hechos, +50 en dimensiones

### 2. 🧱 Modelo Relacional-Objetual (PostgreSQL)
- **Tipos compuestos** y dominios personalizados
- **Herencia de tablas** para especialización
- **Funciones PL/pgSQL** para lógica de negocio
- **Triggers** para validaciones automáticas

### 3. 🗂️ Modelo XML (PostgreSQL)
- **XML Schema (XSD)** para validación
- **Funciones SQL/XML** para consultas
- **XPath** para navegación de documentos
- **Triggers de validación** XML

### 4. 🧾 Modelo JSON (MongoDB)
- **JSON Schema** para validación de documentos
- **Índices compuestos** para consultas eficientes
- **Agregaciones complejas** con pipeline
- **Validación a nivel de colección**

### 5. 🧠 Modelo Orientado a Grafos (Neo4j)
- **Nodos** para entidades (Persona, Película, Premio, etc.)
- **Relaciones** con propiedades (DIRIGIO, ACTUO_EN, etc.)
- **Consultas Cypher** para análisis de redes
- **Índices** para búsquedas eficientes

## 📊 Poblado de Datos

Todos los modelos contienen **datos realistas y consistentes**:

- **Películas**: Cinema Paradiso, The Godfather, Goodfellas, etc.
- **Directores**: Giuseppe Tornatore, Martin Scorsese, Francis Ford Coppola
- **Actores**: Philippe Noiret, Robert De Niro, Al Pacino
- **Productores**: Franco Cristaldi, Kathleen Kennedy
- **Datos cuantitativos**: Salarios $600K-$4.9M, presupuestos reales, fechas históricas

## 🎛️ Interfaces de Administración

Una vez iniciados los servicios:

- **pgAdmin**: http://localhost:8080 (PostgreSQL)
- **Mongo Express**: http://localhost:8081 (MongoDB)  
- **Neo4j Browser**: http://localhost:7474 (Neo4j)

## 🧪 Validaciones Implementadas

- **Rangos de salarios**: $600,000 - $4,900,000
- **Estados civiles**: Soltero, Casado, Divorciado, Viudo, Unión libre
- **Ratings**: 1.0 - 5.0 con decimales
- **Fechas**: Formato YYYY-MM-DD consistente
- **Aportaciones**: Valores positivos con 2 decimales
- **Resúmenes**: 250-450 palabras

## 📈 Características Avanzadas

### Multidimensional
- Vistas materializadas para dashboards
- Índices bitmap para consultas analíticas
- Particionamiento por fecha

### Objetual
- Herencia para especialización Actor/Director/Productor
- Tipos compuestos para direcciones y contactos
- Funciones para cálculos de business logic

### XML
- Validación automática con XSD
- Índices funcionales en expresiones XPath
- Consultas jerárquicas complejas

### JSON/MongoDB
- Índices geoespaciales para ubicaciones
- Text search para contenido de críticas
- Agregaciones para analytics en tiempo real

### Grafos/Neo4j
- Algoritmos de centralidad para influencers
- Recomendaciones basadas en grafos
- Análisis de redes sociales cinematográficas

## 🔄 Flujo de Ejecución

1. **Inicialización**: Docker Compose levanta todos los servicios
2. **Esquemas**: Se crean las estructuras en cada BD
3. **Población**: Se insertan datos consistentes
4. **Consultas**: Se ejecutan las 5 consultas de negocio
5. **Validación**: Se verifican resultados y consistencia

## 📖 Documentación Adicional

- Cada modelo incluye su propio `README.md`
- Diagramas de esquemas en carpeta `docs/` (si existe)
- Comentarios detallados en todos los scripts SQL/Cypher/JS

## 🎓 Contexto Académico

**Institución**: Instituto Politécnico Nacional - ESCOM  
**Materia**: Bases de Datos Avanzadas  
**Objetivo**: Demostrar dominio de múltiples paradigmas de BD  
**Enfoque**: Transformación de modelo ER a NoSQL, XML, OLAP y Grafos

---

## 👥 Créditos

Desarrollado como proyecto académico para IPN-ESCOM, implementando las mejores prácticas en:
- Modelado multidimensional
- Programación orientada a objetos en BD
- Procesamiento de documentos semiestructurados  
- Bases de datos NoSQL
- Análisis de grafos y redes

**¡Listo para ejecutar y demostrar! 🚀**
