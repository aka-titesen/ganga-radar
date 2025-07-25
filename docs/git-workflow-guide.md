# Guía de Git Workflow - Ganga Radar

## 🌟 Estrategia: GitHub Flow simplificado

### 📋 Configuración Inicial

```bash
# Crear rama dev desde main
git checkout -b dev
git push -u origin dev

# Configurar conventional commits (opcional)
git config --global commit.template .gitmessage
```

### 🔄 Flujo de desarrollo por Sprint

```bash
# Trabajar directamente en rama dev durante todo el sprint
git checkout dev
git pull origin dev

# Desarrollo de tareas (commits frecuentes y descriptivos)
git add .
git commit -m "feat(docker): add postgresql service configuration"
git commit -m "feat(docker): add redis cache service"
git commit -m "feat(api): implement property endpoints"
git commit -m "docs(readme): update installation instructions"

# Push frecuente para backup
git push origin dev
```

### 🚀 Flujo al finalizar Sprint

```bash
# Al completar TODAS las tareas del sprint
git checkout dev
git add .
git commit -m "docs(sprint): update sprint completion status"

# Merge a main y crear versión
git checkout main
git pull origin main
git merge dev
git tag v1.0.0-sprint-1 -m "Sprint 1: Configuración Base Completado"
git push origin main --tags

# Continuar desarrollo en dev para próximo sprint
git checkout dev
```

### 🌟 Uso de Feature Branches (Solo cuando sea necesario)

```bash
# SOLO crear feature branch si:
# - Funcionalidad compleja que puede romper el desarrollo
# - Experimentación que puede no funcionar
# - Colaboración con otro desarrollador

git checkout dev
git checkout -b feature/complex-scraping-algorithm
# ... desarrollo experimental ...
git checkout dev
git merge feature/complex-scraping-algorithm
git branch -d feature/complex-scraping-algorithm
```

### 📝 Conventional Commits

```bash
# Tipos principales
feat:     # Nueva funcionalidad
fix:      # Bug fix
docs:     # Documentación
style:    # Formateo, sin cambios de código
refactor: # Refactoring de código
test:     # Tests
chore:    # Tareas de mantenimiento

# Ejemplos específicos para Ganga Radar
feat(docker): add postgresql service configuration
feat(scraper): implement property data extraction
feat(auth): add google oauth integration
fix(api): correct property search endpoint
docs(readme): update installation instructions
test(scraper): add unit tests for data extraction
chore(deps): update dependencies to latest versions
```

### 🏷️ Estrategia de Tags

```bash
# Tags por sprint
v1.0.0-sprint-1  # Configuración base
v1.0.0-sprint-2  # Backend y scraping
v1.0.0-sprint-3  # Frontend básico
v1.0.0-sprint-4  # Integración completa
v1.0.0-sprint-5  # Deploy y optimización

# Tags de release
v1.0.0    # Primera versión completa
v1.1.0    # Nuevas funcionalidades
v1.1.1    # Bug fixes
v2.0.0    # Breaking changes
```

### 🚨 Hotfixes de emergencia

```bash
# Solo para bugs críticos en producción
git checkout main
git checkout -b hotfix/critical-security-patch
# ... fix the issue ...
git checkout main
git merge hotfix/critical-security-patch
git tag v1.0.1 -m "Hotfix: Security patch"
git checkout dev
git merge main  # Ensure dev has the fix too
git push origin main dev --tags
```

### 📊 Comandos de verificación

```bash
# Ver estado de ramas
git branch -av

# Ver historial gráfico
git log --oneline --graph --all

# Ver diferencias entre ramas
git diff dev..main

# Ver tags
git tag -l

# Ver commits desde último tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline
```

### 🔧 Configuración recomendada

```bash
# Configurar aliases útiles
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --all"

# Configurar pull con rebase por defecto
git config --global pull.rebase false

# Configurar push simple
git config --global push.default simple
```

### 📋 Checklist por Sprint (Simplificado)

- [ ] Desarrollar todas las tareas en rama dev
- [ ] Commits frecuentes con conventional commits
- [ ] Push regular a origin dev para backup
- [ ] Al completar sprint: merge dev → main
- [ ] Crear tag de versión del sprint
- [ ] Push con tags
- [ ] Actualizar documentación del sprint

### 📋 Cuándo Crear Feature Branches

**SÍ crear feature branch cuando**:

- 🧪 Funcionalidad experimental que puede fallar
- 🤝 Colaboración con otro desarrollador en funcionalidad específica
- 🔧 Refactoring mayor que puede romper el sistema
- 📦 Integración compleja de librería nueva

**NO crear feature branch para**:

- ✏️ Tareas normales del sprint
- 🐛 Bug fixes pequeños
- 📝 Documentación
- ⚙️ Configuración básica
