# 📜 Scripts de Ejecución - Bases de Datos Avanzadas

## 🎯 Descripción

Esta carpeta contiene todos los scripts necesarios para ejecutar los diferentes modelos de bases de datos del proyecto. Los scripts están diseñados para ser ejecutados tanto en sistemas Unix/Linux como Windows.

## 📂 Contenido de Scripts

### Scripts Maestros
- **`ejecutar_proyecto.sh`** - Script principal para Linux/Mac con menú interactivo
- **`ejecutar_proyecto.ps1`** - Script principal para Windows PowerShell con menú interactivo

### Scripts por Modelo
- **`ejecutar_multidimensional.sh`** - Modelo estrella en PostgreSQL
- **`ejecutar_objetual.sh`** - Modelo relacional-objetual en PostgreSQL
- **`ejecutar_xml.sh`** - Modelo XML en PostgreSQL
- **`ejecutar_mongodb.sh`** - Modelo JSON en MongoDB
- **`ejecutar_neo4j.sh`** - Modelo de grafos en Neo4j

### Scripts de Utilidad
- **`validar_datos.sh`** - Verificación de datos en todos los modelos

## 🚀 Uso Rápido

### Linux/Mac
```bash
cd scripts
chmod +x *.sh
./ejecutar_proyecto.sh
```

### Windows
```powershell
cd scripts
.\ejecutar_proyecto.ps1
```

## 🔧 Prerrequisitos

### Software Requerido
- Docker & Docker Compose
- PostgreSQL client tools (psql, createdb)
- MongoDB shell (mongosh)
- Neo4j shell (cypher-shell)

### Para Linux/Ubuntu
```bash
# PostgreSQL client
sudo apt install postgresql-client

# MongoDB shell
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install mongodb-mongosh

# Neo4j shell (incluido en Neo4j Desktop o servidor)
```

### Para Windows
```powershell
# Instalar desde los sitios oficiales:
# - PostgreSQL: https://www.postgresql.org/download/windows/
# - MongoDB Shell: https://www.mongodb.com/try/download/shell
# - Neo4j Desktop: https://neo4j.com/download/
```

## 📋 Funcionalidades del Menú

1. **🌟 Modelo Multidimensional** - Ejecuta esquema estrella con dimensiones y hechos
2. **🧱 Modelo Relacional-Objetual** - Ejecuta tipos compuestos, herencia y PL/pgSQL
3. **🗂️ Modelo XML** - Ejecuta validación XSD y consultas XPath
4. **🧾 Modelo JSON** - Ejecuta colecciones MongoDB con validaciones
5. **🧠 Modelo Orientado a Grafos** - Ejecuta nodos y relaciones en Neo4j
6. **🎯 Ejecutar TODOS** - Ejecuta todos los modelos secuencialmente
7. **🐳 Iniciar servicios Docker** - Levanta todos los contenedores
8. **🛑 Detener servicios** - Detiene todos los contenedores
9. **📊 Estado de servicios** - Muestra estado actual de contenedores

## 🔍 Validación de Datos

El script `validar_datos.sh` verifica que todos los modelos contengan los datos esperados:

```bash
./validar_datos.sh
```

**Verificaciones incluidas:**
- ✅ Conteo de registros en cada tabla/colección
- ✅ Presencia de "Cinema Paradiso" en todos los modelos
- ✅ Presencia de "Franco Cristaldi" en todos los modelos
- ✅ Estado de servicios Docker
- ✅ Conectividad a todas las bases de datos

## 🌐 URLs de Acceso

Una vez ejecutados los servicios:

| Servicio | URL | Credenciales |
|----------|-----|--------------|
| pgAdmin | http://localhost:8080 | admin@admin.com / admin123 |
| Mongo Express | http://localhost:8081 | sin autenticación |
| Neo4j Browser | http://localhost:7474 | neo4j / password123 |

## 🐛 Solución de Problemas

### Error: "docker-compose command not found"
```bash
# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Error: "psql command not found"
```bash
# Ubuntu/Debian
sudo apt install postgresql-client

# CentOS/RHEL
sudo yum install postgresql

# macOS
brew install postgresql
```

### Error: "mongosh command not found"
```bash
# Descargar desde: https://www.mongodb.com/try/download/shell
# O usar npm:
npm install -g mongosh
```

### Error: "cypher-shell command not found"
```bash
# Instalar Neo4j Desktop o servidor desde:
# https://neo4j.com/download/
```

### Servicios no inician correctamente
```bash
# Verificar Docker
docker --version
docker-compose --version

# Limpiar contenedores existentes
docker-compose down --volumes
docker system prune -f

# Reiniciar servicios
docker-compose up -d
```

## 📈 Orden de Ejecución Recomendado

1. **Iniciar servicios Docker** (opción 7)
2. **Esperar 30-60 segundos** para que los servicios estén listos
3. **Ejecutar modelos individuales** (opciones 1-5) o **todos juntos** (opción 6)
4. **Validar datos** con `./validar_datos.sh`
5. **Acceder a interfaces web** para explorar datos

## 🎓 Notas Académicas

- Cada script incluye comentarios explicativos
- Los datos son consistentes entre modelos para facilitar comparaciones
- Las consultas de negocio están implementadas en todos los paradigmas
- Se incluyen validaciones de rangos de datos según especificaciones del proyecto

## 🛠️ Personalización

Para modificar configuraciones:

1. **Credenciales**: Editar variables al inicio de cada script
2. **Puertos**: Modificar en `docker-compose.yml` y scripts
3. **Datos**: Editar archivos SQL/Cypher/JS en carpetas de modelos
4. **Timeouts**: Ajustar valores de `sleep` en scripts

---

**💡 Tip**: Ejecuta `./validar_datos.sh` después de cualquier modificación para verificar integridad de datos.
