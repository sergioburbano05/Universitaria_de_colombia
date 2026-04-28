# TALLER: PROGRAMACIÓN DINÁMICA EN PRUEBAS DE SOFTWARE

## 📋 Resumen

Este taller profundiza en **dos problemas fundamentales de programación dinámica** y su aplicación directa a **pruebas de software**:

1. **FIBONACCI CON MEMOIZACIÓN** — Demostración empírica del poder de la optimización
2. **MOCHILA 0/1 CON RECONSTRUCCIÓN** — Priorización de casos de prueba bajo presupuesto

---

## 🎯 Objetivos

Al completar este taller, habrás:

- ✅ Implementado **Fibonacci** usando tres enfoques: recursión ingenua, memoización, tabulación
- ✅ Resuelto **Mochila 0/1** con reconstrucción de la solución completa
- ✅ Medido empíricamente el **speedup** de la memoización (100x, 1000x o más)
- ✅ Aplicado DP a problemas reales de testing: **priorización de regresión bajo presupuesto**
- ✅ Escrito una suite de **pruebas exhaustivas** que valida corrección, optimización y consistencia

---

## 📁 Archivos

```
clase_17/
├── taller_pd_pruebas_software.py    # Código principal (AQUÍ IMPLEMENTAS)
├── README.md                         # Este archivo
└── .pytest_cache/                    # Caché de pytest (ignora)
```

---

## 🚀 Cómo Ejecutar

### 1. Instalar dependencias
```bash
pip install pytest
```

### 2. Implementar las funciones TODOs

Abre `taller_pd_pruebas_software.py` y busca todas las funciones marcadas con `# TODO`:

```python
# PARTE I: FIBONACCI
@lru_cache(maxsize=None)
def fibonacci(n: int) -> int:
    """Implementar aquí"""
    # TODO: Implementar con memoización
    ...

def fibonacci_tabular(n: int) -> int:
    """Versión space-efficient"""
    # TODO: Implementar versión tabular
    ...

# PARTE II: MOCHILA 0/1
def mochila_01(pesos: List[int], valores: List[int], W: int) -> Tuple[int, List[int]]:
    """Resolver mochila 0/1 con reconstrucción"""
    # TODO: Implementar mochila 0/1 con reconstrucción
    ...

def mochila_01_space_optimized(...):
    """Versión space-efficient: O(W) en lugar de O(n*W)"""
    # TODO: Implementar versión optimizada en espacio
    ...
```

### 3. Ejecutar los tests

```bash
# Todos los tests
pytest taller_pd_pruebas_software.py -v

# Solo tests de Fibonacci
pytest taller_pd_pruebas_software.py::TestFibonacci -v

# Solo tests de Mochila
pytest taller_pd_pruebas_software.py::TestMochila01 -v

# Tests con más detalle
pytest taller_pd_pruebas_software.py -v --tb=long
```

### 4. Ejecutar como script de Python

```bash
python taller_pd_pruebas_software.py
```

---

## 📚 Contenido Detallado

### PARTE I: FIBONACCI — Memoización vs Recursión

#### El Problema
Calcular el N-ésimo número de Fibonacci: F(n) = F(n-1) + F(n-2)

#### Tres Enfoques

| Enfoque | Complejidad | Espacio | Factible hasta n=40? |
|---------|-----------|---------|-----|
| **Recursión ingenua** | O(2^n) | O(n) | ❌ NO |
| **Memoización** | O(n) | O(n) | ✅ SÍ |
| **Tabulación** | O(n) | O(n) | ✅ SÍ (mejor) |

#### Conexión con Testing
En sistemas de CI/CD con dependencias Fibonacci-like (cada test depende de dos anteriores), calcular cobertura es exponencial sin memoización. 

**Test clave:** `test_fibonacci_vs_ingenua_rendimiento` mide el speedup real (1000x+ esperado).

#### Funciones a Implementar

1. **`fibonacci(n)`** — Recursiva con `@lru_cache`
   ```python
   @lru_cache(maxsize=None)
   def fibonacci(n: int) -> int:
       if n < 0:
           raise ValueError("n debe ser no negativo")
       if n < 2:
           return n
       return fibonacci(n - 1) + fibonacci(n - 2)
   ```

2. **`fibonacci_tabular(n)`** — Bottom-up, sin recursión
   ```python
   def fibonacci_tabular(n: int) -> int:
       if n < 2:
           return n
       a, b = 0, 1
       for _ in range(2, n + 1):
           a, b = b, a + b
       return b
   ```

3. **`fibonacci_ingenua(n)`** — Sin memoización (solo para comparar)
   ```python
   def fibonacci_ingenua(n: int) -> int:
       if n < 2:
           return n
       return fibonacci_ingenua(n - 1) + fibonacci_ingenua(n - 2)
   ```

#### Tests Clave
- `test_fibonacci_casos_base` — Validar F(0)=0, F(1)=1
- `test_fibonacci_valor_grande` — Verificar F(50) sin timeout
- `test_fibonacci_vs_ingenua_rendimiento` — Medir speedup > 1000x
- `test_fibonacci_cache_invalida_para_diferentes_valores` — Validar efectividad del caché

---

### PARTE II: MOCHILA 0/1 — Priorización de Pruebas

#### El Problema
**Escenario real:** Tienes 100 horas de testing disponibles. Hay 20 casos de prueba para regresión. Cada uno requiere:
- **Peso (costo):** Horas de ejecución (2-8 horas)
- **Valor:** Probabilidad de detectar defectos (1-12 puntos de severidad)

**Pregunta:** ¿Cuáles casos ejecutar para maximizar detección bajo presupuesto?

#### Algoritmo: Mochila 0/1
- **Complejidad:** O(n×W) en tiempo, O(n×W) en espacio
- **Space-optimized:** O(W) en espacio
- **Reconstrucción:** CRÍTICA — necesitas saber QUÉ casos ejecutar, no solo el valor máximo

#### Tabla DP

```
     Capacidad (W)
      0  1  2  3  4  5
   +--+--+--+--+--+--+
   0| 0| 0| 0| 0| 0| 0|
 I +--+--+--+--+--+--+
 T 1| 0| 0| 3| 3| 3| 3|  (item 0: peso=2, valor=3)
 E +--+--+--+--+--+--+
 M 2| 0| 0| 3| 4| 4| 7|  (item 1: peso=3, valor=4)
   +--+--+--+--+--+--+
```

#### Reconstrucción (Backtrack)
Desde `dp[n][W]`, subir hacia `dp[0][0]` verificando si cada item está incluido.

#### Funciones a Implementar

1. **`mochila_01(pesos, valores, W)`** — Versión estándar O(nW)
   ```python
   def mochila_01(pesos: List[int], valores: List[int], W: int) -> Tuple[int, List[int]]:
       n = len(pesos)
       dp = [[0] * (W + 1) for _ in range(n + 1)]
       
       # Llenar tabla DP
       for i in range(1, n + 1):
           for w in range(W + 1):
               dp[i][w] = dp[i - 1][w]  # No incluir
               if pesos[i - 1] <= w:
                   # Incluir si cabe
                   cand = dp[i - 1][w - pesos[i - 1]] + valores[i - 1]
                   if cand > dp[i][w]:
                       dp[i][w] = cand
       
       # Reconstrucción
       elegidos = []
       w = W
       for i in range(n, 0, -1):
           if dp[i][w] != dp[i - 1][w]:  # Item i-1 está incluido
               elegidos.append(i - 1)
               w -= pesos[i - 1]
       
       elegidos.reverse()
       return dp[n][W], elegidos
   ```

2. **`mochila_01_space_optimized(...)`** — O(W) espacio
   ```python
   def mochila_01_space_optimized(pesos, valores, W):
       prev = [0] * (W + 1)
       curr = [0] * (W + 1)
       
       for i in range(len(pesos)):
           for w in range(W + 1):
               curr[w] = prev[w]
               if pesos[i] <= w:
                   cand = prev[w - pesos[i]] + valores[i]
                   if cand > curr[w]:
                       curr[w] = cand
           prev, curr = curr, prev
       
       return prev[W], []
   ```

#### Tests Clave
- `test_mochila_basico` — Caso simple verificable manualmente
- `test_mochila_reconstruccion_valida` — Validar que los items elegidos caben y dan el valor correcto
- `test_mochila_optimalidad_pequenas_cases` — Comparación exhaustiva (2^n)
- `test_mochila_caso_integrador_pagos` — Aplicación real de priorización

---

### PARTE III: Casos Integradores

#### Caso 1: Priorización de Suite de Regresión
```python
def caso_integrador_priorizar_regresion() -> Dict:
    """
    Catálogo de 8 pruebas críticas para sistema de pagos.
    Presupuesto: 40 horas.
    Encontrar qué pruebas ejecutar para máxima cobertura.
    """
    pruebas = {
        "Autorización tarjeta":        (4, 9),   # (horas, criticidad)
        "Fraude múltiples intentos":   (6, 12),
        "Devolución de pago":          (3, 7),
        ...
    }
```

#### Caso 2: Análisis Multi-Suite
```python
def caso_integrador_multisuite() -> Dict:
    """
    Distribuir presupuesto entre 3 suites simultáneamente:
    - Suite unitaria (12 pruebas, máx 20 horas)
    - Suite integración (8 pruebas, máx 15 horas)
    - Suite E2E (5 pruebas, máx 10 horas)
    
    Tres estrategias:
    1. Equitativa (15-15-15)
    2. Prioritaria (25-12-8)
    3. Integración-first (15-20-10)
    """
```

---

## 📊 Resultados Esperados

### Todos los Tests Deben Pasar

```
test session starts ===
collected 30 items                                                             

TestFibonacci::test_fibonacci_casos_base PASSED
TestFibonacci::test_fibonacci_valores_pequenos PASSED
TestFibonacci::test_fibonacci_valor_grande PASSED
TestFibonacci::test_fibonacci_recurrencia PASSED
... (14 tests de Fibonacci)
TestMochila01::test_mochila_basico PASSED
TestMochila01::test_mochila_reconstruccion_valida PASSED
... (11 tests de Mochila)
TestCasosIntegradores::test_caso_integrador_priorizar_regresion_valido PASSED
... (2 tests de casos integradores)

======= 30 passed in 0.78s =======
```

### Análisis de Rendimiento
```python
>>> from taller_pd_pruebas_software import comparar_fibonacci_rendimiento
>>> resultados = comparar_fibonacci_rendimiento(35)
>>> resultados
{
    'tabular': 0.00001,      # Más rápido
    'memoizado': 0.00002,    # Muy similar
    'ingenua': 2.541         # 100,000x más lento
}
```

---

## 🎓 Conceptos Clave

### Programación Dinámica
1. **Propiedad de subestructura óptima:** La solución usa soluciones óptimas de subproblemas
2. **Solapamiento de subproblemas:** Los mismos subproblemas se calculan múltiples veces
3. **Memoización:** Almacenar resultados para evitar recálculos
4. **Tabulación:** Llenar tabla de abajo hacia arriba (bottom-up)

### Testing de Algoritmos DP
1. **Corrección:** ¿Produce el resultado correcto?
2. **Optimización:** ¿Es eficiente en tiempo y espacio?
3. **Reconstrucción:** ¿Podemos recuperar la solución completa?
4. **Casos límite:** Listas vacías, capacidad cero, un solo item, etc.

### Aplicación a Pruebas de Software
- **Fibonacci:** Modela explosión combinatoria en test execution
- **Mochila:** Priorización de regresión bajo presupuesto limitado
- **Reconstrucción:** No es suficiente saber el valor; necesitas saber QUÉ cases ejecutar

---

## 💡 Desafíos Bonus

### 1. Fibonacci Matrix Exponentiation (Opcional)
Implementar Fibonacci en **O(log n)** usando exponenciación de matrices:
```
[F(n+1), F(n)] = [[1,1],[1,0]]^n * [1, 0]
```

### 2. Mochila Multidimensional (Opcional)
Extender a múltiples restricciones:
- Peso (horas)
- Memoria disponible
- Ancho de banda de I/O

Aplicación: Optimizar test suite considerando múltiples recursos.

### 3. Análisis Comparativo (Desafío)
Proponer una estrategia de distribución de presupuesto entre suites que NO sea ninguna de las tres predefinidas. Justificar con cálculos.

---

## 📝 Criterios de Evaluación

| Criterio | Puntos | Descripción |
|----------|--------|-----------|
| **Corrección** | 50% | Todos los tests pasan (30/30) |
| **Reconstrucción** | 25% | `elegidos` es correcto (no solo valor máximo) |
| **Optimización** | 15% | Space-optimized implementado y validado |
| **Documentación** | 10% | Docstrings claros, comentarios en código difícil |

---

## 🔍 Troubleshooting

### Error: "ModuleNotFoundError: No module named 'pytest'"
```bash
pip install pytest
```

### Error: "RecursionError: maximum recursion depth exceeded"
- Ocurre si implementas Fibonacci sin memoización para n > 1000
- Solución: Usar `fibonacci_tabular` o verificar `@lru_cache`

### Error: "Test 'test_mochila_optimalidad_pequenas_cases' is very slow"
- Verificar que la tabla DP se calcula en O(nW), no O(2^n)
- Usar `pytest -v --durations=10` para perfilar

---

## 📚 Referencias

- **Cormen et al.** — "Introduction to Algorithms" (Chapters 14-15: Dynamic Programming)
- **GeeksforGeeks** — DP tutorials
- **LeetCode** — Problems 509 (Fibonacci), 416 (Knapsack)

---

## 📞 Contacto y Preguntas

**Docente:** Mg. Sergio Alejandro Burbano Mena  
**Email:** sburbano@uniandes.edu.co  
**Oficina:** Ingeniería de Software, VII Semestre

---

**¡Éxito en el taller!** 🎯✨
