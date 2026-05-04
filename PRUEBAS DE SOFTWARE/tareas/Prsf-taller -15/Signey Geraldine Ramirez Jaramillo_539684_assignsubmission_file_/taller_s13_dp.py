"""
============================================================
Taller en Clase | Sesión 13 | Programación Dinámica
UNIVERSITARIA DE COLOMBIA
Ingeniería de Software · Pruebas de Software · 7mo Semestre
Mg. Sergio Alejandro Burbano Mena | Abril 2026
============================================================
"""

import time
import sys
import matplotlib.pyplot as plt
from functools import lru_cache

# ============================================================
# PARTE 1 — FIBONACCI DP (15 min)
# ============================================================

# --- 1.1 Naive (versión recursiva sin memorización) ---
llamadas_naive = 0

def fib_naive(n):
    """Fibonacci recursivo sin optimización. Complejidad O(2^n)."""
    global llamadas_naive
    llamadas_naive += 1
    if n <= 1:
        return n
    return fib_naive(n - 1) + fib_naive(n - 2)


# --- 1.2 Memoización con @lru_cache ---
llamadas_memo = 0

@lru_cache(maxsize=None)
def fib_memo(n):
    """
    Fibonacci con memoización usando @lru_cache.
    Complejidad tiempo: O(n) | Complejidad espacio: O(n)
    Cada subproblema se calcula UNA sola vez y se cachea.
    """
    global llamadas_memo
    llamadas_memo += 1
    if n <= 1:
        return n
    return fib_memo(n - 1) + fib_memo(n - 2)


# --- 1.3 Tabulación (bottom-up DP) ---
def fib_tabla(n):
    """
    Fibonacci con tabulación (bottom-up).
    Complejidad tiempo: O(n) | Complejidad espacio: O(n)
    Se construye la tabla desde los casos base hacia arriba.
    """
    if n <= 1:
        return n
    dp = [0] * (n + 1)
    dp[0] = 0
    dp[1] = 1
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]
    return dp[n]


# --- Ejecutar y comparar para n=30 ---
print("=" * 60)
print("PARTE 1 — FIBONACCI DP")
print("=" * 60)

N = 30

# Naive
llamadas_naive = 0
sys.setrecursionlimit(10000)
t0 = time.perf_counter()
resultado_naive = fib_naive(N)
t_naive = time.perf_counter() - t0
print(f"\n[Naive]      fib({N}) = {resultado_naive}")
print(f"             Llamadas recursivas : {llamadas_naive:,}")
print(f"             Tiempo              : {t_naive*1000:.4f} ms")

# Memo
llamadas_memo = 0
fib_memo.cache_clear()
t0 = time.perf_counter()
resultado_memo = fib_memo(N)
t_memo = time.perf_counter() - t0
print(f"\n[Memo]       fib({N}) = {resultado_memo}")
print(f"             Llamadas (con cache): {llamadas_memo}")
print(f"             Tiempo              : {t_memo*1000:.6f} ms")

# Tabla
t0 = time.perf_counter()
resultado_tabla = fib_tabla(N)
t_tabla = time.perf_counter() - t0
print(f"\n[Tabulación] fib({N}) = {resultado_tabla}")
print(f"             Tiempo              : {t_tabla*1000:.6f} ms")

print(f"\n  Speedup Memo  vs Naive : {t_naive/t_memo:.0f}x más rápido")
print(f"  Speedup Tabla vs Naive : {t_naive/t_tabla:.0f}x más rápido")

# --- Gráfica 1: Llamadas recursivas vs n ---
ns = list(range(1, 26))
calls_naive_list = []
calls_memo_list  = []

for n_val in ns:
    llamadas_naive = 0
    fib_naive(n_val)
    calls_naive_list.append(llamadas_naive)

    llamadas_memo = 0
    fib_memo.cache_clear()
    fib_memo(n_val)
    calls_memo_list.append(llamadas_memo)

fig, axes = plt.subplots(1, 2, figsize=(14, 5))
fig.suptitle("Sesión 13 — Programación Dinámica", fontsize=14, fontweight="bold")

axes[0].plot(ns, calls_naive_list, color="tomato",  marker="o", label="Naive O(2ⁿ)")
axes[0].plot(ns, calls_memo_list,  color="steelblue", marker="s", label="Memo O(n)")
axes[0].set_title("Llamadas Recursivas: Naive vs Memo")
axes[0].set_xlabel("n")
axes[0].set_ylabel("Número de llamadas")
axes[0].legend()
axes[0].grid(True, linestyle="--", alpha=0.5)


# ============================================================
# PARTE 2 — COIN CHANGE (25 min)
# ============================================================

print("\n" + "=" * 60)
print("PARTE 2 — COIN CHANGE")
print("=" * 60)

# --- 2.1 Implementación básica ---
def coin_change(monedas, objetivo):
    """
    Mínimo número de monedas para formar 'objetivo'.
    DP bottom-up: dp[i] = mínimas monedas para formar i pesos.
    Complejidad: O(objetivo * len(monedas))
    """
    INF = float("inf")
    dp = [INF] * (objetivo + 1)
    dp[0] = 0                          # Caso base: 0 monedas para 0 pesos

    for i in range(1, objetivo + 1):
        for moneda in monedas:
            if moneda <= i and dp[i - moneda] + 1 < dp[i]:
                dp[i] = dp[i - moneda] + 1

    return dp[objetivo] if dp[objetivo] != INF else -1


monedas_co = [50, 100, 200, 500, 1000]
objetivo   = 2450
resultado_cc = coin_change(monedas_co, objetivo)
print(f"\n[2.1] Mínimas monedas para {objetivo} pesos: {resultado_cc}")
# Esperado: 5 monedas → 1000+1000+200+200+50


# --- 2.2 Traza de la tabla dp[] (primeros 10 múltiplos de 50) ---
print("\n[2.2] Traza de dp[] — primeros 10 valores significativos (múltiplos de 50):")
INF = float("inf")
dp_trace = [INF] * (objetivo + 1)
dp_trace[0] = 0
for i in range(1, objetivo + 1):
    for m in monedas_co:
        if m <= i and dp_trace[i - m] + 1 < dp_trace[i]:
            dp_trace[i] = dp_trace[i - m] + 1

indices  = [0, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500]
valores  = [dp_trace[i] for i in indices]
header   = " | ".join(f"{i:>5}" for i in indices)
row      = " | ".join(f"{v:>5}" for v in valores)
print(f"  i    : {header}")
print(f"  dp[i]: {row}")


# --- 2.3 Extensión — Reconstrucción de monedas usadas ---
def coin_change_con_monedas(monedas, objetivo):
    """
    Igual al anterior + reconstrucción de qué monedas se usaron.
    'used[i]' guarda la moneda que se usó para alcanzar dp[i].
    """
    INF  = float("inf")
    dp   = [INF] * (objetivo + 1)
    used = [0]  * (objetivo + 1)
    dp[0] = 0

    for i in range(1, objetivo + 1):
        for moneda in monedas:
            if moneda <= i and dp[i - moneda] + 1 < dp[i]:
                dp[i]   = dp[i - moneda] + 1
                used[i] = moneda

    if dp[objetivo] == INF:
        return -1, []

    # Reconstrucción hacia atrás
    lista_monedas = []
    actual = objetivo
    while actual > 0:
        lista_monedas.append(used[actual])
        actual -= used[actual]

    return dp[objetivo], sorted(lista_monedas, reverse=True)


n_monedas, lista = coin_change_con_monedas(monedas_co, objetivo)
print(f"\n[2.3] Reconstrucción: {n_monedas} monedas → {lista}")
print(f"      Verificación: suma = {sum(lista)} pesos")


# ============================================================
# PARTE 3 — DP APLICADO A TESTING (20 min)
# ============================================================

print("\n" + "=" * 60)
print("PARTE 3 — DP APLICADO A TESTING (Knapsack 0/1)")
print("=" * 60)

tests = [
    ("test_login_usuarios",    3, 90),
    ("test_pagos_integracion", 7, 95),
    ("test_reportes_pdf",      5, 70),
    ("test_carga_concurrent",  9, 60),
    ("test_api_estudiantes",   2, 80),
    ("test_seguridad_xss",     4, 85),
    ("test_notificaciones",    3, 50),
    ("test_dashboard",         5, 65),
]


# --- 3.1 Implementación Knapsack 0/1 ---
def seleccionar_tests(tests, presupuesto):
    """
    Knapsack 0/1 para selección óptima de tests.
    tests    : lista de (nombre, tiempo, puntos)
    presupuesto: tiempo total disponible en minutos
    Complejidad: O(n * presupuesto)
    """
    n  = len(tests)
    # dp[i][w] = máx puntos usando los primeros i tests con w minutos
    dp = [[0] * (presupuesto + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        nombre, tiempo, puntos = tests[i - 1]
        for w in range(presupuesto + 1):
            # Opción 1: No incluir el test i
            dp[i][w] = dp[i - 1][w]
            # Opción 2: Incluir el test i (si cabe en el presupuesto)
            if tiempo <= w:
                con_test = dp[i - 1][w - tiempo] + puntos
                if con_test > dp[i][w]:
                    dp[i][w] = con_test

    # Reconstrucción — recorremos la tabla hacia atrás
    seleccionados = []
    w = presupuesto
    for i in range(n, 0, -1):
        if dp[i][w] != dp[i - 1][w]:          # el test i fue incluido
            seleccionados.append(tests[i - 1])
            w -= tests[i - 1][1]

    cobertura_total = dp[n][presupuesto]
    tiempo_usado    = sum(t[1] for t in seleccionados)

    return seleccionados, cobertura_total, tiempo_usado


# --- 3.2 Solución óptima con presupuesto = 20 min ---
PRESUPUESTO = 20
sel, cobertura, tiempo_usado = seleccionar_tests(tests, PRESUPUESTO)

print(f"\n[3.2] Solución ÓPTIMA (Knapsack 0/1) — Presupuesto: {PRESUPUESTO} min")
print(f"  {'Test':<30} {'Tiempo':>7} {'Puntos':>7}")
print(f"  {'-'*46}")
for nombre, tiempo, puntos in sel:
    print(f"  {nombre:<30} {tiempo:>5} min  {puntos:>5} pts")
print(f"  {'-'*46}")
print(f"  {'TOTAL':<30} {tiempo_usado:>5} min  {cobertura:>5} pts")


# --- 3.3 Comparación con Greedy (ratio puntos/tiempo) ---
def seleccionar_tests_greedy(tests, presupuesto):
    """
    Greedy: selecciona tests ordenados por ratio puntos/tiempo descendente.
    No garantiza la solución óptima global.
    """
    ordenados = sorted(tests, key=lambda t: t[2] / t[1], reverse=True)
    seleccionados = []
    tiempo_restante = presupuesto

    for nombre, tiempo, puntos in ordenados:
        if tiempo <= tiempo_restante:
            seleccionados.append((nombre, tiempo, puntos))
            tiempo_restante -= tiempo

    cobertura = sum(t[2] for t in seleccionados)
    tiempo_us = sum(t[1] for t in seleccionados)
    return seleccionados, cobertura, tiempo_us


sel_g, cob_g, t_g = seleccionar_tests_greedy(tests, PRESUPUESTO)

print(f"\n[3.3] Solución GREEDY (ratio pts/min) — Presupuesto: {PRESUPUESTO} min")
print(f"  {'Test':<30} {'Tiempo':>7} {'Puntos':>7}  {'Ratio':>6}")
print(f"  {'-'*54}")
for nombre, tiempo, puntos in sel_g:
    print(f"  {nombre:<30} {tiempo:>5} min  {puntos:>5} pts  {puntos/tiempo:>5.1f}")
print(f"  {'-'*54}")
print(f"  {'TOTAL':<30} {t_g:>5} min  {cob_g:>5} pts")

print(f"\n  ➤ Knapsack: {cobertura} pts en {tiempo_usado} min")
print(f"  ➤ Greedy  : {cob_g} pts en {t_g} min")
if cobertura > cob_g:
    print(f"  ✓ Knapsack es MEJOR por {cobertura - cob_g} puntos.")
elif cobertura == cob_g:
    print(f"  ≈ Ambos llegan al mismo resultado en este caso.")
else:
    print(f"  ✗ Greedy superó a Knapsack (situación inusual).")


# ============================================================
# GRÁFICA 2 — Comparación de cobertura DP vs Greedy por presupuesto
# ============================================================

presupuestos  = list(range(1, 31))
cob_dp_list   = []
cob_gr_list   = []

for p in presupuestos:
    _, c_dp, _ = seleccionar_tests(tests, p)
    _, c_gr, _ = seleccionar_tests_greedy(tests, p)
    cob_dp_list.append(c_dp)
    cob_gr_list.append(c_gr)

axes[1].plot(presupuestos, cob_dp_list, color="steelblue", marker="o", label="Knapsack DP (óptimo)")
axes[1].plot(presupuestos, cob_gr_list, color="orange",    marker="s", linestyle="--", label="Greedy")
axes[1].axvline(x=20, color="gray", linestyle=":", label="Presupuesto=20")
axes[1].set_title("Cobertura de Riesgo: Knapsack vs Greedy")
axes[1].set_xlabel("Presupuesto (minutos)")
axes[1].set_ylabel("Puntos de cobertura")
axes[1].legend()
axes[1].grid(True, linestyle="--", alpha=0.5)

plt.tight_layout()
plt.savefig("/mnt/user-data/outputs/grafica_dp_s13.png", dpi=150, bbox_inches="tight")
plt.show()
print("\n  Gráfica guardada: grafica_dp_s13.png")

print("\n" + "=" * 60)
print("FIN DEL TALLER — Sesión 13")
print("=" * 60)
