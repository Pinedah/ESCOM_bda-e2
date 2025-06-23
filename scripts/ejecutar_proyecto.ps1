# ============================================================================
# SCRIPT MAESTRO - PROYECTO BASES DE DATOS AVANZADAS (PowerShell)
# Ejecución completa de todos los modelos de datos
# ============================================================================

Write-Host "🚀 PROYECTO BASES DE DATOS AVANZADAS - IPN ESCOM" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "Transformación de modelo ER a múltiples paradigmas de BD" -ForegroundColor Yellow
Write-Host ""

# Función para mostrar menú
function Show-Menu {
    Write-Host "Selecciona qué modelo ejecutar:" -ForegroundColor Blue
    Write-Host "1. 🌟 Modelo Multidimensional (PostgreSQL)"
    Write-Host "2. 🧱 Modelo Relacional-Objetual (PostgreSQL)"
    Write-Host "3. 🗂️  Modelo XML (PostgreSQL)"
    Write-Host "4. 🧾 Modelo JSON (MongoDB)"
    Write-Host "5. 🧠 Modelo Orientado a Grafos (Neo4j)"
    Write-Host "6. 🎯 Ejecutar TODOS los modelos"
    Write-Host "7. 🐳 Iniciar servicios Docker"
    Write-Host "8. 🛑 Detener servicios Docker"
    Write-Host "9. 📊 Mostrar estado de servicios"
    Write-Host "0. ❌ Salir"
    Write-Host ""
}

# Función para verificar Docker
function Test-Docker {
    if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Docker no está instalado" -ForegroundColor Red
        exit 1
    }
    
    if (!(Get-Command docker-compose -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Docker Compose no está instalado" -ForegroundColor Red
        exit 1
    }
}

# Función para iniciar servicios
function Start-Services {
    Write-Host "🐳 Iniciando servicios Docker..." -ForegroundColor Yellow
    docker-compose up -d
    
    Write-Host "⏳ Esperando a que los servicios estén listos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    
    Write-Host "✅ Servicios iniciados" -ForegroundColor Green
    Show-ServicesStatus
}

# Función para detener servicios
function Stop-Services {
    Write-Host "🛑 Deteniendo servicios Docker..." -ForegroundColor Yellow
    docker-compose down
    Write-Host "✅ Servicios detenidos" -ForegroundColor Green
}

# Función para mostrar estado de servicios
function Show-ServicesStatus {
    Write-Host "📊 Estado de los servicios:" -ForegroundColor Blue
    Write-Host ""
    docker-compose ps
    Write-Host ""
    Write-Host "🌐 URLs de acceso:" -ForegroundColor Blue
    Write-Host "• PostgreSQL: localhost:5432"
    Write-Host "• pgAdmin: http://localhost:8080"
    Write-Host "• MongoDB: localhost:27017"
    Write-Host "• Mongo Express: http://localhost:8081"
    Write-Host "• Neo4j Browser: http://localhost:7474"
    Write-Host "• Neo4j Bolt: bolt://localhost:7687"
}

# Función para ejecutar SQL en PostgreSQL
function Invoke-PostgreSQL {
    param(
        [string]$Database,
        [string]$SqlFile
    )
    
    $env:PGPASSWORD = "postgres123"
    & psql -h localhost -p 5432 -U postgres -d $Database -f $SqlFile
}

# Función para crear base de datos PostgreSQL
function New-PostgreSQLDatabase {
    param([string]$Database)
    
    $env:PGPASSWORD = "postgres123"
    & createdb -h localhost -p 5432 -U postgres $Database 2>$null
}

# Función para ejecutar modelo específico
function Invoke-Model {
    param([int]$Model)
    
    switch ($Model) {
        1 {
            Write-Host "🌟 Ejecutando Modelo Multidimensional..." -ForegroundColor Yellow
            
            # Crear BD y ejecutar scripts
            New-PostgreSQLDatabase -Database "multidimensional_db"
            Invoke-PostgreSQL -Database "multidimensional_db" -SqlFile "../modelo_multidimensional/schema_multidimensional.sql"
            Invoke-PostgreSQL -Database "multidimensional_db" -SqlFile "../modelo_multidimensional/poblar_dimensiones.sql"
            Invoke-PostgreSQL -Database "multidimensional_db" -SqlFile "../modelo_multidimensional/poblar_hechos.sql"
            Invoke-PostgreSQL -Database "multidimensional_db" -SqlFile "../modelo_multidimensional/consultas_negocio.sql"
            
            Write-Host "✅ Modelo Multidimensional ejecutado correctamente" -ForegroundColor Green
        }
        2 {
            Write-Host "🧱 Ejecutando Modelo Relacional-Objetual..." -ForegroundColor Yellow
            
            New-PostgreSQLDatabase -Database "objetual_db"
            Invoke-PostgreSQL -Database "objetual_db" -SqlFile "../modelo_objetual/schema_objetual.sql"
            Invoke-PostgreSQL -Database "objetual_db" -SqlFile "../modelo_objetual/poblar_datos_objetual.sql"
            Invoke-PostgreSQL -Database "objetual_db" -SqlFile "../modelo_objetual/consultas_objetual.sql"
            
            Write-Host "✅ Modelo Relacional-Objetual ejecutado correctamente" -ForegroundColor Green
        }
        3 {
            Write-Host "🗂️ Ejecutando Modelo XML..." -ForegroundColor Yellow
            
            New-PostgreSQLDatabase -Database "xml_db"
            Invoke-PostgreSQL -Database "xml_db" -SqlFile "../modelo_xml/schema_xml.sql"
            Invoke-PostgreSQL -Database "xml_db" -SqlFile "../modelo_xml/poblar_datos_xml.sql"
            Invoke-PostgreSQL -Database "xml_db" -SqlFile "../modelo_xml/consultas_xml.sql"
            
            Write-Host "✅ Modelo XML ejecutado correctamente" -ForegroundColor Green
        }
        4 {
            Write-Host "🧾 Ejecutando Modelo JSON (MongoDB)..." -ForegroundColor Yellow
            
            # Ejecutar script de MongoDB
            & mongosh --host localhost:27017 --file "../modelo_json/crear_poblar_mongodb.js"
            
            Write-Host "✅ Modelo JSON (MongoDB) ejecutado correctamente" -ForegroundColor Green
        }
        5 {
            Write-Host "🧠 Ejecutando Modelo Orientado a Grafos (Neo4j)..." -ForegroundColor Yellow
            
            # Ejecutar scripts de Neo4j
            & cypher-shell -a bolt://localhost:7687 -u neo4j -p password123 --file "../modelo_grafo/schema_grafo.cypher"
            & cypher-shell -a bolt://localhost:7687 -u neo4j -p password123 --file "../modelo_grafo/poblar_datos_grafo.cypher"
            & cypher-shell -a bolt://localhost:7687 -u neo4j -p password123 --file "../modelo_grafo/consultas_negocio_grafo.cypher"
            
            Write-Host "✅ Modelo Orientado a Grafos ejecutado correctamente" -ForegroundColor Green
        }
        6 {
            Write-Host "🎯 Ejecutando TODOS los modelos..." -ForegroundColor Yellow
            
            for ($i = 1; $i -le 5; $i++) {
                Invoke-Model -Model $i
                Write-Host ""
            }
            
            Write-Host "🎉 TODOS LOS MODELOS EJECUTADOS EXITOSAMENTE!" -ForegroundColor Green
        }
        default {
            Write-Host "❌ Opción inválida" -ForegroundColor Red
        }
    }
}

# Verificar Docker
Test-Docker

# Verificar que estamos en el directorio correcto
if (!(Test-Path "docker-compose.yml")) {
    Write-Host "❌ No se encontró docker-compose.yml" -ForegroundColor Red
    Write-Host "Ejecuta este script desde el directorio raíz del proyecto"
    exit 1
}

# Loop principal del menú
while ($true) {
    Show-Menu
    $choice = Read-Host "Ingresa tu opción"
    
    switch ($choice) {
        "0" {
            Write-Host "👋 ¡Hasta luego!" -ForegroundColor Green
            exit 0
        }
        "7" {
            Start-Services
        }
        "8" {
            Stop-Services
        }
        "9" {
            Show-ServicesStatus
        }
        { $_ -match '^[1-6]$' } {
            # Verificar que los servicios estén corriendo
            $services = docker-compose ps --services --filter "status=running"
            if (!$services) {
                Write-Host "⚠️  Los servicios no están corriendo" -ForegroundColor Yellow
                $startNow = Read-Host "¿Deseas iniciarlos ahora? (y/n)"
                if ($startNow -eq "y" -or $startNow -eq "Y") {
                    Start-Services
                } else {
                    Write-Host "❌ Necesitas iniciar los servicios primero" -ForegroundColor Red
                    continue
                }
            }
            Invoke-Model -Model [int]$choice
        }
        default {
            Write-Host "❌ Opción inválida. Intenta de nuevo." -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Read-Host "Presiona Enter para continuar..."
    Clear-Host
}
