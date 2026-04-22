
# Fibonacci con memoización — O(n) tiempo y espacio
from functools import lru_cache

# ENFOQUE 1: Decorador lru_cache (pythónico)
@lru_cache(maxsize=None)
def fib_memo(n: int) -> int:
    """
    lru_cache guarda resultados automáticamente.
    Primera vez fib_memo(10) → calcula
    Segunda vez fib_memo(10) → retorna del caché
    """
    if n <= 1:
        return n
    return fib_memo(n-1) + fib_memo(n-2)


def fib_tabla(n: int) -> int:
    """
    Llenamos la tabla de ABAJO HACIA ARRIBA.
    Empezamos con casos base y construimos
    hasta llegar a la respuesta.
    """
    if n <= 1:
        return n

    # Tabla DP: dp[i] = i-ésimo número de Fibonacci
    dp = [0] * (n + 1)
    dp[0] = 0  # caso base
    dp[1] = 1  # caso base

    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]  # recurrencia

    return dp[n]

# OPTIMIZACIÓN DE ESPACIO a O(1):
# Solo necesitamos los 2 valores anteriores
def fib_optimo(n: int) -> int:
    if n <= 1: return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b   # solo guardamos 2 valores
    return b

# Traza para n=6:
# dp = [0, 1, 1, 2, 3, 5, 8]
# dp[2]=dp[1]+dp[0]=1, dp[3]=2, dp[4]=3, dp[5]=5, dp[6]=8


# coin_change.py — O(amount × len(coins)) tiempo y espacio

def coin_change(monedas: list, objetivo: int) -> int:
    """
    dp[i] = mínimo número de monedas para formar cantidad i
    Recurrencia: dp[i] = min(dp[i - coin] + 1) para cada coin
    """
    INF = float('inf')
    dp = [INF] * (objetivo + 1)
    dp[0] = 0  # caso base: 0 monedas para cantidad 0

    for cantidad in range(1, objetivo + 1):
        for moneda in monedas:
            if moneda <= cantidad:
                dp[cantidad] = min(dp[cantidad],dp[cantidad - moneda] + 1)
    return dp[objetivo] if dp[objetivo] != INF else -1

# Ejemplo: monedas=[1,5,10,25], objetivo=36
print(coin_change([1,5,10,25], 36))  # 3 (25+10+1)
print(coin_change([2], 3))            # -1 (imposible)


¿Por qué DP y no Greedy?


# lcs.py — O(m × n) tiempo y espacio

def lcs(s1: str, s2: str) -> int:
    """
    LCS = subsecuencia más larga común a ambas cadenas.
    (No necesariamente contigua, pero en orden)
    """
    m, n = len(s1), len(s2)
    # dp[i][j] = longitud LCS de s1[:i] y s2[:j]
    dp = [[0]*(n+1) for _ in range(m+1)]

    for i in range(1, m+1):
        for j in range(1, n+1):
            if s1[i-1] == s2[j-1]:           # caracteres iguales
                dp[i][j] = dp[i-1][j-1] + 1
            else:                             # tomar el mejor previo
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    return dp[m][n]

# Ejemplo: LCS('ABCBDAB', 'BDCABA') = 4 (ej: 'BCBA' o 'BCAB')
print(lcs('ABCBDAB', 'BDCABA'))  # 4


# knapsack.py — 0/1 Knapsack O(n × W)

def knapsack(pesos, valores, capacidad):
    """
    Para cada ítem: ¿incluir o no incluir?
    dp[i][w] = máximo valor con ítems 0..i y capacidad w
    """
    n = len(pesos)
    dp = [[0]*(capacidad+1) for _ in range(n+1)]

    for i in range(1, n+1):
        for w in range(capacidad+1):
            # Opción 1: no incluir ítem i
            dp[i][w] = dp[i-1][w]
            # Opción 2: incluir ítem i (si cabe)
            if pesos[i-1] <= w:
                con_item = dp[i-1][w-pesos[i-1]] + valores[i-1]
                dp[i][w] = max(dp[i][w], con_item)

    return dp[n][capacidad]

# Ejemplo:
pesos   = [2, 3, 4, 5]
valores = [3, 4, 5, 6]
print(knapsack(pesos, valores, 5))  # 7 (items 0 y 1)



# edit_distance.py — O(m × n)

def edit_distance(s1: str, s2: str) -> int:
    """
    Operaciones permitidas:
    - Insertar carácter
    - Eliminar carácter
    - Reemplazar carácter
    dp[i][j] = mín. ops para transformar s1[:i] en s2[:j]
    """
    m, n = len(s1), len(s2)
    dp = [[0]*(n+1) for _ in range(m+1)]

    # Casos base: desde/hacia cadena vacía
    for i in range(m+1): dp[i][0] = i
    for j in range(n+1): dp[0][j] = j

    for i in range(1, m+1):
        for j in range(1, n+1):
            if s1[i-1] == s2[j-1]:  # sin operación
                dp[i][j] = dp[i-1][j-1]
            else:                    # min de 3 ops
                dp[i][j] = 1 + min(dp[i-1][j],
                                    dp[i][j-1],
                                    dp[i-1][j-1])
    return dp[m][n]

print(edit_distance('kitten', 'sitting'))  # 3


# fibonacci_trace.py — Con contador de llamadas

llamadas = {'total': 0, 'cache_hits': 0}

def fib_traced(n: int, memo: dict = None) -> int:
    if memo is None: memo = {}
    llamadas['total'] += 1

    if n in memo:
        llamadas['cache_hits'] += 1
        return memo[n]

    if n <= 1:
        memo[n] = n
        return n

    resultado = fib_traced(n-1, memo) + fib_traced(n-2, memo)
    memo[n] = resultado
    return resultado

# Traza para fib(6):
memo = {}
fib_traced(6, memo)
print(f'Total llamadas: {llamadas["total"]}')        # 11
print(f'Cache hits:     {llamadas["cache_hits"]}')   # 4
print(f'Memo final: {memo}')
# {0: 0, 1: 1, 2: 1, 3: 2, 4: 3, 5: 5, 6: 8}



# lcs_con_reconstruccion.py
def lcs_con_traza(s1: str, s2: str):
    m, n = len(s1), len(s2)
    dp = [[0]*(n+1) for _ in range(m+1)]
    for i in range(1, m+1):
        for j in range(1, n+1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
    # Reconstruir la subsecuencia
    lcs_str, i, j = [], m, n
    while i > 0 and j > 0:
        if s1[i-1] == s2[j-1]:
            lcs_str.append(s1[i-1])
            i -= 1; j -= 1
        elif dp[i-1][j] > dp[i][j-1]:
            i -= 1
        else:
            j -= 1
    return dp[m][n], ''.join(reversed(lcs_str))



longitud, seq = lcs_con_traza('ABCBDAB', 'BDCABA')
print(f'LCS={longitud}, sec={seq}')  # 4, 'BCBA'



# test_selection_knapsack.py
def seleccionar_tests(tests, presupuesto_min):
    """
    tests = [(nombre, tiempo_min, riesgo_cubierto), ...]
    Maximiza riesgo_cubierto sin superar presupuesto_min
    """
    n = len(tests)
    dp = [[0]*(presupuesto_min+1) for _ in range(n+1)]
    for i in range(1, n+1):
        nombre, tiempo, riesgo = tests[i-1]
        for t in range(presupuesto_min+1):
            dp[i][t] = dp[i-1][t]
            if tiempo <= t:
                dp[i][t] = max(dp[i][t], dp[i-1][t-tiempo]+riesgo)
    return dp[n][presupuesto_min]



# lis.py — Longest Increasing Subsequence — O(n²)

def lis(nums: list) -> int:
    """
    dp[i] = longitud de la LIS que termina en índice i
    """
    if not nums: return 0
    n = len(nums)
    dp = [1] * n  # cada elemento es LIS de longitud 1

    for i in range(1, n):
        for j in range(i):
            if nums[j] < nums[i]:
                dp[i] = max(dp[i], dp[j] + 1)

    return max(dp)

# Ejemplo:
print(lis([10, 9, 2, 5, 3, 7, 101, 18]))  # 4 ([2,3,7,101] o [2,5,7,101])

# Versión O(n log n) con binary search — más eficiente
# import bisect
# def lis_optimo(nums):
#     tails = []
#     for n in nums:
#         i = bisect.bisect_left(tails, n)
#         if i == len(tails): tails.append(n)
#         else: tails[i] = n
#     return len(tails)


# grid_paths.py — O(m × n)

def caminos_grilla(m: int, n: int) -> int:
    """
    Solo se puede mover ABAJO o DERECHA.
    dp[i][j] = número de caminos desde (0,0) hasta (i,j)
    Recurrencia: dp[i][j] = dp[i-1][j] + dp[i][j-1]
    """
    dp = [[1]*n for _ in range(m)]
    # Primera fila y primera columna: solo 1 camino

    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = dp[i-1][j] + dp[i][j-1]

    return dp[m-1][n-1]

# Ejemplos:
print(caminos_grilla(3, 3))   # 6
print(caminos_grilla(5, 5))   # 70
print(caminos_grilla(10, 10)) # 48620

# Relación con combinatoria: C(m+n-2, m-1)



# subset_sum.py — O(n × sum)

def subset_sum(nums: list, target: int) -> bool:
    """
    dp[i][s] = True si existe subconjunto de nums[0..i]
              con suma exactamente s
    """
    n = len(nums)
    dp = [[False]*(target+1) for _ in range(n+1)]

    # Caso base: suma 0 siempre es alcanzable (conjunto vacío)
    for i in range(n+1):
        dp[i][0] = True

    for i in range(1, n+1):
        for s in range(1, target+1):
            dp[i][s] = dp[i-1][s]  # no incluir nums[i-1]
            if nums[i-1] <= s:
                dp[i][s] = dp[i][s] or dp[i-1][s-nums[i-1]]

    return dp[n][target]

# Ejemplo:
print(subset_sum([3, 34, 4, 12, 5, 2], 9))   # True (4+5 o 3+4+2)
print(subset_sum([3, 34, 4, 12, 5, 2], 30))  # False
