#!/bin/bash

# Script de Destrucción - GenAI DevOps Demo

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TERRAFORM_DIR="../../infrastructure/terraform"

echo -e "${RED}🗑️  Destruyendo infraestructura GenAI DevOps...${NC}"
echo ""

# Verificar que estamos en el directorio raíz del proyecto
if [[ ! -f "README.md" ]] || [[ ! -d "infrastructure" ]]; then
    echo -e "${RED}❌ Error: Ejecutar desde el directorio raíz del proyecto${NC}"
    exit 1
fi

# Navegar al directorio de Terraform
cd infrastructure/terraform

echo -e "${YELLOW}⚠️  ADVERTENCIA: Esto eliminará TODOS los recursos AWS.${NC}"
read -p "¿Continuar? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operación cancelada."
    exit 1
fi

echo -e "${YELLOW}🔥 Destruyendo recursos...${NC}"
terraform destroy -auto-approve

echo -e "${GREEN}✅ Infraestructura eliminada completamente.${NC}"
