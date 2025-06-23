#!/bin/bash

# ============================================================================
# SCRIPT DE EJECUCIÓN - MODELO JSON (MongoDB)
# ============================================================================

echo "🧾 Ejecutando Modelo JSON (MongoDB)..."

# Variables
MONGO_HOST="localhost"
MONGO_PORT="27017"
MONGO_DB="cine_db"

# Función para ejecutar MongoDB script
execute_mongo() {
    local file=$1
    echo "Ejecutando: $file"
    mongosh --host $MONGO_HOST:$MONGO_PORT --file "$file"
    if [ $? -eq 0 ]; then
        echo "✅ $file ejecutado correctamente"
    else
        echo "❌ Error ejecutando $file"
        exit 1
    fi
}

# Esperar a que MongoDB esté listo
echo "Esperando a que MongoDB esté listo..."
sleep 15

# Verificar conexión a MongoDB
echo "Verificando conexión a MongoDB..."
mongosh --host $MONGO_HOST:$MONGO_PORT --eval "db.adminCommand('ping')" --quiet
if [ $? -ne 0 ]; then
    echo "❌ No se puede conectar a MongoDB"
    exit 1
fi

# Ejecutar script de creación y población
execute_mongo "../modelo_json/crear_poblar_mongodb.js"

echo "📊 Ejecutando consultas de negocio..."
echo "Conectándose a MongoDB para ejecutar consultas..."

# Ejecutar consultas de negocio directamente
mongosh --host $MONGO_HOST:$MONGO_PORT $MONGO_DB --eval "
console.log('=== CONSULTAS DE NEGOCIO MONGODB ===');

// A. Total de salarios de actores de Cinema Paradiso
console.log('A. Total de salarios - Cinema Paradiso:');
db.peliculas.aggregate([
    { \$match: { titulo: 'Cinema Paradiso' } },
    { \$unwind: '\$reparto' },
    { \$group: { 
        _id: null, 
        totalSalarios: { \$sum: '\$reparto.salario' },
        actores: { \$push: { nombre: '\$reparto.nombre', salario: '\$reparto.salario' } }
    }}
]).pretty();

// B. Premios de Cinema Paradiso
console.log('B. Premios de Cinema Paradiso:');
db.peliculas.find(
    { titulo: 'Cinema Paradiso' },
    { titulo: 1, ranking: 1, premios: 1, _id: 0 }
).pretty();

// C. Aportes de Franco Cristaldi
console.log('C. Aportes económicos de Franco Cristaldi:');
db.peliculas.aggregate([
    { \$match: { 'productores.nombre': 'Franco Cristaldi' } },
    { \$unwind: '\$productores' },
    { \$match: { 'productores.nombre': 'Franco Cristaldi' } },
    { \$group: { 
        _id: null, 
        totalAportes: { \$sum: '\$productores.aportacion_economica' },
        peliculas: { \$push: '\$titulo' }
    }}
]).pretty();

console.log('🎉 Consultas ejecutadas exitosamente!');
"

echo "🎉 Modelo JSON (MongoDB) ejecutado exitosamente!"
echo "Conecta a: mongodb://$MONGO_HOST:$MONGO_PORT/$MONGO_DB"
echo "JSON Schema disponible en: ../modelo_json/schema_cine.json"
