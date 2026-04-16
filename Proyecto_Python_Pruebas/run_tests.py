#!/usr/bin/env python
"""
Script para ejecutar la suite de pruebas localmente
Simula lo que hace el pipeline de CI/CD en GitHub Actions
"""
import subprocess
import sys
from pathlib import Path


class Colors:
    """Colores para terminal"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    END = '\033[0m'


def run_command(cmd, description):
    """Ejecuta un comando y reporta el resultado"""
    print(f"\n{Colors.BLUE}{'='*60}{Colors.END}")
    print(f"{Colors.BLUE}▶ {description}{Colors.END}")
    print(f"{Colors.BLUE}{'='*60}{Colors.END}")
    
    result = subprocess.run(cmd, shell=True)
    
    if result.returncode == 0:
        print(f"{Colors.GREEN}✓ {description} - PASSED{Colors.END}")
        return True
    else:
        print(f"{Colors.RED}✗ {description} - FAILED{Colors.END}")
        return False


def main():
    """Ejecuta todas las pruebas y validaciones"""
    print(f"{Colors.BLUE}")
    print("╔════════════════════════════════════════════════════════════╗")
    print("║        Suite de Pruebas - TaskManager Project             ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print(f"{Colors.END}")
    
    results = {}
    
    # Verificar que pytest esté instalado
    result = subprocess.run("pip list | grep pytest", shell=True, capture_output=True)
    if result.returncode != 0:
        print(f"{Colors.YELLOW}Instalando dependencias...{Colors.END}")
        subprocess.run("pip install -r requirements.txt", shell=True)
    
    # 1. Pruebas Unitarias
    results['unit'] = run_command(
        "pytest tests/test_unit_tasks.py -v",
        "Pruebas Unitarias"
    )
    
    # 2. Smoke Tests
    results['smoke'] = run_command(
        "pytest tests/test_smoke_tasks.py -v",
        "Smoke Tests"
    )
    
    # 3. Pruebas de Regresión
    results['regression'] = run_command(
        "pytest tests/test_regression_tasks.py -v",
        "Pruebas de Regresión"
    )
    
    # 4. Pruebas de Performance
    results['performance'] = run_command(
        "pytest tests/test_performance_tasks.py -v",
        "Pruebas de Performance"
    )
    
    # 5. Cobertura
    results['coverage'] = run_command(
        "pytest --cov=src --cov-report=html --cov-report=term-missing -v",
        "Análisis de Cobertura"
    )
    
    # 6. Análisis de código (opcional - no falla el build)
    print(f"\n{Colors.BLUE}{'='*60}{Colors.END}")
    print(f"{Colors.BLUE}▶ Análisis de Código (Informativo){Colors.END}")
    print(f"{Colors.BLUE}{'='*60}{Colors.END}")
    
    subprocess.run("flake8 src/ tests/ --statistics", shell=True)
    
    # Resumen final
    print(f"\n{Colors.BLUE}")
    print("╔════════════════════════════════════════════════════════════╗")
    print("║                      RESUMEN DE RESULTADOS                 ║")
    print("╚════════════════════════════════════════════════════════════╝")
    print(f"{Colors.END}")
    
    all_passed = all(results.values())
    
    for test_type, passed in results.items():
        status = f"{Colors.GREEN}✓ PASSED{Colors.END}" if passed else f"{Colors.RED}✗ FAILED{Colors.END}"
        print(f"  {test_type.upper():.<20} {status}")
    
    # Recomendación de cobertura
    print(f"\n{Colors.YELLOW}📊 Reporte de cobertura disponible en: htmlcov/index.html{Colors.END}")
    print(f"{Colors.YELLOW}   Abre en navegador para ver detalles{Colors.END}")
    
    # Resultado final
    print(f"\n{Colors.BLUE}")
    if all_passed:
        print(f"{Colors.GREEN}{'='*60}{Colors.END}")
        print(f"{Colors.GREEN}✓ TODAS LAS PRUEBAS PASARON CORRECTAMENTE{Colors.END}")
        print(f"{Colors.GREEN}{'='*60}{Colors.END}")
        return 0
    else:
        print(f"{Colors.RED}{'='*60}{Colors.END}")
        print(f"{Colors.RED}✗ ALGUNAS PRUEBAS FALLARON{Colors.END}")
        print(f"{Colors.RED}{'='*60}{Colors.END}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
