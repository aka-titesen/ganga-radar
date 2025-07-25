# 🎯 Ganga Radar - Rastreador Automático de Precios

[![Estado del Proyecto](https://img.shields.io/badge/Estado-En%20Desarrollo-yellow)](https://github.com/aka-titesen/ganga-radar)
[![Versión](https://img.shields.io/badge/Versión-0.1.0--alpha-blue)](https://github.com/aka-titesen/ganga-radar)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-green)](LICENSE)

## 📝 Descripción

Ganga Radar es una aplicación web diseñada para monitorear y notificar automáticamente las variaciones de precios de productos en tiendas físicas y digitales dentro del territorio argentino. El sistema permite al usuario seguir productos específicos, visualizar su historial de precios y recibir alertas personalizadas ante descuentos relevantes.

## ✨ Características Principales

- 🔐 **Autenticación con Google** (AWS Cognito)
- 🔍 **Búsqueda y filtrado avanzado** de productos
- 📈 **Seguimiento personalizado** de productos con historial de precios
- 📧 **Notificaciones automáticas** por email y WhatsApp
- 👥 **Reportes comunitarios** con sistema de votación
- 📊 **Exportación automática** a Google Sheets
- 🏗️ **Arquitectura de microservicios** escalable

## 🛠️ Stack Tecnológico

### Frontend
- **React** + **Vite** - Interfaz de usuario moderna y rápida
- **TailwindCSS** - Estilos utilitarios y diseño responsivo
- **React Router** - Navegación SPA

### Backend
- **Node.js** + **Express** - API REST robusta
- **Prisma ORM** - Manejo de base de datos
- **PostgreSQL** - Base de datos principal
- **Redis** - Cache y gestión de sesiones

### Scraping & Automatización
- **Python** - Microservicio de scraping
- **BeautifulSoup** + **Selenium** - Extracción de datos web
- **n8n** - Automatización de flujos de trabajo

### Cloud & DevOps
- **AWS** - Infraestructura cloud
- **Docker** + **Docker Compose** - Contenedorización
- **GitHub Actions** - CI/CD

## 🚀 Inicio Rápido

### Prerrequisitos

- Node.js 18+ 
- Python 3.9+
- Docker & Docker Compose
- Git

### Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/aka-titesen/ganga-radar.git
   cd ganga-radar
   ```

2. **Configurar variables de entorno**
   ```bash
   cp .env.example .env
   # Editar .env con tus configuraciones
   ```

3. **Levantar servicios con Docker**
   ```bash
   docker-compose up -d
   ```

4. **Instalar dependencias del frontend**
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

5. **Instalar dependencias del backend**
   ```bash
   cd ../backend
   npm install
   npm run dev
   ```

6. **Ejecutar migraciones de base de datos**
   ```bash
   npm run db:migrate
   npm run db:seed
   ```

## 📁 Estructura del Proyecto

```
ganga-radar/
├── frontend/          # Aplicación React
├── backend/           # API Node.js + Express
├── scraper/           # Microservicio Python
├── prisma/            # Esquemas y migraciones de BD
├── tests/             # Pruebas unitarias e integración
├── scripts/           # Scripts de automatización
├── config/            # Configuraciones globales
├── docs/              # Documentación técnica
└── sprints/           # Gestión de proyecto (gitignored)
```

## 🔧 Desarrollo

### Comandos Útiles

```bash
# Desarrollo completo
docker-compose up -d

# Solo base de datos
docker-compose up postgres redis -d

# Ver logs
docker-compose logs -f [servicio]

# Ejecutar tests
npm run test

# Linting
npm run lint

# Build para producción
npm run build
```

### Scripts Disponibles

- `npm run dev` - Modo desarrollo
- `npm run build` - Build para producción
- `npm run test` - Ejecutar tests
- `npm run lint` - Verificar código
- `npm run db:migrate` - Ejecutar migraciones
- `npm run db:seed` - Poblar BD con datos de prueba

## 📊 Estado del Proyecto

| Componente | Estado | Progreso |
|------------|---------|----------|
| 🏗️ Configuración Base | 🚧 En Progreso | 20% |
| 🗄️ Backend Core | ⏳ Pendiente | 0% |
| 🎨 Frontend MVP | ⏳ Pendiente | 0% |
| 🕷️ Scraping | ⏳ Pendiente | 0% |
| 📧 Notificaciones | ⏳ Pendiente | 0% |

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add: AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

## 📞 Contacto

**Facundo N. González** - [@aka-titesen](https://github.com/aka-titesen)

**Link del Proyecto**: [https://github.com/aka-titesen/ganga-radar](https://github.com/aka-titesen/ganga-radar)

---

⭐ **Si este proyecto te resulta útil, considera darle una estrella en GitHub!** ⭐