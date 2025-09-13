#!/usr/bin/env python3
from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.network import ALB, InternetGateway
from diagrams.aws.database import Aurora
from diagrams.aws.ml import Bedrock
from diagrams.aws.compute import Lambda
from diagrams.aws.management import Cloudwatch
from diagrams.onprem.client import Users
from diagrams.onprem.vcs import Github
from diagrams import Cluster, Edge

with Diagram("GenAI DevOps - Arquitectura Detallada", show=False, filename="docs/diagrams/genai-devops-detailed", direction="TB"):
    
    # Usuario externo
    user = Users("Usuario")
    
    # Internet
    internet = InternetGateway("Internet Gateway")
    
    # VPC Principal
    with Cluster("VPC (10.0.0.0/16) - Multi-AZ"):
        
        # Load Balancer
        alb = ALB("Application Load Balancer\n(Público)")
        
        # Auto Scaling Group
        with Cluster("Auto Scaling Group (2-10 instancias)"):
            web1 = EC2("Web Server 1\n(us-east-1a)")
            web2 = EC2("Web Server 2\n(us-east-1b)")
            web3 = EC2("Web Server 3\n(Auto Scale)")
            web_servers = [web1, web2, web3]
        
        # Base de datos
        with Cluster("Aurora Serverless v2 (Privado)"):
            aurora = Aurora("Aurora MySQL Cluster\n(0.5-16 ACUs)")
    
    # DevOps Generativo
    with Cluster("DevOps Generativo - AI Powered"):
        
        # AI Components
        bedrock = Bedrock("Amazon Bedrock\nClaude 3 Sonnet")
        optimizer = Lambda("AI Optimizer Agent\n")
        
        # Monitoring
        cloudwatch = Cloudwatch("CloudWatch\nMetrics & Alertas")
        
        # CI/CD
        github = Github("GitHub Actions\nPipeline Auto-Sanador")
    
    # Conexiones principales
    user >> Edge(label="HTTPS Traffic") >> internet >> alb
    alb >> Edge(label="HTTP (Port 80)") >> web_servers
    web_servers >> Edge(label="MySQL (Port 3306)") >> aurora
    
    # AI y monitoreo
    optimizer >> Edge(label="AI Analysis", color="blue") >> bedrock
    cloudwatch >> Edge(label="Metrics Collection") >> optimizer
    web_servers >> Edge(label="Application Logs") >> cloudwatch
    aurora >> Edge(label="DB Metrics") >> cloudwatch
    alb >> Edge(label="Access Logs") >> cloudwatch
    
    # Pipeline auto-sanador
    github >> Edge(label="Automated Deploy", color="green") >> web_servers
    cloudwatch >> Edge(label="Health Alerts", color="orange") >> github
    optimizer >> Edge(label="Optimization Recommendations", color="purple") >> github

print("✅ Diagrama detallado generado: docs/diagrams/genai-devops-detailed.png")
