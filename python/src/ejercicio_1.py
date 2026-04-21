def calcular_descuento(edad: int, es_estudiante: bool) -> int | str:
    """
    Calcula el % de descuento según edad y estado de estudiante.

    Reglas:
    - edad < 0 o > 120: error
    - 0 <= edad < 18: 10% si es estudiante, 0% si no
    - 18 <= edad < 60: 15% si es estudiante, 0% si no
    - edad >= 60: 25% siempre (adulto mayor)
    """
    if edad < 0 or edad > 120:
        return 'ERROR'

    if edad < 18:
        return 10 if es_estudiante else 0
    elif edad < 60:
        return 15 if es_estudiante else 0
    else:
        return 25
