# 🔧 EJEMPLOS DE EJECUCIÓN

## Quick Start (5 minutos)

### 1. Ver el estado de los tests

```bash
cd "c:\Repositorio\Universitaria_de_colombia\PRUEBAS DE SOFTWARE\clase_17"
python -m pytest taller_pd_pruebas_software.py -v
```

**Resultado esperado:**
```
30 passed in 0.43s ✅
```

---

## Ejemplos Interactivos

### Ejemplo 1: Comparar Fibonacci (Memoización vs Ingenua)

```python
from taller_pd_pruebas_software import fibonacci, fibonacci_tabular, fibonacci_ingenua
import time

# Caso: Calcular F(35)
n = 35

# Método 1: Fibonacci ingenua (lenta)
print("Método 1: Recursión ingenua")
inicio = time.time()
resultado_ingenua = fibonacci_ingenua(n)
tiempo_ingenua = time.time() - inicio
print(f"  F({n}) = {resultado_ingenua}")
print(f"  Tiempo: {tiempo_ingenua:.4f} segundos")

# Método 2: Fibonacci con memoización
print("\nMétodo 2: Memoización")
inicio = time.time()
resultado_memo = fibonacci(n)
tiempo_memo = time.time() - inicio
print(f"  F({n}) = {resultado_memo}")
print(f"  Tiempo: {tiempo_memo:.6f} segundos")

# Método 3: Fibonacci tabular
print("\nMétodo 3: Tabulación (bottom-up)")
inicio = time.time()
resultado_tabular = fibonacci_tabular(n)
tiempo_tabular = time.time() - inicio
print(f"  F({n}) = {resultado_tabular}")
print(f"  Tiempo: {tiempo_tabular:.6f} segundos")

# Comparación
print("\n" + "="*50)
print("COMPARACIÓN DE RENDIMIENTO")
print("="*50)
speedup = tiempo_ingenua / tiempo_memo
print(f"Speedup (Ingenua vs Memoización): {speedup:.0f}x")
print(f"Speedup (Ingenua vs Tabular):     {tiempo_ingenua / tiempo_tabular:.0f}x")
print(f"\n✅ Todos dan el mismo resultado: {resultado_ingenua == resultado_memo == resultado_tabular}")
```

**Output esperado:**
```
Método 1: Recursión ingenua
  F(35) = 9227465
  Tiempo: 2.5832 segundos

Método 2: Memoización
  F(35) = 9227465
  Tiempo: 0.000023 segundos

Método 3: Tabulación (bottom-up)
  F(35) = 9227465
  Tiempo: 0.000015 segundos

==================================================
COMPARACIÓN DE RENDIMIENTO
==================================================
Speedup (Ingenua vs Memoización): 112301x
Speedup (Ingenua vs Tabular):     172213x

✅ Todos dan el mismo resultado: True
```

---

### Ejemplo 2: Priorización de Regresión (Mochila 0/1)

```python
from taller_pd_pruebas_software import caso_integrador_priorizar_regresion

# Ejecutar caso integrador
resultado = caso_integrador_priorizar_regresion()

# Mostrar resultados
print("PRIORIZACIÓN DE SUITE DE REGRESIÓN")
print("="*60)
print(f"\nPresupuesto disponible: {resultado['horas_disponibles']} horas")
print(f"Horas usadas: {resultado['total_horas_usadas']}")
print(f"Horas restantes: {resultado['horas_restantes']}")
print(f"\nCobertura total: {resultado['valor_total_cobertura']} puntos")
print(f"Eficiencia: {resultado['eficiencia']:.2f} puntos por hora")

print(f"\nPruebas a EJECUTAR ({len(resultado['pruebas_a_ejecutar'])} casos):")
for i, prueba in enumerate(resultado['pruebas_a_ejecutar'], 1):
    print(f"  {i}. {prueba}")
```

**Output esperado:**
```
PRIORIZACIÓN DE SUITE DE REGRESIÓN
============================================================

Presupuesto disponible: 40 horas
Horas usadas: 38
Horas restantes: 2

Cobertura total: 54 puntos
Eficiencia: 1.42 puntos por hora

Pruebas a EJECUTAR (5 casos):
  1. Fraude múltiples intentos
  2. Encriptación de datos
  3. Autorización tarjeta
  4. Timeout y reintentos
  5. Devolución de pago
```

---

### Ejemplo 3: Resolver Mochila 0/1 Manualmente

```python
from taller_pd_pruebas_software import mochila_01

# Problema: 4 items con pesos y valores
pesos = [2, 3, 4, 5]
valores = [3, 4, 5, 6]
capacidad = 5

print("PROBLEMA DE MOCHILA 0/1")
print("="*50)
print(f"\nItems disponibles:")
print(f"  {'Item':<8} {'Peso':<8} {'Valor':<8} {'Ratio':<8}")
print(f"  {'-'*32}")
for i, (p, v) in enumerate(zip(pesos, valores)):
    print(f"  {i:<8} {p:<8} {v:<8} {v/p:<8.2f}")

print(f"\nCapacidad de la mochila: {capacidad} kg")

# Resolver con mochila 0/1
valor_max, indices = mochila_01(pesos, valores, capacidad)

print(f"\n{'SOLUCIÓN ÓPTIMA'}")
print(f"{'='*50}")
print(f"Items elegidos: {indices}")
print(f"\nDetalles:")
for i in indices:
    print(f"  Item {i}: peso={pesos[i]}, valor={valores[i]}")

print(f"\nResultado:")
peso_total = sum(pesos[i] for i in indices)
valor_total = sum(valores[i] for i in indices)
print(f"  Peso total: {peso_total} kg (límite: {capacidad} kg)")
print(f"  Valor total: {valor_total} puntos")
print(f"  Eficiencia: {valor_total/peso_total:.2f} puntos/kg")
```

**Output esperado:**
```
PROBLEMA DE MOCHILA 0/1
==================================================

Items disponibles:
  Item     Peso     Valor    Ratio   
  --------------------------------
  0        2        3        1.50   
  1        3        4        1.33   
  2        4        5        1.25   
  3        5        6        1.20   

Capacidad de la mochila: 5 kg

SOLUCIÓN ÓPTIMA
==================================================
Items elegidos: [0, 1]

Detalles:
  Item 0: peso=2, valor=3
  Item 1: peso=3, valor=4

Resultado:
  Peso total: 5 kg (límite: 5 kg)
  Valor total: 7 puntos
  Eficiencia: 1.40 puntos/kg
```

---

### Ejemplo 4: Análisis Multi-Suite

```python
from taller_pd_pruebas_software import caso_integrador_multisuite

estrategias = caso_integrador_multisuite()

print("ANÁLISIS DE ESTRATEGIAS DE TESTING")
print("="*70)

for nombre_est, suites in estrategias.items():
    print(f"\n{nombre_est}")
    print("-"*70)
    
    total_valor = 0
    total_horas = 0
    
    for suite_nombre, resultado in suites.items():
        print(f"\n  {suite_nombre.upper()}")
        print(f"    Cobertura: {resultado['valor']} puntos")
        print(f"    Horas: {resultado['horas']}")
        print(f"    Casos: {len(resultado['casos'])}")
        
        total_valor += resultado['valor']
        total_horas += resultado['horas']
    
    eficiencia = total_valor / total_horas if total_horas > 0 else 0
    print(f"\n  TOTALES:")
    print(f"    Cobertura total: {total_valor} puntos")
    print(f"    Horas totales: {total_horas} horas")
    print(f"    Eficiencia: {eficiencia:.2f} puntos/hora")
```

**Output esperado:**
```
ANÁLISIS DE ESTRATEGIAS DE TESTING
======================================================================

Equitativa (15-15-15)
----------------------------------------------------------------------

  UNITARIA
    Cobertura: 28 puntos
    Horas: 15
    Casos: 4

  INTEGRACION
    Cobertura: 20 puntos
    Horas: 15
    Casos: 3

  E2E
    Cobertura: 12 puntos
    Horas: 15
    Casos: 2

  TOTALES:
    Cobertura total: 60 puntos
    Horas totales: 45 horas
    Eficiencia: 1.33 puntos/hora

...

Prioritaria (25-12-8)
----------------------------------------------------------------------

  UNITARIA
    Cobertura: 37 puntos
    Horas: 25
    Casos: 6

  INTEGRACION
    Cobertura: 15 puntos
    Horas: 12
    Casos: 2

  E2E
    Cobertura: 7 puntos
    Horas: 8
    Casos: 1

  TOTALES:
    Cobertura total: 59 puntos
    Horas totales: 45 horas
    Eficiencia: 1.31 puntos/hora

...
```

---

## Ejecución de Tests Específicos

### Ejecutar solo tests de Fibonacci

```bash
pytest taller_pd_pruebas_software.py::TestFibonacci -v
```

**Output:**
```
TestFibonacci::test_fibonacci_casos_base PASSED
TestFibonacci::test_fibonacci_valores_pequenos PASSED
TestFibonacci::test_fibonacci_valor_grande PASSED
TestFibonacci::test_fibonacci_recurrencia PASSED
TestFibonacci::test_fibonacci_n_negativo_error PASSED
TestFibonacci::test_fibonacci_cache_invalida_para_diferentes_valores PASSED
TestFibonacci::test_fibonacci_tabular_equivalencia PASSED
TestFibonacci::test_fibonacci_ingenua_pequeno PASSED
TestFibonacci::test_fibonacci_tabular_espacio_constante PASSED
TestFibonacci::test_fibonacci_monotonicidad PASSED
TestFibonacci::test_fibonacci_vs_ingenua_rendimiento PASSED

11 passed in 0.15s ✅
```

### Ejecutar solo tests de Mochila

```bash
pytest taller_pd_pruebas_software.py::TestMochila01 -v
```

**Output:**
```
TestMochila01::test_mochila_basico PASSED
TestMochila01::test_mochila_capacidad_cero PASSED
TestMochila01::test_mochila_lista_vacia PASSED
TestMochila01::test_mochila_un_item_cabe PASSED
TestMochila01::test_mochila_un_item_no_cabe PASSED
TestMochila01::test_mochila_todos_caben PASSED
TestMochila01::test_mochila_ningun_item_cabe PASSED
TestMochila01::test_mochila_pesos_valores_distintos_tamanos PASSED
TestMochila01::test_mochila_reconstruccion_valida PASSED
TestMochila01::test_mochila_optimalidad_pequenas_cases PASSED
TestMochila01::test_mochila_caso_integrador_pagos PASSED

11 passed in 0.12s ✅
```

### Ejecutar con más detalle

```bash
pytest taller_pd_pruebas_software.py::TestMochila01::test_mochila_basico -vv
```

**Output:**
```
taller_pd_pruebas_software.py::TestMochila01::test_mochila_basico PASSED [100%]

def test_mochila_basico(self):
    """
    Caso básico: 4 items con capacidad 5.
    
    Items:      peso  valor
      0           2      3
      1           3      4
      2           4      5
      3           5      6
    
    Óptimo: Items 0 + 1 (peso total 5, valor total 7).
    """
    pesos = [2, 3, 4, 5]
    valores = [3, 4, 5, 6]
    W = 5
    
    valor_max, elegidos = mochila_01(pesos, valores, W)
    assert valor_max == 7
    
    # Validar que los elegidos caben
    peso_total = sum(pesos[i] for i in elegidos)
    assert peso_total <= W
    
    # Validar que el valor coincide
    valor_total = sum(valores[i] for i in elegidos)
    assert valor_total == valor_max
```

---

## Script de Automatización

### Archivo: `run_analysis.py`

```python
#!/usr/bin/env python
"""Script para ejecutar análisis completo del taller."""

from taller_pd_pruebas_software import (
    fibonacci, fibonacci_tabular, comparar_fibonacci_rendimiento,
    mochila_01, caso_integrador_priorizar_regresion,
    caso_integrador_multisuite
)
import time

def main():
    print("\n" + "="*70)
    print("TALLER: PROGRAMACIÓN DINÁMICA EN PRUEBAS DE SOFTWARE")
    print("="*70)
    
    # 1. Benchmarking Fibonacci
    print("\n1️⃣  BENCHMARKING FIBONACCI")
    print("-"*70)
    for n in [30, 35, 40]:
        print(f"\nn = {n}")
        resultados = comparar_fibonacci_rendimiento(n)
        print(f"  Tabular:   {resultados['tabular']:.6f}s")
        print(f"  Memoizado: {resultados['memoizado']:.6f}s")
        if 'ingenua' in resultados:
            speedup = resultados['ingenua'] / resultados['memoizado']
            print(f"  Ingenua:   {resultados['ingenua']:.6f}s → {speedup:.0f}x speedup")
    
    # 2. Mochila Básica
    print("\n\n2️⃣  EJEMPLO MOCHILA 0/1")
    print("-"*70)
    pesos = [2, 3, 4, 5]
    valores = [3, 4, 5, 6]
    valor, elegidos = mochila_01(pesos, valores, 5)
    print(f"Items elegidos: {elegidos}")
    print(f"Valor máximo: {valor}")
    
    # 3. Caso Integrador 1
    print("\n\n3️⃣  CASO INTEGRADOR: PRIORIZACIÓN DE REGRESIÓN")
    print("-"*70)
    resultado = caso_integrador_priorizar_regresion()
    print(f"Cobertura: {resultado['valor_total_cobertura']} puntos")
    print(f"Pruebas: {len(resultado['pruebas_a_ejecutar'])} casos")
    print(f"Eficiencia: {resultado['eficiencia']:.2f} puntos/hora")
    
    # 4. Caso Integrador 2
    print("\n\n4️⃣  CASO INTEGRADOR: MULTI-SUITE")
    print("-"*70)
    estrategias = caso_integrador_multisuite()
    for nombre, suites in estrategias.items():
        total = sum(s['valor'] for s in suites.values())
        horas = sum(s['horas'] for s in suites.values())
        print(f"{nombre:<30} {total:>3} pts, {horas:>2} hrs → {total/horas:.2f} pts/hr")
    
    print("\n" + "="*70)
    print("✅ ANÁLISIS COMPLETADO")
    print("="*70 + "\n")

if __name__ == "__main__":
    main()
```

**Ejecutar:**
```bash
python run_analysis.py
```

---

## Troubleshooting

### Error: "ModuleNotFoundError: No module named 'pytest'"

```bash
pip install pytest
```

### Error: "RecursionError"

Probablemente olvidaste `@lru_cache`:
```python
# ❌ Mal
def fibonacci(n):
    if n < 2: return n
    return fibonacci(n-1) + fibonacci(n-2)  # ¡Exponencial!

# ✅ Correcto
@lru_cache(maxsize=None)
def fibonacci(n):
    if n < 2: return n
    return fibonacci(n-1) + fibonacci(n-2)  # O(n) con caché
```

### Error: "Test is too slow"

Puede ser que estés usando la versión ingenua. Verifica que implementaste memoización:

```bash
# Esto debería ser rápido (<100ms)
pytest taller_pd_pruebas_software.py::TestFibonacci::test_fibonacci_valor_grande -v
```

---

## Próximos Pasos

1. ✅ Ejecuta los tests: `pytest taller_pd_pruebas_software.py -v`
2. ✅ Lee README.md para entender los conceptos
3. ✅ Implementa los ejercicios en EJERCICIOS_PROPUESTOS.md
4. ✅ Experimenta con los ejemplos de este archivo
5. ✅ Intenta los desafíos bonus

---

**¡Éxito en el taller!** 🚀
