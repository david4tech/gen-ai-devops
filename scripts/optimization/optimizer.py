#!/usr/bin/env python3
"""
Demo 3: Agente Autónomo de Optimización de Infraestructura
Utiliza Amazon Bedrock para analizar y optimizar recursos AWS automáticamente
"""

import boto3
import json
import time
from datetime import datetime, timedelta
from typing import Dict, List, Any

class InfrastructureOptimizer:
    def __init__(self, region='us-east-1'):
        self.bedrock = boto3.client('bedrock-runtime', region_name=region)
        self.cloudwatch = boto3.client('cloudwatch', region_name=region)
        self.ec2 = boto3.client('ec2', region_name=region)
        self.rds = boto3.client('rds', region_name=region)
        self.model_id = 'anthropic.claude-3-sonnet-20240229-v1:0'
    
    def get_resource_metrics(self) -> Dict[str, Any]:
        """Recolecta métricas de recursos AWS"""
        end_time = datetime.utcnow()
        start_time = end_time - timedelta(hours=1)
        
        metrics = {
            'ec2_cpu_utilization': self._get_ec2_metrics(start_time, end_time),
            'rds_connections': self._get_rds_metrics(start_time, end_time),
            'alb_response_time': self._get_alb_metrics(start_time, end_time),
            'cost_data': self._get_cost_data()
        }
        
        return metrics
    
    def _get_ec2_metrics(self, start_time, end_time) -> List[Dict]:
        """Obtiene métricas de CPU de instancias EC2"""
        try:
            response = self.cloudwatch.get_metric_statistics(
                Namespace='AWS/EC2',
                MetricName='CPUUtilization',
                StartTime=start_time,
                EndTime=end_time,
                Period=300,
                Statistics=['Average', 'Maximum']
            )
            return response.get('Datapoints', [])
        except Exception as e:
            print(f"Error obteniendo métricas EC2: {e}")
            return []
    
    def _get_rds_metrics(self, start_time, end_time) -> List[Dict]:
        """Obtiene métricas de conexiones RDS"""
        try:
            response = self.cloudwatch.get_metric_statistics(
                Namespace='AWS/RDS',
                MetricName='DatabaseConnections',
                StartTime=start_time,
                EndTime=end_time,
                Period=300,
                Statistics=['Average', 'Maximum']
            )
            return response.get('Datapoints', [])
        except Exception as e:
            print(f"Error obteniendo métricas RDS: {e}")
            return []
    
    def _get_alb_metrics(self, start_time, end_time) -> List[Dict]:
        """Obtiene métricas de tiempo de respuesta del ALB"""
        try:
            response = self.cloudwatch.get_metric_statistics(
                Namespace='AWS/ApplicationELB',
                MetricName='TargetResponseTime',
                StartTime=start_time,
                EndTime=end_time,
                Period=300,
                Statistics=['Average']
            )
            return response.get('Datapoints', [])
        except Exception as e:
            print(f"Error obteniendo métricas ALB: {e}")
            return []
    
    def _get_cost_data(self) -> Dict:
        """Simula datos de costos (en producción usar Cost Explorer API)"""
        return {
            'daily_cost': 45.67,
            'monthly_projection': 1370.10,
            'top_services': ['EC2', 'RDS', 'ALB']
        }
    
    def analyze_with_ai(self, metrics: Dict[str, Any]) -> Dict[str, Any]:
        """Utiliza Bedrock para analizar métricas y generar recomendaciones"""
        
        prompt = f"""
        Analiza estas métricas de infraestructura AWS y proporciona recomendaciones de optimización:

        Métricas:
        {json.dumps(metrics, indent=2, default=str)}

        Proporciona tu análisis en formato JSON con esta estructura:
        {{
            "analysis_summary": "Resumen del análisis",
            "performance_issues": ["lista de problemas de rendimiento"],
            "cost_optimization": ["oportunidades de ahorro"],
            "scaling_recommendations": ["recomendaciones de escalado"],
            "security_improvements": ["mejoras de seguridad"],
            "priority_actions": [
                {{
                    "action": "descripción de la acción",
                    "impact": "alto/medio/bajo",
                    "estimated_savings": "porcentaje o monto",
                    "terraform_code": "código terraform para implementar"
                }}
            ]
        }}
        """
        
        try:
            body = {
                "anthropic_version": "bedrock-2023-05-31",
                "max_tokens": 3000,
                "messages": [
                    {
                        "role": "user",
                        "content": prompt
                    }
                ]
            }
            
            response = self.bedrock.invoke_model(
                modelId=self.model_id,
                body=json.dumps(body)
            )
            
            response_body = json.loads(response['body'].read())
            ai_analysis = json.loads(response_body['content'][0]['text'])
            
            return ai_analysis
            
        except Exception as e:
            print(f"Error en análisis con IA: {e}")
            return {"error": str(e)}
    
    def apply_optimizations(self, recommendations: Dict[str, Any]) -> Dict[str, Any]:
        """Aplica automáticamente las optimizaciones recomendadas"""
        
        results = {
            "applied_changes": [],
            "skipped_changes": [],
            "errors": []
        }
        
        for action in recommendations.get('priority_actions', []):
            if action.get('impact') == 'alto':
                try:
                    # En un entorno real, aquí se aplicarían los cambios
                    # Por ahora, simulamos la aplicación
                    
                    print(f"🔧 Aplicando: {action['action']}")
                    
                    # Simular aplicación de cambio
                    time.sleep(1)
                    
                    results["applied_changes"].append({
                        "action": action['action'],
                        "status": "success",
                        "timestamp": datetime.utcnow().isoformat()
                    })
                    
                except Exception as e:
                    results["errors"].append({
                        "action": action['action'],
                        "error": str(e)
                    })
            else:
                results["skipped_changes"].append({
                    "action": action['action'],
                    "reason": "Impacto no crítico - requiere aprobación manual"
                })
        
        return results
    
    def run_optimization_cycle(self):
        """Ejecuta un ciclo completo de optimización"""
        
        print("🚀 Iniciando ciclo de optimización automática...")
        
        # 1. Recolectar métricas
        print("📊 Recolectando métricas...")
        metrics = self.get_resource_metrics()
        
        # 2. Análisis con IA
        print("🤖 Analizando con IA...")
        analysis = self.analyze_with_ai(metrics)
        
        if "error" in analysis:
            print(f"❌ Error en análisis: {analysis['error']}")
            return
        
        # 3. Mostrar recomendaciones
        print("\n📋 Recomendaciones de optimización:")
        print(f"Resumen: {analysis.get('analysis_summary', 'N/A')}")
        
        for action in analysis.get('priority_actions', []):
            print(f"  • {action['action']} (Impacto: {action['impact']})")
            if action.get('estimated_savings'):
                print(f"    💰 Ahorro estimado: {action['estimated_savings']}")
        
        # 4. Aplicar optimizaciones automáticas
        print("\n🔧 Aplicando optimizaciones...")
        results = self.apply_optimizations(analysis)
        
        # 5. Reporte final
        print(f"\n✅ Optimización completada:")
        print(f"  • Cambios aplicados: {len(results['applied_changes'])}")
        print(f"  • Cambios omitidos: {len(results['skipped_changes'])}")
        print(f"  • Errores: {len(results['errors'])}")
        
        return {
            "metrics": metrics,
            "analysis": analysis,
            "results": results
        }

def main():
    """Función principal para demostración"""
    
    print("🎯 Demo: Agente Autónomo de Optimización")
    print("=" * 50)
    
    optimizer = InfrastructureOptimizer()
    
    # Ejecutar ciclo de optimización
    cycle_result = optimizer.run_optimization_cycle()
    
    # Guardar resultados para análisis posterior
    with open('optimization_results.json', 'w') as f:
        json.dump(cycle_result, f, indent=2, default=str)
    
    print(f"\n📄 Resultados guardados en: optimization_results.json")

if __name__ == "__main__":
    main()
