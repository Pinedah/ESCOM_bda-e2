#!/bin/bash

# ============================================================================
# SCRIPT DE VALIDACIÓN - VERIFICAR DATOS EN TODOS LOS MODELOS
# ============================================================================

echo "🔍 VALIDANDO DATOS EN TODOS LOS MODELOS..."
echo "=========================================="

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para ejecutar SQL y contar resultados
check_postgresql() {
    local db=$1
    local query=$2
    local description=$3
    
    echo -e "${BLUE}Verificando: $description${NC}"
    
    result=$(PGPASSWORD=postgres123 psql -h localhost -p 5432 -U postgres -d $db -t -c "$query" 2>/dev/null | xargs)
    
    if [ -z "$result" ]; then
        echo -e "${RED}❌ Error o sin datos${NC}"
        return 1
    else
        echo -e "${GREEN}✅ $result registros${NC}"
        return 0
    fi
}

# Función para verificar MongoDB
check_mongodb() {
    local collection=$1
    local description=$2
    
    echo -e "${BLUE}Verificando: $description${NC}"
    
    result=$(mongosh --host localhost:27017 cine_db --eval "db.$collection.countDocuments()" --quiet 2>/dev/null)
    
    if [ -z "$result" ] || [ "$result" = "0" ]; then
        echo -e "${RED}❌ Error o sin datos${NC}"
        return 1
    else
        echo -e "${GREEN}✅ $result documentos${NC}"
        return 0
    fi
}

# Función para verificar Neo4j
check_neo4j() {
    local query=$1
    local description=$2
    
    echo -e "${BLUE}Verificando: $description${NC}"
    
    result=$(cypher-shell -a bolt://localhost:7687 -u neo4j -p password123 "$query" --format plain 2>/dev/null | tail -n 1)
    
    if [ -z "$result" ]; then
        echo -e "${RED}❌ Error o sin datos${NC}"
        return 1
    else
        echo -e "${GREEN}✅ $result nodos/relaciones${NC}"
        return 0
    fi
}

echo ""
echo -e "${YELLOW}🌟 MODELO MULTIDIMENSIONAL (PostgreSQL)${NC}"
echo "-------------------------------------------"

check_postgresql "multidimensional_db" "SELECT COUNT(*) FROM dim_tiempo;" "Dimensión Tiempo"
check_postgresql "multidimensional_db" "SELECT COUNT(*) FROM dim_persona;" "Dimensión Persona"
check_postgresql "multidimensional_db" "SELECT COUNT(*) FROM dim_pelicula;" "Dimensión Película"
check_postgresql "multidimensional_db" "SELECT COUNT(*) FROM hechos_actuacion;" "Hechos de Actuación"
check_postgresql "multidimensional_db" "SELECT COUNT(*) FROM hechos_produccion;" "Hechos de Producción"

echo ""
echo -e "${YELLOW}🧱 MODELO RELACIONAL-OBJETUAL (PostgreSQL)${NC}"
echo "--------------------------------------------------"

check_postgresql "objetual_db" "SELECT COUNT(*) FROM personas;" "Tabla Personas"
check_postgresql "objetual_db" "SELECT COUNT(*) FROM directores;" "Tabla Directores"
check_postgresql "objetual_db" "SELECT COUNT(*) FROM actores;" "Tabla Actores"
check_postgresql "objetual_db" "SELECT COUNT(*) FROM productores;" "Tabla Productores"
check_postgresql "objetual_db" "SELECT COUNT(*) FROM peliculas;" "Tabla Películas"

echo ""
echo -e "${YELLOW}🗂️ MODELO XML (PostgreSQL)${NC}"
echo "-----------------------------------"

check_postgresql "xml_db" "SELECT COUNT(*) FROM documentos_xml WHERE tipo_documento = 'pelicula';" "Documentos XML Películas"
check_postgresql "xml_db" "SELECT COUNT(*) FROM documentos_xml WHERE tipo_documento = 'persona';" "Documentos XML Personas"
check_postgresql "xml_db" "SELECT COUNT(*) FROM documentos_xml WHERE tipo_documento = 'critica';" "Documentos XML Críticas"

echo ""
echo -e "${YELLOW}🧾 MODELO JSON (MongoDB)${NC}"
echo "------------------------------------"

check_mongodb "peliculas" "Colección Películas"
check_mongodb "directores" "Colección Directores"
check_mongodb "actores" "Colección Actores"
check_mongodb "productores" "Colección Productores"

echo ""
echo -e "${YELLOW}🧠 MODELO ORIENTADO A GRAFOS (Neo4j)${NC}"
echo "--------------------------------------------"

check_neo4j "MATCH (n:Persona) RETURN count(n);" "Nodos Persona"
check_neo4j "MATCH (n:Pelicula) RETURN count(n);" "Nodos Película"
check_neo4j "MATCH (n:Genero) RETURN count(n);" "Nodos Género"
check_neo4j "MATCH ()-[r:DIRIGIO]->() RETURN count(r);" "Relaciones DIRIGIO"
check_neo4j "MATCH ()-[r:ACTUO_EN]->() RETURN count(r);" "Relaciones ACTUO_EN"

echo ""
echo -e "${YELLOW}🎯 VERIFICACIÓN DE CONSULTAS DE NEGOCIO${NC}"
echo "----------------------------------------------"

echo -e "${BLUE}Verificando Cinema Paradiso en todos los modelos...${NC}"

# Multidimensional
echo -n "Multidimensional: "
PGPASSWORD=postgres123 psql -h localhost -p 5432 -U postgres -d multidimensional_db -t -c "
SELECT COUNT(*) FROM dim_pelicula WHERE titulo = 'Cinema Paradiso';" 2>/dev/null | xargs

# Objetual
echo -n "Objetual: "
PGPASSWORD=postgres123 psql -h localhost -p 5432 -U postgres -d objetual_db -t -c "
SELECT COUNT(*) FROM peliculas WHERE titulo = 'Cinema Paradiso';" 2>/dev/null | xargs

# XML
echo -n "XML: "
PGPASSWORD=postgres123 psql -h localhost -p 5432 -U postgres -d xml_db -t -c "
SELECT COUNT(*) FROM documentos_xml WHERE xpath_exists('/pelicula[titulo=\"Cinema Paradiso\"]', contenido_xml);" 2>/dev/null | xargs

# MongoDB
echo -n "MongoDB: "
mongosh --host localhost:27017 cine_db --eval "db.peliculas.countDocuments({titulo: 'Cinema Paradiso'})" --quiet 2>/dev/null

# Neo4j
echo -n "Neo4j: "
cypher-shell -a bolt://localhost:7687 -u neo4j -p password123 "MATCH (p:Pelicula {titulo: 'Cinema Paradiso'}) RETURN count(p);" --format plain 2>/dev/null | tail -n 1

echo ""
echo -e "${BLUE}Verificando Franco Cristaldi en todos los modelos...${NC}"

# Multidimensional
echo -n "Multidimensional: "
PGPASSWORD=postgres123 psql -h localhost -p 5432 -U postgres -d multidimensional_db -t -c "
SELECT COUNT(*) FROM dim_persona WHERE nombre = 'Franco Cristaldi';" 2>/dev/null | xargs

# Objetual
echo -n "Objetual: "
PGPASSWORD=postgres123 psql -h localhost -p 5432 -U postgres -d objetual_db -t -c "
SELECT COUNT(*) FROM productores p JOIN personas pe ON p.id_persona = pe.id_persona WHERE pe.nombre = 'Franco Cristaldi';" 2>/dev/null | xargs

# XML
echo -n "XML: "
PGPASSWORD=postgres123 psql -h localhost -p 5432 -U postgres -d xml_db -t -c "
SELECT COUNT(*) FROM documentos_xml WHERE xpath_exists('/persona[nombre=\"Franco Cristaldi\"]', contenido_xml);" 2>/dev/null | xargs

# MongoDB
echo -n "MongoDB: "
mongosh --host localhost:27017 cine_db --eval "db.productores.countDocuments({nombre: 'Franco Cristaldi'})" --quiet 2>/dev/null

# Neo4j
echo -n "Neo4j: "
cypher-shell -a bolt://localhost:7687 -u neo4j -p password123 "MATCH (p:Persona {nombre: 'Franco Cristaldi'}) RETURN count(p);" --format plain 2>/dev/null | tail -n 1

echo ""
echo -e "${GREEN}🎉 VALIDACIÓN COMPLETADA${NC}"
echo ""
echo -e "${BLUE}📊 RESUMEN DE INTERFACES:${NC}"
echo "• pgAdmin: http://localhost:8080"
echo "• Mongo Express: http://localhost:8081"  
echo "• Neo4j Browser: http://localhost:7474"
echo ""
echo -e "${BLUE}📋 CREDENCIALES:${NC}"
echo "• PostgreSQL: postgres / postgres123"
echo "• MongoDB: sin autenticación"
echo "• Neo4j: neo4j / password123"
