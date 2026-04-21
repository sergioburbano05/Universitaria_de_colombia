"""
Tests Ejercicio 1 — Clases de Equivalencia y BVA
calcular_descuento(edad, es_estudiante)
"""

import pytest
from src.ejercicio_1 import calcular_descuento


@pytest.mark.parametrize('edad, es_estudiante, esperado', [
    # Casos invalidos (C1, C2)
    (-1,  False, 'ERROR'),          # limite bajo invalido
    (121, True,  'ERROR'),          # limite alto invalido
    # Clase C3: estudiante menor
    (0,   True,  10),               # min valido
    (17,  True,  10),               # max de la clase
    # Clase C4: no estudiante menor
    (0,   False, 0),
    (17,  False, 0),
    # Clase C5: estudiante adulto
    (18,  True,  15), (59, True,  15),
    # Clase C6: no estudiante adulto
    (18,  False, 0),  (59, False, 0),
    # Clase C7: adulto mayor
    (60,  True,  25), (60,  False, 25),
    (120, True,  25), (120, False, 25),
])
def test_calcular_descuento(edad, es_estudiante, esperado):
    resultado = calcular_descuento(edad, es_estudiante)
    assert resultado == esperado
