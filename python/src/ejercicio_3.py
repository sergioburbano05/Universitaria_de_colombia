def promedio_ponderado(notas: list, pesos: list) -> float:
    """
    Calcula el promedio ponderado de una lista de notas con sus pesos.

    Raises ValueError si las longitudes no coinciden o la suma de pesos <= 0.
    """
    if len(notas) != len(pesos):
        raise ValueError('Longitudes no coinciden')
    if sum(pesos) <= 0:
        raise ValueError('Suma de pesos debe ser positiva')
    total = sum(n * p for n, p in zip(notas, pesos))
    return total / sum(pesos)
