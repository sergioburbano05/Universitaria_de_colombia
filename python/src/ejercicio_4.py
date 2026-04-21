def revertir(s: str) -> str:
    """Invierte una cadena."""
    return s[::-1]


def es_palindromo(s: str) -> bool:
    """True si la cadena es palindromo (ignora mayusculas/espacios)."""
    limpio = s.lower().replace(' ', '')
    return limpio == limpio[::-1]


def concatenar_lista(palabras: list, separador: str = ' ') -> str:
    """Une una lista de palabras con el separador dado."""
    return separador.join(palabras)
