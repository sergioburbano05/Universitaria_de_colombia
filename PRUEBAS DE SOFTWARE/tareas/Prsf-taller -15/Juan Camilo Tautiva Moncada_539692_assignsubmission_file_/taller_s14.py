# ============================================================
# TALLER INTEGRADOR — SESIÓN 14 | PRUEBAS DE SOFTWARE
# Universitaria de Colombia | Ing. de Software | 7mo Semestre
# Mg. Sergio Alejandro Burbano Mena | Abril 2026
# ============================================================

# ============================================================
# PARTE 1 — EXPLORATORY TESTING (SBTM)
# ============================================================
"""
CHARTER 1
---------
Explorar:       El cálculo de promedios ponderados por materia y semestre
Con:            Datos de estudiantes con notas extremas (0.0, 5.0), notas decimales
                y materias con diferentes créditos
Para descubrir: Si el sistema calcula correctamente el promedio cuando hay créditos
                distintos por materia o notas en los límites del rango permitido

CHARTER 2
---------
Explorar:       La detección de estudiantes en riesgo académico
Con:            Listas de estudiantes con promedios exactamente en el umbral (3.0),
                sin materias registradas y con historial vacío
Para descubrir: Si el sistema incluye, excluye o falla al procesar estudiantes cuyo
                promedio es igual al umbral, o que no tienen materias registradas

CHARTER 3
---------
Explorar:       La exportación de reportes consolidados en múltiples formatos (PDF, Excel)
Con:            Reportes con grandes volúmenes de datos, caracteres especiales en nombres
                y facultades con datos vacíos
Para descubrir: Si el sistema genera archivos corruptos, pierde datos o falla
                silenciosamente al exportar bajo condiciones adversas

REPORTE DE SESIÓN SBTM
-----------------------
Charter ejecutado: Detección de estudiantes en riesgo académico
Hora inicio: 08:00  |  Hora fin: 08:20  |  Duración: 20 min

Notas cronológicas:
08:00 — Se carga el módulo con 10 estudiantes. El sistema responde correctamente para casos estándar.
08:04 — Estudiante con promedio exactamente 3.0: NO se incluye en riesgo (condición es <, correcto).
08:08 — Estudiante con materias vacías: el sistema lo omite sin errores (comportamiento esperado).
08:12 — Nota negativa (-1.5): el sistema la procesa sin validar, genera promedio incorrecto → BUG #1.
08:16 — Lista completamente vacía: retorna [] correctamente.
08:19 — Estudiante sin campo 'id': lanza KeyError no controlado → BUG #2 crítico.

BUG #1:
  Descripción: El sistema acepta notas negativas sin validación, generando falsos positivos en riesgo.
  Severidad: Alta
  Pasos: Enviar {'id':'001','materias':[{'nota':-1.5},{'nota':2.0}]} → promedio incorrecto 0.25

BUG #2:
  Descripción: Si un estudiante no tiene campo 'id', lanza KeyError no controlado y detiene ejecución.
  Severidad: Crítica
  Pasos: Enviar {'materias':[{'nota':2.0}]} sin 'id' → KeyError: 'id'
"""

# ============================================================
# PARTE 2 — TESTING DINÁMICO
# ============================================================

# --- Módulo a probar (analitica.py) ---

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


# --- 2.2 Tests pytest — Branch Coverage 100% ---

import pytest

def test_lista_vacia():
    """Test 1 — lista vacía: debe retornar lista vacía"""
    resultado = detectar_estudiantes_riesgo([])
    assert resultado == []

def test_estudiante_sin_materias():
    """Test 2 — estudiante sin materias: debe omitirlo sin error"""
    notas = [{'id': '001', 'materias': []}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert resultado == []

def test_estudiante_en_riesgo():
    """Test 3 — estudiante con promedio < 3.0: debe aparecer en la lista"""
    notas = [{'id': '002', 'materias': [{'nota': 2.0}, {'nota': 2.5}]}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert len(resultado) == 1
    assert resultado[0]['id'] == '002'
    assert resultado[0]['promedio'] == 2.25

def test_estudiante_aprobado():
    """Test 4 — estudiante con promedio >= 3.0: NO debe aparecer en la lista"""
    notas = [{'id': '003', 'materias': [{'nota': 3.5}, {'nota': 4.0}]}]
    resultado = detectar_estudiantes_riesgo(notas)
    assert resultado == []

def test_umbral_personalizado():
    """Test 5 — umbral personalizado: debe usar el umbral indicado"""
    notas = [{'id': '004', 'materias': [{'nota': 3.5}, {'nota': 3.8}]}]
    resultado = detectar_estudiantes_riesgo(notas, umbral=4.0)
    assert len(resultado) == 1
    assert resultado[0]['id'] == '004'


# --- 2.3 Propiedad Hypothesis ---

try:
    from hypothesis import given, strategies as st

    @given(
        st.lists(
            st.fixed_dictionaries({
                'id': st.text(min_size=1),
                'materias': st.lists(
                    st.fixed_dictionaries({
                        'nota': st.floats(min_value=0.0, max_value=5.0)
                    }),
                    min_size=1, max_size=10
                )
            }),
            min_size=0, max_size=20
        )
    )
    def test_propiedad_promedio_siempre_menor_umbral(notas):
        """PROPIEDAD: Todo estudiante en riesgo debe tener promedio >= 0.0 y < umbral (3.0)"""
        resultado = detectar_estudiantes_riesgo(notas)
        for estudiante in resultado:
            assert 0.0 <= estudiante['promedio'] < 3.0

except ImportError:
    print("hypothesis no instalado. Instalar con: pip install hypothesis")


# ============================================================
# PARTE 3 — DP APLICADO (Knapsack 0/1)
# ============================================================

def seleccionar_tests_optimos(tests, presupuesto):
    """
    Implementación Knapsack 0/1 para selección óptima de tests.
    tests: [(nombre, tiempo, valor), ...]
    presupuesto: tiempo máximo disponible (minutos)
    Retorna (valor_total, lista_tests_seleccionados, tiempo_usado)
    """
    n = len(tests)

    # Construir tabla DP [n+1][presupuesto+1]
    dp = [[0] * (presupuesto + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        nombre, tiempo, valor = tests[i - 1]
        for t in range(presupuesto + 1):
            if tiempo > t:
                dp[i][t] = dp[i - 1][t]
            else:
                dp[i][t] = max(dp[i - 1][t], dp[i - 1][t - tiempo] + valor)

    # Reconstruir qué tests se seleccionaron
    seleccionados = []
    t = presupuesto
    for i in range(n, 0, -1):
        if dp[i][t] != dp[i - 1][t]:
            seleccionados.append(tests[i - 1][0])
            t -= tests[i - 1][1]

    valor_total = dp[n][presupuesto]
    tiempo_usado = presupuesto - t

    return valor_total, seleccionados, tiempo_usado


def seleccionar_tests_greedy(tests, presupuesto):
    """
    Selección Greedy: ordena por ratio valor/tiempo descendente.
    Retorna (valor_total, lista_tests_seleccionados, tiempo_usado)
    """
    # Ordenar por ratio valor/tiempo descendente
    ordenados = sorted(tests, key=lambda x: x[2] / x[1], reverse=True)

    seleccionados = []
    tiempo_usado = 0
    valor_total = 0

    for nombre, tiempo, valor in ordenados:
        if tiempo_usado + tiempo <= presupuesto:
            seleccionados.append(nombre)
            tiempo_usado += tiempo
            valor_total += valor

    return valor_total, seleccionados, tiempo_usado


# --- Datos del problema ---
tests = [
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

# --- Ejecutar DP ---
valor_dp, tests_dp, tiempo_dp = seleccionar_tests_optimos(tests, PRESUPUESTO)

# --- Ejecutar Greedy ---
valor_greedy, tests_greedy, tiempo_greedy = seleccionar_tests_greedy(tests, PRESUPUESTO)

# --- Mostrar resultados ---
print("=" * 60)
print("  PARTE 3 — SELECCIÓN ÓPTIMA DE TESTS (Knapsack 0/1)")
print("=" * 60)

print("\n📊 RESULTADOS DP (Programación Dinámica):")
print(f"  Valor total:        {valor_dp}")
print(f"  Tiempo usado:       {tiempo_dp} / {PRESUPUESTO} min")
print(f"  Tests seleccionados ({len(tests_dp)}):")
for t in tests_dp:
    info = next(x for x in tests if x[0] == t)
    print(f"    ✅ {t:30s} | {info[1]} min | valor {info[2]}")

print("\n📊 RESULTADOS GREEDY (Ratio valor/tiempo):")
print(f"  Valor total:        {valor_greedy}")
print(f"  Tiempo usado:       {tiempo_greedy} / {PRESUPUESTO} min")
print(f"  Tests seleccionados ({len(tests_greedy)}):")
for t in tests_greedy:
    info = next(x for x in tests if x[0] == t)
    print(f"    ✅ {t:30s} | {info[1]} min | valor {info[2]}")

# --- Tabla comparativa ---
print("\n" + "=" * 60)
print("  TABLA COMPARATIVA DP vs GREEDY")
print("=" * 60)
print(f"  {'Métrica':<35} {'DP':>10} {'Greedy':>10}")
print(f"  {'-'*55}")
print(f"  {'Valor total obtenido':<35} {valor_dp:>10} {valor_greedy:>10}")
print(f"  {'Tiempo usado (min)':<35} {tiempo_dp:>10} {tiempo_greedy:>10}")
print(f"  {'Nro. de tests seleccionados':<35} {len(tests_dp):>10} {len(tests_greedy):>10}")

diferencia = round(((valor_dp - valor_greedy) / valor_greedy) * 100, 2) if valor_greedy else 0
print(f"  {'Diferencia de valor (%)':<35} {diferencia:>10}%")

solo_dp = set(tests_dp) - set(tests_greedy)
solo_greedy = set(tests_greedy) - set(tests_dp)
print(f"\n  Tests solo en DP:     {solo_dp if solo_dp else 'Ninguno (coinciden)'}")
print(f"  Tests solo en Greedy: {solo_greedy if solo_greedy else 'Ninguno (coinciden)'}")

print("\n📌 ANÁLISIS:")
if valor_dp > valor_greedy:
    print(f"  DP supera a Greedy en {valor_dp - valor_greedy} puntos de valor.")
    print("  Greedy falla porque toma decisiones locales sin ver combinaciones globales.")
else:
    print("  En este caso ambos algoritmos llegan al mismo resultado óptimo.")
    print("  Esto ocurre cuando los ratios valor/tiempo están bien distribuidos.")
    print("  Sin embargo, DP SIEMPRE garantiza el óptimo global; Greedy no.")

print("\n" + "=" * 60)
print("  Taller completado | Pruebas de Software | Sesión 14")
print("=" * 60)
