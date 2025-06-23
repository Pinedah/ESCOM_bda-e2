# Script de Validacion - Verificar Datos en Todos los Modelos (PowerShell)

Write-Host "VALIDANDO DATOS EN TODOS LOS MODELOS..." -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Funcion para verificar PostgreSQL
function Test-PostgreSQL {
    param(
        [string]$Database,
        [string]$Query,
        [string]$Description
    )
    
    Write-Host "Verificando: $Description" -ForegroundColor Blue
    
    try {
        $env:PGPASSWORD = "postgres123"
        $result = & docker exec escom_postgres psql -h localhost -p 5432 -U postgres -d $Database -t -c $Query 2>$null
        
        if ($result -and $result.Trim() -ne "") {
            $count = $result.Trim()
            Write-Host "OK: $count registros" -ForegroundColor Green
            return $true
        } else {
            Write-Host "ERROR: Sin datos o error de conexion" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Funcion para verificar MongoDB
function Test-MongoDB {
    param(
        [string]$Collection,
        [string]$Description
    )
    
    Write-Host "Verificando: $Description" -ForegroundColor Blue
    
    try {
        $mongoCmd = "db.${Collection}.countDocuments()"
        $result = & docker exec escom_mongodb mongosh --host localhost:27017 cine_db --eval $mongoCmd --quiet 2>$null
        
        if ($result -and $result.Trim() -ne "" -and $result.Trim() -ne "0") {
            Write-Host "OK: $($result.Trim()) documentos" -ForegroundColor Green
            return $true
        } else {
            Write-Host "ERROR: Sin datos o error de conexion" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Funcion para verificar Neo4j
function Test-Neo4j {
    param(
        [string]$Query,
        [string]$Description
    )
    
    Write-Host "Verificando: $Description" -ForegroundColor Blue
    
    try {
        $result = & docker exec escom_neo4j cypher-shell -u neo4j -p neo4j123 $Query 2>$null
        
        if ($result -and $result.Trim() -ne "") {
            $count = $result.Trim()
            Write-Host "OK: $count nodos/relaciones" -ForegroundColor Green
            return $true
        } else {
            Write-Host "ERROR: Sin datos o error de conexion" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Variables de control
$totalTests = 0
$passedTests = 0

Write-Host ""
Write-Host "1. VERIFICANDO MODELO MULTIDIMENSIONAL (PostgreSQL)" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow

$totalTests++
if (Test-PostgreSQL -Database "peliculas_dwh" -Query "SELECT COUNT(*) FROM dim_pelicula;" -Description "Dimension Peliculas") {
    $passedTests++
}

$totalTests++
if (Test-PostgreSQL -Database "peliculas_dwh" -Query "SELECT COUNT(*) FROM dim_director;" -Description "Dimension Directores") {
    $passedTests++
}

$totalTests++
if (Test-PostgreSQL -Database "peliculas_dwh" -Query "SELECT COUNT(*) FROM dim_actor;" -Description "Dimension Actores") {
    $passedTests++
}

$totalTests++
if (Test-PostgreSQL -Database "peliculas_dwh" -Query "SELECT COUNT(*) FROM fact_pelicula;" -Description "Tabla de Hechos") {
    $passedTests++
}

Write-Host ""
Write-Host "2. VERIFICANDO MODELO RELACIONAL-OBJETUAL (PostgreSQL)" -ForegroundColor Yellow
Write-Host "===================================================" -ForegroundColor Yellow

$totalTests++
if (Test-PostgreSQL -Database "cine_objetual" -Query "SELECT COUNT(*) FROM peliculas;" -Description "Tabla Peliculas (Objetual)") {
    $passedTests++
}

$totalTests++
if (Test-PostgreSQL -Database "cine_objetual" -Query "SELECT COUNT(*) FROM directores;" -Description "Tabla Directores (Objetual)") {
    $passedTests++
}

Write-Host ""
Write-Host "3. VERIFICANDO MODELO XML (PostgreSQL)" -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Yellow

$totalTests++
if (Test-PostgreSQL -Database "cine_xml" -Query "SELECT COUNT(*) FROM peliculas_xml;" -Description "Datos XML de Peliculas") {
    $passedTests++
}

Write-Host ""
Write-Host "4. VERIFICANDO MODELO JSON/MONGODB" -ForegroundColor Yellow
Write-Host "=================================" -ForegroundColor Yellow

$totalTests++
if (Test-MongoDB -Collection "peliculas" -Description "Coleccion Peliculas") {
    $passedTests++
}

$totalTests++
if (Test-MongoDB -Collection "directores" -Description "Coleccion Directores") {
    $passedTests++
}

$totalTests++
if (Test-MongoDB -Collection "actores" -Description "Coleccion Actores") {
    $passedTests++
}

Write-Host ""
Write-Host "5. VERIFICANDO MODELO DE GRAFOS (Neo4j)" -ForegroundColor Yellow
Write-Host "======================================" -ForegroundColor Yellow

$totalTests++
if (Test-Neo4j -Query "MATCH (p:Pelicula) RETURN count(p)" -Description "Nodos Pelicula") {
    $passedTests++
}

$totalTests++
if (Test-Neo4j -Query "MATCH (d:Director) RETURN count(d)" -Description "Nodos Director") {
    $passedTests++
}

$totalTests++
if (Test-Neo4j -Query "MATCH (a:Actor) RETURN count(a)" -Description "Nodos Actor") {
    $passedTests++
}

Write-Host ""
Write-Host "RESUMEN DE VALIDACION" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host "Pruebas ejecutadas: $totalTests" -ForegroundColor White
Write-Host "Pruebas exitosas: $passedTests" -ForegroundColor Green
Write-Host "Pruebas fallidas: $($totalTests - $passedTests)" -ForegroundColor Red

$successRate = [math]::Round(($passedTests / $totalTests) * 100, 2)
Write-Host "Tasa de exito: $successRate%" -ForegroundColor $(if ($successRate -ge 80) { "Green" } elseif ($successRate -ge 60) { "Yellow" } else { "Red" })

if ($passedTests -eq $totalTests) {
    Write-Host ""
    Write-Host "TODAS LAS VALIDACIONES EXITOSAS!" -ForegroundColor Green
    Write-Host "El proyecto esta listo para su uso y demostracion." -ForegroundColor Green
} elseif ($successRate -ge 80) {
    Write-Host ""
    Write-Host "La mayoria de validaciones fueron exitosas." -ForegroundColor Yellow
    Write-Host "Revisar los modelos que fallaron para completar la configuracion." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Multiples validaciones fallaron." -ForegroundColor Red
    Write-Host "Revisar la configuracion de los servicios y la carga de datos." -ForegroundColor Red
}

Write-Host ""
Write-Host "ACCESO A INTERFACES WEB:" -ForegroundColor Cyan
Write-Host "- pgAdmin: http://localhost:8080 (admin@admin.com / admin123)" -ForegroundColor White
Write-Host "- Mongo Express: http://localhost:8081" -ForegroundColor White
Write-Host "- Neo4j Browser: http://localhost:7474 (neo4j / neo4j123)" -ForegroundColor White
