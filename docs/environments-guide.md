# Comportamiento por Entorno - Ganga Radar

## 🛠️ DEVELOPMENT (Desarrollo)

```javascript
if (process.env.NODE_ENV === "development") {
  // Configuraciones para desarrollo
  app.use(cors({ origin: "http://localhost:3000" }));
  app.use(morgan("dev")); // Logs detallados
  app.use("/api-docs", swaggerUi.serve); // Documentación API visible

  // Base de datos
  DATABASE_URL = "postgresql://localhost:5432/ganga_radar_dev";

  // Logging
  console.log("🔧 Modo desarrollo activo");
  console.log("📊 Datos de debug habilitados");

  // Scraping
  SCRAPING_DELAY = 1000; // 1 segundo entre requests
  SCRAPING_CONCURRENT = 2; // Solo 2 procesos paralelos

  // Emails
  EMAIL_PROVIDER = "ethereal"; // Email falso para testing

  // Cache
  REDIS_TTL = 60; // Cache corto para testing
}
```

## 🧪 STAGING (Pre-producción)

```javascript
if (process.env.NODE_ENV === "staging") {
  // Configuraciones similares a producción pero menos estrictas
  app.use(cors({ origin: "https://staging.gangaradar.com" }));
  app.use(morgan("combined")); // Logs menos detallados
  app.use("/api-docs", swaggerUi.serve); // Documentación aún visible

  // Base de datos
  DATABASE_URL = "postgresql://staging-db:5432/ganga_radar_staging";

  // Logging
  console.log("🚀 Modo staging activo");

  // Scraping
  SCRAPING_DELAY = 3000; // 3 segundos entre requests
  SCRAPING_CONCURRENT = 5; // Más procesos paralelos

  // Emails
  EMAIL_PROVIDER = "sendgrid"; // Email real pero limitado

  // Cache
  REDIS_TTL = 300; // Cache medio
}
```

## 🌐 PRODUCTION (Producción)

```javascript
if (process.env.NODE_ENV === "production") {
  // Configuraciones optimizadas y seguras
  app.use(cors({ origin: "https://gangaradar.com" }));
  app.use(morgan("combined")); // Logs básicos
  // NO documentación API visible

  // Base de datos
  DATABASE_URL = "postgresql://prod-db:5432/ganga_radar_prod";

  // Logging
  // Sin console.log en producción

  // Scraping
  SCRAPING_DELAY = 5000; // 5 segundos entre requests
  SCRAPING_CONCURRENT = 10; // Máximo rendimiento

  // Emails
  EMAIL_PROVIDER = "sendgrid"; // Email real sin límites

  // Cache
  REDIS_TTL = 3600; // Cache largo

  // Seguridad
  app.use(helmet()); // Headers de seguridad
  app.use(rateLimit({ windowMs: 15 * 60 * 1000, max: 100 })); // Rate limiting
}
```

## 🧬 TEST (Testing)

```javascript
if (process.env.NODE_ENV === "test") {
  // Configuraciones para tests automatizados
  app.use(cors({ origin: "*" }));
  // Sin logs para no contaminar output de tests

  // Base de datos
  DATABASE_URL = "postgresql://localhost:5432/ganga_radar_test";

  // Scraping
  SCRAPING_DELAY = 0; // Sin delay para tests rápidos
  SCRAPING_CONCURRENT = 1; // Secuencial para tests predecibles

  // Emails
  EMAIL_PROVIDER = "mock"; // Email falso para tests

  // Cache
  REDIS_TTL = 1; // Cache mínimo para tests
}
```
