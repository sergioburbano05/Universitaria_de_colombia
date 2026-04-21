def validar_matricula(estudiante: dict) -> str:
    """
    Valida si un estudiante puede matricularse.

    Retorna:
    - DATOS_VACIOS: si el diccionario es None o está vacío
    - ESTUDIANTE_INACTIVO: si el estado es INACTIVO
    - TIENE_DEUDA: si tiene deuda > 0
    - CREDITOS_INVALIDOS: si créditos < 0 o > 24
    - HABILITADO: si promedio >= 3.0
    - CONDICIONAL: en otros casos
    """
    if not estudiante:
        return 'DATOS_VACIOS'
    if estudiante.get('estado') == 'INACTIVO':
        return 'ESTUDIANTE_INACTIVO'
    if estudiante.get('deuda', 0) > 0:
        return 'TIENE_DEUDA'

    creditos = estudiante.get('creditos', 0)
    if creditos < 0 or creditos > 24:
        return 'CREDITOS_INVALIDOS'

    if estudiante.get('promedio', 0) >= 3.0:
        return 'HABILITADO'

    return 'CONDICIONAL'
