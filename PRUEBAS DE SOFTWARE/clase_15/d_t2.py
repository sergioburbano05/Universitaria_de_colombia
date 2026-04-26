import pytest
from analitica import detectar_estudiantes_riesgo

def test_lista_vacia():
    # Rama: if not notas
    assert detectar_estudiantes_riesgo([]) == []
    assert detectar_estudiantes_riesgo(None) == []

def test_estudiante_sin_materias():
    # Rama: if not estudiante.get('materias')
    datos = [{'id': 1, 'materias': []}, {'id': 2}]
    assert detectar_estudiantes_riesgo(datos) == []

def test_estudiante_en_riesgo():
    # Rama: if promedio < umbral (True)
    datos = [{'id': 1, 'materias': [{'nota': 2.5}, {'nota': 2.8}]}]
    resultado = detectar_estudiantes_riesgo(datos)
    assert len(resultado) == 1
    assert resultado[0]['id'] == 1
    assert resultado[0]['promedio'] == pytest.approx(2.65)

def test_estudiante_aprobado():
    # Rama: if promedio < umbral (False)
    datos = [{'id': 2, 'materias': [{'nota': 4.0}, {'nota': 4.5}]}]
    assert detectar_estudiantes_riesgo(datos) == []

def test_umbral_personalizado():
    # Parámetro umbral diferente
    datos = [{'id': 3, 'materias': [{'nota': 4.0}]}]
    # Con umbral 4.5, el estudiante con 4.0 ESTÁ en riesgo
    resultado = detectar_estudiantes_riesgo(datos, umbral=4.5)
    assert len(resultado) == 1

def test_limite_exacto_umbral():
    # Caso borde: promedio == umbral (no está en riesgo)
    datos = [{'id': 4, 'materias': [{'nota': 3.0}]}]
    assert detectar_estudiantes_riesgo(datos, umbral=3.0) == []

# Resultado esperado: 100% branch coverage con pytest --cov-branch
