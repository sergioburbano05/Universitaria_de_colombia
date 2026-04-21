"""
Guia Rapida de Uso - Ejercicios Resueltos Sesion 12
Testing Dinamico · Mutation Testing · Property-Based Testing

Para usar este proyecto:

1. INSTALACION
   ============
   cd C:\Repositorio\Universitaria_de_colombia\python
   pip install -r requirements.txt

2. EJECUTAR TODOS LOS TESTS
   ==========================
   pytest

   Con detalle:
   pytest -v

3. EJECUTAR POR EJERCICIO (con cobertura individual)
   ===================================================
   # Ejercicio 1: Clases de Equivalencia y BVA
   pytest tests/test_ejercicio_1.py --cov=src.ejercicio_1 --cov-report=term-missing -v

   # Ejercicio 2: Branch Coverage 100%
   pytest tests/test_ejercicio_2.py --cov=src.ejercicio_2 --cov-report=term-missing -v

   # Ejercicio 3: Mutation Testing
   pytest tests/test_ejercicio_3.py --cov=src.ejercicio_3 --cov-report=term-missing -v

   # Ejercicio 4: Property-Based Testing (Hypothesis)
   pytest tests/test_ejercicio_4.py --cov=src.ejercicio_4 --cov-report=term-missing -v

4. COBERTURA COMPLETA
   ===================
   pytest --cov=src --cov-report=html
   # Abre: htmlcov/index.html

5. USAR LAS FUNCIONES EN PYTHON
   =============================
   from src.ejercicio_1 import calcular_descuento
   print(calcular_descuento(15, True))   # 10
   print(calcular_descuento(70, False))  # 25
   print(calcular_descuento(-5, True))   # 'ERROR'

   from src.ejercicio_2 import validar_matricula
   from src.ejercicio_3 import promedio_ponderado
   from src.ejercicio_4 import revertir, es_palindromo, concatenar_lista

Estructura del Proyecto:
========================
python/
├── src/
│   ├── __init__.py
│   ├── ejercicio_1.py    # calcular_descuento
│   ├── ejercicio_2.py    # validar_matricula
│   ├── ejercicio_3.py    # promedio_ponderado
│   └── ejercicio_4.py    # revertir, es_palindromo, concatenar_lista
├── tests/
│   ├── test_ejercicio_1.py    # 14 tests  - EP + BVA
│   ├── test_ejercicio_2.py    # 16 tests  - Branch Coverage
│   ├── test_ejercicio_3.py    #  5 tests  - Mutation Testing
│   └── test_ejercicio_4.py    #  3 tests  - Property-Based Testing
├── requirements.txt
├── pytest.ini
├── conftest.py
└── README.md

Total: 38 tests · 100% pasando
"""

if __name__ == "__main__":
    print(__doc__)
