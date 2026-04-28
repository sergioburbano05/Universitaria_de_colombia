# 🎯 EJERCICIOS PROPUESTOS PARA EL TALLER

## Nivel 1: Implementación Básica

### Ejercicio 1.1: Fibonacci con Memoización
**Dificultad:** ⭐ Fácil

Implementa `fibonacci(n)` usando decorador `@lru_cache`.

**Requerimientos:**
- Debe manejar n=0 y n=1 como casos base
- Debe lanzar `ValueError` si n < 0
- Debe funcionar para n hasta 50 (sin timeout)

**Validación:**
```bash
pytest taller_pd_pruebas_software.py::TestFibonacci::test_fibonacci_valor_grande -v
# Esperado: PASSED (F(50) = 12586269025)
```

---

### Ejercicio 1.2: Fibonacci Tabular (Bottom-Up)
**Dificultad:** ⭐ Fácil

Implementa `fibonacci_tabular(n)` usando iteración sin recursión.

**Requerimientos:**
- Usar un bucle `for` en lugar de recursión
- Complejidad: O(n) tiempo, O(1) espacio
- Debe producir exactamente el mismo resultado que `fibonacci(n)`

**Validación:**
```bash
pytest taller_pd_pruebas_software.py::TestFibonacciTabular -v
# Esperado: 3 tests PASSED
```

**Pista:**
```python
def fibonacci_tabular(n: int) -> int:
    if n < 2:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
```

---

### Ejercicio 2.1: Mochila 0/1 Básica
**Dificultad:** ⭐ Medio

Implementa `mochila_01(pesos, valores, W)` que retorne el **valor máximo**.

**Requerimientos:**
- Llenar tabla DP de dimensión (n+1) × (W+1)
- Para cada item, decidir: ¿incluir o no?
- Retornar el valor máximo

**Validación:**
```python
>>> mochila_01([2, 3, 4, 5], [3, 4, 5, 6], 5)
# Esperado: (7, [...])  # Valor máximo = 7
```

**Tabla esperada:**
```
     0  1  2  3  4  5
   +--+--+--+--+--+--+
 0 | 0| 0| 0| 0| 0| 0|
   +--+--+--+--+--+--+
 1 | 0| 0| 3| 3| 3| 3|  (item peso=2, valor=3)
   +--+--+--+--+--+--+
 2 | 0| 0| 3| 4| 4| 7|  (item peso=3, valor=4)
   +--+--+--+--+--+--+
```

---

### Ejercicio 2.2: Mochila 0/1 con Reconstrucción
**Dificultad:** ⭐⭐ Medio-Difícil

Completa `mochila_01()` para retornar no solo el valor, sino también **QUÉ items elegir**.

**Requerimientos:**
- Retornar tupla: `(valor_max, indices_elegidos)`
- `indices_elegidos` = lista de índices (0-indexados) de items incluidos
- La suma de pesos de items elegidos ≤ W
- La suma de valores de items elegidos = valor_max

**Validación:**
```python
>>> valor, elegidos = mochila_01([2, 3, 4, 5], [3, 4, 5, 6], 5)
>>> print(valor)
7
>>> print(elegidos)
[0, 1]  # Items 0 y 1 → pesos (2,3) = 5, valores (3,4) = 7
```

**Algoritmo de reconstrucción (backtrack):**
```
1. Empezar en dp[n][W]
2. Para cada item i (de n hacia 1):
   - Si dp[i][w] != dp[i-1][w], entonces item i-1 está incluido
   - Restar el peso: w -= pesos[i-1]
3. Invertir la lista de elegidos (porque se construyó hacia atrás)
```

**Validación:**
```bash
pytest taller_pd_pruebas_software.py::TestMochila01::test_mochila_reconstruccion_valida -v
# Esperado: PASSED
```

---

## Nivel 2: Optimización y Análisis

### Ejercicio 3.1: Mochila Space-Optimized
**Dificultad:** ⭐⭐⭐ Difícil

Implementa `mochila_01_space_optimized(pesos, valores, W)` usando O(W) espacio en lugar de O(n×W).

**Requerimientos:**
- En lugar de tabla de (n+1) × (W+1), usar solo dos filas: `prev` y `curr`
- Mismo resultado que versión estándar (mismo valor máximo)
- Complejidad: O(n×W) tiempo, O(W) espacio

**Validación:**
```bash
pytest taller_pd_pruebas_software.py::TestMochilaSpaceOptimized -v
# Esperado: 2 tests PASSED
```

**Algoritmo:**
```python
def mochila_01_space_optimized(pesos, valores, W):
    prev = [0] * (W + 1)
    curr = [0] * (W + 1)
    
    for i in range(len(pesos)):
        for w in range(W + 1):
            curr[w] = prev[w]  # No incluir
            if pesos[i] <= w:
                cand = prev[w - pesos[i]] + valores[i]
                if cand > curr[w]:
                    curr[w] = cand
        prev, curr = curr, prev
    
    return prev[W], []  # Reconstrucción es más compleja aquí
```

**Nota:** Reconstrucción con versión space-optimized es más complicada (requiere guardar decisiones aparte).

---

### Ejercicio 3.2: Análisis de Rendimiento
**Dificultad:** ⭐⭐ Medio-Difícil

Usa `comparar_fibonacci_rendimiento(n)` para analizar tiempos reales.

**Tarea:**
1. Ejecuta para n = 30, 35, 40
2. Tabula los resultados
3. Calcula el **speedup** (tiempo_ingenua / tiempo_memo)
4. ¿Cuándo se vuelve imposible usar ingenua?

**Código:**
```python
from taller_pd_pruebas_software import comparar_fibonacci_rendimiento

for n in [30, 35, 40]:
    resultados = comparar_fibonacci_rendimiento(n)
    print(f"\nn = {n}")
    print(f"  Tabular:   {resultados['tabular']:.6f} s")
    print(f"  Memoizado: {resultados['memoizado']:.6f} s")
    if 'ingenua' in resultados:
        print(f"  Ingenua:   {resultados['ingenua']:.6f} s")
        speedup = resultados['ingenua'] / resultados['memoizado']
        print(f"  Speedup:   {speedup:.0f}x")
```

**Resultado esperado:**
```
n = 30
  Tabular:   0.000001 s
  Memoizado: 0.000002 s
  Ingenua:   0.250000 s
  Speedup:   125000x

n = 35
  Tabular:   0.000002 s
  Memoizado: 0.000003 s
  Ingenua:   2.500000 s
  Speedup:   833333x

n = 40
  Tabular:   0.000003 s
  Memoizado: 0.000005 s
  (Ingenua: ¡TIMEOUT! > 30 segundos)
```

---

### Ejercicio 3.3: Validación de Optimalidad
**Dificultad:** ⭐⭐⭐ Difícil

Para instancias pequeñas, verifica que la solución de mochila es óptima comparando contra fuerza bruta.

**Código:**
```python
def validar_mochila_optimo(pesos, valores, W):
    """Verificar que mochila_01 es óptimo por comparación exhaustiva."""
    valor_opt, elegidos_opt = mochila_01(pesos, valores, W)
    
    # Fuerza bruta: probar todos los 2^n subconjuntos
    n = len(pesos)
    valor_max_esperado = 0
    mejor_subconjunto = None
    
    for mask in range(1 << n):
        peso_total = 0
        valor_total = 0
        subconjunto = []
        
        for i in range(n):
            if mask & (1 << i):
                peso_total += pesos[i]
                valor_total += valores[i]
                subconjunto.append(i)
        
        if peso_total <= W and valor_total > valor_max_esperado:
            valor_max_esperado = valor_total
            mejor_subconjunto = subconjunto
    
    assert valor_opt == valor_max_esperado, \
        f"Mochila retornó {valor_opt}, pero óptimo es {valor_max_esperado}"
    assert elegidos_opt == mejor_subconjunto or \
           sum(valores[i] for i in elegidos_opt) == sum(valores[i] for i in mejor_subconjunto)
    
    return True

# Ejecutar
validar_mochila_optimo([2, 3, 4, 5], [3, 4, 5, 6], 5)
print("✅ Mochila es óptima!")
```

---

## Nivel 3: Aplicación a Casos Reales

### Ejercicio 4.1: Priorización Real de Testing
**Dificultad:** ⭐⭐⭐ Difícil

Dados estos casos de prueba reales de tu proyecto, ejecuta `caso_integrador_priorizar_regresion()` e interpreta los resultados.

**Tareas:**
1. ¿Cuántos casos se pueden ejecutar en 40 horas?
2. ¿Cuál es el valor de cobertura total?
3. ¿Qué casos son los "más valiosos por hora" (eficiencia)?
4. Si tienes 50 horas en lugar de 40, ¿cambia la selección?

**Código:**
```python
from taller_pd_pruebas_software import caso_integrador_priorizar_regresion

resultado = caso_integrador_priorizar_regresion()

print(f"Cobertura total: {resultado['valor_total_cobertura']}")
print(f"Horas usadas: {resultado['total_horas_usadas']}")
print(f"Eficiencia: {resultado['eficiencia']:.2f} puntos/hora")
print(f"\nPruebas a ejecutar:")
for prueba in resultado['pruebas_a_ejecutar']:
    print(f"  - {prueba}")
print(f"\nHoras restantes: {resultado['horas_restantes']}")
```

---

### Ejercicio 4.2: Análisis Multi-Suite
**Dificultad:** ⭐⭐⭐⭐ Muy Difícil

Ejecuta `caso_integrador_multisuite()` y compara las 3 estrategias.

**Tareas:**
1. ¿Cuál estrategia tiene mayor cobertura total?
2. ¿Cuál es más eficiente (valor/hora)?
3. ¿Cuál priorizarías y por qué?
4. Propón una **4ª estrategia** alternativa

**Código:**
```python
from taller_pd_pruebas_software import caso_integrador_multisuite

estrategias = caso_integrador_multisuite()

print("ANÁLISIS DE ESTRATEGIAS DE TESTING\n")
print("="*60)

for nombre, suites in estrategias.items():
    print(f"\n{nombre}:")
    print(f"  Unitaria:    {suites['unitaria']['valor']} puntos")
    print(f"               ({suites['unitaria']['horas']} horas, "
          f"{len(suites['unitaria']['casos'])} casos)")
    print(f"  Integración: {suites['integracion']['valor']} puntos")
    print(f"               ({suites['integracion']['horas']} horas, "
          f"{len(suites['integracion']['casos'])} casos)")
    print(f"  E2E:         {suites['e2e']['valor']} puntos")
    print(f"               ({suites['e2e']['horas']} horas, "
          f"{len(suites['e2e']['casos'])} casos)")
    
    valor_total = (suites['unitaria']['valor'] + 
                   suites['integracion']['valor'] + 
                   suites['e2e']['valor'])
    horas_total = (suites['unitaria']['horas'] + 
                   suites['integracion']['horas'] + 
                   suites['e2e']['horas'])
    
    print(f"  TOTAL:       {valor_total} puntos, {horas_total} horas")
    print(f"  EFICIENCIA:  {valor_total/horas_total:.2f} puntos/hora")
```

---

### Ejercicio 4.3: Estrategia Propia
**Dificultad:** ⭐⭐⭐⭐⭐ Desafío

Propón una **distribución personalizada** de 45 horas entre unitaria, integración y E2E **diferente** a las 3 predefinidas.

**Requerimientos:**
1. Distribuir exactamente 45 horas
2. Usar `mochila_01()` por cada suite
3. Calcular valor total y eficiencia
4. Justificar por escrito: ¿Por qué crees que tu estrategia es mejor?

**Estructura:**
```python
def mi_estrategia_personalizada():
    """Mi estrategia propia."""
    # Define tus suite (reutiliza del caso integrador)
    suite_unit = {...}
    suite_integ = {...}
    suite_e2e = {...}
    
    # Distribución personalizada
    horas_unit = 18      # Ajusta
    horas_integ = 18     # Ajusta
    horas_e2e = 9        # Ajusta
    
    # Resolver cada suite
    val1, casos1 = mochila_01([h for h, _ in suite_unit.values()], 
                              [v for _, v in suite_unit.values()], 
                              horas_unit)
    # ... similar para integ y e2e
    
    # Calcular eficiencia
    valor_total = val1 + val2 + val3
    eficiencia = valor_total / 45
    
    print(f"Mi estrategia: {valor_total} puntos, {eficiencia:.2f} puntos/hora")
    return valor_total, eficiencia

mi_estrategia_personalizada()
```

---

## Desafíos Bonus

### Bonus 1: Fibonacci Matrix Exponentiation ⭐⭐⭐⭐
**Calcular F(n) en O(log n) usando exponenciación de matrices**

```python
def fibonacci_matrix_exp(n: int) -> int:
    """
    F(n) = [[1,1],[1,0]]^n * [1, 0]
    
    Usar fast matrix exponentiation para O(log n).
    """
    # TODO: Implementar
    pass

# Valida que:
assert fibonacci_matrix_exp(50) == fibonacci(50)
assert fibonacci_matrix_exp(100) == fibonacci(100)
```

---

### Bonus 2: Mochila Multidimensional ⭐⭐⭐⭐⭐
**Extender a múltiples restricciones: tiempo, memoria, I/O**

```python
def mochila_multidimensional(
    items: List[Dict],      # {"peso_tiempo": int, "peso_mem": int, ...}
    capacidades: List[int]  # [max_tiempo, max_mem, ...]
) -> Tuple[int, List[int]]:
    """
    Aplicación: Optimizar test suite bajo múltiples restricciones.
    
    Cada test:
      - Costo en tiempo (CPU)
      - Costo en memoria
      - Costo en I/O
    """
    # TODO: Implementar
    pass
```

---

### Bonus 3: Análisis Comparativo ⭐⭐⭐⭐⭐
**Proponer estrategia óptima bajo restricciones complejas**

Imagina que tu empresa tiene MÚLTIPLES presupuestos:
- Horas de testing: 100
- Máquinas disponibles: 5 (cada suite requiere máquinas)
- Dinero: $5000

Proponer una estrategia que optimice bajo TODOS estos presupuestos.

---

## 📋 Checklist de Entrega

- [ ] Fibonacci (memoizado) implementado y todos los tests pasan
- [ ] Fibonacci tabular implementado y valida equivalencia
- [ ] Fibonacci ingenua implementado (para benchmarking)
- [ ] Comparar rendimiento (speedup > 1000x demostrado)
- [ ] Mochila 0/1 básica implementada (valor máximo)
- [ ] Mochila 0/1 con reconstrucción (indices correctos)
- [ ] Mochila space-optimized implementada
- [ ] 30/30 tests PASSED
- [ ] Casos integradores funcionan sin error
- [ ] Archivo README.md leído y comprendido
- [ ] Al menos UN desafío bonus intentado

---

## ⏰ Tiempo Estimado

| Ejercicio | Tiempo Estimado |
|-----------|---------|
| 1.1 Fibonacci memoizado | 10 min |
| 1.2 Fibonacci tabular | 15 min |
| 2.1 Mochila valor máximo | 20 min |
| 2.2 Mochila reconstrucción | 25 min |
| 3.1 Mochila space-optimized | 30 min |
| 3.2 Análisis rendimiento | 15 min |
| 3.3 Validación optimalidad | 20 min |
| 4.1 Caso priorización real | 15 min |
| 4.2 Multisuite | 20 min |
| 4.3 Estrategia propia | 30 min |
| **TOTAL** | **3.5 horas** |

---

**¡Éxito en los ejercicios!** 🚀

*Si tienes dudas, contacta al docente: sburbano@uniandes.edu.co*
