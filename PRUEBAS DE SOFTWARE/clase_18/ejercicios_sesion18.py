"""
SESIÓN 18 · PRUEBAS DE SOFTWARE
Coeficientes Binomiales y Subsecuencia Común Máxima (LCS)
Mg. Sergio Alejandro Burbano Mena
Universitaria de Colombia · VII Semestre
"""

from functools import lru_cache


# ============================================================
# SECCIÓN 1: COEFICIENTES BINOMIALES — TRIÁNGULO DE PASCAL
# ============================================================

def separador(titulo):
    print("\n" + "=" * 60)
    print(f"  {titulo}")
    print("=" * 60)

def paso(numero, descripcion):
    print(f"\n  [Paso {numero}] {descripcion}")


# ----------------------------------------------------------
# VERSIÓN 1: Recursión con memoización (lru_cache)
# ----------------------------------------------------------
# Recurrencia de Pascal:
#   C(n, k) = C(n-1, k-1) + C(n-1, k)
# Casos base:
#   C(n, 0) = 1   y   C(n, n) = 1   para todo n ≥ 0
# Ventaja sobre fórmula factorial:
#   Solo usa sumas → nunca desborda incluso para n grande.
# ----------------------------------------------------------

@lru_cache(maxsize=None)
def binomial_memo(n, k):
    """
    Calcula C(n, k) con memoización.
    Tiempo:  O(n·k) — cada par (n,k) se calcula una sola vez.
    Espacio: O(n·k) por la caché + pila de recursión.
    """
    if k == 0 or k == n:
        return 1
    if k > n:
        return 0
    return binomial_memo(n - 1, k - 1) + binomial_memo(n - 1, k)


def demo_binomial_memo():
    separador("COEFICIENTES BINOMIALES — Versión 1: Recursión con Memoización")

    paso(1, "Definición de la recurrencia de Pascal:")
    print("      C(n, k) = C(n-1, k-1) + C(n-1, k)")
    print("      Casos base: C(n, 0) = 1  y  C(n, n) = 1")

    paso(2, "¿Por qué la recurrencia y no la fórmula factorial?")
    print("      Fórmula factorial: C(n,k) = n! / (k! · (n-k)!)")
    print("      → Para n=25, los factoriales intermedios superan 2^32.")
    print("      Recurrencia: solo suma enteros pequeños → sin desbordamiento.")

    paso(3, "Cálculo de C(5, 2) mostrando cada sub-llamada:")
    print("      C(5,2) = C(4,1) + C(4,2)")
    print("             = (C(3,0) + C(3,1)) + (C(3,1) + C(3,2))")
    print("             = (1 + C(2,0) + C(2,1)) + (C(2,0) + C(2,1) + C(2,1) + C(2,2))")
    resultado = binomial_memo(5, 2)
    print(f"      Resultado final C(5, 2) = {resultado}  (esperado: 10)")

    paso(4, "Verificación con varios ejemplos:")
    casos = [(10, 3), (20, 10), (50, 25)]
    for n, k in casos:
        r = binomial_memo(n, k)
        print(f"      C({n}, {k}) = {r}")

    paso(5, "Complejidad:")
    print("      Tiempo:  O(n·k) — cada par (n,k) se evalúa una vez.")
    print("      Espacio: O(n·k) — caché almacena todos los pares visitados.")


# ----------------------------------------------------------
# VERSIÓN 2: Tabulación — tabla de Pascal completa
# ----------------------------------------------------------
# Construye TODA la tabla hasta la fila n_max.
# Permite consulta O(1) de cualquier C(n, k) ya tabulado.
# ----------------------------------------------------------

def pascal_tabla(n_max):
    """
    Construye la tabla de Pascal dp[0..n_max][0..n_max].
    dp[n][k] = C(n, k).
    Tiempo:  O(n_max²)
    Espacio: O(n_max²)
    """
    dp = [[0] * (n_max + 1) for _ in range(n_max + 1)]
    for n in range(n_max + 1):
        dp[n][0] = 1          # C(n, 0) = 1
        dp[n][n] = 1          # C(n, n) = 1
        for k in range(1, n):
            dp[n][k] = dp[n - 1][k - 1] + dp[n - 1][k]
    return dp


def demo_pascal_tabla():
    separador("COEFICIENTES BINOMIALES — Versión 2: Tabulación (Triángulo de Pascal)")

    paso(1, "Inicializar tabla dp[n][k] = 0 para todo n, k.")
    paso(2, "Para cada fila n, fijar dp[n][0]=1 y dp[n][n]=1.")
    paso(3, "Llenar posiciones interiores: dp[n][k] = dp[n-1][k-1] + dp[n-1][k].")

    n_max = 6
    dp = pascal_tabla(n_max)

    paso(4, f"Triángulo de Pascal hasta n={n_max}:")
    print()
    for n in range(n_max + 1):
        fila = [dp[n][k] for k in range(n + 1)]
        espacios = "  " * (n_max - n)
        print(f"  n={n}  {espacios}{fila}")

    paso(5, "Consultas O(1) sobre la tabla:")
    consultas = [(4, 2), (6, 3), (5, 2)]
    for n, k in consultas:
        print(f"      C({n}, {k}) = dp[{n}][{k}] = {dp[n][k]}")

    paso(6, "Complejidad:")
    print("      Tiempo:  O(n_max²)")
    print("      Espacio: O(n_max²) — almacena toda la tabla.")


# ----------------------------------------------------------
# VERSIÓN 3: Optimización en espacio — solo una fila O(k)
# ----------------------------------------------------------
# Solo necesitamos la fila anterior. Iteramos de derecha
# a izquierda para no pisar los valores que aún se usan
# (misma técnica que la mochila 0/1).
# ----------------------------------------------------------

def binomial_opt(n, k):
    """
    Calcula C(n, k) usando una sola fila de tamaño (k+1).
    Tiempo:  O(n·k)
    Espacio: O(k)  ← gran mejora respecto a la tabla completa
    """
    if k > n - k:
        k = n - k       # simetría: C(n, k) = C(n, n-k)
    dp = [0] * (k + 1)
    dp[0] = 1           # C(0, 0) = 1 como semilla
    for i in range(1, n + 1):
        # iterar de derecha a izquierda para preservar valores previos
        for j in range(min(i, k), 0, -1):
            dp[j] = dp[j] + dp[j - 1]
    return dp[k]


def demo_binomial_opt():
    separador("COEFICIENTES BINOMIALES — Versión 3: Fila Única (Espacio O(k))")

    paso(1, "Reducir k usando simetría C(n,k) = C(n, n-k).")
    paso(2, "Inicializar dp = [1, 0, 0, ..., 0] (tamaño k+1).")
    paso(3, "Para cada i de 1 a n, actualizar dp de DERECHA a IZQUIERDA.")
    print("      → Iterar de j=min(i,k) hasta j=1:")
    print("        dp[j] = dp[j] + dp[j-1]")
    print("      La dirección inversa evita sobreescribir dp[j-1] antes de usarlo.")

    paso(4, "Trazado manual de C(5, 2):")
    n, k = 5, 2
    if k > n - k:
        k = n - k
    dp = [0] * (k + 1)
    dp[0] = 1
    print(f"      Estado inicial: dp = {dp}")
    for i in range(1, n + 1):
        for j in range(min(i, k), 0, -1):
            dp[j] = dp[j] + dp[j - 1]
        print(f"      Después de i={i}: dp = {dp}")
    print(f"      Resultado C(5, 2) = dp[{k}] = {dp[k]}  (esperado: 10)")

    paso(5, "Verificación de varios casos:")
    for (n, k) in [(10, 3), (20, 10), (50, 25)]:
        print(f"      C({n}, {k}) = {binomial_opt(n, k)}")

    paso(6, "Complejidad:")
    print("      Tiempo:  O(n·k)")
    print("      Espacio: O(k)  — solo una fila de tamaño k+1.")


# ============================================================
# SECCIÓN 2: SUBSECUENCIA COMÚN MÁXIMA (LCS)
# ============================================================

# ----------------------------------------------------------
# LCS — Solo longitud (tabla completa O(mn) espacio)
# ----------------------------------------------------------
# Recurrencia:
#   Si X[i] == Y[j]:  L[i][j] = L[i-1][j-1] + 1
#   Si no:            L[i][j] = max(L[i-1][j], L[i][j-1])
# Casos base: L[0][j] = L[i][0] = 0
# ----------------------------------------------------------

def lcs_longitud(X, Y):
    """
    Calcula la longitud de la LCS de X e Y.
    Tiempo:  O(m·n)
    Espacio: O(m·n)
    """
    m, n = len(X), len(Y)
    L = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if X[i - 1] == Y[j - 1]:
                L[i][j] = L[i - 1][j - 1] + 1
            else:
                L[i][j] = max(L[i - 1][j], L[i][j - 1])
    return L[m][n]


# ----------------------------------------------------------
# LCS — Longitud + Reconstrucción de la subsecuencia
# ----------------------------------------------------------

def lcs_completo(X, Y):
    """
    Devuelve (longitud, subsecuencia) de la LCS de X e Y.
    Reconstruye la cadena recorriendo la tabla hacia atrás.
    Tiempo:  O(m·n) para tabular + O(m+n) para reconstruir.
    Espacio: O(m·n)
    """
    m, n = len(X), len(Y)
    L = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if X[i - 1] == Y[j - 1]:
                L[i][j] = L[i - 1][j - 1] + 1
            else:
                L[i][j] = max(L[i - 1][j], L[i][j - 1])

    # Reconstrucción: ir desde L[m][n] hasta L[0][0]
    sub, i, j = [], m, n
    while i > 0 and j > 0:
        if X[i - 1] == Y[j - 1]:
            sub.append(X[i - 1])
            i -= 1
            j -= 1
        elif L[i - 1][j] >= L[i][j - 1]:
            i -= 1
        else:
            j -= 1

    return L[m][n], ''.join(reversed(sub))


# ----------------------------------------------------------
# LCS — Optimizado en espacio (solo dos filas)
# ----------------------------------------------------------

def lcs_longitud_opt(X, Y):
    """
    Calcula solo la longitud usando dos filas alternas.
    Tiempo:  O(m·n)
    Espacio: O(min(m, n))
    Nota: NO permite reconstruir la subsecuencia.
    """
    if len(X) < len(Y):
        X, Y = Y, X        # asegurar que Y sea la más corta
    m, n = len(X), len(Y)
    prev = [0] * (n + 1)

    for i in range(1, m + 1):
        curr = [0] * (n + 1)
        for j in range(1, n + 1):
            if X[i - 1] == Y[j - 1]:
                curr[j] = prev[j - 1] + 1
            else:
                curr[j] = max(prev[j], curr[j - 1])
        prev = curr

    return prev[n]


def imprimir_tabla_lcs(X, Y, L):
    """Imprime la tabla de LCS con etiquetas de filas y columnas."""
    m, n = len(X), len(Y)
    # Encabezado
    encabezado = "        " + "   ".join(f"'{c}'" for c in Y)
    print("      " + encabezado)
    print("      " + "-" * (len(encabezado) + 2))
    for i in range(m + 1):
        etiq = f"'{X[i-1]}'" if i > 0 else "   "
        fila = "  ".join(f"{L[i][j]:3}" for j in range(n + 1))
        print(f"  {etiq}  |  {fila}")


def demo_lcs():
    separador("LCS — Subsecuencia Común Máxima: Construcción de la Tabla")

    X = "AGCAT"
    Y = "GAC"

    paso(1, f"Definir las cadenas: X = '{X}'  Y = '{Y}'")
    paso(2, "Crear tabla L de tamaño (m+1)×(n+1) inicializada en 0.")
    print(f"      m = len(X) = {len(X)},  n = len(Y) = {len(Y)}")
    print(f"      Tabla L de {len(X)+1} filas × {len(Y)+1} columnas.")

    paso(3, "Aplicar la recurrencia celda por celda:")
    print("      Si X[i-1] == Y[j-1]:  L[i][j] = L[i-1][j-1] + 1")
    print("      Si no:                L[i][j] = max(L[i-1][j], L[i][j-1])")

    m, n = len(X), len(Y)
    L = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if X[i - 1] == Y[j - 1]:
                L[i][j] = L[i - 1][j - 1] + 1
            else:
                L[i][j] = max(L[i - 1][j], L[i][j - 1])

    paso(4, "Tabla LCS completada:")
    imprimir_tabla_lcs(X, Y, L)

    paso(5, f"Resultado: LCS tiene longitud = {L[m][n]}")
    print("      (Posibles subsecuencias: 'GA', 'AC', 'GC' — todas de longitud 2)")


def demo_lcs_completo():
    separador("LCS — Reconstrucción de la Subsecuencia Óptima")

    X = "ABCBDAB"
    Y = "BDCABA"

    paso(1, f"Cadenas: X = '{X}'  Y = '{Y}'")
    paso(2, "Tabular la matriz L (mismo proceso que antes).")

    longitud, sub = lcs_completo(X, Y)

    paso(3, "Reconstrucción — recorrer la tabla desde L[m][n] hasta L[0][0]:")
    print("      En cada celda L[i][j]:")
    print("        → Si X[i-1] == Y[j-1]: agregar carácter, moverse diagonal.")
    print("        → Si L[i-1][j] >= L[i][j-1]: subir (i -= 1).")
    print("        → Si no: ir a la izquierda (j -= 1).")

    paso(4, "Resultado:")
    print(f"      Longitud LCS : {longitud}")
    print(f"      Subsecuencia : '{sub}'")
    print(f"      (Otras LCS válidas de longitud {longitud}: 'BCBA', 'BDAB', etc.)")

    paso(5, "Ejemplo del PPTX — cadenas de testing:")
    X2 = "PRUEBASOFTWARE"
    Y2 = "PRUEBASUNITARIAS"
    lon2, sub2 = lcs_completo(X2, Y2)
    print(f"      X = '{X2}'")
    print(f"      Y = '{Y2}'")
    print(f"      LCS = '{sub2}'  (longitud {lon2})")


def demo_lcs_optimizado():
    separador("LCS — Versión Optimizada en Espacio (Solo Dos Filas)")

    X = "ABCBDAB"
    Y = "BDCABA"

    paso(1, "En lugar de guardar toda la tabla (m+1)×(n+1),")
    print("      solo mantenemos la fila anterior (prev) y la actual (curr).")
    paso(2, "Al terminar cada fila i, hacer: prev = curr.")
    paso(3, "La longitud final es prev[n].")

    lon = lcs_longitud_opt(X, Y)

    paso(4, "Resultado:")
    print(f"      LCS('{X}', '{Y}') = {lon}")
    print()
    print("      ADVERTENCIA: con esta versión NO es posible")
    print("      recuperar la subsecuencia, solo su longitud.")

    paso(5, "Trade-off espacio vs reconstrucción:")
    print("      ┌─────────────────────────────┬──────────────────────────┐")
    print("      │  Tabla completa O(m·n)      │ Reconstruye subsecuencia │")
    print("      │  Dos filas O(min(m,n))      │ Solo devuelve longitud   │")
    print("      │  Hirschberg O(m+n) espacio  │ Reconstruye + O(mn) tpo  │")
    print("      └─────────────────────────────┴──────────────────────────┘")


# ============================================================
# SECCIÓN 3: ERRORES COMUNES (del PPTX)
# ============================================================

def demo_errores_comunes():
    separador("ERRORES COMUNES AL IMPLEMENTAR LCS")

    print("""
  Error 1 — Confundir índices de cadena con índices de tabla:
    La tabla tiene tamaño (m+1)×(n+1). El prefijo vacío ocupa la
    fila/columna 0. Acceder con X[i] en lugar de X[i-1] produce
    IndexError o resultados incorrectos.

  Error 2 — Intentar reconstruir la LCS con solo dos filas:
    La versión optimizada en espacio descarta filas anteriores.
    Para reconstruir la cadena se necesita la tabla completa.

  Error 3 — Asumir que la LCS es única:
    Pueden existir VARIAS subsecuencias de longitud máxima.
    La reconstrucción devuelve una de ellas (no necesariamente
    siempre la misma según la dirección del recorrido).

  Error 4 — Olvidar que LCS preserva ORDEN:
    'ABCBDAB' y 'BDCABA' → LCS es 'BCBA', no simplemente
    la intersección de letras sin respetar su posición relativa.

  Error 5 — Desbordar con Unicode:
    Emojis o caracteres compuestos (ñ con acento combinado)
    pueden ocupar múltiples code points. Usar len() en Python 3
    con cadenas normalizadas (unicodedata.normalize) para evitarlo.
    """)


# ============================================================
# SECCIÓN 4: LCS APLICADO A PRUEBAS DE SOFTWARE
# ============================================================

def demo_lcs_testing():
    separador("LCS APLICADO A PRUEBAS DE SOFTWARE")

    paso(1, "Contexto: cuando un test falla, se compara salida esperada vs real.")
    print("      LCS permite identificar qué partes coinciden y dónde difieren.")

    esperado = "El resultado es 42 y el estado es OK"
    obtenido = "El resultado es 43 y el estado es ERROR"

    paso(2, f"Salida esperada : '{esperado}'")
    print(f"      Salida obtenida : '{obtenido}'")

    _, sub = lcs_completo(esperado, obtenido)
    lon = len(sub)

    paso(3, "Subsecuencia común más larga entre ambas salidas:")
    print(f"      LCS = '{sub}'")
    print(f"      Longitud = {lon}")
    sim = lon / max(len(esperado), len(obtenido)) * 100
    print(f"      Similitud aproximada: {sim:.1f}%")

    paso(4, "Herramientas que usan LCS internamente:")
    print("      → git diff / diff de Unix (algoritmo de Myers basado en LCS)")
    print("      → pytest, Jest, JUnit al mostrar diffs en aserciones fallidas")
    print("      → Bioinformática: alineamiento de secuencias de ADN (BLAST)")
    print("      → Detección de plagio en código fuente")


# ============================================================
# PROGRAMA PRINCIPAL
# ============================================================

def main():
    print("\n" + "=" * 60)
    print("  SESIÓN 18 · PRUEBAS DE SOFTWARE")
    print("  Coeficientes Binomiales y LCS")
    print("  Universitaria de Colombia · VII Semestre")
    print("=" * 60)

    # ── Coeficientes Binomiales ──────────────────────────────
    demo_binomial_memo()
    demo_pascal_tabla()
    demo_binomial_opt()

    # ── Subsecuencia Común Máxima ────────────────────────────
    demo_lcs()
    demo_lcs_completo()
    demo_lcs_optimizado()

    # ── Errores comunes y aplicaciones ──────────────────────
    demo_errores_comunes()
    demo_lcs_testing()

    print("\n" + "=" * 60)
    print("  Fin de la sesión 18")
    print("=" * 60 + "\n")


if __name__ == "__main__":
    main()
