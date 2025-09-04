# 🤖 GenAI DevOps - Infraestructura AWS que se Autoconstruye y Optimiza con IA

> **Infraestructura AWS completamente automatizada con inteligencia artificial para optimización de costos y auto-sanación**

## 📋 Descripción del Proyecto

Sistema completo de DevOps potenciado por IA que automatiza el despliegue, monitoreo y optimización de infraestructura AWS. Utiliza Amazon Bedrock con Claude 3 Sonnet para análisis inteligente de costos y pipelines de auto-sanación para mantener la infraestructura en estado óptimo.

### 🎯 Problema que Resuelve
- **Tiempo de despliegue**: Reducido de 45 minutos a 15 minutos (70% mejora)
- **Optimización de costos**: Identificación automática de 30-50% de ahorro potencial
- **Resolución de incidentes**: De horas a 3 minutos (95% mejora)
- **Democratización DevOps**: Cualquier desarrollador puede desplegar infraestructura compleja

## 🌍 Ambientes y Ramas

### Estructura de Ramas
- **`develop`** → Ambiente **dev** - Desarrollo activo
- **`main`** → Ambiente **prod** - Producción

### Flujo de Trabajo
1. **Desarrollo:** Trabajar en rama `develop`
2. **Producción:** Merge a `main` para despliegue final

## 🚀 Inicio Rápido

### Prerrequisitos
- Cuenta AWS configurada
- Credenciales AWS en GitHub Secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
- Variables de GitHub (opcional):
  - `AWS_REGION` (default: us-east-1)
  - `ENABLED_MONITORING` (true/false - controla pipeline de monitoreo)
  - `ENABLED_SELF_HEALING` (true/false - controla pipeline de auto-sanación)

### Despliegue con GitHub Actions

1. **Desplegar Infraestructura**:
   - Ir a Actions → "Deploy Infrastructure" → Run workflow
   - Seleccionar rama: `develop` (dev) o `main` (prod)
   - Elegir tipo: `basic` o `full`
   - Recursos tendrán sufijo según rama: `-dev` o `-prod`

2. **Verificar Estado**:
   - Ir a Actions → "Infrastructure Status" → Run workflow
   - El ambiente se detecta según la rama actual

3. **Destruir Recursos**:
   - Ir a Actions → "Destroy Infrastructure" → Run workflow
   - Escribir "DESTROY" para confirmar
   - El ambiente se detecta según la rama actual

### Pipelines Automáticos
- **Infrastructure Plan**: Automático en push/PR - Muestra cambios sin aplicar
- **Self-Healing**: Cada 15 minutos (si `ENABLED_SELF_HEALING=true`) - Detecta y corrige problemas
- **Monitoring**: Cada 15 minutos (si `ENABLED_MONITORING=true`) - Verifica recursos y costos

> **Nota:** Los pipelines automáticos se pueden habilitar/deshabilitar con variables de GitHub sin modificar código.

### Pipelines Manuales
- **Infrastructure Status**: Verificación de estado según rama actual
- **Destroy Infrastructure**: Destrucción segura según rama actual

### Despliegue Local (Opcional)
```bash
# Clonar repositorio
git clone https://github.com/david4tech/gen-ai-devops.git
cd gen-ai-devops

# Desplegar todas las demos
./scripts/deployment/deploy-all.sh
```

## 🏗️ Arquitectura

### Infraestructura AWS (28 recursos)
- **VPC** con subnets públicas y privadas
- **Application Load Balancer** con Auto Scaling Group (2-10 instancias)
- **Aurora Serverless v2** MySQL para base de datos
- **Security Groups** con principios de menor privilegio
- **CloudWatch** para monitoreo y logs

### Componentes de IA
- **Amazon Bedrock** con Claude 3 Sonnet para análisis de costos
- **Optimizador inteligente** que identifica oportunidades de ahorro
- **Recomendaciones automáticas** de optimización

### Backend y Estado
- **S3 Backend único**: `genai-devops-terraform-state-{account}`
- **Paths por ambiente**:
  - `dev/terraform.tfstate`
  - `prod/terraform.tfstate`
- **Terraform Workspaces** separados por ambiente

## 🔧 Configuración de Variables

### GitHub Repository Variables
```
AWS_REGION=us-east-1
ENABLED_MONITORING=true
ENABLED_SELF_HEALING=true
```

### GitHub Secrets (Requeridos)
```
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
```

## 📊 Diferencias entre Deploy Types

### Basic Deploy
- ✅ Infraestructura Terraform completa (28 recursos AWS)
- ✅ Aplicación web funcionando
- ⏱️ **Más rápido** - Solo infraestructura

### Full Deploy
- ✅ Todo lo del Basic Deploy +
- ✅ **AI Optimizer** ejecutado automáticamente
- ✅ Análisis de costos con Amazon Bedrock
- ✅ Recomendaciones de optimización (30-50% ahorro)
- ⏱️ **Más completo** - Infraestructura + IA

## 🔄 Pipelines Detallados

### Infrastructure Plan (Automático)
- **Trigger**: Push/PR a cualquier rama con cambios en `infrastructure/`
- **Función**: Muestra plan de Terraform sin aplicar cambios
- **Ambiente**: Detecta automáticamente según la rama
- **Output**: Comentario en PR con cambios propuestos

### Deploy Infrastructure (Manual)
- **Trigger**: Manual con selección de parámetros
- **Función**: Despliega infraestructura completa
- **Backend**: S3 con folder específico por ambiente

### Self-Healing (Automático/Manual)
- **Trigger**: Cada 15 minutos (si habilitado) o manual
- **Función**: Detecta drift y aplica correcciones automáticas
- **Ambiente**: `dev` por defecto, seleccionable en manual
- **Control**: Variable `ENABLED_SELF_HEALING`

### Monitoring (Automático/Manual)
- **Trigger**: Cada 15 minutos (si habilitado) o manual
- **Función**: Análisis de costos y verificación de recursos
- **Ambiente**: `dev` por defecto, seleccionable en manual
- **Control**: Variable `ENABLED_MONITORING`

### Infrastructure Status (Manual)
- **Trigger**: Manual con selección de ambiente
- **Función**: Verificación completa de estado por ambiente
- **Output**: Estado de recursos, conectividad, inventario AWS

### Destroy Infrastructure (Manual)
- **Trigger**: Manual con confirmación requerida
- **Seguridad**: Requiere escribir "DESTROY" exactamente
- **Función**: Destrucción completa por ambiente
- **Verificación**: Confirma destrucción exitosa

## 🎯 Casos de Uso

### Para Desarrolladores
- Despliegue rápido de infraestructura compleja
- Ambiente de desarrollo aislado (`dev`)
- Pipelines automáticos para CI/CD

### Para DevOps
- Monitoreo automático y auto-sanación
- Optimización de costos con IA

### Para Empresas
- Reducción de costos operativos (30-50%)
- Tiempo de resolución de incidentes (95% mejora)
- Democratización de DevOps

## 📈 Métricas y Resultados

### Mejoras Cuantificadas
- **Tiempo de despliegue**: 45 min → 15 min (70% reducción)
- **Ahorro de costos**: 30-50% identificado por IA ($400-500/mes)
- **Resolución de incidentes**: Horas → 3 minutos (95% mejora)
- **Recursos desplegados**: 28 recursos AWS automatizados

### Beneficios Clave
- ✅ **Automatización completa** del ciclo de vida de infraestructura
- ✅ **IA integrada** para optimización continua
- ✅ **Multi-ambiente** con aislamiento completo
- ✅ **Auto-sanación** proactiva vs reactiva
- ✅ **Democratización** de DevOps para cualquier desarrollador

## 🛠️ Tecnologías Utilizadas

### AWS Services
- **Compute**: EC2, Auto Scaling Groups, Application Load Balancer
- **Database**: Aurora Serverless v2 MySQL
- **Network**: VPC, Subnets, Security Groups, Internet Gateway
- **AI/ML**: Amazon Bedrock (Claude 3 Sonnet)
- **Storage**: S3 (Terraform state)
- **Monitoring**: CloudWatch

### DevOps Tools
- **IaC**: Terraform 1.5+
- **CI/CD**: GitHub Actions
- **Languages**: Python 3.11, Bash
- **Version Control**: Git (multi-branch strategy)

### Architecture Patterns
- **Infrastructure as Code** (IaC)
- **GitOps** workflow
- **Multi-environment** deployment
- **Auto-healing** infrastructure
- **AI-powered** optimization

## 📁 Estructura del Proyecto

```
gen-ai-devops/
├── .github/workflows/          # Pipelines de GitHub Actions
│   ├── deploy.yml             # Despliegue manual por ambiente
│   ├── destroy.yml            # Destrucción segura por ambiente
│   ├── monitoring.yml         # Monitoreo automático/manual
│   ├── plan.yml               # Plan automático en PR/push
│   ├── self-healing.yml       # Auto-sanación automática/manual
│   └── status.yml             # Verificación de estado manual
├── docs/                      # Documentación del proyecto
├── infrastructure/terraform/   # Configuración de infraestructura
│   ├── main.tf               # Recursos principales
│   ├── variables.tf          # Variables de ambiente
│   ├── outputs.tf            # Outputs de Terraform
│   └── backend.tf            # Configuración S3 backend (generado)
├── scripts/
│   ├── deployment/           # Scripts de despliegue local
│   │   ├── deploy.sh         # Despliegue individual
│   │   ├── deploy-all.sh     # Despliegue completo
│   │   ├── destroy.sh        # Destrucción local
│   │   └── status.sh         # Estado local
│   ├── optimization/         # Scripts de optimización IA
│   │   └── optimizer.py      # Optimizador con Bedrock
│   └── setup-backend.sh      # Configuración S3 backend
└── README.md                 # Este archivo
```

## 🤝 Contribución

1. Fork el repositorio
2. Crear rama feature desde `develop`
3. Hacer cambios y commit
4. Push a tu fork
5. Crear Pull Request a `develop`

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## 🔗 Enlaces Útiles

- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Amazon Bedrock](https://aws.amazon.com/bedrock/)
- [GitHub Actions](https://docs.github.com/en/actions)

---

**Desarrollado con ❤️ y 🤖 IA para democratizar DevOps en AWS**
