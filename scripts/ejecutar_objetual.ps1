# Script de Ejecucion - Modelo Objetual (PostgreSQL)

Write-Host "Ejecutando Modelo Objetual (PostgreSQL)..." -ForegroundColor Cyan

# Variables de configuracion
$DB_HOST = "localhost"
$DB_PORT = "5432"
$DB_NAME = "cine_objetual"
$DB_USER = "postgres"
$DB_PASS = "panke"

# Funcion para crear base de datos
function Create-DatabaseIfNotExists {
    param([string]$DatabaseName)
    
    Write-Host "Verificando/creando base de datos: $DatabaseName" -ForegroundColor Yellow
    
    $env:PGPASSWORD = $DB_PASS
    $checkDb = & docker exec escom_postgres psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -t -c "SELECT 1 FROM pg_database WHERE datname='$DatabaseName';" 2>$null
    
    if (-not $checkDb -or $checkDb.Trim() -eq "") {
        Write-Host "Creando base de datos: $DatabaseName" -ForegroundColor Blue
        & docker exec escom_postgres psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -c "CREATE DATABASE $DatabaseName;" 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "OK: Base de datos $DatabaseName creada" -ForegroundColor Green
        } else {
            Write-Host "ERROR: No se pudo crear la base de datos $DatabaseName" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "OK: Base de datos $DatabaseName ya existe" -ForegroundColor Green
    }
    return $true
}

# Funcion para ejecutar SQL
function Execute-SqlFile {
    param(
        [string]$FilePath,
        [string]$DatabaseName
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "ERROR: Archivo no encontrado: $FilePath" -ForegroundColor Red
        return $false
    }
    
    Write-Host "Ejecutando: $FilePath" -ForegroundColor Blue
    $env:PGPASSWORD = $DB_PASS
    
    # Leer el contenido del archivo y ejecutarlo
    $sqlContent = Get-Content $FilePath -Raw
    $tempFile = [System.IO.Path]::GetTempFileName() + ".sql"
    $sqlContent | Out-File -FilePath $tempFile -Encoding UTF8
    
    # Copiar archivo al contenedor y ejecutar
    & docker cp $tempFile escom_postgres:/tmp/temp.sql
    $result = & docker exec escom_postgres psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DatabaseName -f /tmp/temp.sql
    
    Remove-Item $tempFile -Force
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK: $FilePath ejecutado correctamente" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ERROR: Fallo al ejecutar $FilePath" -ForegroundColor Red
        return $false
    }
}

# Esperar a que PostgreSQL este listo
Write-Host "Esperando a que PostgreSQL este listo..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Crear base de datos
if (-not (Create-DatabaseIfNotExists -DatabaseName $DB_NAME)) {
    Write-Host "ABORTADO: No se pudo crear la base de datos" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "1. Creando estructura objetual..." -ForegroundColor Yellow

# Ejecutar scripts en orden
$scripts = @(
    "modelo_objetual/schema_objetual.sql",
    "modelo_objetual/poblar_datos_objetual.sql"
)

$success = $true
foreach ($script in $scripts) {
    $fullPath = Join-Path (Get-Location) $script
    if (-not (Execute-SqlFile -FilePath $fullPath -DatabaseName $DB_NAME)) {
        $success = $false
        break
    }
}

if ($success) {
    Write-Host ""
    Write-Host "2. Ejecutando consultas objetuales..." -ForegroundColor Yellow
    $consultasPath = Join-Path (Get-Location) "modelo_objetual/consultas_objetual.sql"
    Execute-SqlFile -FilePath $consultasPath -DatabaseName $DB_NAME | Out-Null
    
    Write-Host ""
    Write-Host "MODELO OBJETUAL EJECUTADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "=======================================" -ForegroundColor Green
    Write-Host "Base de datos: $DB_NAME" -ForegroundColor White
    Write-Host "Host: ${DB_HOST}:${DB_PORT}" -ForegroundColor White
    Write-Host "Usuario: $DB_USER" -ForegroundColor White
    Write-Host ""
    Write-Host "Acceso a pgAdmin: http://localhost:8080" -ForegroundColor Cyan
    Write-Host "Email: admin@admin.com | Password: $DB_PASS" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "ERROR: Fallos durante la ejecucion del modelo objetual" -ForegroundColor Red
    exit 1
}
