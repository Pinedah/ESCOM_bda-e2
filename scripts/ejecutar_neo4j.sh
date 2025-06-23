#!/bin/bash

# ============================================================================
# SCRIPT DE EJECUCIÓN - MODELO ORIENTADO A GRAFOS (Neo4j)
# ============================================================================

echo "🧠 Ejecutando Modelo Orientado a Grafos (Neo4j)..."

# Variables
NEO4J_HOST="localhost"
NEO4J_PORT="7687"
NEO4J_HTTP_PORT="7474"
NEO4J_USER="neo4j"
NEO4J_PASS="password123"

# Función para ejecutar Cypher script
execute_cypher() {
    local file=$1
    echo "Ejecutando: $file"
    cypher-shell -a bolt://$NEO4J_HOST:$NEO4J_PORT -u $NEO4J_USER -p $NEO4J_PASS --file "$file"
    if [ $? -eq 0 ]; then
        echo "✅ $file ejecutado correctamente"
    else
        echo "❌ Error ejecutando $file"
        exit 1
    fi
}

# Esperar a que Neo4j esté listo
echo "Esperando a que Neo4j esté listo..."
sleep 20

# Verificar conexión a Neo4j
echo "Verificando conexión a Neo4j..."
cypher-shell -a bolt://$NEO4J_HOST:$NEO4J_PORT -u $NEO4J_USER -p $NEO4J_PASS "RETURN 'Neo4j conectado' as status;" --format plain
if [ $? -ne 0 ]; then
    echo "❌ No se puede conectar a Neo4j"
    echo "Verifica que Neo4j esté corriendo y las credenciales sean correctas"
    exit 1
fi

# Ejecutar scripts en orden
execute_cypher "../modelo_grafo/schema_grafo.cypher"
execute_cypher "../modelo_grafo/poblar_datos_grafo.cypher"

echo "📊 Ejecutando consultas de negocio..."
execute_cypher "../modelo_grafo/consultas_negocio_grafo.cypher"

echo "🎉 Modelo Orientado a Grafos ejecutado exitosamente!"
echo "Interfaz web Neo4j: http://$NEO4J_HOST:$NEO4J_HTTP_PORT"
echo "Credenciales: $NEO4J_USER / $NEO4J_PASS"
echo "Conexión Bolt: bolt://$NEO4J_HOST:$NEO4J_PORT"
