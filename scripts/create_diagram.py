#!/usr/bin/env python3
from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.network import ALB
from diagrams.aws.database import Aurora
from diagrams.aws.ml import Bedrock
from diagrams.aws.compute import Lambda
from diagrams.aws.management import Cloudwatch
from diagrams.aws.network import InternetGateway
from diagrams.onprem.client import Users
from diagrams.onprem.vcs import Github
from diagrams import Cluster

with Diagram("GenAI DevOps - Infraestructura Autoconstruida", show=False, filename="docs/diagrams/genai-devops-architecture"):
    
    # Usuario
    user = Users("Usuario")
    
    # Internet Gateway
    igw = InternetGateway("Internet\nGateway")
    
    # Load Balancer
    alb = ALB("Application\nLoad Balancer")
    
    # Auto Scaling Group
    with Cluster("Auto Scaling Group (2-10 instancias)"):
        web_servers = [
            EC2("Web Server 1"),
            EC2("Web Server 2"), 
            EC2("Web Server 3")
        ]
    
    # Base de datos
    with Cluster("Aurora Serverless v2"):
        rds_cluster = Aurora("Aurora MySQL\nCluster")
    
    # AI y DevOps Generativo
    with Cluster("DevOps Generativo"):
        bedrock = Bedrock("Amazon Bedrock\n(Claude 3 Sonnet)")
        optimizer = Lambda("AI Optimizer\nAgent")
        cloudwatch = Cloudwatch("CloudWatch\nMetrics")
    
    # GitHub Actions
    github = Github("GitHub Actions\nPipeline")
    
    # Conexiones principales
    user >> igw >> alb >> web_servers
    web_servers >> rds_cluster
    
    # AI y monitoreo
    optimizer >> bedrock
    cloudwatch >> optimizer
    web_servers >> cloudwatch
    rds_cluster >> cloudwatch
    alb >> cloudwatch
    
    # Pipeline
    github >> web_servers

print("✅ Diagrama generado: docs/diagrams/genai-devops-architecture.png")
