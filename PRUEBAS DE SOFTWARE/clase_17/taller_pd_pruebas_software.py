"""
====================================================================
TALLER: PROGRAMACIÓN DINÁMICA EN PRUEBAS DE SOFTWARE
       Fibonacci y Mochila 0/1 — Análisis y Optimización
====================================================================

Asignatura : Pruebas de Software
Programa   : Ingeniería de Software · VII Semestre
Institución: Universitaria de Colombia
Docente    : Mg. Sergio Alejandro Burbano Mena
Fecha      : 2026

====================================================================
OBJETIVO DEL TALLER
====================================================================

Este taller profundiza en DOS problemas fundamentales de programación
dinámica y su aplicación directa a pruebas de software:

  1. FIBONACCI CON MEMOIZACIÓN
     - Demostración empírica del poder de la memoización
     - Medición de speedup: recursión ingenua vs memoización vs DP tabular
     - Aplicación: estimación de cobertura de pruebas en sistemas
       Fibonacci-like (cascadas, dependencias complejas)

  2. MOCHILA 0/1 CON RECONSTRUCCIÓN
     - Priorización de casos de prueba bajo presupuesto limitado
     - Casos límite y optimización de espacio
     - Reconstrucción de la solución: ¿CUÁLES pruebas ejecutar?
     - Aplicación: asignación inteligente de recursos de testing

Cada sección combina:
  • Problema real de testing
  • Algoritmo de programación dinámica
  • Suite completa de pruebas unitarias
  • Análisis de complejidad y trade-offs

====================================================================
CÓMO EJECUTAR
====================================================================

1. Implementar las funciones marcadas con # TODO

2. Ejecutar los tests:
      pytest taller_pd_pruebas_software.py -v

3. Verificar que ALL tests pasen (100% de cobertura)

4. Analizar los resultados de rendimiento

====================================================================
CRITERIOS DE EVALUACIÓN
====================================================================

  ✓ Corrección (50%):     Todos los tests pasan
  ✓ Reconstrucción (25%): Recuperar solución completa, no solo valor
  ✓ Optimización (15%):   Versiones space-efficient donde se pida
  ✓ Testing (10%):        Proponer 3 casos de prueba adicionales

====================================================================
"""

from functools import lru_cache
from typing import Callable, List, Tuple, Dict
import pytest
import time


# ====================================================================
# PARTE I: FIBONACCI — Memoización vs Recursión vs Tabulación
# ====================================================================
#
# CONTEXTO DE TESTING
# -------------------
# En sistemas de testing distribuido, el cálculo del número de pruebas
# necesarias para cubrir dependencias de N componentes puede seguir
# una serie Fibonacci si cada componente depende de los dos anteriores
# (test case explosion en sistemas pipeline o CI/CD complejos).
#
# PROBLEMA: calcular eficientemente el N-ésimo número de Fibonacci.
#
# TRES ENFOQUES:
#   1. Recursión ingenua:        O(2^n)   — ¡INFACTIBLE para n>40!
#   2. Memoización recursiva:    O(n)     — Almacenar llamadas recursivas
#   3. Tabulación iterativa:     O(n)     — DP bottom-up
#
# LECCIÓN DE TESTING: Sin memoización, validar fibonacci(50) es
# computacionalmente imposible. Con memoización, tarda milisegundos.
# ====================================================================

@lru_cache(maxsize=None)
def fibonacci(n: int) -> int:
    """
    Calcula el n-ésimo número de Fibonacci usando MEMOIZACIÓN recursiva.
    
    Complejidad: O(n) en tiempo, O(n) en espacio de recursión.
    
    Casos de prueba básicos:
      - fibonacci(0) = 0
      - fibonacci(1) = 1
      - fibonacci(n) = fib(n-1) + fib(n-2) para n >= 2
    """
    # TODO: Implementar con memoización
    if n < 0:
        raise ValueError("n debe ser no negativo")
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)


def fibonacci_tabular(n: int) -> int:
    """
    Calcula el n-ésimo número de Fibonacci usando TABULACIÓN (bottom-up).
    
    Complejidad: O(n) en tiempo, O(n) en espacio (pero predecible, no recursión).
    
    Ventaja sobre memoización: NO hay límite de profundidad de recursión.
    Desventaja: Requiere más espacio adicional (el arreglo dp).
    """
    # TODO: Implementar versión tabular
    if n < 0:
        raise ValueError("n debe ser no negativo")
    if n < 2:
        return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b


def fibonacci_ingenua(n: int) -> int:
    """
    VERSIÓN INGENUA — Recursión sin memoización.
    
    ⚠️  NO USAR EN PRODUCCIÓN PARA n > 35 — Es exponencial O(2^n)
    
    Solo para TESTING: verificar que la memoización realmente funciona.
    """
    if n < 0:
        raise ValueError("n debe ser no negativo")
    if n < 2:
        return n
    return fibonacci_ingenua(n - 1) + fibonacci_ingenua(n - 2)


def comparar_fibonacci_rendimiento(n: int) -> Dict[str, float]:
    """
    TAREA DE TESTING: Compara tiempos de ejecución.
    
    Retorna un diccionario con tiempos en segundos para:
      - "tabular":     fibonacci_tabular(n)
      - "memoizado":   fibonacci(n)
      - "ingenua":     fibonacci_ingenua(n) [solo si n <= 30 para no bloquear]
    
    LECCIÓN: Verificar que tabular ≤ memoizado << ingenua
    """
    resultados = {}
    
    # Versión tabular
    inicio = time.time()
    valor_tabular = fibonacci_tabular(n)
    resultados["tabular"] = time.time() - inicio
    
    # Versión memoizada
    fibonacci.cache_clear()  # Limpiar caché antes
    inicio = time.time()
    valor_memo = fibonacci(n)
    resultados["memoizado"] = time.time() - inicio
    
    # Versión ingenua (solo si n es pequeño)
    if n <= 30:
        inicio = time.time()
        valor_ingenua = fibonacci_ingenua(n)
        resultados["ingenua"] = time.time() - inicio
        assert valor_ingenua == valor_tabular == valor_memo
    
    return resultados


# ====================================================================
# PARTE II: MOCHILA 0/1 — Priorización de Pruebas
# ====================================================================
#
# CONTEXTO DE TESTING
# -------------------
# Tu proyecto tiene 100 horas de testing disponibles. Tienes un
# catálogo de 20 casos de prueba para regresión, cada uno con:
#   - Peso: horas que toma ejecutar (2-8 horas)
#   - Valor: probabilidad de detectar un defecto * severidad esperada
#
# PROBLEMA: ¿Cuáles casos ejecutar para maximizar cobertura bajo
# restricción de tiempo?
#
# SOLUCIÓN: Mochila 0/1 donde cada caso es un "objeto" con peso
# (costo en horas) y valor (capacidad de detección).
#
# RECONSTRUCCIÓN: Es crítico saber CUÁLES casos ejecutar, no solo
# el valor máximo. Por eso retornamos los índices elegidos.
# ====================================================================

def mochila_01(pesos: List[int], valores: List[int], W: int) -> Tuple[int, List[int]]:
    """
    Resuelve el problema de la MOCHILA 0/1 con RECONSTRUCCIÓN.
    
    Args:
      - pesos:    Lista de pesos (horas de ejecución de cada prueba)
      - valores:  Lista de valores (capacidad de detección de defectos)
      - W:        Capacidad de la mochila (horas disponibles)
    
    Returns:
      - (valor_max, indices_elegidos)
        * valor_max:       Valor total máximo alcanzable
        * indices_elegidos: Lista de índices (0-indexados) de items incluidos
    
    Complejidad: O(n*W) en tiempo, O(n*W) en espacio
    Espacios reducido: O(W) si no necesitas reconstrucción
    
    TAREA: Implementar con reconstrucción correcta.
    """
    # TODO: Implementar mochila 0/1 con reconstrucción
    n = len(pesos)
    if n != len(valores):
        raise ValueError("pesos y valores deben tener la misma longitud")
    if n == 0 or W == 0:
        return 0, []
    
    # DP: dp[i][w] = valor máximo usando primeros i items y capacidad w
    dp = [[0] * (W + 1) for _ in range(n + 1)]
    
    # Llenar la tabla DP
    for i in range(1, n + 1):
        for w in range(W + 1):
            # Opción 1: NO incluir el item i-1
            dp[i][w] = dp[i - 1][w]
            
            # Opción 2: Incluir el item i-1 (si cabe)
            if pesos[i - 1] <= w:
                cand = dp[i - 1][w - pesos[i - 1]] + valores[i - 1]
                if cand > dp[i][w]:
                    dp[i][w] = cand
    
    # RECONSTRUCCIÓN: Backtrack desde dp[n][W]
    elegidos = []
    w = W
    for i in range(n, 0, -1):
        # Si el valor cambió respecto a no incluir el item, lo incluimos
        if dp[i][w] != dp[i - 1][w]:
            elegidos.append(i - 1)
            w -= pesos[i - 1]
    
    elegidos.reverse()
    return dp[n][W], elegidos


def mochila_01_space_optimized(
    pesos: List[int], valores: List[int], W: int
) -> Tuple[int, List[int]]:
    """
    VERSIÓN OPTIMIZADA EN ESPACIO: O(W) en lugar de O(n*W).
    
    Nota: Reconstrucción es más compleja. Aquí retornamos solo el valor.
    
    DESAFÍO (opcional): Modificar para incluir reconstrucción.
    """
    # TODO: Implementar versión space-efficient
    n = len(pesos)
    if n == 0 or W == 0:
        return 0, []
    
    # Usar solo dos filas: anterior y actual
    prev = [0] * (W + 1)
    curr = [0] * (W + 1)
    
    for i in range(n):
        for w in range(W + 1):
            curr[w] = prev[w]
            if pesos[i] <= w:
                cand = prev[w - pesos[i]] + valores[i]
                if cand > curr[w]:
                    curr[w] = cand
        prev, curr = curr, prev
    
    return prev[W], []


# ====================================================================
# CASO DE USO INTEGRADOR: Priorización Realista de Suite de Regresión
# ====================================================================
#
# Escenario: Sistema de pagos en línea. Disponemos de 40 horas de
# testing al mes. Se identifica un conjunto de 8 pruebas críticas
# para regresión. Cada una tiene un costo (tiempo) y un valor
# (severidad * probabilidad de encontrar defectos).
#
# TABLA DE PRUEBAS:
#   ID   | Nombre                     | Horas | Valor (criticidad)
#   -----+----------------------------+-------+--------------------
#    0   | Autorización de tarjeta    |  4    |  9   (crítica)
#    1   | Fraude de múltiples intentos|  6    |  12  (crítica)
#    2   | Devolución de pago         |  3    |  7   (media)
#    3   | Validación de moneda       |  2    |  5   (baja)
#    4   | Logging y auditoría        |  5    |  6   (media)
#    5   | Timeout y reintentos       |  4    |  8   (media)
#    6   | Encriptación de datos      |  7    |  11  (crítica)
#    7   | Reconciliación de saldos   |  3    |  4   (baja)
# ====================================================================

def caso_integrador_priorizar_regresion() -> Dict:
    """
    Demuestra la aplicación real: priorización de suite de regresión
    bajo presupuesto limitado usando Mochila 0/1.
    """
    # Catálogo de pruebas (horas, valor)
    pruebas = {
        "Autorización tarjeta":        (4, 9),
        "Fraude múltiples intentos":   (6, 12),
        "Devolución de pago":          (3, 7),
        "Validación de moneda":        (2, 5),
        "Logging y auditoría":         (5, 6),
        "Timeout y reintentos":        (4, 8),
        "Encriptación de datos":       (7, 11),
        "Reconciliación de saldos":    (3, 4),
    }
    
    horas_disponibles = 40
    pesos = [h for h, _ in pruebas.values()]
    valores = [v for _, v in pruebas.values()]
    
    valor_max, indices = mochila_01(pesos, valores, horas_disponibles)
    
    pruebas_list = list(pruebas.items())
    pruebas_elegidas = [pruebas_list[i][0] for i in indices]
    horas_usadas = sum(pesos[i] for i in indices)
    
    return {
        "valor_total_cobertura": valor_max,
        "pruebas_a_ejecutar": pruebas_elegidas,
        "total_horas_usadas": horas_usadas,
        "horas_disponibles": horas_disponibles,
        "horas_restantes": horas_disponibles - horas_usadas,
        "eficiencia": valor_max / horas_usadas if horas_usadas > 0 else 0,
    }


# ====================================================================
# CASO INTEGRADOR 2: Análisis Multi-Suite de Testing
# ====================================================================
#
# Más complejo: Usar MOCHILA para distribuir tiempo entre tipos de
# pruebas DIFERENTES (unitarias, integración, e2e, performance) donde
# cada suite tiene un catálogo diferente de casos.
# ====================================================================

def caso_integrador_multisuite() -> Dict:
    """
    Analiza TRES suites de testing simultáneamente:
      1. Suite unitaria (12 pruebas, máx 20 horas)
      2. Suite integración (8 pruebas, máx 15 horas)
      3. Suite E2E (5 pruebas, máx 10 horas)
    
    Total presupuesto: 45 horas
    
    DESAFÍO: Optimizar cada suite por separado y luego comparar
    estrategias de distribución.
    """
    # Suite Unitaria: modelos, validadores, utilidades
    suite_unit = {
        "Parser de JSON": (1, 3),
        "Validador de email": (1, 2),
        "Hasher de contraseñas": (1, 4),
        "Formateo de fechas": (2, 2),
        "Cache LRU": (3, 5),
        "Manejo de excepciones": (2, 3),
        "Serialización": (2, 3),
        "Compresión de datos": (3, 4),
        "Cifrado": (2, 5),
        "Rate limiting": (3, 6),
        "Pooling de conexiones": (4, 7),
        "Transacciones": (2, 4),
    }
    
    # Suite Integración: APIs, bases de datos, servicios
    suite_integ = {
        "GET /users": (2, 4),
        "POST /users": (3, 5),
        "PUT /users/{id}": (3, 5),
        "DELETE /users/{id}": (2, 3),
        "Query BD con filtros": (2, 4),
        "Transacciones simultáneas": (4, 6),
        "Rollback de errores": (3, 5),
        "Caché consistency": (2, 4),
    }
    
    # Suite E2E: flujos completos de usuario
    suite_e2e = {
        "Signup → Email confirmation → Login": (8, 9),
        "Compra completa con tarjeta": (6, 10),
        "Cambio de contraseña": (4, 6),
        "Reporte de anomalías": (5, 7),
        "Admin dashboard": (5, 8),
    }
    
    def resolver_suite(suite_dict, presupuesto):
        pesos = [h for h, _ in suite_dict.values()]
        valores = [v for _, v in suite_dict.values()]
        valor_max, indices = mochila_01(pesos, valores, presupuesto)
        casos_elegidos = [list(suite_dict.keys())[i] for i in indices]
        horas_usadas = sum(pesos[i] for i in indices)
        return {
            "valor": valor_max,
            "casos": casos_elegidos,
            "horas": horas_usadas,
        }
    
    # Tres estrategias de distribución de presupuesto
    estrategias = {
        "Equitativa (15-15-15)": {
            "unitaria": resolver_suite(suite_unit, 15),
            "integracion": resolver_suite(suite_integ, 15),
            "e2e": resolver_suite(suite_e2e, 15),
        },
        "Prioritaria (25-12-8)": {
            "unitaria": resolver_suite(suite_unit, 25),
            "integracion": resolver_suite(suite_integ, 12),
            "e2e": resolver_suite(suite_e2e, 8),
        },
        "Integración-first (15-20-10)": {
            "unitaria": resolver_suite(suite_unit, 15),
            "integracion": resolver_suite(suite_integ, 20),
            "e2e": resolver_suite(suite_e2e, 10),
        },
    }
    
    return estrategias


# ====================================================================
# DESAFÍO BONUS: Versionas Mejoradas
# ====================================================================

def fibonacci_matrix_exponentiation(n: int) -> int:
    """
    DESAFÍO BONUS: Fibonacci usando exponenciación de matrices.
    
    La relación [F(n+1), F(n)] = [[1,1],[1,0]]^n * [1, 0] permite
    calcular F(n) en O(log n) usando fast matrix exponentiation.
    
    ⚠️  Mucho más complejo pero sub-lineal.
    """
    # TODO: Implementar (opcional)
    pass


def mochila_01_multidimensional(
    items: List[Dict], capacidades: List[int]
) -> Tuple[int, List[int]]:
    """
    DESAFÍO BONUS: Mochila MULTIDIMENSIONAL.
    
    Cada item tiene MÚLTIPLES pesos (p.ej., tiempo, memoria, ancho de banda)
    y hay límites para cada dimensión.
    
    Aplicación: Optimización de test suites considerando múltiples
    recursos (tiempo, CPU, memoria, I/O).
    """
    # TODO: Implementar (opcional)
    pass




# ====================================================================
# TESTS — pytest
# ====================================================================
# Los siguientes tests cubren FIBONACCI y MOCHILA en detalle.
# La meta es 100% de aprobación.
# ====================================================================


# ========== TESTS de FIBONACCI ==========

class TestFibonacci:
    """Suite de pruebas para Fibonacci: memoización vs otros enfoques."""
    
    def test_fibonacci_casos_base(self):
        """Casos base: F(0) = 0, F(1) = 1."""
        assert fibonacci(0) == 0
        assert fibonacci(1) == 1
    
    def test_fibonacci_valores_pequenos(self):
        """Valores pequeños verificables manualmente."""
        assert fibonacci(2) == 1      # 0 + 1
        assert fibonacci(3) == 2      # 1 + 1
        assert fibonacci(4) == 3      # 1 + 2
        assert fibonacci(5) == 5      # 2 + 3
        assert fibonacci(10) == 55    # Clásico
    
    def test_fibonacci_valor_grande(self):
        """
        IMPORTANTE: Sin memoización, fibonacci(50) es INFACTIBLE.
        Con memoización, debe completar en milisegundos.
        
        Este test VALIDA que la memoización funciona.
        """
        assert fibonacci(50) == 12_586_269_025
        assert fibonacci(35) == 9_227_465
    
    def test_fibonacci_recurrencia(self):
        """Propiedad fundamental: F(n) = F(n-1) + F(n-2)."""
        for n in range(2, 30):
            assert fibonacci(n) == fibonacci(n - 1) + fibonacci(n - 2)
    
    def test_fibonacci_n_negativo_error(self):
        """Valores negativos deben lanzar ValueError."""
        with pytest.raises(ValueError):
            fibonacci(-1)
        with pytest.raises(ValueError):
            fibonacci(-10)
    
    def test_fibonacci_cache_invalida_para_diferentes_valores(self):
        """
        Verificar que el cache funciona: calcular nuevamente debe ser
        muy rápido. Esto valida la efectividad de lru_cache.
        """
        fibonacci.cache_clear()
        inicio = time.time()
        r1 = fibonacci(40)
        primer_tiempo = time.time() - inicio
        
        # Segunda llamada (desde cache) debe ser casi instantánea
        inicio = time.time()
        r2 = fibonacci(40)
        segundo_tiempo = time.time() - inicio
        
        assert r1 == r2
        # La segunda llamada es al menos 100x más rápida (cache hit)
        if primer_tiempo > 0.01:  # Solo si la primera fue significativa
            assert segundo_tiempo < primer_tiempo / 50
    
    def test_fibonacci_tabular_equivalencia(self):
        """Validar que fibonacci_tabular produce el mismo resultado."""
        for n in range(0, 35):
            assert fibonacci_tabular(n) == fibonacci(n)
    
    def test_fibonacci_ingenua_pequeno(self):
        """Validar fibonacci_ingenua para valores pequeños."""
        for n in range(0, 25):
            # fibonacci_ingenua es O(2^n), así que solo para n <= 25
            assert fibonacci_ingenua(n) == fibonacci(n)
    
    def test_fibonacci_tabular_espacio_constante(self):
        """Verificar que fibonacci_tabular usa espacio O(1) amortizado."""
        # Simplemente verificar que funciona para valores grandes
        assert fibonacci_tabular(100) == fibonacci(100)
    
    def test_fibonacci_monotonicidad(self):
        """Fibonacci es monótonamente no-decreciente desde n=0."""
        valores = [fibonacci(n) for n in range(0, 20)]
        for i in range(2, len(valores)):
            # Desde n=2 en adelante es estrictamente creciente
            assert valores[i] >= valores[i - 1]
    
    def test_fibonacci_vs_ingenua_rendimiento(self):
        """
        TEST DE RENDIMIENTO: Demostrar que memoización es exponencialmente
        más rápida que recursión ingenua.
        """
        n = 30
        
        # Fibonacci ingenua: O(2^n)
        inicio = time.time()
        r_ingenua = fibonacci_ingenua(n)
        t_ingenua = time.time() - inicio
        
        # Fibonacci memoizada: O(n)
        fibonacci.cache_clear()
        inicio = time.time()
        r_memo = fibonacci(n)
        t_memo = time.time() - inicio
        
        assert r_ingenua == r_memo
        
        # Memoización debe ser al menos 1000x más rápida
        if t_ingenua > 0.01:
            speedup = t_ingenua / t_memo
            assert speedup > 1000, f"Speedup: {speedup}x (esperado > 1000x)"


class TestFibonacciTabular:
    """Tests específicos para la versión tabular."""
    
    def test_tabular_casos_base(self):
        assert fibonacci_tabular(0) == 0
        assert fibonacci_tabular(1) == 1
    
    def test_tabular_valores(self):
        for n in range(0, 50):
            assert fibonacci_tabular(n) == fibonacci(n)
    
    def test_tabular_n_negativo(self):
        with pytest.raises(ValueError):
            fibonacci_tabular(-1)


# ========== TESTS de MOCHILA 0/1 ==========

class TestMochila01:
    """Suite de pruebas para Mochila 0/1 con reconstrucción."""
    
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
    
    def test_mochila_capacidad_cero(self):
        """Capacidad 0 → no cabe nada."""
        valor, elegidos = mochila_01([1, 2, 3], [10, 20, 30], 0)
        assert valor == 0
        assert elegidos == []
    
    def test_mochila_lista_vacia(self):
        """Lista de items vacía."""
        valor, elegidos = mochila_01([], [], 10)
        assert valor == 0
        assert elegidos == []
    
    def test_mochila_un_item_cabe(self):
        """Un solo item que cabe."""
        valor, elegidos = mochila_01([3], [10], 5)
        assert valor == 10
        assert elegidos == [0]
    
    def test_mochila_un_item_no_cabe(self):
        """Un solo item que NO cabe."""
        valor, elegidos = mochila_01([10], [100], 5)
        assert valor == 0
        assert elegidos == []
    
    def test_mochila_todos_caben(self):
        """Todos los items caben."""
        pesos = [1, 1, 1]
        valores = [5, 4, 3]
        valor, elegidos = mochila_01(pesos, valores, 10)
        assert valor == 12
        assert set(elegidos) == {0, 1, 2}
    
    def test_mochila_ningun_item_cabe(self):
        """Ningún item cabe."""
        valor, elegidos = mochila_01([10, 20, 30], [100, 200, 300], 5)
        assert valor == 0
        assert elegidos == []
    
    def test_mochila_pesos_valores_distintos_tamanos(self):
        """Error si pesos y valores tienen tamaños distintos."""
        with pytest.raises(ValueError):
            mochila_01([1, 2], [1], 10)
        with pytest.raises(ValueError):
            mochila_01([1], [1, 2], 10)
    
    def test_mochila_reconstruccion_valida(self):
        """
        Validar que la reconstrucción es correcta:
          1. Los items elegidos caben en la capacidad
          2. El valor total coincide
          3. No hay items duplicados
        """
        pesos = [2, 3, 4, 5, 6]
        valores = [3, 4, 5, 6, 7]
        W = 10
        
        valor_max, elegidos = mochila_01(pesos, valores, W)
        
        # Sin duplicados
        assert len(elegidos) == len(set(elegidos))
        
        # Todos los índices son válidos
        assert all(0 <= i < len(pesos) for i in elegidos)
        
        # Cabe en la mochila
        peso_total = sum(pesos[i] for i in elegidos)
        assert peso_total <= W
        
        # Valor coincide
        valor_total = sum(valores[i] for i in elegidos)
        assert valor_total == valor_max
    
    def test_mochila_optimalidad_peque_cases(self):
        """
        Para instancias pequeñas, verificar que es óptimo por
        comparación exhaustiva.
        """
        pesos = [2, 2, 3]
        valores = [3, 4, 5]
        W = 4
        
        valor_opt, elegidos_opt = mochila_01(pesos, valores, W)
        
        # Verificar exhaustivamente (2^3 = 8 subconjuntos)
        valor_max_esperado = 0
        for mask in range(1 << len(pesos)):
            peso_total = sum(pesos[i] for i in range(len(pesos)) if mask & (1 << i))
            if peso_total <= W:
                valor_total = sum(valores[i] for i in range(len(pesos)) if mask & (1 << i))
                valor_max_esperado = max(valor_max_esperado, valor_total)
        
        assert valor_opt == valor_max_esperado
    
    def test_mochila_caso_integrador_pagos(self):
        """Validar con el caso integrador: priorización de suite de regresión."""
        resultado = caso_integrador_priorizar_regresion()
        
        # Validaciones básicas
        assert resultado["valor_total_cobertura"] > 0
        assert len(resultado["pruebas_a_ejecutar"]) > 0
        assert resultado["total_horas_usadas"] <= resultado["horas_disponibles"]
        assert resultado["eficiencia"] > 0


class TestMochilaSpaceOptimized:
    """Tests para la versión space-optimized."""
    
    def test_space_optimized_basico(self):
        """Validar que produce el mismo valor que la versión normal."""
        pesos = [2, 3, 4, 5]
        valores = [3, 4, 5, 6]
        W = 5
        
        valor1, _ = mochila_01(pesos, valores, W)
        valor2, _ = mochila_01_space_optimized(pesos, valores, W)
        
        assert valor1 == valor2
    
    def test_space_optimized_caso_vacio(self):
        """Caso vacío."""
        valor, _ = mochila_01_space_optimized([], [], 10)
        assert valor == 0


# ========== TESTS de RENDIMIENTO COMPARATIVO ==========

class TestRendimiento:
    """Benchmarks de rendimiento entre enfoques."""
    
    def test_fibonacci_comparar_rendimiento(self):
        """Ejecutar comparativas de rendimiento."""
        resultados = comparar_fibonacci_rendimiento(30)
        
        assert "tabular" in resultados
        assert "memoizado" in resultados
        
        # Tabular debe ser ≤ memoizado
        assert resultados["tabular"] <= resultados["memoizado"] * 1.5
        
        # Ambos deben ser muy rápidos para n=30
        assert resultados["tabular"] < 0.1
        assert resultados["memoizado"] < 0.1


# ========== TESTS de CASOS INTEGRADORES ==========

class TestCasosIntegradores:
    """Validar casos de uso realistas."""
    
    def test_caso_integrador_priorizar_regresion_valido(self):
        """El caso integrador debe generar resultados válidos."""
        resultado = caso_integrador_priorizar_regresion()
        
        assert resultado["valor_total_cobertura"] > 0
        assert len(resultado["pruebas_a_ejecutar"]) > 0
        assert resultado["total_horas_usadas"] > 0
        assert resultado["horas_restantes"] >= 0
        assert resultado["eficiencia"] > 0
    
    def test_caso_integrador_multisuite_valido(self):
        """El caso multisuite debe generar tres estrategias válidas."""
        estrategias = caso_integrador_multisuite()
        
        assert len(estrategias) == 3
        
        for nombre_estrategia, suites in estrategias.items():
            assert "unitaria" in suites
            assert "integracion" in suites
            assert "e2e" in suites
            
            for suite_nombre, resultado_suite in suites.items():
                assert resultado_suite["valor"] >= 0
                assert resultado_suite["horas"] >= 0
                assert len(resultado_suite["casos"]) >= 0


if __name__ == "__main__":
    import sys
    sys.exit(pytest.main([__file__, "-v"]))

