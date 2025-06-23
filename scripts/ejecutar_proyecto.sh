#!/bin/bash

# ============================================================================
# SCRIPT MAESTRO - PROYECTO BASES DE DATOS AVANZADAS
# Ejecución completa de todos los modelos de datos
# ============================================================================

echo "🚀 PROYECTO BASES DE DATOS AVANZADAS - IPN ESCOM"
echo "=============================================="
echo "Transformación de modelo ER a múltiples paradigmas de BD"
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar menú
show_menu() {
    echo -e "${BLUE}Selecciona qué modelo ejecutar:${NC}"
    echo "1. 🌟 Modelo Multidimensional (PostgreSQL)"
    echo "2. 🧱 Modelo Relacional-Objetual (PostgreSQL)"
    echo "3. 🗂️  Modelo XML (PostgreSQL)"
    echo "4. 🧾 Modelo JSON (MongoDB)"
    echo "5. 🧠 Modelo Orientado a Grafos (Neo4j)"
    echo "6. 🎯 Ejecutar TODOS los modelos"
    echo "7. 🐳 Iniciar servicios Docker"
    echo "8. 🛑 Detener servicios Docker"
    echo "9. 📊 Mostrar estado de servicios"
    echo "0. ❌ Salir"
    echo ""
}

# Función para verificar Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker no está instalado${NC}"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}❌ Docker Compose no está instalado${NC}"
        exit 1
    fi
}

# Función para iniciar servicios
start_services() {
    echo -e "${YELLOW}🐳 Iniciando servicios Docker...${NC}"
    docker-compose up -d
    
    echo -e "${YELLOW}⏳ Esperando a que los servicios estén listos...${NC}"
    sleep 30
    
    echo -e "${GREEN}✅ Servicios iniciados${NC}"
    show_services_status
}

# Función para detener servicios
stop_services() {
    echo -e "${YELLOW}🛑 Deteniendo servicios Docker...${NC}"
    docker-compose down
    echo -e "${GREEN}✅ Servicios detenidos${NC}"
}

# Función para mostrar estado de servicios
show_services_status() {
    echo -e "${BLUE}📊 Estado de los servicios:${NC}"
    echo ""
    docker-compose ps
    echo ""
    echo -e "${BLUE}🌐 URLs de acceso:${NC}"
    echo "• PostgreSQL: localhost:5432"
    echo "• pgAdmin: http://localhost:8080"
    echo "• MongoDB: localhost:27017"
    echo "• Mongo Express: http://localhost:8081"
    echo "• Neo4j Browser: http://localhost:7474"
    echo "• Neo4j Bolt: bolt://localhost:7687"
}

# Función para ejecutar modelo específico
execute_model() {
    local model=$1
    case $model in
        1)
            echo -e "${YELLOW}🌟 Ejecutando Modelo Multidimensional...${NC}"
            bash ejecutar_multidimensional.sh
            ;;
        2)
            echo -e "${YELLOW}🧱 Ejecutando Modelo Relacional-Objetual...${NC}"
            bash ejecutar_objetual.sh
            ;;
        3)
            echo -e "${YELLOW}🗂️ Ejecutando Modelo XML...${NC}"
            bash ejecutar_xml.sh
            ;;
        4)
            echo -e "${YELLOW}🧾 Ejecutando Modelo JSON...${NC}"
            bash ejecutar_mongodb.sh
            ;;
        5)
            echo -e "${YELLOW}🧠 Ejecutando Modelo Orientado a Grafos...${NC}"
            bash ejecutar_neo4j.sh
            ;;
        6)
            echo -e "${YELLOW}🎯 Ejecutando TODOS los modelos...${NC}"
            bash ejecutar_multidimensional.sh
            echo ""
            bash ejecutar_objetual.sh
            echo ""
            bash ejecutar_xml.sh
            echo ""
            bash ejecutar_mongodb.sh
            echo ""
            bash ejecutar_neo4j.sh
            echo -e "${GREEN}🎉 TODOS LOS MODELOS EJECUTADOS EXITOSAMENTE!${NC}"
            ;;
        *)
            echo -e "${RED}❌ Opción inválida${NC}"
            ;;
    esac
}

# Verificar Docker
check_docker

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ No se encontró docker-compose.yml${NC}"
    echo "Ejecuta este script desde el directorio raíz del proyecto"
    exit 1
fi

# Hacer ejecutables los scripts
chmod +x ejecutar_*.sh

# Loop principal del menú
while true; do
    show_menu
    read -p "Ingresa tu opción: " choice
    
    case $choice in
        0)
            echo -e "${GREEN}👋 ¡Hasta luego!${NC}"
            exit 0
            ;;
        7)
            start_services
            ;;
        8)
            stop_services
            ;;
        9)
            show_services_status
            ;;
        [1-6])
            # Verificar que los servicios estén corriendo
            if ! docker-compose ps | grep -q "Up"; then
                echo -e "${YELLOW}⚠️  Los servicios no están corriendo${NC}"
                read -p "¿Deseas iniciarlos ahora? (y/n): " start_now
                if [ "$start_now" = "y" ] || [ "$start_now" = "Y" ]; then
                    start_services
                else
                    echo -e "${RED}❌ Necesitas iniciar los servicios primero${NC}"
                    continue
                fi
            fi
            execute_model $choice
            ;;
        *)
            echo -e "${RED}❌ Opción inválida. Intenta de nuevo.${NC}"
            ;;
    esac
    
    echo ""
    read -p "Presiona Enter para continuar..."
    clear
done
