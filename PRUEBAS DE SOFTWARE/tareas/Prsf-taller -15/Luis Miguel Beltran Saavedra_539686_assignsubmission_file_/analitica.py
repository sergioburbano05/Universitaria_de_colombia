"""
Módulo de Analítica Académica - Universitaria de Colombia
Sesión 14 - Pruebas de Software
"""


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
