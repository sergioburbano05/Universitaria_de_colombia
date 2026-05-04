"""
Suite de tests para detectar_estudiantes_riesgo
- Tests pytest para 100% de cobertura de ramas
- Test de propiedad con Hypothesis
"""
import pytest
from hypothesis import given, strategies as st, settings
from analitica import detectar_estudiantes_riesgo


# ============================================================
# 2.2 - Tests pytest con 100% Branch Coverage
# ============================================================

def test_lista_vacia():
    """Rama: `if not notas` -> True"""
    assert detectar_estudiantes_riesgo([]) == []


def test_estudiante_sin_materias():
    """Rama: `if not estudiante.get('materias')` -> True (continue)"""
    notas = [
        {'id': 'E001', 'materias': []},
        {'id': 'E002'},  # sin la clave 'materias'
    ]
    assert detectar_estudiantes_riesgo(notas) == []


def test_estudiante_en_riesgo():
    """Rama: `if promedio < umbral` -> True (se agrega a riesgo)"""
    notas = [
        {'id': 'E003', 'materias': [
            {'nota': 2.5},
            {'nota': 2.0},
            {'nota': 3.0},
        ]},  # promedio = 2.5 < 3.0
    ]
    resultado = detectar_estudiantes_riesgo(notas)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 'E003'
    assert resultado[0]['promedio'] == 2.5


def test_estudiante_aprobado():
    """Rama: `if promedio < umbral` -> False (NO se agrega)"""
    notas = [
        {'id': 'E004', 'materias': [
            {'nota': 4.5},
            {'nota': 4.0},
            {'nota': 3.5},
        ]},  # promedio = 4.0 >= 3.0
    ]
    assert detectar_estudiantes_riesgo(notas) == []


def test_umbral_personalizado():
    """Verifica que el parámetro `umbral` modifica el corte"""
    notas = [
        {'id': 'E005', 'materias': [{'nota': 3.5}, {'nota': 3.5}]},  # prom 3.5
        {'id': 'E006', 'materias': [{'nota': 4.0}, {'nota': 4.0}]},  # prom 4.0
    ]
    # Con umbral 4.0, solo E005 está en riesgo
    resultado = detectar_estudiantes_riesgo(notas, umbral=4.0)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 'E005'


def test_caso_mixto_completo():
    """Test integrador: varios estudiantes en distintas condiciones"""
    notas = [
        {'id': 'A', 'materias': [{'nota': 2.0}, {'nota': 2.5}]},     # riesgo
        {'id': 'B', 'materias': [{'nota': 4.0}, {'nota': 4.5}]},     # ok
        {'id': 'C', 'materias': []},                                  # sin materias
        {'id': 'D'},                                                  # sin clave
        {'id': 'E', 'materias': [{'nota': 2.9}]},                    # riesgo
    ]
    resultado = detectar_estudiantes_riesgo(notas)
    ids = [r['id'] for r in resultado]
    assert 'A' in ids and 'E' in ids
    assert 'B' not in ids and 'C' not in ids and 'D' not in ids


# ============================================================
# 2.3 - Test de propiedad con Hypothesis
# ============================================================

# Estrategia: generar una lista de estudiantes con IDs únicos
def estudiantes_strategy():
    return st.lists(
        st.fixed_dictionaries({'nota': st.floats(
            min_value=0.0, max_value=5.0, allow_nan=False, allow_infinity=False
        )}),
        min_size=0, max_size=10
    )


@given(
    ids=st.lists(st.text(min_size=1, max_size=8), min_size=0, max_size=20, unique=True),
    materias_por_estudiante=st.data(),
    umbral=st.floats(min_value=0.0, max_value=5.0, allow_nan=False, allow_infinity=False)
)
@settings(max_examples=200)
def test_propiedad_promedio_siempre_menor_que_umbral(ids, materias_por_estudiante, umbral):
    """
    PROPIEDAD: Todo estudiante retornado en la lista de riesgo
    DEBE tener un promedio estrictamente menor que el umbral.

    También verifica:
    - La cardinalidad: |riesgo| <= |estudiantes_de_entrada|.
    - Ningún estudiante sin materias aparece en el resultado.
    """
    notas = [
        {'id': i, 'materias': materias_por_estudiante.draw(estudiantes_strategy())}
        for i in ids
    ]

    resultado = detectar_estudiantes_riesgo(notas, umbral=umbral)

    # Propiedad principal: el filtrado es correcto
    for r in resultado:
        assert r['promedio'] < umbral, (
            f"Violación: estudiante {r['id']} tiene promedio "
            f"{r['promedio']} pero umbral es {umbral}"
        )

    # Propiedad secundaria: cardinalidad
    assert len(resultado) <= len(notas)

    # Propiedad terciaria: ningún estudiante sin materias en el resultado
    ids_sin_materias = {e['id'] for e in notas if not e.get('materias')}
    ids_riesgo = {r['id'] for r in resultado}
    assert ids_riesgo.isdisjoint(ids_sin_materias)
