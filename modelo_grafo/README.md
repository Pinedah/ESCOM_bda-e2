# Modelo Orientado a Grafos - Neo4j

## Descripción
Este modelo representa el sistema de películas usando Neo4j, donde las entidades se modelan como nodos y las relaciones como aristas. El grafo captura la naturaleza interconectada del mundo cinematográfico, permitiendo consultas complejas sobre relaciones y patrones.

## Estructura del Grafo

### Nodos (Entidades)
- **Persona**: Directores, actores, productores
- **Pelicula**: Información de películas
- **Genero**: Géneros cinematográficos
- **Estudio**: Estudios de producción
- **Pais**: Países de origen
- **Idioma**: Idiomas de las películas
- **Premio**: Premios cinematográficos
- **Critica**: Críticas y reseñas

### Relaciones (Aristas)
- **DIRIGIO**: Persona → Pelicula
- **ACTUO_EN**: Persona → Pelicula {papel, tipo}
- **PRODUJO**: Persona → Pelicula {rol}
- **PERTENECE_A**: Pelicula → Genero
- **PRODUCIDA_POR**: Pelicula → Estudio
- **ORIGEN**: Pelicula → Pais
- **EN_IDIOMA**: Pelicula → Idioma
- **GANO_PREMIO**: Persona/Pelicula → Premio {año, categoria}
- **RECIBIO_CRITICA**: Pelicula → Critica
- **COLABORO_CON**: Persona → Persona {peliculas_en_comun}

## Archivos del Modelo

1. **schema_grafo.cypher**: Definición de constraints e índices
2. **poblar_datos_grafo.cypher**: Inserción de datos de prueba
3. **consultas_negocio_grafo.cypher**: Consultas de negocio requeridas
4. **README.md**: Este archivo de documentación

## Casos de Uso Avanzados

### 1. Análisis de Redes Sociales
```cypher
// Encontrar colaboradores frecuentes
MATCH (p1:Persona)-[c:COLABORO_CON]->(p2:Persona)
WHERE c.peliculas_en_comun > 1
RETURN p1.nombre, p2.nombre, c.peliculas_en_comun
```

### 2. Recomendaciones
```cypher
// Recomendar películas por género
MATCH (p:Pelicula {titulo: 'Cinema Paradiso'})-[:PERTENECE_A]->(g:Genero)
MATCH (otras:Pelicula)-[:PERTENECE_A]->(g)
WHERE p <> otras
RETURN otras.titulo, otras.rating
ORDER BY otras.rating DESC
```

### 3. Análisis de Centralidad
```cypher
// Personas más conectadas
MATCH (p:Persona)-[r]-()
RETURN p.nombre, count(r) as conexiones
ORDER BY conexiones DESC
```

## Ventajas del Modelo de Grafo

1. **Navegación Natural**: Las consultas siguen la estructura natural de las relaciones
2. **Flexibilidad**: Fácil agregar nuevos tipos de nodos y relaciones
3. **Análisis de Patrones**: Identificación de patrones complejos en las relaciones
4. **Escalabilidad**: Rendimiento consistente en consultas de profundidad variable
5. **Visualización**: Representación gráfica intuitiva de los datos

## Consultas de Negocio Implementadas

- **A**: Total de salarios de actores en Cinema Paradiso
- **B**: Premios recibidos por Cinema Paradiso con ranking
- **C**: Aportes económicos de Franco Cristaldi
- **D**: Críticas de Cinema Paradiso en período específico
- **E**: Personas involucradas en Cinema Paradiso con datos completos

## Ejecución

```bash
# Iniciar Neo4j en Docker
docker-compose up neo4j

# Ejecutar scripts en orden:
# 1. schema_grafo.cypher
# 2. poblar_datos_grafo.cypher
# 3. consultas_negocio_grafo.cypher
```

La interfaz web de Neo4j estará disponible en: http://localhost:7474
