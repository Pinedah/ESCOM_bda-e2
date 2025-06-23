# Script de Ejecucion - Modelo JSON/MongoDB

Write-Host "Ejecutando Modelo JSON/MongoDB..." -ForegroundColor Cyan

# Variables de configuracion
$MONGO_HOST = "localhost"
$MONGO_PORT = "27017"
$MONGO_DB = "cine_db"
$MONGO_USER = "admin"
$MONGO_PASS = "panke"

# Función para ejecutar JavaScript en MongoDB
function Execute-MongoScript {
    param(
        [string]$FilePath
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "ERROR: Archivo no encontrado: $FilePath" -ForegroundColor Red
        return $false
    }
    
    Write-Host "Ejecutando: $FilePath" -ForegroundColor Blue
      # Copiar archivo al contenedor y ejecutar
    & docker cp $FilePath escom_mongodb:/tmp/mongo_script.js
    $result = & docker exec escom_mongodb mongosh --host $MONGO_HOST --port $MONGO_PORT $MONGO_DB /tmp/mongo_script.js
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK: $FilePath ejecutado correctamente" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ERROR: Fallo al ejecutar $FilePath" -ForegroundColor Red
        return $false
    }
}

# Función para probar conexión a MongoDB
function Test-MongoConnection {
    Write-Host "Probando conexión a MongoDB..." -ForegroundColor Yellow
    
    $result = & docker exec escom_mongodb mongosh --host $MONGO_HOST --port $MONGO_PORT --eval "db.adminCommand('ping')" --quiet 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK: Conexión a MongoDB exitosa" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ERROR: No se puede conectar a MongoDB" -ForegroundColor Red
        return $false
    }
}

# Función para mostrar estadísticas
function Show-MongoStats {
    Write-Host "Obteniendo estadísticas de MongoDB..." -ForegroundColor Yellow
      Write-Host "Colecciones en la base de datos:" -ForegroundColor Blue
    & docker exec escom_mongodb mongosh --host $MONGO_HOST --port $MONGO_PORT $MONGO_DB --eval "db.getCollectionNames()" --quiet
    
    Write-Host "Conteo de documentos:" -ForegroundColor Blue
    & docker exec escom_mongodb mongosh --host $MONGO_HOST --port $MONGO_PORT $MONGO_DB --eval "print('Peliculas: ' + db.peliculas.countDocuments()); print('Directores: ' + db.directores.countDocuments()); print('Actores: ' + db.actores.countDocuments());" --quiet
}

# Esperar a que MongoDB esté listo
Write-Host "Esperando a que MongoDB esté listo..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Probar conexión
if (-not (Test-MongoConnection)) {
    Write-Host "ABORTADO: No se puede conectar a MongoDB" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "1. Ejecutando script de creación y población..." -ForegroundColor Yellow

# Ejecutar el script de MongoDB
$scriptPath = Join-Path (Get-Location) "modelo_json/crear_poblar_mongodb.js"

if (Execute-MongoScript -FilePath $scriptPath) {
    Write-Host ""
    Write-Host "2. Mostrando estadísticas de la base de datos..." -ForegroundColor Yellow
    Show-MongoStats
    
    Write-Host ""
    Write-Host "MODELO JSON/MONGODB EJECUTADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "===========================================" -ForegroundColor Green
    Write-Host "Base de datos: $MONGO_DB" -ForegroundColor White
    Write-Host "Host: ${MONGO_HOST}:${MONGO_PORT}" -ForegroundColor White
    Write-Host "Usuario: $MONGO_USER" -ForegroundColor White
    Write-Host ""
    Write-Host "Acceso a Mongo Express: http://localhost:8081" -ForegroundColor Cyan
    Write-Host "Usuario/Password: admin / $MONGO_PASS" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "ERROR: Fallos durante la ejecución del modelo MongoDB" -ForegroundColor Red
    exit 1
}
