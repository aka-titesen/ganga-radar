# Docker Setup - Ganga Radar

## 🐳 Arquitectura de Servicios

El proyecto utiliza Docker Compose para orquestar los siguientes servicios:

### 📊 Servicios de Base de Datos

- **PostgreSQL 15**: Base de datos principal
- **Redis 7**: Cache y manejo de sesiones

### 🚀 Servicios de Aplicación

- **Backend**: Node.js + Express API
- **Frontend**: React + Vite development server
- **Scraper**: Python microservice para scraping
- **n8n**: Automatización de workflows

## 🔧 Configuración y Uso

### Inicio Rápido

```bash
# Iniciar todos los servicios
./docker.sh start

# Ver logs en tiempo real
./docker.sh dev

# Detener servicios
./docker.sh stop
```

### Comandos Disponibles

```bash
# Gestión de servicios
./docker.sh start      # Iniciar en background
./docker.sh dev        # Modo desarrollo con logs
./docker.sh stop       # Detener servicios
./docker.sh restart    # Reiniciar servicios
./docker.sh status     # Ver estado de servicios

# Desarrollo y debugging
./docker.sh logs [servicio]    # Ver logs
./docker.sh shell [servicio]   # Acceder a shell
./docker.sh db-shell          # Acceder a PostgreSQL
./docker.sh redis-shell       # Acceder a Redis CLI

# Mantenimiento
./docker.sh build      # Rebuild servicios
./docker.sh clean      # Limpiar containers y volumes
./docker.sh db-reset   # Resetear base de datos
./docker.sh test       # Ejecutar tests
```

## 🌐 URLs de Servicios

Cuando los servicios estén ejecutándose:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001
- **n8n Automation**: http://localhost:5678 (admin/admin123)
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

## 📁 Estructura de Volúmenes

```
volumes/
├── postgres_data/     # Datos de PostgreSQL
├── redis_data/        # Datos de Redis
├── n8n_data/         # Configuración de n8n
└── scraper_downloads/ # Archivos descargados por scraper
```

## 🔄 Hot Reload

Todos los servicios están configurados para hot reload:

- **Backend**: Nodemon detecta cambios en `/backend`
- **Frontend**: Vite HMR detecta cambios en `/frontend`
- **Scraper**: Detecta cambios en `/scraper`

## 🏥 Health Checks

Los servicios incluyen health checks:

```bash
# Ver estado de health checks
docker-compose ps

# Health check manual
docker-compose exec postgres pg_isready -U postgres
docker-compose exec redis redis-cli ping
```

## 🐛 Debugging

### Ver logs específicos

```bash
# Logs de un servicio específico
./docker.sh logs backend
./docker.sh logs frontend
./docker.sh logs scraper
./docker.sh logs postgres
```

### Acceder a containers

```bash
# Shell del backend
./docker.sh shell backend

# Shell del scraper
./docker.sh shell scraper

# PostgreSQL CLI
./docker.sh db-shell

# Redis CLI
./docker.sh redis-shell
```

### Troubleshooting común

#### Puerto ocupado

```bash
# Verificar puertos ocupados
sudo lsof -i :3000
sudo lsof -i :3001
sudo lsof -i :5432

# Detener servicios y limpiar
./docker.sh clean
```

#### Problemas de permisos

```bash
# Dar permisos a scripts
chmod +x docker.sh
chmod +x scripts/init-multiple-databases.sh
```

#### Reset completo

```bash
# Reset completo del entorno
./docker.sh clean
docker system prune -a
./docker.sh start
```

## 🔧 Variables de Entorno

### Para desarrollo local (sin Docker)

```bash
DATABASE_URL="postgresql://postgres:password@localhost:5432/ganga_radar_dev"
REDIS_URL="redis://localhost:6379"
```

### Para desarrollo con Docker

```bash
DATABASE_URL="postgresql://postgres:password@postgres:5432/ganga_radar_dev"
REDIS_URL="redis://redis:6379"
```

## 📦 Dependencias por Servicio

### Backend

- Node.js 18
- PostgreSQL client
- Build tools (python3, make, g++)

### Frontend

- Node.js 18
- Git

### Scraper

- Python 3.11
- PostgreSQL client
- Chromium + ChromeDriver
- Build tools (gcc, g++)

## 🚀 Deployment

Para producción, usar:

```bash
docker-compose -f docker-compose.prod.yml up -d
```

(Archivo `docker-compose.prod.yml` será creado en sprints posteriores)
