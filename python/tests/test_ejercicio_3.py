"""
Tests Ejercicio 3 — Mutation Testing con mutmut
promedio_ponderado(notas, pesos)
"""

import pytest
from src.ejercicio_3 import promedio_ponderado


def test_promedio_simple():
    assert promedio_ponderado([4.0, 5.0], [1, 1]) == 4.5


def test_pesos_diferentes():
    # Mata el mutante AOR (+ en vez de *)
    # Si fuera suma: (4+2)+(5+3) = 14, con promedio 14/5=2.8
    # Con producto: (4*2)+(5*3) = 23, con promedio 23/5=4.6
    assert promedio_ponderado([4, 5], [2, 3]) == pytest.approx(4.6)


def test_longitudes_diferentes():
    # Mata el mutante ROR (!= → >)
    with pytest.raises(ValueError, match='Longitudes'):
        promedio_ponderado([4.0], [1, 1])
    with pytest.raises(ValueError, match='Longitudes'):
        promedio_ponderado([4, 5, 6], [1, 1])


def test_pesos_negativos_o_cero():
    # Mata el mutante ROR (<= → <)
    with pytest.raises(ValueError, match='positiva'):
        promedio_ponderado([4, 5], [0, 0])    # suma=0, no < 0 pero <= 0
    with pytest.raises(ValueError, match='positiva'):
        promedio_ponderado([4, 5], [-1, 1])   # suma=0


def test_division_real():
    # Mata el mutante AOR (* en vez de /)
    # 4*2 + 5*3 = 23. Dividido entre 5 = 4.6. Multiplicado entre 5 = 115
    assert promedio_ponderado([4, 5], [2, 3]) == 4.6

# Despues: 6 mutantes generados, 6 matados. Score: 100%
