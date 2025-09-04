#!/bin/bash

# Script de Estado - GenAI DevOps Demo

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}📊 Estado de la Infraestructura GenAI DevOps${NC}"
echo "=============================================="

# Verificar que estamos en el directorio raíz del proyecto
if [[ ! -f "README.md" ]] || [[ ! -d "infrastructure" ]]; then
    echo -e "${RED}❌ Error: Ejecutar desde el directorio raíz del proyecto${NC}"
    exit 1
fi

# Navegar al directorio de Terraform
cd infrastructure/terraform

# Verificar si hay recursos desplegados
RESOURCE_COUNT=$(terraform show -json 2>/dev/null | jq -r '.values.root_module.resources // [] | length' 2>/dev/null || echo "0")

if [ "$RESOURCE_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No hay infraestructura desplegada.${NC}"
    echo "Ejecuta: ./deploy.sh"
    exit 0
fi

echo -e "${GREEN}✅ Infraestructura desplegada${NC}"
echo ""

# Mostrar outputs
terraform output

# Probar aplicación
LOAD_BALANCER_URL=$(terraform output -raw load_balancer_url 2>/dev/null || echo "")
if [ ! -z "$LOAD_BALANCER_URL" ]; then
    echo ""
    echo -e "${YELLOW}🌐 Probando aplicación...${NC}"
    if curl -s --max-time 5 "$LOAD_BALANCER_URL" > /dev/null; then
        echo -e "${GREEN}✅ Aplicación funcionando: ${LOAD_BALANCER_URL}${NC}"
    else
        echo -e "${YELLOW}⚠️  Aplicación no responde: ${LOAD_BALANCER_URL}${NC}"
    fi
fi
