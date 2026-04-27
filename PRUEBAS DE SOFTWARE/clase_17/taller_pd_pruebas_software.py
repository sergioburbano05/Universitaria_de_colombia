"""
====================================================================
TALLER INTEGRADOR — PROGRAMACIÓN DINÁMICA APLICADA A PRUEBAS DE SOFTWARE
====================================================================

Asignatura : Pruebas de Software
Programa   : Ingeniería de Software · VII Semestre
Institución: Universitaria de Colombia
Docente    : Mg. Sergio Alejandro Burbano Mena
Bloque     : Sesiones 16-19 · Programación Dinámica

--------------------------------------------------------------------
INSTRUCCIONES GENERALES
--------------------------------------------------------------------

Este taller integra los seis algoritmos vistos en el bloque de
programación dinámica:

  1. Fibonacci con memoización
  2. Mochila 0/1 con reconstrucción
  3. Coeficientes binomiales (triángulo de Pascal)
  4. Subsecuencia común máxima (LCS) con reconstrucción
  5. Camino de mínimo costo en grilla con reconstrucción
  6. Asignación óptima de recursos con reconstrucción

Cada ejercicio incluye:
  - Enunciado del problema
  - Firma de la función a implementar (stub)
  - Casos de prueba con pytest
  - Conexión explícita con pruebas de software

CÓMO EJECUTAR
--------------------------------------------------------------------

Implementar las funciones marcadas con `# TODO` en el bloque
SOLUCIONES. Luego ejecutar:

    pytest taller_pd_pruebas_software.py -v

El estudiante debe lograr que TODOS los tests pasen. Los tests
verifican corrección sobre casos pequeños, casos límite y
consistencia interna (por ejemplo: la suma de la asignación
reconstruida debe coincidir con el presupuesto).

CRITERIOS DE EVALUACIÓN
--------------------------------------------------------------------

  - Corrección (60%): que pasen todos los tests.
  - Optimización (20%): aplicar las versiones de espacio reducido
    cuando se solicita explícitamente.
  - Reconstrucción (10%): recuperar la solución, no solo su valor.
  - Estilo y documentación (10%): docstrings, nombres claros,
    comentarios donde sea no obvio.

--------------------------------------------------------------------
"""

from functools import lru_cache
from typing import Callable, List, Tuple
import pytest


# ====================================================================
# EJERCICIO 1 — Fibonacci con memoización
# ====================================================================
#
# CONTEXTO. Fibonacci es el problema "Hola, mundo" de la programación
# dinámica. La versión recursiva ingenua es exponencial; con memoización
# se vuelve lineal.
#
# CONEXIÓN CON TESTING. Esta función la usaremos como benchmark para
# verificar que nuestra infraestructura de pruebas funciona y para
# medir el speedup de la memoización frente a la recursión ingenua.
#
# TAREA. Implementar fibonacci(n) usando memoización.
#   - Para n = 0 retornar 0.
#   - Para n = 1 retornar 1.
#   - Para n >= 2 retornar fibonacci(n-1) + fibonacci(n-2).
# ====================================================================

@lru_cache(maxsize=None)
def fibonacci(n: int) -> int:
    """Calcula el n-esimo numero de Fibonacci con memoizacion."""
    # TODO: implementar
    if n < 0:
        raise ValueError("n debe ser no negativo")
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)


# ====================================================================
# EJERCICIO 2 — Mochila 0/1 con reconstrucción
# ====================================================================
#
# CONTEXTO. Dados N objetos con pesos y valores y una capacidad W,
# elegir el subconjunto que maximice el valor total sin exceder W.
#
# CONEXIÓN CON TESTING. Modela la priorización de regresión bajo
# presupuesto: cada caso de prueba tiene un costo (tiempo de ejecución)
# y un valor (probabilidad de detectar regresiones por severidad
# esperada). Bajo un presupuesto fijo de tiempo, queremos seleccionar
# la mejor suite.
#
# TAREA. Implementar mochila_01(pesos, valores, W) que retorne una
# tupla (valor_max, indices_elegidos) donde indices_elegidos es la
# lista de índices (0-indexados) de los objetos incluidos.
# ====================================================================

def mochila_01(pesos: List[int], valores: List[int], W: int) -> Tuple[int, List[int]]:
    """
    Resuelve la mochila 0/1 con reconstruccion.
    Retorna el valor maximo y la lista de indices elegidos.
    """
    # TODO: implementar con reconstruccion
    n = len(pesos)
    if n != len(valores):
        raise ValueError("pesos y valores deben tener la misma longitud")
    dp = [[0] * (W + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        for w in range(W + 1):
            dp[i][w] = dp[i - 1][w]
            if pesos[i - 1] <= w:
                cand = dp[i - 1][w - pesos[i - 1]] + valores[i - 1]
                if cand > dp[i][w]:
                    dp[i][w] = cand

    # Reconstruccion
    elegidos = []
    w = W
    for i in range(n, 0, -1):
        if dp[i][w] != dp[i - 1][w]:
            elegidos.append(i - 1)
            w -= pesos[i - 1]
    elegidos.reverse()
    return dp[n][W], elegidos


# ====================================================================
# EJERCICIO 3 — Coeficientes binomiales con la recurrencia de Pascal
# ====================================================================
#
# CONTEXTO. C(n, k) cuenta de cuantas maneras podemos elegir k objetos
# de n. La recurrencia de Pascal C(n,k) = C(n-1,k-1) + C(n-1,k) usa
# solo sumas, evitando el desbordamiento de la formula factorial.
#
# CONEXIÓN CON TESTING. Pairwise testing y combinatorial coverage
# usan coeficientes binomiales para contar la cantidad de pares de
# parámetros a cubrir.
#
# TAREA. Implementar binomial(n, k) usando la recurrencia de Pascal.
# Validar 0 <= k <= n; en otro caso retornar 0.
# ====================================================================

def binomial(n: int, k: int) -> int:
    """Calcula C(n, k) con la recurrencia de Pascal y tabulacion."""
    # TODO: implementar
    if k < 0 or k > n:
        return 0
    if k == 0 or k == n:
        return 1
    # Optimizacion: usar la simetria C(n,k) = C(n,n-k)
    k = min(k, n - k)
    fila = [0] * (k + 1)
    fila[0] = 1
    for i in range(1, n + 1):
        # Iteramos de derecha a izquierda
        j = min(i, k)
        while j > 0:
            fila[j] = fila[j] + fila[j - 1]
            j -= 1
    return fila[k]


# ====================================================================
# EJERCICIO 4 — Subsecuencia común máxima (LCS) con reconstrucción
# ====================================================================
#
# CONTEXTO. Dadas dos cadenas X e Y, encontrar la subsecuencia mas
# larga que es comun a ambas (no necesariamente contigua).
#
# CONEXIÓN CON TESTING. LCS esta detras de git diff. En automatizacion
# con golden files, LCS nos permite identificar exactamente que lineas
# de la salida observada difieren de la esperada.
#
# TAREA. Implementar lcs(x, y) que retorne (longitud, subsecuencia).
# Si hay varias soluciones validas, retornar cualquiera.
# ====================================================================

def lcs(x: str, y: str) -> Tuple[int, str]:
    """Calcula la subsecuencia comun maxima de dos cadenas."""
    # TODO: implementar
    m, n = len(x), len(y)
    L = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if x[i - 1] == y[j - 1]:
                L[i][j] = L[i - 1][j - 1] + 1
            else:
                L[i][j] = max(L[i - 1][j], L[i][j - 1])

    # Reconstruccion
    i, j = m, n
    chars = []
    while i > 0 and j > 0:
        if x[i - 1] == y[j - 1]:
            chars.append(x[i - 1])
            i -= 1
            j -= 1
        elif L[i - 1][j] >= L[i][j - 1]:
            i -= 1
        else:
            j -= 1
    chars.reverse()
    return L[m][n], "".join(chars)


# ====================================================================
# EJERCICIO 5 — Camino de mínimo costo con reconstrucción
# ====================================================================
#
# CONTEXTO. En una grilla m x n, cada celda tiene un costo. Empezamos
# en (0,0) y queremos llegar a (m-1, n-1) minimizando la suma de
# costos. Solo movimientos derecha y abajo.
#
# CONEXIÓN CON TESTING. Modela coverage de caminos en grafos de
# control: encontrar el camino mas barato (menor numero de
# instrucciones, menor consumo de memoria) que cubra una rama dada.
#
# TAREA. Implementar camino_minimo(grilla) que retorne (costo_minimo,
# camino) donde camino es la lista de coordenadas (i, j) recorridas
# en orden desde (0, 0) hasta la celda final.
# ====================================================================

def camino_minimo(grilla: List[List[int]]) -> Tuple[int, List[Tuple[int, int]]]:
    """Calcula el costo y el camino minimo en una grilla."""
    # TODO: implementar
    m = len(grilla)
    n = len(grilla[0]) if m > 0 else 0
    if m == 0 or n == 0:
        return 0, []

    dp = [[0] * n for _ in range(m)]
    dp[0][0] = grilla[0][0]
    for j in range(1, n):
        dp[0][j] = dp[0][j - 1] + grilla[0][j]
    for i in range(1, m):
        dp[i][0] = dp[i - 1][0] + grilla[i][0]
    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = grilla[i][j] + min(dp[i - 1][j], dp[i][j - 1])

    # Reconstruccion
    camino = [(m - 1, n - 1)]
    i, j = m - 1, n - 1
    while (i, j) != (0, 0):
        if i == 0:
            j -= 1
        elif j == 0:
            i -= 1
        elif dp[i - 1][j] < dp[i][j - 1]:
            i -= 1
        else:
            j -= 1
        camino.append((i, j))
    camino.reverse()
    return dp[m - 1][n - 1], camino


# ====================================================================
# EJERCICIO 6 — Asignación óptima de recursos
# ====================================================================
#
# CONTEXTO. Tenemos R unidades de un recurso y N proyectos, cada uno
# con una funcion de retorno f_i(x) que da la ganancia al asignar x
# unidades. Maximizar la ganancia total.
#
# CONEXIÓN CON TESTING. Distribuir un presupuesto de horas de testing
# entre distintos modulos o entre tipos de prueba (unitaria,
# integracion, e2e, rendimiento) cuando los rendimientos son no
# lineales.
#
# TAREA. Implementar asignacion_recursos(funciones, R) que retorne
# (ganancia_max, asignacion) donde asignacion[i] indica cuantas
# unidades se asignaron al proyecto i.
# ====================================================================

def asignacion_recursos(
    funciones: List[Callable[[int], int]], R: int
) -> Tuple[int, List[int]]:
    """Asignacion optima de R unidades entre N proyectos."""
    # TODO: implementar
    N = len(funciones)
    if N == 0 or R < 0:
        return 0, [0] * N

    dp = [[0] * (R + 1) for _ in range(N + 1)]
    elec = [[0] * (R + 1) for _ in range(N + 1)]

    for i in range(1, N + 1):
        for r in range(R + 1):
            mejor = -1
            mejor_x = 0
            for x in range(r + 1):
                ganancia = funciones[i - 1](x) + dp[i - 1][r - x]
                if ganancia > mejor:
                    mejor = ganancia
                    mejor_x = x
            dp[i][r] = mejor
            elec[i][r] = mejor_x

    # Reconstruccion
    asignacion = [0] * N
    r = R
    for i in range(N, 0, -1):
        x = elec[i][r]
        asignacion[i - 1] = x
        r -= x
    return dp[N][R], asignacion


# ====================================================================
# CASO INTEGRADOR — Priorización de regresión combinada
# ====================================================================
#
# CONTEXTO. Una empresa tiene 100 horas de testing al mes. Debe
# distribuirlas entre 4 tipos de prueba con funciones de detección
# de defectos no lineales. Ademas, dentro del tiempo asignado a
# pruebas unitarias, debe seleccionar que casos especificos ejecutar
# de un catalogo finito (mochila 0/1).
#
# Esto combina ASIGNACION (paso 1) + MOCHILA (paso 2) en un mismo
# escenario realista.
#
# TAREA. La funcion ya esta resuelta como demostracion. Los
# estudiantes deben leerla, entender la composicion y proponer una
# variante que cubra al menos cinco modulos.
# ====================================================================

def caso_integrador_demo() -> dict:
    """
    Demuestra la composicion de asignacion + mochila aplicada al
    presupuesto anual de pruebas.
    """
    # Funciones de retorno para 4 tipos de prueba (rendimientos
    # decrecientes — defectos detectados por hora invertida).
    def f_unitaria(h):
        return min(h * 8, 60 + h)

    def f_integracion(h):
        return min(h * 5, 40 + h // 2)

    def f_e2e(h):
        return min(h * 3, 25 + h // 3)

    def f_rendimiento(h):
        return h * 2

    R = 100  # horas totales
    ganancia, distribucion = asignacion_recursos(
        [f_unitaria, f_integracion, f_e2e, f_rendimiento], R
    )

    # Dentro de las horas asignadas a unitaria, selecciono casos.
    horas_unit = distribucion[0]
    pesos = [2, 3, 4, 5, 6, 7]   # horas que toma cada caso
    valores = [3, 5, 8, 9, 11, 13]  # valor esperado de cada caso
    valor_unit, casos_elegidos = mochila_01(pesos, valores, horas_unit)

    return {
        "ganancia_total_estimada": ganancia,
        "distribucion_horas": {
            "unitaria": distribucion[0],
            "integracion": distribucion[1],
            "e2e": distribucion[2],
            "rendimiento": distribucion[3],
        },
        "casos_unitaria_seleccionados": casos_elegidos,
        "valor_casos_unitaria": valor_unit,
    }


# ====================================================================
# TESTS — pytest
# ====================================================================
# Los siguientes tests cubren cada ejercicio. La barra de aprobación
# es 100% — todo debe pasar para considerar el taller resuelto.
# ====================================================================


# ---------- Tests del Ejercicio 1: Fibonacci ----------

class TestFibonacci:
    def test_casos_base(self):
        assert fibonacci(0) == 0
        assert fibonacci(1) == 1

    def test_valores_pequenos(self):
        assert fibonacci(2) == 1
        assert fibonacci(5) == 5
        assert fibonacci(10) == 55

    def test_valor_grande(self):
        # Sin memoizacion esto seria infactible.
        assert fibonacci(50) == 12_586_269_025

    def test_consistencia_recurrencia(self):
        # F(n) = F(n-1) + F(n-2) para todo n >= 2.
        for n in range(2, 30):
            assert fibonacci(n) == fibonacci(n - 1) + fibonacci(n - 2)

    def test_n_negativo_lanza(self):
        with pytest.raises(ValueError):
            fibonacci(-1)


# ---------- Tests del Ejercicio 2: Mochila 0/1 ----------

class TestMochila01:
    def test_caso_basico(self):
        valor, elegidos = mochila_01([2, 3, 4, 5], [3, 4, 5, 6], 5)
        assert valor == 7
        # Debe elegir los objetos cuyo peso sume <= 5
        assert sum([2, 3, 4, 5][i] for i in elegidos) <= 5
        # Y cuyo valor sume exactamente 7
        assert sum([3, 4, 5, 6][i] for i in elegidos) == 7

    def test_capacidad_cero(self):
        valor, elegidos = mochila_01([1, 2, 3], [10, 20, 30], 0)
        assert valor == 0
        assert elegidos == []

    def test_lista_vacia(self):
        valor, elegidos = mochila_01([], [], 10)
        assert valor == 0
        assert elegidos == []

    def test_un_solo_objeto_cabe(self):
        valor, elegidos = mochila_01([3], [10], 5)
        assert valor == 10
        assert elegidos == [0]

    def test_un_solo_objeto_no_cabe(self):
        valor, elegidos = mochila_01([10], [100], 5)
        assert valor == 0
        assert elegidos == []

    def test_pesos_valores_distintas_longitudes(self):
        with pytest.raises(ValueError):
            mochila_01([1, 2], [1], 5)


# ---------- Tests del Ejercicio 3: Binomial ----------

class TestBinomial:
    def test_casos_base(self):
        assert binomial(0, 0) == 1
        assert binomial(5, 0) == 1
        assert binomial(5, 5) == 1

    def test_valores_clasicos(self):
        assert binomial(5, 2) == 10
        assert binomial(10, 3) == 120
        assert binomial(20, 10) == 184_756

    def test_simetria(self):
        # C(n, k) = C(n, n-k)
        for n in range(15):
            for k in range(n + 1):
                assert binomial(n, k) == binomial(n, n - k)

    def test_recurrencia_pascal(self):
        # C(n, k) = C(n-1, k-1) + C(n-1, k)
        for n in range(2, 15):
            for k in range(1, n):
                assert binomial(n, k) == binomial(n - 1, k - 1) + binomial(n - 1, k)

    def test_valores_invalidos(self):
        assert binomial(5, -1) == 0
        assert binomial(5, 6) == 0


# ---------- Tests del Ejercicio 4: LCS ----------

class TestLCS:
    def test_caso_clasico(self):
        long_, sub = lcs("AGCAT", "GAC")
        assert long_ == 2
        assert len(sub) == 2

    def test_cadenas_iguales(self):
        long_, sub = lcs("ABC", "ABC")
        assert long_ == 3
        assert sub == "ABC"

    def test_cadena_vacia(self):
        long_, sub = lcs("", "ABC")
        assert long_ == 0
        assert sub == ""
        long_, sub = lcs("ABC", "")
        assert long_ == 0
        assert sub == ""

    def test_sin_caracteres_comunes(self):
        long_, sub = lcs("ABC", "DEF")
        assert long_ == 0
        assert sub == ""

    def test_subsecuencia_es_valida(self):
        # La subsecuencia retornada debe aparecer en orden en ambas cadenas.
        x, y = "PRUEBASOFTWARE", "PRUEBASUNITARIAS"
        long_, sub = lcs(x, y)
        assert _es_subsecuencia(sub, x)
        assert _es_subsecuencia(sub, y)
        assert len(sub) == long_


def _es_subsecuencia(sub: str, completa: str) -> bool:
    """Verifica que sub aparece en orden dentro de completa."""
    it = iter(completa)
    return all(c in it for c in sub)


# ---------- Tests del Ejercicio 5: Camino mínimo ----------

class TestCaminoMinimo:
    def test_caso_clasico(self):
        grilla = [[1, 3, 1], [1, 5, 1], [4, 2, 1]]
        costo, camino = camino_minimo(grilla)
        assert costo == 7
        # El camino debe empezar en (0,0) y terminar en (2,2)
        assert camino[0] == (0, 0)
        assert camino[-1] == (2, 2)
        # La suma del camino debe coincidir con el costo
        assert sum(grilla[i][j] for i, j in camino) == costo

    def test_un_solo_renglon(self):
        grilla = [[1, 2, 3, 4]]
        costo, camino = camino_minimo(grilla)
        assert costo == 10
        assert camino == [(0, 0), (0, 1), (0, 2), (0, 3)]

    def test_una_sola_columna(self):
        grilla = [[1], [2], [3], [4]]
        costo, camino = camino_minimo(grilla)
        assert costo == 10
        assert camino == [(0, 0), (1, 0), (2, 0), (3, 0)]

    def test_celda_unica(self):
        costo, camino = camino_minimo([[5]])
        assert costo == 5
        assert camino == [(0, 0)]

    def test_movimientos_validos(self):
        # Solo derecha o abajo
        grilla = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        _, camino = camino_minimo(grilla)
        for k in range(1, len(camino)):
            di = camino[k][0] - camino[k - 1][0]
            dj = camino[k][1] - camino[k - 1][1]
            assert (di, dj) in [(0, 1), (1, 0)]


# ---------- Tests del Ejercicio 6: Asignación de recursos ----------

class TestAsignacionRecursos:
    def test_caso_basico(self):
        # Tres proyectos identicos con f(x) = x*x. Optimo: 4 a uno solo.
        f = lambda x: x * x
        ganancia, asignacion = asignacion_recursos([f, f, f], 4)
        # Por convexidad, concentrar todo en uno es optimo: 4*4 = 16.
        assert ganancia == 16
        assert sum(asignacion) == 4

    def test_rendimientos_decrecientes_reparte(self):
        # Funciones concavas — el optimo reparte.
        import math

        def f(x):
            return int(10 * math.sqrt(x)) if x > 0 else 0

        ganancia, asignacion = asignacion_recursos([f, f], 10)
        # El optimo (5, 5) deberia dominar a (10, 0)
        assert sum(asignacion) == 10
        assert ganancia >= f(5) + f(5)
        assert ganancia >= f(10) + f(0)

    def test_lista_vacia(self):
        ganancia, asignacion = asignacion_recursos([], 10)
        assert ganancia == 0
        assert asignacion == []

    def test_recurso_cero(self):
        f = lambda x: x * 2
        ganancia, asignacion = asignacion_recursos([f, f, f], 0)
        assert ganancia == 0
        assert asignacion == [0, 0, 0]

    def test_consistencia_reconstruccion(self):
        # La suma de las asignaciones debe ser <= R y debe coincidir
        # con el valor reportado por dp.
        funciones = [
            lambda x: 4 * x - x * x // 2,
            lambda x: 3 * x,
            lambda x: 5 * x - x // 2,
        ]
        ganancia, asignacion = asignacion_recursos(funciones, 8)
        assert sum(asignacion) <= 8
        valor_reconstruido = sum(f(x) for f, x in zip(funciones, asignacion))
        assert valor_reconstruido == ganancia


# ---------- Test del caso integrador ----------

class TestCasoIntegrador:
    def test_demo_ejecuta_y_es_consistente(self):
        resultado = caso_integrador_demo()
        # La distribucion debe sumar 100 horas.
        total = sum(resultado["distribucion_horas"].values())
        assert total == 100
        # Los casos elegidos deben caber en las horas de unitaria.
        horas_unit = resultado["distribucion_horas"]["unitaria"]
        pesos = [2, 3, 4, 5, 6, 7]
        peso_total = sum(pesos[i] for i in resultado["casos_unitaria_seleccionados"])
        assert peso_total <= horas_unit
        # La ganancia total debe ser positiva.
        assert resultado["ganancia_total_estimada"] > 0


if __name__ == "__main__":
    # Permite ejecutar los tests directamente con `python` sin pytest.
    import sys
    sys.exit(pytest.main([__file__, "-v"]))
