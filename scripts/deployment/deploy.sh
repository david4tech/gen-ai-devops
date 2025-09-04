#!/bin/bash

# Script de Despliegue Automatizado - GenAI DevOps Demo
# Autor: AWS Builder Community

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Variables
TERRAFORM_DIR="../../infrastructure/terraform"
REGION="us-east-1"

echo -e "${BLUE}🎯 GenAI DevOps - Despliegue Automatizado${NC}"
echo "=================================================="
echo ""

# Verificar AWS CLI
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI no encontrado. Instálalo primero.${NC}"
    exit 1
fi

# Verificar Terraform
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}❌ Terraform no encontrado. Instálalo primero.${NC}"
    exit 1
fi

# Verificar credenciales AWS
echo -e "${YELLOW}🔐 Verificando credenciales AWS...${NC}"
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ Credenciales AWS no configuradas.${NC}"
    echo "Ejecuta: aws configure"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo -e "${GREEN}✅ Conectado a cuenta AWS: ${ACCOUNT_ID}${NC}"

# Verificar que estamos en el directorio raíz del proyecto
if [[ ! -f "README.md" ]] || [[ ! -d "infrastructure" ]]; then
    echo -e "${RED}❌ Error: Ejecutar desde el directorio raíz del proyecto${NC}"
    exit 1
fi

# Navegar al directorio de Terraform
cd infrastructure/terraform

echo -e "${YELLOW}📦 Inicializando Terraform...${NC}"
terraform init

echo -e "${YELLOW}✅ Validando configuración...${NC}"
terraform validate

echo -e "${YELLOW}📋 Generando plan de despliegue...${NC}"
terraform plan -out=tfplan

echo -e "${YELLOW}🚀 Desplegando infraestructura...${NC}"
terraform apply tfplan

echo -e "${GREEN}✅ Despliegue completado!${NC}"
echo ""

# Obtener outputs
echo -e "${BLUE}📊 Información de la infraestructura:${NC}"
terraform output

# Probar aplicación web
LOAD_BALANCER_URL=$(terraform output -raw load_balancer_url)
echo ""
echo -e "${YELLOW}🌐 Probando aplicación web...${NC}"
sleep 30  # Esperar que las instancias estén listas

if curl -s --max-time 10 "$LOAD_BALANCER_URL" > /dev/null; then
    echo -e "${GREEN}✅ Aplicación web funcionando: ${LOAD_BALANCER_URL}${NC}"
else
    echo -e "${YELLOW}⚠️  Aplicación aún iniciando. Prueba en unos minutos: ${LOAD_BALANCER_URL}${NC}"
fi

echo ""
echo -e "${GREEN}🎉 ¡Despliegue de DevOps Generativo Completado!${NC}"
echo -e "${BLUE}📋 Resumen:${NC}"
echo "   • VPC con subnets públicas y privadas"
echo "   • Load Balancer con Auto Scaling"
echo "   • Aurora Serverless v2 MySQL"
echo "   • Security Groups configurados"
echo "   • 28 recursos AWS desplegados"
echo ""
echo -e "${YELLOW}🔧 Para destruir la infraestructura:${NC}"
echo "   ./destroy.sh"
