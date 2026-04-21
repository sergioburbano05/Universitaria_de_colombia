"""
Tests Ejercicio 4 — Property-Based Testing con Hypothesis
revertir, es_palindromo, concatenar_lista
"""

from hypothesis import given, strategies as st
from src.ejercicio_4 import revertir, es_palindromo, concatenar_lista


# PROPIEDAD 1: revertir es INVOLUTIVA (f(f(x)) = x)
@given(st.text())
def test_propiedad_revertir_dos_veces(s):
    """revertir(revertir(s)) debe devolver s"""
    assert revertir(revertir(s)) == s


# PROPIEDAD 2: cualquier cadena + su reverso = palindromo
@given(st.text(alphabet=st.characters(whitelist_categories=('L',), max_codepoint=127), min_size=1))
def test_propiedad_cadena_mas_reverso(s):
    """s + reverso(s) siempre es palindromo (letras ASCII)"""
    combinado = s + revertir(s)
    assert es_palindromo(combinado)


# PROPIEDAD 3: concatenar y luego split restaura la lista original
@given(
    st.lists(st.text(alphabet='ABCDEFGHIJKLMNOP', min_size=1), min_size=1),
    st.sampled_from(['-', '|', ',', '/'])
)
def test_propiedad_concatenar_es_reversible(palabras, separador):
    """Si el separador no esta en las palabras,
       concatenar + split restaura la lista original."""
    resultado = concatenar_lista(palabras, separador)
    restaurado = resultado.split(separador)
    assert restaurado == palabras
