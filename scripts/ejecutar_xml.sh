#!/bin/bash

# ============================================================================
# SCRIPT DE EJECUCIÓN - MODELO XML (PostgreSQL)
# ============================================================================

echo "🗂️ Ejecutando Modelo XML (PostgreSQL)..."

# Variables
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="xml_db"
DB_USER="postgres"
DB_PASS="postgres123"

# Función para ejecutar SQL
execute_sql() {
    local file=$1
    echo "Ejecutando: $file"
    PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$file"
    if [ $? -eq 0 ]; then
        echo "✅ $file ejecutado correctamente"
    else
        echo "❌ Error ejecutando $file"
        exit 1
    fi
}

# Esperar a que PostgreSQL esté listo
echo "Esperando a que PostgreSQL esté listo..."
sleep 10

# Crear la base de datos
echo "Creando base de datos..."
PGPASSWORD=$DB_PASS createdb -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME 2>/dev/null || true

# Ejecutar scripts en orden
execute_sql "../modelo_xml/schema_xml.sql"
execute_sql "../modelo_xml/poblar_datos_xml.sql"

echo "📊 Ejecutando consultas de negocio..."
execute_sql "../modelo_xml/consultas_xml.sql"

echo "🎉 Modelo XML ejecutado exitosamente!"
echo "Conecta a: postgresql://$DB_USER:$DB_PASS@$DB_HOST:$DB_PORT/$DB_NAME"
echo "XSD Schema disponible en: ../modelo_xml/schema_cine.xsd"
