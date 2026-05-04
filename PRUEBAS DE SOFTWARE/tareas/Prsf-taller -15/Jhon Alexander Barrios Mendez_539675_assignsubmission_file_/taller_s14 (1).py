# =============================================================
# TALLER INTEGRADOR — SESIÓN 14 | PRUEBAS DE SOFTWARE
# Universitaria de Colombia | Mg. Sergio Alejandro Burbano Mena
# =============================================================

# =============================================================
# PARTE 2 — TESTING DINÁMICO
# =============================================================

# ── analitica.py (módulo a probar) ──────────────────────────

def detectar_estudiantes_riesgo(notas: list, umbral: float = 3.0) -> list:
    """
    Retorna estudiantes con promedio < umbral.
    """
    if not notas:
        return []
    riesgo = []
    for estudiante in notas:
        if not estudiante.get('materias'):
            continue
        suma = sum(m['nota'] for m in estudiante['materias'])
        promedio = suma / len(estudiante['materias'])
        if promedio < umbral:
            riesgo.append({'id': estudiante['id'], 'promedio': promedio})
    return riesgo


# =============================================================
# 2.2 BRANCH COVERAGE 100% — pytest
# =============================================================
import pytest

def test_lista_vacia():
    """Rama: notas vacía → retorna []"""
    resultado = detectar_estudiantes_riesgo([])
    assert resultado == []

def test_estudiante_sin_materias():
    """Rama: estudiante sin clave 'materias' → se omite (continue)"""
    notas = [{'id': 1}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert resultado == []

def test_estudiante_materias_vacias():
    """Rama: materias lista vacía → .get('materias') falsy → continue"""
    notas = [{'id': 2, 'materias': []}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert resultado == []

def test_estudiante_en_riesgo():
    """Rama: promedio < umbral → se agrega a riesgo"""
    notas = [{'id': 3, 'materias': [{'nota': 2.5}, {'nota': 2.0}]}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 3
    assert abs(resultado[0]['promedio'] - 2.25) < 0.001

def test_estudiante_aprobado():
    """Rama: promedio >= umbral → NO se agrega a riesgo"""
    notas = [{'id': 4, 'materias': [{'nota': 4.0}, {'nota': 3.5}]}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert resultado == []

def test_umbral_personalizado():
    """Rama: umbral distinto al default; estudiante bajo umbral custom"""
    notas = [{'id': 5, 'materias': [{'nota': 3.5}]}]
    # Con umbral=4.0 → 3.5 < 4.0 → en riesgo
    resultado = detectar_estudiantes_riesgo(notas, umbral=4.0)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 5

def test_mixto_varios_estudiantes():
    """Cubre múltiples ramas en una sola llamada"""
    notas = [
        {'id': 10, 'materias': [{'nota': 1.0}]},   # en riesgo
        {'id': 11, 'materias': [{'nota': 4.5}]},   # aprobado
        {'id': 12},                                  # sin materias
    ]
    resultado = detectar_estudiantes_riesgo(notas)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 10


# =============================================================
# 2.3 PROPIEDAD CON HYPOTHESIS
# =============================================================
from hypothesis import given, settings, strategies as st

# Estrategia: lista de estudiantes con estructura válida
estudiante_strategy = st.fixed_dictionaries({
    'id': st.integers(min_value=1, max_value=9999),
    'materias': st.lists(
        st.fixed_dictionaries({'nota': st.floats(min_value=0.0, max_value=5.0, allow_nan=False)}),
        min_size=1, max_size=10
    )
})

@given(
    notas=st.lists(estudiante_strategy, min_size=0, max_size=20),
    umbral=st.floats(min_value=0.0, max_value=5.0, allow_nan=False)
)
@settings(max_examples=200)
def test_propiedad_todo_riesgo_menor_umbral(notas, umbral):
    """
    PROPIEDAD: Todos los estudiantes retornados tienen promedio < umbral,
    y ningún estudiante con promedio >= umbral aparece en el resultado.
    """
    resultado = detectar_estudiantes_riesgo(notas, umbral=umbral)

    # Construir mapa id → promedio real
    promedios_reales = {}
    for e in notas:
        if e.get('materias'):
            p = sum(m['nota'] for m in e['materias']) / len(e['materias'])
            promedios_reales[e['id']] = p

    ids_resultado = {r['id'] for r in resultado}

    # P1: Todo id en resultado tiene promedio < umbral
    for r in resultado:
        assert r['promedio'] < umbral, (
            f"Estudiante {r['id']} con promedio {r['promedio']} no debería estar en riesgo (umbral={umbral})"
        )

    # P2: Todo estudiante con promedio < umbral debe estar en resultado
    for eid, prom in promedios_reales.items():
        if prom < umbral:
            assert eid in ids_resultado, (
                f"Estudiante {eid} con promedio {prom} < umbral {umbral} debería estar en riesgo"
            )


# =============================================================
# PARTE 3 — DP APLICADO: KNAPSACK 0/1
# =============================================================

def seleccionar_tests_optimos(tests, presupuesto):
    """
    tests: [(nombre, tiempo, valor), ...]
    Retorna (valor_total, lista_tests_seleccionados)
    Implementación Knapsack 0/1 con programación dinámica.
    """
    n = len(tests)
    # Tabla DP: dp[i][w] = máximo valor usando los primeros i tests con presupuesto w
    dp = [[0] * (presupuesto + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        nombre, tiempo, valor = tests[i - 1]
        for w in range(presupuesto + 1):
            # No incluir el test i
            dp[i][w] = dp[i - 1][w]
            # Incluir el test i si cabe
            if tiempo <= w:
                dp[i][w] = max(dp[i][w], dp[i - 1][w - tiempo] + valor)

    # Reconstruir cuáles tests se seleccionaron
    seleccionados = []
    w = presupuesto
    for i in range(n, 0, -1):
        if dp[i][w] != dp[i - 1][w]:
            nombre, tiempo, valor = tests[i - 1]
            seleccionados.append(nombre)
            w -= tiempo

    seleccionados.reverse()
    return dp[n][presupuesto], seleccionados


def seleccionar_tests_greedy(tests, presupuesto):
    """
    Estrategia greedy: ordenar por ratio valor/tiempo descendente,
    tomar mientras quede presupuesto.
    """
    ordenados = sorted(tests, key=lambda t: t[2] / t[1], reverse=True)
    seleccionados = []
    tiempo_usado = 0
    valor_total = 0
    for nombre, tiempo, valor in ordenados:
        if tiempo_usado + tiempo <= presupuesto:
            seleccionados.append(nombre)
            tiempo_usado += tiempo
            valor_total += valor
    return valor_total, seleccionados


# ── Datos del problema ──────────────────────────────────────
tests_data = [
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

PRESUPUESTO = 25

if __name__ == "__main__":
    # ── Ejecutar Knapsack DP ────────────────────────────────
    valor_dp, tests_dp = seleccionar_tests_optimos(tests_data, PRESUPUESTO)
    tiempo_dp = sum(t for n, t, v in tests_data if n in tests_dp)

    print("=" * 60)
    print("PARTE 3 — RESULTADO KNAPSACK 0/1 (DP)")
    print("=" * 60)
    print(f"Valor total DP      : {valor_dp}")
    print(f"Tests seleccionados : {tests_dp}")
    print(f"Tiempo usado        : {tiempo_dp} min")

    # ── Ejecutar Greedy ─────────────────────────────────────
    valor_g, tests_g = seleccionar_tests_greedy(tests_data, PRESUPUESTO)
    tiempo_g = sum(t for n, t, v in tests_data if n in tests_g)

    print()
    print("=" * 60)
    print("COMPARACIÓN DP vs GREEDY")
    print("=" * 60)
    print(f"Valor DP     : {valor_dp}")
    print(f"Valor Greedy : {valor_g}")
    diff_pct = ((valor_dp - valor_g) / valor_g) * 100 if valor_g else 0
    print(f"Diferencia   : {diff_pct:.2f}%")

    solo_greedy = set(tests_g) - set(tests_dp)
    solo_dp     = set(tests_dp) - set(tests_g)
    print(f"Tests en Greedy pero NO en DP : {solo_greedy or 'ninguno'}")
    print(f"Tests en DP pero NO en Greedy : {solo_dp or 'ninguno'}")

    print()
    print("Tabla de ratios valor/tiempo:")
    print(f"{'Test':<30} {'Tiempo':>7} {'Valor':>7} {'Ratio':>8}  {'DP':>4}  {'Greedy':>7}")
    print("-" * 68)
    for nombre, tiempo, valor in tests_data:
        ratio = valor / tiempo
        en_dp = "✓" if nombre in tests_dp else "✗"
        en_g  = "✓" if nombre in tests_g  else "✗"
        print(f"{nombre:<30} {tiempo:>7} {valor:>7} {ratio:>8.2f}  {en_dp:>4}  {en_g:>7}")
