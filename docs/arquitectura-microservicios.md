# Arquitectura de Microservicios y Clean Architecture – Ganga Radar

## 🏗️ Visión General

Ganga Radar está diseñado bajo el patrón de **microservicios desacoplados + REST**, siguiendo principios de Clean Architecture en cada servicio. Esta arquitectura permite escalabilidad, mantenibilidad y resiliencia.

---

## 1. ¿Qué es un Microservicio?

Un microservicio es un servicio backend independiente, con responsabilidad única, que se comunica con otros servicios mediante APIs (REST o eventos). Cada microservicio puede estar desarrollado en un lenguaje diferente y desplegarse de forma aislada.

---

## 2. Componentes Principales

### **Frontend (React + Vite)**

- Interfaz de usuario (SPA)
- Consume APIs REST de los microservicios

### **Microservicios**

- **Core API Service (Node.js + Express)**
  - Gestión de usuarios, productos, alertas, reportes
  - Exposición de endpoints REST
  - Orquestación de lógica de negocio
- **Scraper Service (Python + FastAPI)**
  - Extracción de datos de sitios externos
  - Procesamiento y almacenamiento de históricos
- **Notification Service (Node.js)**
  - Envío de emails, SMS, notificaciones push
  - Gestión de preferencias de usuario
- **n8n (Automatización)**
  - Workflows y tareas programadas

### **Infraestructura Compartida**

- **PostgreSQL**: Base de datos única, con esquemas por servicio
- **Redis**: Cache, coordinación y Pub/Sub

---

## 3. Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                    FRONTEND (React)                     │
└─────────────────────┬───────────────────────────────────┘
                      │ HTTP/REST
                      ▼
┌─────────────────────────────────────────────────────────┐
│                  MICROSERVICIOS                         │
│  ┌───────────────┐ ┌───────────────┐ ┌───────────────┐  │
│  │  Core API     │ │    Scraper    │ │ Notification  │  │
│  │  Service      │ │   Service     │ │   Service     │  │
│  │ (Node.js)     │ │  (Python)     │ │  (Node.js)    │  │
│  └───────────────┘ └───────────────┘ └───────────────┘  │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              CAPA DE DATOS COMPARTIDA                   │
│  ┌─────────────────┐        ┌─────────────────────────┐ │
│  │   PostgreSQL    │        │        Redis            │ │
│  │  (Datos)        │        │   (Cache + PubSub)      │ │
│  └─────────────────┘        └─────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## 5. Estructura Interna Detallada de Cada Microservicio

### **Core API Service (Node.js + Express)**

#### **Convención de Nomenclatura:**

```
src/
├── controllers/     # Capa de Controladores
├── use-cases/      # Capa de Casos de Uso
├── services/       # Capa de Servicios Externos
├── repositories/   # Capa de Repositorios
├── entities/       # Capa de Entidades
├── middleware/     # Middlewares transversales
├── config/         # Configuraciones
└── utils/          # Utilidades compartidas
```

#### **1. Controllers (Capa de Entrada HTTP)**

- **Función**: Manejar requests HTTP, validar entrada, llamar use cases
- **Responsabilidades**:
  - Parsing de parámetros y body de requests
  - Validación de schemas con Joi/Zod
  - Transformación de responses HTTP
  - Manejo de errores HTTP (4xx, 5xx)
  - Rate limiting y autenticación
- **Archivos**:
  - `UserController.js` - CRUD usuarios
  - `ProductController.js` - Gestión productos
  - `AlertController.js` - Alertas de precios
  - `AuthController.js` - Autenticación y autorización
  - `ReportController.js` - Generación reportes

#### **2. Use Cases (Lógica de Negocio)**

- **Función**: Orquestar la lógica de negocio, coordinar entre capas
- **Responsabilidades**:
  - Implementar reglas de negocio específicas
  - Coordinar entre repositories y services
  - Validaciones de dominio
  - Transacciones de base de datos
  - Emisión de eventos de negocio
- **Archivos**:
  - `CreateUser.js` - Registro de usuarios
  - `FollowProduct.js` - Seguimiento productos
  - `TriggerAlert.js` - Disparo de alertas
  - `GenerateReport.js` - Creación reportes

#### **3. Services (Servicios Externos)**

- **Función**: Abstracción de APIs externas y otros microservicios
- **Responsabilidades**:
  - Comunicación HTTP con otros microservicios
  - Integración con APIs de terceros (AWS Cognito, etc.)
  - Manejo de errores de red y timeouts
  - Circuit breaker pattern
  - Retry logic con backoff
- **Archivos**:
  - `ScraperService.js` - API calls al Scraper Service
  - `NotificationService.js` - API calls al Notification Service
  - `CognitoService.js` - Integración AWS Cognito
  - `RedisService.js` - Manejo cache y pub/sub

#### **4. Repositories (Acceso a Datos)**

- **Función**: Abstracción del acceso a base de datos
- **Responsabilidades**:
  - Operaciones CRUD con Prisma ORM
  - Consultas complejas y agregaciones
  - Transacciones de base de datos
  - Mapeo entre entities y modelos BD
  - Optimización de queries
- **Archivos**:
  - `UserRepository.js` - Persistencia usuarios
  - `ProductRepository.js` - Persistencia productos
  - `AlertRepository.js` - Persistencia alertas

#### **5. Entities (Modelos de Dominio)**

- **Función**: Representar conceptos del dominio con sus reglas
- **Responsabilidades**:
  - Encapsular datos y comportamientos del dominio
  - Validaciones de integridad de datos
  - Métodos de negocio específicos
  - Inmutabilidad cuando corresponde
- **Archivos**:
  - `User.js` - Entidad usuario con validaciones
  - `Product.js` - Entidad producto con reglas precio
  - `Alert.js` - Entidad alerta con criterios

### **Scraper Service (Python + FastAPI)**

#### **Convención de Nomenclatura:**

```
src/
├── routers/        # Capa de Endpoints (FastAPI)
├── use_cases/      # Capa de Casos de Uso
├── adapters/       # Capa de Adaptadores de Scraping
├── gateways/       # Capa de Acceso a Datos
├── entities/       # Capa de Entidades
├── providers/      # Configuraciones por proveedor
├── config/         # Configuraciones generales
└── utils/          # Utilidades compartidas
```

#### **1. Routers (Capa de Entrada FastAPI)**

- **Función**: Definir endpoints REST con FastAPI
- **Responsabilidades**:
  - Definición de rutas y métodos HTTP
  - Validación con Pydantic models
  - Documentación automática OpenAPI
  - Manejo de errores HTTP
  - Middleware de autenticación
- **Archivos**:
  - `scraping_router.py` - Endpoints scraping
  - `jobs_router.py` - Gestión trabajos
  - `providers_router.py` - Configuración proveedores
  - `health_router.py` - Health checks

#### **2. Use Cases (Lógica de Negocio)**

- **Función**: Orquestar procesos de scraping y procesamiento
- **Responsabilidades**:
  - Lógica de extracción de datos
  - Procesamiento y normalización
  - Detección de cambios significativos
  - Manejo de colas de trabajos
  - Anti-bot strategies
- **Archivos**:
  - `scrape_product.py` - Scraping individual
  - `process_queue.py` - Procesamiento batch
  - `detect_changes.py` - Detección cambios precios
  - `manage_sessions.py` - Gestión sesiones navegador

#### **3. Adapters (Tecnologías de Scraping)**

- **Función**: Abstracción de herramientas de scraping
- **Responsabilidades**:
  - Implementación específica por tecnología
  - Manejo de navegadores (Selenium, Playwright)
  - Parsing HTML (BeautifulSoup)
  - Gestión de proxies y user agents
  - Screenshot y debugging
- **Archivos**:
  - `selenium_adapter.py` - Adapter Selenium
  - `playwright_adapter.py` - Adapter Playwright
  - `beautifulsoup_adapter.py` - Adapter BS4
  - `requests_adapter.py` - Adapter requests HTTP

#### **4. Gateways (Acceso a Datos Externos)**

- **Función**: Abstracción de persistencia y cache
- **Responsabilidades**:
  - Conexiones a PostgreSQL (SQLAlchemy)
  - Operaciones Redis (cache, locks, queues)
  - Manejo de archivos temporales
  - Logging estructurado
  - Métricas y monitoreo
- **Archivos**:
  - `database_gateway.py` - Acceso PostgreSQL
  - `redis_gateway.py` - Operaciones Redis
  - `filesystem_gateway.py` - Manejo archivos
  - `queue_gateway.py` - Sistema de colas

#### **5. Entities (Modelos de Dominio)**

- **Función**: Representar conceptos específicos del scraping
- **Responsabilidades**:
  - Modelos de datos con Pydantic
  - Validaciones específicas de scraping
  - Transformaciones de datos
  - Serialización/deserialización
- **Archivos**:
  - `scraping_job.py` - Trabajo de scraping
  - `product_data.py` - Datos producto extraído
  - `vendor_config.py` - Configuración por vendor
  - `price_snapshot.py` - Snapshot precio histórico

### **Notification Service (Node.js + Express)**

#### **Convención de Nomenclatura:**

```
src/
├── consumers/      # Capa de Event Consumers
├── controllers/    # Capa de Controladores HTTP
├── use-cases/      # Capa de Casos de Uso
├── adapters/       # Capa de Adaptadores Externos
├── repositories/   # Capa de Repositorios
├── entities/       # Capa de Entidades
├── templates/      # Templates de notificación
├── config/         # Configuraciones
└── utils/          # Utilidades compartidas
```

#### **1. Consumers (Capa de Eventos)**

- **Función**: Escuchar eventos Redis Pub/Sub y procesar
- **Responsabilidades**:
  - Subscription a canales Redis
  - Parsing de eventos recibidos
  - Dispatch a use cases apropiados
  - Manejo de errores en processing
  - Dead letter queue para fallos
- **Archivos**:
  - `price_changed_consumer.js` - Eventos cambio precio
  - `user_registered_consumer.js` - Eventos registro usuario
  - `alert_triggered_consumer.js` - Eventos alertas

#### **2. Controllers (Capa HTTP)**

- **Función**: APIs REST para gestión manual de notificaciones
- **Responsabilidades**:
  - Endpoints para envío manual
  - Gestión de templates
  - Configuración de preferencias
  - Webhooks para servicios externos
  - APIs de monitoreo y métricas
- **Archivos**:
  - `notification_controller.js` - Envío manual
  - `template_controller.js` - Gestión templates
  - `webhook_controller.js` - Webhooks externos

#### **3. Use Cases (Lógica de Negocio)**

- **Función**: Orquestar envío de notificaciones
- **Responsabilidades**:
  - Validación de usuarios y preferencias
  - Selección de canal apropiado
  - Rate limiting y deduplicación
  - Procesamiento de templates
  - Retry logic para fallos
- **Archivos**:
  - `send_email_alert.js` - Envío emails
  - `send_sms_alert.js` - Envío SMS/WhatsApp
  - `send_push_notification.js` - Push notifications
  - `process_template.js` - Procesamiento templates

#### **4. Adapters (Servicios Externos)**

- **Función**: Abstracción de proveedores de notificación
- **Responsabilidades**:
  - Integración con SendGrid, Nodemailer
  - Integración con Twilio, WhatsApp
  - Integración con Firebase FCM, OneSignal
  - Manejo de diferentes formatos
  - Fallback entre proveedores
- **Archivos**:
  - `email_adapter.js` - Adaptadores email
  - `sms_adapter.js` - Adaptadores SMS
  - `push_adapter.js` - Adaptadores push

#### **5. Repositories (Acceso a Datos)**

- **Función**: Persistencia de notificaciones y templates
- **Responsabilidades**:
  - CRUD notificaciones enviadas
  - Gestión de templates
  - Historial de entregas
  - Métricas de engagement
  - Configuraciones usuario
- **Archivos**:
  - `notification_repository.js` - Persistencia notificaciones
  - `template_repository.js` - Gestión templates
  - `user_preference_repository.js` - Preferencias usuario

#### **6. Entities (Modelos de Dominio)**

- **Función**: Representar conceptos de notificación
- **Responsabilidades**:
  - Validaciones específicas de canal
  - Reglas de negocio de notificación
  - Formateo y transformación
  - Estados y tracking
- **Archivos**:
  - `notification.js` - Entidad notificación
  - `template.js` - Entidad template
  - `user_preference.js` - Preferencias usuario

---

## 6. Comunicación REST y Pub/Sub

- **Frontend → Microservicios**: Llamadas HTTP/REST (JSON)
- **Entre microservicios**: REST y eventos Pub/Sub vía Redis
- **n8n**: Orquestación de workflows y tareas programadas

---

## 6. Estrategia de Base de Datos: Esquemas Compartidos

### **Enfoque Híbrido Adoptado**

Ganga Radar utiliza un enfoque híbrido de **PostgreSQL único con esquemas separados por microservicio**, en lugar de bases de datos completamente independientes.

### **Estructura de Base de Datos**

```sql
-- PostgreSQL único con ESQUEMAS separados
ganga_radar_database/
├── public (schema)           ← Core API Service
│   ├── users
│   ├── products
│   ├── alerts
│   ├── reports
│   └── tracking
├── pricing (schema)          ← Scraper Service
│   ├── price_history
│   ├── scraping_jobs
│   ├── vendor_configs
│   └── product_snapshots
└── notifications (schema)    ← Notification Service
    ├── notifications_sent
    ├── templates
    ├── user_preferences
    └── delivery_logs
```

### **Arquitectura de Datos Resumida**

```
FRONTEND (React)
      │
      ▼ HTTP/REST
┌─────────────────────────────────┐
│        MICROSERVICIOS           │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐│
│  │Core API │ │ Scraper │ │Notifications││
│  │Service  │ │ Service │ │ Service │││
│  │(public) │ │(pricing)│ │(notifications)││
│  └─────────┘ └─────────┘ └─────────┘│
└─────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────┐
│    DATOS COMPARTIDOS            │
│  ┌─────────────┐ ┌─────────────┐ │
│  │ PostgreSQL  │ │   Redis     │ │
│  │(esquemas    │ │ (cache +    │ │
│  │ separados)  │ │  pub/sub)   │ │
│  └─────────────┘ └─────────────┘ │
└─────────────────────────────────┘
```

### **✅ Ventajas del Enfoque Híbrido**

#### **Operacionales**

- **Menor complejidad**: Un solo PostgreSQL para administrar
- **Backup simplificado**: Un solo proceso de respaldo para todos los datos
- **Recovery unificado**: Restauración coordinada de todos los servicios
- **Monitoreo centralizado**: Métricas y logs de BD en un solo lugar
- **Menor costo**: Una sola instancia de base de datos

#### **Desarrollo**

- **Transacciones cross-service**: Operaciones ACID entre esquemas cuando sea necesario
- **Consultas join**: Reportes complejos que requieren datos de múltiples servicios
- **Migraciones coordinadas**: Cambios de schema sincronizados
- **Testing integrado**: Tests que involucran múltiples servicios más fáciles

#### **Infraestructura**

- **Configuración simplificada**: Una sola cadena de conexión base
- **Escalado coordinado**: Recursos de BD optimizados conjuntamente
- **Conexiones eficientes**: Pool de conexiones compartido optimizado

### **❌ Desventajas Aceptadas**

#### **Acoplamiento**

- **Schema coupling**: Cambios en un schema pueden afectar queries cross-service
- **Dependencia de BD**: Fallo de PostgreSQL afecta todos los servicios
- **Versionado complejo**: Migraciones deben considerar impacto en otros servicios

#### **Escalabilidad**

- **Escalado conjunto**: No se puede escalar BD independientemente por servicio
- **Hotspots de rendimiento**: Un servicio intensivo puede afectar a otros
- **Límites de conexiones**: Pool compartido puede generar contención

#### **Aislamiento**

- **Menos resiliencia**: Problemas de BD afectan todo el sistema
- **Seguridad compartida**: Permisos y accesos deben gestionarse cuidadosamente
- **Testing aislado**: Tests unitarios pueden tener interdependencias

### **🔄 Comparación: Híbrido vs Microservicios Puros**

| Aspecto                        | Enfoque Híbrido (Ganga Radar) | Microservicios Puros     |
| ------------------------------ | ----------------------------- | ------------------------ |
| **BD por servicio**            | 1 PostgreSQL + esquemas       | 3 PostgreSQL separadas   |
| **Complejidad operacional**    | ✅ Baja                       | ❌ Alta                  |
| **Aislamiento de fallos**      | ❌ Medio                      | ✅ Alto                  |
| **Queries cross-service**      | ✅ Directas (JOIN)            | ❌ APIs múltiples        |
| **Transacciones distribuidas** | ✅ ACID nativo                | ❌ Saga pattern          |
| **Costo infraestructura**      | ✅ Bajo                       | ❌ Alto                  |
| **Escalado independiente**     | ❌ Limitado                   | ✅ Total                 |
| **Backup/Recovery**            | ✅ Simplificado               | ❌ Coordinación compleja |

### **🎯 Justificación de la Decisión**

#### **Contexto del Proyecto**

- **Equipo pequeño**: 1-3 desarrolladores
- **MVP inicial**: Prioridad en velocidad de desarrollo
- **Presupuesto limitado**: Optimización de costos
- **Complejidad moderada**: No requiere ultra-escalabilidad inicial

#### **Evolución Futura**

```
FASE 1 (Actual): PostgreSQL + esquemas
    ↓ (Si crece la demanda)
FASE 2: Separar BD del Scraper (más intensivo)
    ↓ (Si crece aún más)
FASE 3: BDs completamente independientes
```

### **🔧 Implementación Práctica**

#### **Conexiones por Servicio**

```javascript
// Core API Service
DATABASE_URL=postgresql://user:pass@postgres:5432/ganga_radar?schema=public

// Scraper Service
DATABASE_URL=postgresql://user:pass@postgres:5432/ganga_radar?schema=pricing

// Notification Service
DATABASE_URL=postgresql://user:pass@postgres:5432/ganga_radar?schema=notifications
```

#### **Migraciones Coordinadas**

```bash
# Migración que afecta múltiples esquemas
001_add_product_id_cross_schema.sql
├── ALTER TABLE public.products ...
├── ALTER TABLE pricing.price_history ...
└── ALTER TABLE notifications.templates ...
```

---

## 7. Ventajas de la Arquitectura

- **Desacoplamiento**: Servicios independientes, escalables y mantenibles
- **Responsabilidad única**: Cada microservicio tiene un propósito claro
- **Resiliencia**: Fallos aislados, fácil recuperación
- **Clean Architecture**: Separación de capas, fácil testing y evolución

---

## 8. Próximos Pasos

- Implementar estructura interna de cada microservicio
- Definir APIs REST y eventos entre servicios
- Añadir migraciones y seeders para la base de datos
- Orquestar despliegue con Kubernetes (AWS EKS)
