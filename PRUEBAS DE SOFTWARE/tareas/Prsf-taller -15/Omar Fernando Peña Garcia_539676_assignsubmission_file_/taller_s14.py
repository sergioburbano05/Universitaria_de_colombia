# ============================================================
# Taller Integrador — Sesión 14 | Pruebas de Software
# Mg. Sergio Alejandro Burbano Mena
# ============================================================

# ============================================================
# PARTE 2 — TESTING DINÁMICO
# ============================================================

# analitica.py
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


# ── 2.2 Branch Coverage 100% ────────────────────────────────
import pytest

def test_lista_vacia():
    """Test 1 — lista vacía: retorna lista vacía sin iterar."""
    resultado = detectar_estudiantes_riesgo([])
    assert resultado == []

def test_estudiante_sin_materias():
    """Test 2 — estudiante sin materias: el bloque 'continue' se ejecuta."""
    notas = [{'id': 'E001', 'materias': []}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert resultado == []

def test_estudiante_en_riesgo():
    """Test 3 — promedio < umbral (3.0 por defecto): aparece en la lista."""
    notas = [{'id': 'E002', 'materias': [{'nota': 2.5}, {'nota': 2.0}]}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 'E002'
    assert resultado[0]['promedio'] == pytest.approx(2.25)

def test_estudiante_aprobado():
    """Test 4 — promedio >= umbral: NO aparece en la lista de riesgo."""
    notas = [{'id': 'E003', 'materias': [{'nota': 4.0}, {'nota': 3.5}]}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert resultado == []

def test_umbral_personalizado():
    """Test 5 — umbral personalizado 4.0: estudiante que antes aprobaba ahora está en riesgo."""
    notas = [{'id': 'E004', 'materias': [{'nota': 3.8}, {'nota': 3.6}]}]
    resultado = detectar_estudiantes_riesgo(notas, umbral=4.0)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 'E004'
    assert resultado[0]['promedio'] == pytest.approx(3.7)

def test_mixto_riesgo_y_aprobado():
    """Test 6 (bonus) — mezcla de estudiantes: solo los que están bajo umbral."""
    notas = [
        {'id': 'E005', 'materias': [{'nota': 2.0}, {'nota': 1.5}]},  # riesgo
        {'id': 'E006', 'materias': [{'nota': 4.5}, {'nota': 5.0}]},  # aprobado
    ]
    resultado = detectar_estudiantes_riesgo(notas)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 'E005'


# ── 2.3 Propiedad Hypothesis ────────────────────────────────
from hypothesis import given, settings, strategies as st

# Estrategia para generar una nota válida (0.0 – 5.0, escala colombiana)
nota_valida = st.floats(min_value=0.0, max_value=5.0, allow_nan=False)

# Estrategia para generar un estudiante
estudiante_st = st.fixed_dictionaries({
    'id': st.text(min_size=1, max_size=10),
    'materias': st.lists(
        st.fixed_dictionaries({'nota': nota_valida}),
        min_size=1, max_size=10
    )
})

@given(
    notas=st.lists(estudiante_st, min_size=0, max_size=20),
    umbral=st.floats(min_value=0.0, max_value=5.0, allow_nan=False)
)
@settings(max_examples=200)
def test_propiedad_cardinalidad_nunca_supera_entrada(notas, umbral):
    """
    PROPIEDAD: La cantidad de estudiantes en riesgo nunca supera
    la cantidad total de estudiantes en la entrada.
    """
    resultado = detectar_estudiantes_riesgo(notas, umbral=umbral)
    assert len(resultado) <= len(notas)

@given(
    notas=st.lists(estudiante_st, min_size=1, max_size=20)
)
@settings(max_examples=200)
def test_propiedad_umbral_maximo_incluye_todos(notas):
    """
    PROPIEDAD: Con umbral = 5.0 + epsilon, todos los estudiantes
    con al menos 1 materia deben aparecer en riesgo.
    """
    umbral = 5.1  # Mayor que la nota máxima posible
    resultado = detectar_estudiantes_riesgo(notas, umbral=umbral)
    estudiantes_con_materias = [e for e in notas if e.get('materias')]
    assert len(resultado) == len(estudiantes_con_materias)


# ============================================================
# PARTE 3 — DP APLICADO (Knapsack 0/1)
# ============================================================

def seleccionar_tests_optimos(tests, presupuesto):
    """
    tests: [(nombre, tiempo, valor), ...]
    Retorna (valor_total, lista_tests_seleccionados)
    """
    n = len(tests)
    # Tabla dp[i][w] = máximo valor usando los primeros i tests con w minutos
    dp = [[0] * (presupuesto + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        nombre, tiempo, valor = tests[i - 1]
        for w in range(presupuesto + 1):
            # No tomar el test i
            dp[i][w] = dp[i - 1][w]
            # Tomar el test i (si cabe)
            if tiempo <= w:
                dp[i][w] = max(dp[i][w], dp[i - 1][w - tiempo] + valor)

    # Reconstruir qué tests se seleccionaron
    seleccionados = []
    w = presupuesto
    for i in range(n, 0, -1):
        if dp[i][w] != dp[i - 1][w]:
            seleccionados.append(tests[i - 1][0])
            w -= tests[i - 1][1]

    valor_total = dp[n][presupuesto]
    tiempo_usado = sum(t for nombre, t, v in tests if nombre in seleccionados)
    return valor_total, list(reversed(seleccionados)), tiempo_usado


def seleccionar_tests_greedy(tests, presupuesto):
    """Greedy: ordena por ratio valor/tiempo descendente."""
    ordenados = sorted(tests, key=lambda x: x[2] / x[1], reverse=True)
    seleccionados = []
    tiempo_restante = presupuesto
    valor_total = 0
    for nombre, tiempo, valor in ordenados:
        if tiempo <= tiempo_restante:
            seleccionados.append(nombre)
            tiempo_restante -= tiempo
            valor_total += valor
    tiempo_usado = presupuesto - tiempo_restante
    return valor_total, seleccionados, tiempo_usado


# Datos del enunciado
tests = [
    ("test_login",           3, 85),
    ("test_calculo_promedio",5, 95),
    ("test_deteccion_riesgo",4, 90),
    ("test_exportar_pdf",    6, 70),
    ("test_exportar_excel",  5, 75),
    ("test_api_reportes",    3, 80),
    ("test_prediccion",      8, 65),
    ("test_ui_dashboard",    7, 60),
    ("test_concurrency",     9, 55),
    ("test_seguridad",       4, 88),
]

PRESUPUESTO = 25

dp_valor, dp_tests, dp_tiempo = seleccionar_tests_optimos(tests, PRESUPUESTO)
gr_valor, gr_tests, gr_tiempo = seleccionar_tests_greedy(tests, PRESUPUESTO)

diferencia_pct = ((dp_valor - gr_valor) / gr_valor * 100) if gr_valor else 0
solo_greedy = [t for t in gr_tests if t not in dp_tests]
solo_dp     = [t for t in dp_tests  if t not in gr_tests]

print("=" * 60)
print("RESULTADOS KNAPSACK 0/1 (DP) — presupuesto =", PRESUPUESTO, "min")
print("=" * 60)
print(f"Valor total:        {dp_valor}")
print(f"Tests seleccionados:{dp_tests}")
print(f"Tiempo usado:       {dp_tiempo} min")
print()
print("=" * 60)
print("RESULTADOS GREEDY — presupuesto =", PRESUPUESTO, "min")
print("=" * 60)
print(f"Valor total:        {gr_valor}")
print(f"Tests seleccionados:{gr_tests}")
print(f"Tiempo usado:       {gr_tiempo} min")
print()
print("=" * 60)
print("COMPARATIVA")
print("=" * 60)
print(f"Diferencia (%):     {diferencia_pct:.2f}%")
print(f"Solo en Greedy:     {solo_greedy}")
print(f"Solo en DP:         {solo_dp}")
