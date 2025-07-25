#!/bin/bash

# ===================================
# GANGA RADAR - DOCKER COMMANDS
# ===================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function print_header() {
    echo -e "${BLUE}=====================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=====================================${NC}"
}

function print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

function print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

function print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# ===================================
# COMANDOS PRINCIPALES
# ===================================

case "$1" in
    "start")
        print_header "INICIANDO SERVICIOS DE GANGA RADAR"
        docker-compose up -d
        print_success "Servicios iniciados en modo detached"
        echo ""
        echo "📊 URLs disponibles:"
        echo "   Frontend: http://localhost:3000"
        echo "   Backend API: http://localhost:3001"
        echo "   n8n Automation: http://localhost:5678"
        echo "   PostgreSQL: localhost:5432"
        echo "   Redis: localhost:6379"
        ;;
    
    "dev")
        print_header "INICIANDO EN MODO DESARROLLO"
        docker-compose up
        ;;
    
    "stop")
        print_header "DETENIENDO SERVICIOS"
        docker-compose down
        print_success "Servicios detenidos"
        ;;
    
    "restart")
        print_header "REINICIANDO SERVICIOS"
        docker-compose down
        docker-compose up -d
        print_success "Servicios reiniciados"
        ;;
    
    "logs")
        if [ -z "$2" ]; then
            print_header "LOGS DE TODOS LOS SERVICIOS"
            docker-compose logs -f
        else
            print_header "LOGS DE $2"
            docker-compose logs -f "$2"
        fi
        ;;
    
    "build")
        print_header "REBUILDING SERVICIOS"
        docker-compose build --no-cache
        print_success "Build completado"
        ;;
    
    "clean")
        print_header "LIMPIANDO DOCKER"
        docker-compose down -v --remove-orphans
        docker system prune -f
        print_success "Limpieza completada"
        ;;
    
    "db-reset")
        print_header "RESETEANDO BASE DE DATOS"
        docker-compose down postgres
        docker volume rm ganga-radar_postgres_data 2>/dev/null || true
        docker-compose up -d postgres
        print_warning "Base de datos reseteada - todos los datos se han perdido"
        ;;
    
    "status")
        print_header "ESTADO DE SERVICIOS"
        docker-compose ps
        ;;
    
    "shell")
        if [ -z "$2" ]; then
            print_error "Especifica el servicio: ./docker.sh shell [backend|frontend|scraper|postgres|redis]"
        else
            print_header "ACCEDIENDO A SHELL DE $2"
            docker-compose exec "$2" sh
        fi
        ;;
    
    "db-shell")
        print_header "ACCEDIENDO A POSTGRESQL"
        docker-compose exec postgres psql -U postgres -d ganga_radar_dev
        ;;
    
    "redis-shell")
        print_header "ACCEDIENDO A REDIS CLI"
        docker-compose exec redis redis-cli
        ;;
    
    "test")
        print_header "EJECUTANDO TESTS"
        docker-compose exec backend npm test
        docker-compose exec frontend npm test
        docker-compose exec scraper python -m pytest
        ;;
    
    *)
        echo "Uso: ./docker.sh [comando]"
        echo ""
        echo "Comandos disponibles:"
        echo "  start      - Iniciar servicios en background"
        echo "  dev        - Iniciar en modo desarrollo (con logs)"
        echo "  stop       - Detener servicios"
        echo "  restart    - Reiniciar servicios"
        echo "  logs       - Ver logs (opcional: especificar servicio)"
        echo "  build      - Rebuild servicios"
        echo "  clean      - Limpiar containers y volumes"
        echo "  db-reset   - Resetear base de datos"
        echo "  status     - Ver estado de servicios"
        echo "  shell      - Acceder a shell de servicio"
        echo "  db-shell   - Acceder a PostgreSQL"
        echo "  redis-shell- Acceder a Redis CLI"
        echo "  test       - Ejecutar tests"
        echo ""
        echo "Ejemplos:"
        echo "  ./docker.sh start"
        echo "  ./docker.sh logs backend"
        echo "  ./docker.sh shell backend"
        ;;
esac
