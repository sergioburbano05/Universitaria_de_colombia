"""
Tests Ejercicio 2 — Branch Coverage 100%
validar_matricula(estudiante)
"""

import pytest
from src.ejercicio_2 import validar_matricula


def test_datos_vacios():
    # Cubre R1 = True
    assert validar_matricula({}) == 'DATOS_VACIOS'
    assert validar_matricula(None) == 'DATOS_VACIOS'


def test_estudiante_inactivo():
    # Cubre R1=False, R2=True
    est = {'estado': 'INACTIVO', 'deuda': 0}
    assert validar_matricula(est) == 'ESTUDIANTE_INACTIVO'


def test_tiene_deuda():
    # Cubre R1=F, R2=F, R3=True
    est = {'estado': 'ACTIVO', 'deuda': 500000}
    assert validar_matricula(est) == 'TIENE_DEUDA'


def test_creditos_invalidos():
    # Cubre R4=True (caso creditos < 0 Y caso > 24)
    est1 = {'estado': 'ACTIVO', 'deuda': 0, 'creditos': -1}
    est2 = {'estado': 'ACTIVO', 'deuda': 0, 'creditos': 25}
    assert validar_matricula(est1) == 'CREDITOS_INVALIDOS'
    assert validar_matricula(est2) == 'CREDITOS_INVALIDOS'


def test_habilitado():
    # Cubre todas las R previas = False, R5 = True
    est = {'estado': 'ACTIVO', 'deuda': 0, 'creditos': 18, 'promedio': 4.0}
    assert validar_matricula(est) == 'HABILITADO'


def test_condicional():
    # Cubre todas las R previas = False, R5 = False
    est = {'estado': 'ACTIVO', 'deuda': 0, 'creditos': 18, 'promedio': 2.5}
    assert validar_matricula(est) == 'CONDICIONAL'


@pytest.mark.parametrize('deuda, creditos, promedio, esperado', [
    (0.01,  12,  3.5,  'TIENE_DEUDA'),
    (1000,  12,  3.5,  'TIENE_DEUDA'),
    (0,      1,  3.5,  'HABILITADO'),
    (0,     23,  3.5,  'HABILITADO'),
    (0,     12,  3.0,  'HABILITADO'),
    (0,     12,  2.99, 'CONDICIONAL'),
    (0,     12,  0.0,  'CONDICIONAL'),
    (0,     12,  5.0,  'HABILITADO'),
    (0,      0,  3.5,  'HABILITADO'),
    (0,     24,  2.5,  'CONDICIONAL'),
])
def test_pesos_diferentes(deuda, creditos, promedio, esperado):
    """Verifica distintas combinaciones de pesos (deuda, creditos, promedio)."""
    estudiante = {
        'estado': 'ACTIVO',
        'deuda': deuda,
        'creditos': creditos,
        'promedio': promedio
    }
    assert validar_matricula(estudiante) == esperado

