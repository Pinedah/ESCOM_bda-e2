#!/bin/bash

# ============================================================================
# SCRIPT DE EJECUCIÓN - MODELO RELACIONAL-OBJETUAL (PostgreSQL)
# ============================================================================

echo "🧱 Ejecutando Modelo Relacional-Objetual (PostgreSQL)..."

# Variables
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="objetual_db"
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
execute_sql "../modelo_objetual/schema_objetual.sql"
execute_sql "../modelo_objetual/poblar_datos_objetual.sql"

echo "📊 Ejecutando consultas de negocio..."
execute_sql "../modelo_objetual/consultas_objetual.sql"

echo "🎉 Modelo Relacional-Objetual ejecutado exitosamente!"
echo "Conecta a: postgresql://$DB_USER:$DB_PASS@$DB_HOST:$DB_PORT/$DB_NAME"
