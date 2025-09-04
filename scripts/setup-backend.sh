#!/bin/bash

# Setup S3 Backend para Terraform State

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Generar nombre único para el bucket (un solo bucket para todos los ambientes)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET_NAME="genai-devops-terraform-state-${ACCOUNT_ID}"
REGION="us-east-1"

echo -e "${BLUE}🪣 Configurando S3 Backend para Terraform${NC}"
echo "=========================================="
echo "Bucket: ${BUCKET_NAME}"
echo "Region: ${REGION}"
echo ""

# Verificar si el bucket ya existe
if aws s3api head-bucket --bucket "${BUCKET_NAME}" 2>/dev/null; then
    echo -e "${GREEN}✅ Bucket ${BUCKET_NAME} ya existe${NC}"
else
    echo -e "${YELLOW}🔧 Creando bucket S3...${NC}"
    
    # Crear bucket
    aws s3api create-bucket \
        --bucket "${BUCKET_NAME}" \
        --region "${REGION}"
    
    # Habilitar versionado
    aws s3api put-bucket-versioning \
        --bucket "${BUCKET_NAME}" \
        --versioning-configuration Status=Enabled
    
    # Habilitar cifrado
    aws s3api put-bucket-encryption \
        --bucket "${BUCKET_NAME}" \
        --server-side-encryption-configuration '{
            "Rules": [{
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }]
        }'
    
    # Bloquear acceso público
    aws s3api put-public-access-block \
        --bucket "${BUCKET_NAME}" \
        --public-access-block-configuration \
        BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
    
    echo -e "${GREEN}✅ Bucket ${BUCKET_NAME} creado exitosamente${NC}"
fi

# Crear archivo de backend base (será modificado por cada pipeline)
echo -e "${YELLOW}📝 Configurando backend de Terraform...${NC}"

cat > infrastructure/terraform/backend.tf << EOF
terraform {
  backend "s3" {
    bucket = "${BUCKET_NAME}"
    key    = "terraform.tfstate"
    region = "${REGION}"
  }
}
EOF

echo -e "${GREEN}✅ Backend configurado en infrastructure/terraform/backend.tf${NC}"
echo ""
echo -e "${BLUE}📋 Configuración completada:${NC}"
echo "• Bucket S3: ${BUCKET_NAME}"
echo "• Versionado: Habilitado"
echo "• Cifrado: AES256"
echo "• Acceso público: Bloqueado"
echo "• Backend Terraform: Configurado"
