# ============================================================
#  TALLER INTEGRADOR — SESIÓN 14 | PRUEBAS DE SOFTWARE
#  Universitaria de Colombia — Mg. Sergio Burbano Mena
# ============================================================

# ==============================================================
# PARTE 2 — TESTING DINÁMICO
# ==============================================================

# --------------- analitica.py (código del profesor) ----------
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


# --------------- 2.2 Tests Pytest — Branch Coverage 100% -----
"""
Ejecutar con:  pytest solucion_taller_s14.py -v --tb=short
(o copiar los tests a un archivo test_analitica.py)
"""

import pytest


# TEST 1 — lista vacía: cubre el branch "if not notas: return []"
def test_lista_vacia():
    """Branch: lista vacía → retorna [] inmediatamente."""
    resultado = detectar_estudiantes_riesgo([])
    assert resultado == []


# TEST 2 — estudiante sin materias: cubre el branch "if not estudiante.get('materias'): continue"
def test_estudiante_sin_materias():
    """Branch: estudiante sin clave 'materias' → se omite."""
    notas = [{'id': 1, 'materias': []}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert resultado == []


# TEST 3 — estudiante en riesgo: cubre el branch "if promedio < umbral: riesgo.append(...)"
def test_estudiante_en_riesgo():
    """Branch: promedio < umbral → aparece en lista de riesgo."""
    notas = [
        {'id': 42, 'materias': [{'nota': 2.0}, {'nota': 1.5}]}
    ]
    resultado = detectar_estudiantes_riesgo(notas)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 42
    assert abs(resultado[0]['promedio'] - 1.75) < 1e-9


# TEST 4 — estudiante aprobado: cubre el branch "else" (promedio >= umbral)
def test_estudiante_aprobado():
    """Branch: promedio >= umbral → NO aparece en lista de riesgo."""
    notas = [
        {'id': 10, 'materias': [{'nota': 4.0}, {'nota': 4.5}]}
    ]
    resultado = detectar_estudiantes_riesgo(notas)
    assert resultado == []


# TEST 5 — umbral personalizado: verifica que el parámetro umbral funcione
def test_umbral_personalizado():
    """Branch: umbral distinto al default (4.5) filtra correctamente."""
    notas = [
        {'id': 1, 'materias': [{'nota': 4.0}]},   # riesgo con umbral 4.5
        {'id': 2, 'materias': [{'nota': 5.0}]},   # aprobado con umbral 4.5
    ]
    resultado = detectar_estudiantes_riesgo(notas, umbral=4.5)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 1


# TEST 6 — mezcla de estudiantes en riesgo y aprobados
def test_mezcla_riesgo_y_aprobados():
    """Cubre ambos branches dentro del loop en una sola llamada."""
    notas = [
        {'id': 1, 'materias': [{'nota': 2.5}, {'nota': 2.0}]},  # riesgo
        {'id': 2, 'materias': [{'nota': 4.0}, {'nota': 3.5}]},  # aprobado
        {'id': 3, 'materias': []},                                # sin materias
    ]
    resultado = detectar_estudiantes_riesgo(notas)
    ids_en_riesgo = [e['id'] for e in resultado]
    assert 1 in ids_en_riesgo
    assert 2 not in ids_en_riesgo


# --------------- 2.3 Propiedad con Hypothesis -------------------
from hypothesis import given, settings, strategies as st


@given(
    st.lists(
        st.fixed_dictionaries({
            'id': st.integers(min_value=1, max_value=9999),
            'materias': st.lists(
                st.fixed_dictionaries({'nota': st.floats(min_value=0.0, max_value=5.0)}),
                min_size=1, max_size=10
            )
        }),
        min_size=0, max_size=20
    ),
    st.floats(min_value=0.1, max_value=5.0)
)
@settings(max_examples=200)
def test_propiedad_todos_los_en_riesgo_tienen_promedio_menor_al_umbral(notas, umbral):
    """
    PROPIEDAD: Todo estudiante devuelto por detectar_estudiantes_riesgo
    debe tener un promedio estrictamente menor al umbral dado.
    Además, ningún estudiante con promedio >= umbral debe aparecer.
    """
    resultado = detectar_estudiantes_riesgo(notas, umbral=umbral)

    # Propiedad 1: todos los devueltos tienen promedio < umbral
    for e in resultado:
        assert e['promedio'] < umbral, (
            f"Estudiante {e['id']} tiene promedio {e['promedio']} >= umbral {umbral}"
        )

    # Propiedad 2: no se omite ningún estudiante que sí esté en riesgo
    ids_resultado = {e['id'] for e in resultado}
    for estudiante in notas:
        if not estudiante.get('materias'):
            continue
        notas_vals = [m['nota'] for m in estudiante['materias']]
        promedio = sum(notas_vals) / len(notas_vals)
        if promedio < umbral:
            assert estudiante['id'] in ids_resultado, (
                f"Estudiante {estudiante['id']} con promedio {promedio} "
                f"debería estar en riesgo (umbral={umbral})"
            )


# ==============================================================
# PARTE 3 — DP APLICADO: KNAPSACK 0/1
# ==============================================================

def seleccionar_tests_optimos(tests: list, presupuesto: int):
    """
    Selecciona el subconjunto de tests que maximiza el valor total
    sin exceder el presupuesto de tiempo (Knapsack 0/1).

    Args:
        tests: lista de tuplas (nombre, tiempo_min, valor)
        presupuesto: tiempo total disponible en minutos

    Returns:
        (valor_total, lista_tests_seleccionados, tiempo_usado)
    """
    n = len(tests)

    # dp[i][t] = máximo valor usando los primeros i tests con t minutos
    dp = [[0] * (presupuesto + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        nombre, tiempo, valor = tests[i - 1]
        for t in range(presupuesto + 1):
            # Opción 1: no incluir este test
            dp[i][t] = dp[i - 1][t]
            # Opción 2: incluirlo si hay tiempo suficiente
            if tiempo <= t:
                dp[i][t] = max(dp[i][t], dp[i - 1][t - tiempo] + valor)

    # Reconstruir cuáles tests fueron seleccionados
    seleccionados = []
    t = presupuesto
    for i in range(n, 0, -1):
        if dp[i][t] != dp[i - 1][t]:
            seleccionados.append(tests[i - 1][0])
            t -= tests[i - 1][1]

    tiempo_usado = presupuesto - t
    seleccionados.reverse()
    return dp[n][presupuesto], seleccionados, tiempo_usado


def seleccionar_tests_greedy(tests: list, presupuesto: int):
    """
    Versión greedy: ordena por ratio valor/tiempo (mayor primero)
    y agrega tests mientras haya tiempo disponible.
    """
    # Ordenar por ratio valor/tiempo de mayor a menor
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


def ejecutar_parte3():
    """Ejecuta y compara DP vs Greedy con los datos del taller."""
    tests = [
        ('test_login',            3,  85),
        ('test_calculo_promedio', 5,  95),
        ('test_deteccion_riesgo', 4,  90),
        ('test_exportar_pdf',     6,  70),
        ('test_exportar_excel',   5,  75),
        ('test_api_reportes',     3,  80),
        ('test_prediccion',       8,  65),
        ('test_ui_dashboard',     7,  60),
        ('test_concurrency',      9,  55),
        ('test_seguridad',        4,  88),
    ]
    presupuesto = 25

    print('=' * 60)
    print('PARTE 3 — KNAPSACK 0/1: SELECCIÓN ÓPTIMA DE TESTS')
    print('=' * 60)

    # Solución DP
    val_dp, sel_dp, t_dp = seleccionar_tests_optimos(tests, presupuesto)
    print(f'\n[DP Knapsack 0/1]')
    print(f'  Valor total:       {val_dp}')
    print(f'  Tests elegidos:    {sel_dp}')
    print(f'  Tiempo usado:      {t_dp} / {presupuesto} min')

    # Solución Greedy
    val_g, sel_g, t_g = seleccionar_tests_greedy(tests, presupuesto)
    print(f'\n[Greedy (ratio valor/tiempo)]')
    print(f'  Valor total:       {val_g}')
    print(f'  Tests elegidos:    {sel_g}')
    print(f'  Tiempo usado:      {t_g} / {presupuesto} min')

    # Comparación
    diferencia_pct = (val_dp - val_g) / val_g * 100 if val_g else 0
    solo_dp  = [t for t in sel_dp if t not in sel_g]
    solo_g   = [t for t in sel_g  if t not in sel_dp]

    print(f'\n[Comparación]')
    print(f'  Valor DP:          {val_dp}')
    print(f'  Valor Greedy:      {val_g}')
    print(f'  Diferencia (%):    {diferencia_pct:.1f}%')
    print(f'  Solo en DP:        {solo_dp if solo_dp else "ninguno"}')
    print(f'  Solo en Greedy:    {solo_g if solo_g else "ninguno"}')
    print('=' * 60)


# ==============================================================
# MENÚ PRINCIPAL
# ==============================================================
if __name__ == '__main__':
    import sys

    print('\n========== TALLER S14 — MENÚ ==========')
    print('1. Ejecutar Parte 3: Knapsack DP vs Greedy')
    print('2. Ejecutar tests pytest (desde terminal: pytest solucion_taller_s14.py -v)')
    print('0. Salir')

    opcion = input('\nOpción: ').strip()
    if opcion == '1':
        ejecutar_parte3()
    elif opcion == '2':
        print('\nEjecuta en terminal:')
        print('  pip install pytest hypothesis --break-system-packages')
        print('  pytest solucion_taller_s14.py -v')
    else:
        print('¡Hasta luego!')