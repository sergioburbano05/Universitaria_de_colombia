"""
Selección óptima de tests con Knapsack 0/1
Pipeline CI: 25 minutos disponibles antes del deploy.
"""
from typing import List, Tuple


# ============================================================
# 3.1 / 3.2 — Datos del problema y Knapsack 0/1 (Programación Dinámica)
# ============================================================

TESTS = [
    # (nombre, tiempo_min, valor_cov_x_mut)
    ("test_login",            3, 85),
    ("test_calculo_promedio", 5, 95),
    ("test_deteccion_riesgo", 4, 90),
    ("test_exportar_pdf",     6, 70),
    ("test_exportar_excel",   5, 75),
    ("test_api_reportes",     3, 80),
    ("test_prediccion",       8, 65),
    ("test_ui_dashboard",     7, 60),
    ("test_concurrency",      9, 55),
    ("test_seguridad",        4, 88),
]


def seleccionar_tests_optimos(tests: List[Tuple[str, int, int]],
                              presupuesto: int) -> Tuple[int, List[str]]:
    """
    Knapsack 0/1 - Programación Dinámica.

    tests:        lista de (nombre, tiempo, valor)
    presupuesto:  capacidad máxima en minutos
    Retorna:      (valor_total, lista_de_nombres_seleccionados)
    """
    n = len(tests)
    # dp[i][w] = mejor valor usando los primeros i tests con presupuesto w
    dp = [[0] * (presupuesto + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        nombre, tiempo, valor = tests[i - 1]
        for w in range(presupuesto + 1):
            # Opción 1: NO incluir el test i
            dp[i][w] = dp[i - 1][w]
            # Opción 2: incluir el test i (si cabe)
            if tiempo <= w:
                candidato = dp[i - 1][w - tiempo] + valor
                if candidato > dp[i][w]:
                    dp[i][w] = candidato

    # Reconstrucción de la solución
    seleccionados = []
    w = presupuesto
    for i in range(n, 0, -1):
        if dp[i][w] != dp[i - 1][w]:
            nombre, tiempo, _ = tests[i - 1]
            seleccionados.append(nombre)
            w -= tiempo

    seleccionados.reverse()
    return dp[n][presupuesto], seleccionados


def seleccionar_tests_greedy(tests: List[Tuple[str, int, int]],
                             presupuesto: int) -> Tuple[int, List[str]]:
    """
    Heurística Greedy: ordenar por ratio valor/tiempo descendente
    y agregar mientras quepa.
    """
    ordenados = sorted(tests, key=lambda t: t[2] / t[1], reverse=True)
    seleccionados = []
    valor_total = 0
    tiempo_usado = 0
    for nombre, tiempo, valor in ordenados:
        if tiempo_usado + tiempo <= presupuesto:
            seleccionados.append(nombre)
            valor_total += valor
            tiempo_usado += tiempo
    return valor_total, seleccionados


def tiempo_total(nombres, tests):
    mapa = {n: t for n, t, _ in tests}
    return sum(mapa[n] for n in nombres)


# ============================================================
# 3.3 — Análisis comparativo
# ============================================================

if __name__ == "__main__":
    PRESUPUESTO = 25

    valor_dp, tests_dp = seleccionar_tests_optimos(TESTS, PRESUPUESTO)
    valor_g,  tests_g  = seleccionar_tests_greedy(TESTS, PRESUPUESTO)

    print("=" * 60)
    print(f"PRESUPUESTO: {PRESUPUESTO} minutos")
    print("=" * 60)

    print("\n--- SOLUCIÓN DP (Knapsack 0/1) ---")
    print(f"Valor total:  {valor_dp}")
    print(f"Tiempo usado: {tiempo_total(tests_dp, TESTS)} min")
    print(f"Tests:        {tests_dp}")

    print("\n--- SOLUCIÓN GREEDY (ratio valor/tiempo) ---")
    print(f"Valor total:  {valor_g}")
    print(f"Tiempo usado: {tiempo_total(tests_g, TESTS)} min")
    print(f"Tests:        {tests_g}")

    print("\n--- COMPARACIÓN ---")
    diff = valor_dp - valor_g
    pct = (diff / valor_g * 100) if valor_g else 0
    print(f"Diferencia absoluta: {diff}")
    print(f"Diferencia (%):      {pct:.2f}%")

    en_g_no_dp = set(tests_g) - set(tests_dp)
    en_dp_no_g = set(tests_dp) - set(tests_g)
    print(f"Tests en Greedy y NO en DP: {sorted(en_g_no_dp) or 'ninguno'}")
    print(f"Tests en DP y NO en Greedy: {sorted(en_dp_no_g) or 'ninguno'}")

    # ----------------------------------------------------------------
    # Análisis adicional: explorar otros presupuestos para mostrar que
    # la optimalidad de Greedy NO está garantizada (es solo coincidencia
    # con presupuesto = 25).
    # ----------------------------------------------------------------
    print("\n" + "=" * 60)
    print("ANÁLISIS DE SENSIBILIDAD: Greedy NO siempre es óptimo")
    print("=" * 60)
    print(f"{'Presup.':>8} | {'DP':>5} | {'Greedy':>6} | {'Δ':>4} | Greedy óptimo?")
    print("-" * 60)
    for p in range(10, 30):
        v_dp, _ = seleccionar_tests_optimos(TESTS, p)
        v_g, _ = seleccionar_tests_greedy(TESTS, p)
        diferencia = v_dp - v_g
        flag = "SI" if diferencia == 0 else "NO"
        print(f"{p:>8} | {v_dp:>5} | {v_g:>6} | {diferencia:>4} | {flag}")
