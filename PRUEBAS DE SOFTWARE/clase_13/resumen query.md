# Guía de Programación Dinámica — Clase 13


---

## ¿Qué es Programación Dinámica (DP)?

Es una técnica para resolver problemas difíciles dividiéndolos en subproblemas más pequeños
y **guardando las respuestas** para no calcularlas dos veces.

**Regla de oro:** Si un problema te pide el "mínimo", "máximo" o "cantidad de formas",
y tiene subproblemas que se repiten, probablemente se resuelve con DP.

---

## CÓDIGO 1 — Fibonacci con Memoización (`fib_memo`)

```python
@lru_cache(maxsize=None)
def fib_memo(n: int) -> int:
    if n <= 1:
        return n
    return fib_memo(n-1) + fib_memo(n-2)
```

### ¿Qué hace?

Calcula el número de Fibonacci de posición `n`.
La secuencia es: 0, 1, 1, 2, 3, 5, 8, 13, 21...
La fórmula es: F(n) = F(n-1) + F(n-2)

### ¿Por qué tiene @lru_cache?

Sin ese decorador, la función recalcula los mismos valores muchas veces:

```
fib(5)
├── fib(4)
│   ├── fib(3)  ← se calcula
│   └── fib(2)
└── fib(3)      ← se calcula OTRA VEZ (redundante)
```

Con `@lru_cache`, Python guarda cada resultado en memoria y la segunda vez
que se necesita, lo devuelve instantáneamente sin recalcular.

### Cuándo usar esto en clase

Cuando el alumno entiende recursión y quiere hacerla más eficiente con una línea.

### Complejidad

- Tiempo: O(n) — cada valor se calcula solo una vez
- Espacio: O(n) — guarda n resultados en el caché

---

## CÓDIGO 2 — Fibonacci con Tabla (`fib_tabla`)

```python
def fib_tabla(n: int) -> int:
    if n <= 1:
        return n

    dp = [0] * (n + 1)
    dp[0] = 0
    dp[1] = 1

    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]

    return dp[n]
```

### ¿Qué hace?

En lugar de recursión, llena una lista de abajo hacia arriba,
empezando desde los casos simples hasta llegar a la respuesta.

### Ejemplo para n=6

```
Paso 1: dp = [0, 1, 0, 0, 0, 0, 0]  (casos base)
Paso 2: dp = [0, 1, 1, 0, 0, 0, 0]  (dp[2] = dp[1]+dp[0] = 1)
Paso 3: dp = [0, 1, 1, 2, 0, 0, 0]  (dp[3] = dp[2]+dp[1] = 2)
Paso 4: dp = [0, 1, 1, 2, 3, 0, 0]  (dp[4] = dp[3]+dp[2] = 3)
Paso 5: dp = [0, 1, 1, 2, 3, 5, 0]  (dp[5] = dp[4]+dp[3] = 5)
Paso 6: dp = [0, 1, 1, 2, 3, 5, 8]  (dp[6] = dp[5]+dp[4] = 8)

Resultado: dp[6] = 8
```

### Cómo explicárselo al alumno

"Imagina que vas llenando una tabla fila por fila. Cada casilla la calculas
usando las dos casillas anteriores que ya tienes resueltas. No tienes que
volver a calcular nada, solo miras hacia atrás."

### Complejidad

- Tiempo: O(n) — el bucle recorre n veces
- Espacio: O(n) — guarda la tabla completa

---

## CÓDIGO 3 — Fibonacci Optimizado (`fib_optimo`)

```python
def fib_optimo(n: int) -> int:
    if n <= 1: return n
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b
```

### ¿Qué hace diferente?

Observa que para calcular cualquier F(n) solo necesitas los 2 valores anteriores,
no toda la tabla. Entonces usa solo 2 variables en lugar de una lista.

### Traza para n=6

```
inicio: a=0, b=1
i=2:    a=1, b=1   (nuevo_b = 0+1 = 1)
i=3:    a=1, b=2   (nuevo_b = 1+1 = 2)
i=4:    a=2, b=3   (nuevo_b = 1+2 = 3)
i=5:    a=3, b=5   (nuevo_b = 2+3 = 5)
i=6:    a=5, b=8   (nuevo_b = 3+5 = 8)

Resultado: b = 8
```

### Cuándo explicarlo

Después de `fib_tabla`. Pregúntale al alumno:
"¿Para calcular dp[6] qué necesitamos exactamente?"
Solo dp[5] y dp[4]. Entonces no necesitamos guardar toda la lista.

### Complejidad

- Tiempo: O(n)
- Espacio: O(1) ← MEJOR que los anteriores, solo 2 variables

---

## CÓDIGO 4 — Coin Change (`coin_change`)

```python
def coin_change(monedas: list, objetivo: int) -> int:
    INF = float('inf')
    dp = [INF] * (objetivo + 1)
    dp[0] = 0

    for cantidad in range(1, objetivo + 1):
        for moneda in monedas:
            if moneda <= cantidad:
                dp[cantidad] = min(dp[cantidad], dp[cantidad - moneda] + 1)

    return dp[objetivo] if dp[objetivo] != INF else -1
```

### ¿Qué hace?

Dado un conjunto de monedas, encuentra la menor cantidad de monedas
necesarias para sumar exactamente el valor `objetivo`.

### La pregunta que responde dp[i]

"¿Cuántas monedas como mínimo necesito para formar la cantidad i?"

### Ejemplo: monedas=[1,5,10,25], objetivo=36

```
dp[0]  = 0   (0 monedas para hacer 0)
dp[1]  = 1   (una moneda de 1)
dp[5]  = 1   (una moneda de 5)
dp[10] = 1   (una moneda de 10)
dp[11] = 2   (10 + 1)
dp[25] = 1   (una moneda de 25)
dp[35] = 2   (25 + 10)
dp[36] = 3   (25 + 10 + 1)  ← respuesta
```

### La recurrencia en palabras simples

Para calcular dp[36], el algoritmo pregunta:
- Si uso moneda de 25 → necesito dp[11] + 1 = 2 + 1 = 3
- Si uso moneda de 10 → necesito dp[26] + 1 = 2 + 1 = 3
- Si uso moneda de 5  → necesito dp[31] + 1 = más monedas
- Si uso moneda de 1  → necesito dp[35] + 1 = 2 + 1 = 3

Elige el mínimo → 3 monedas.

### ¿Por qué no funciona Greedy aquí?

Greedy: "Siempre toma la moneda más grande posible"

Con monedas [1, 3, 4] y objetivo = 6:
- Greedy toma 4 → queda 2 → toma 1 → queda 1 → toma 1 → Total: 3 monedas ❌
- DP encuentra 3 + 3 = 6 → Total: 2 monedas ✅

Greedy no garantiza el mínimo. DP sí.

### Complejidad

- Tiempo: O(objetivo × len(monedas)) — dos bucles anidados
- Espacio: O(objetivo) — la lista dp

---

## CÓDIGO 5 — LCS: Subsecuencia Común más Larga (`lcs`)

```python
def lcs(s1: str, s2: str) -> int:
    m, n = len(s1), len(s2)
    dp = [[0]*(n+1) for _ in range(m+1)]

    for i in range(1, m+1):
        for j in range(1, n+1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    return dp[m][n]
```

### ¿Qué es una subsecuencia?

No es contigua. Puedes saltarte letras, pero debes mantener el orden.

```
s1 = "ABCBDAB"
s2 = "BDCABA"

Una subsecuencia común: "BCBA" (está en ambas en ese orden)
Longitud: 4
```

### La tabla DP (explicación visual)

Cada celda dp[i][j] responde: "¿Cuál es la LCS entre los primeros i
caracteres de s1 y los primeros j caracteres de s2?"

```
     ""  B  D  C  A  B  A
""  [ 0  0  0  0  0  0  0 ]
A   [ 0  0  0  0  1  1  1 ]
B   [ 0  1  1  1  1  2  2 ]
C   [ 0  1  1  2  2  2  2 ]
B   [ 0  1  1  2  2  3  3 ]
D   [ 0  1  2  2  2  3  3 ]
A   [ 0  1  2  2  3  3  4 ]
B   [ 0  1  2  2  3  4  4 ]  ← dp[7][6] = 4
```

### Las dos reglas de la recurrencia

**Regla 1 — letras iguales:**
```python
if s1[i-1] == s2[j-1]:
    dp[i][j] = dp[i-1][j-1] + 1
```
"Esta letra cuenta, súmala a la LCS de lo que había antes"

**Regla 2 — letras diferentes:**
```python
dp[i][j] = max(dp[i-1][j], dp[i][j-1])
```
"Esta letra no cuenta, toma el mejor resultado ignorando una u otra"

### Cómo explicarlo en clase

"Imagina que vas comparando letra por letra. Cuando dos letras coinciden,
las marcas como parte de la subsecuencia y avanzas en ambas cadenas.
Cuando no coinciden, dejas la mejor opción que tenías antes."

### Complejidad

- Tiempo: O(m × n) — tabla completa
- Espacio: O(m × n) — tabla de (m+1)×(n+1)

---

## CÓDIGO 6 — Knapsack 0/1 (`knapsack`)

```python
def knapsack(pesos, valores, capacidad):
    n = len(pesos)
    dp = [[0]*(capacidad+1) for _ in range(n+1)]

    for i in range(1, n+1):
        for w in range(capacidad+1):
            dp[i][w] = dp[i-1][w]
            if pesos[i-1] <= w:
                con_item = dp[i-1][w-pesos[i-1]] + valores[i-1]
                dp[i][w] = max(dp[i][w], con_item)

    return dp[n][capacidad]
```

### ¿Qué hace?

Tienes una mochila con capacidad limitada (peso máximo).
Tienes ítems, cada uno con peso y valor.
¿Qué combinación de ítems mete el mayor valor sin exceder el peso?

### Ejemplo

```
pesos   = [2, 3, 4, 5]
valores = [3, 4, 5, 6]
capacidad = 5

Mejor opción: ítem 0 (peso 2, valor 3) + ítem 1 (peso 3, valor 4)
Peso total: 2 + 3 = 5 ✅
Valor total: 3 + 4 = 7
```

### La pregunta que responde dp[i][w]

"¿Cuál es el máximo valor que puedo meter en una mochila de capacidad w
usando solo los primeros i ítems?"

### Las dos decisiones por cada ítem

Para cada ítem y cada capacidad, tienes dos opciones:

```
Opción 1 — NO incluir el ítem i:
    dp[i][w] = dp[i-1][w]
    (El valor es el mismo que sin considerar ese ítem)

Opción 2 — SÍ incluir el ítem i (solo si cabe):
    dp[i][w] = dp[i-1][w - peso[i]] + valor[i]
    (Reservo espacio para el ítem y tomo el mejor valor del resto)

Eliges la que da más valor.
```

### Cómo explicarlo con analogía

"Imagina que estás empacando una maleta para un viaje. Por cada objeto
te preguntas: ¿Lo llevo o no lo llevo? Si lo llevas, ocupas espacio pero
ganas valor. Si no lo llevas, guardas el espacio. El algoritmo prueba
todas las combinaciones de forma inteligente sin repetir cálculos."

### La diferencia con 0/1

El "0/1" significa que cada ítem o lo incluyes (1) o no lo incluyes (0).
No puedes llevar medio ítem ni llevar el mismo ítem dos veces.

### Complejidad

- Tiempo: O(n × W) — donde n=cantidad de ítems, W=capacidad
- Espacio: O(n × W) — tabla completa

---

## CÓDIGO 7 — Distancia de Edición (`edit_distance`)

```python
def edit_distance(s1: str, s2: str) -> int:
    m, n = len(s1), len(s2)
    dp = [[0]*(n+1) for _ in range(m+1)]

    for i in range(m+1): dp[i][0] = i
    for j in range(n+1): dp[0][j] = j

    for i in range(1, m+1):
        for j in range(1, n+1):
            if s1[i-1] == s2[j-1]:
                dp[i][j] = dp[i-1][j-1]
            else:
                dp[i][j] = 1 + min(dp[i-1][j],
                                   dp[i][j-1],
                                   dp[i-1][j-1])
    return dp[m][n]
```

### ¿Qué hace?

Calcula el mínimo número de operaciones para transformar una cadena en otra.
Las operaciones permitidas son:
- **Insertar** un carácter
- **Eliminar** un carácter
- **Reemplazar** un carácter

### Ejemplo

```
s1 = "kitten"
s2 = "sitting"

Pasos:
1. kitten → sitten   (reemplaza k→s)
2. sitten → sittin   (reemplaza e→i)
3. sittin → sitting  (inserta g al final)

Total: 3 operaciones
```

### Los casos base (primera fila y primera columna)

```
dp[i][0] = i  → para transformar s1[:i] en cadena vacía necesitas i eliminaciones
dp[0][j] = j  → para transformar cadena vacía en s2[:j] necesitas j inserciones
```

### Las tres operaciones en código

```
Letras iguales → sin operación:
    dp[i][j] = dp[i-1][j-1]

Letras diferentes → elige la más barata + 1:
    dp[i-1][j]   = eliminar carácter de s1
    dp[i][j-1]   = insertar carácter en s1
    dp[i-1][j-1] = reemplazar carácter
```

### Aplicaciones reales

- Correctores ortográficos ("¿Quisiste decir...?")
- Comparación de ADN en bioinformática
- Sistemas de control de versiones (diff)
- Búsquedas aproximadas en bases de datos

### Complejidad

- Tiempo: O(m × n)
- Espacio: O(m × n)

---

## Tabla Resumen de todos los algoritmos

| Algoritmo       | Problema que resuelve           | Tiempo         | Espacio   |
|-----------------|----------------------------------|----------------|-----------|
| `fib_memo`      | Fibonacci con caché              | O(n)           | O(n)      |
| `fib_tabla`     | Fibonacci con tabla              | O(n)           | O(n)      |
| `fib_optimo`    | Fibonacci optimizado             | O(n)           | O(1)      |
| `coin_change`   | Mínimo de monedas para un monto  | O(n × m)       | O(n)      |
| `lcs`           | Subsecuencia común más larga     | O(m × n)       | O(m × n)  |
| `knapsack`      | Máximo valor en mochila limitada | O(n × W)       | O(n × W)  |
| `edit_distance` | Mínimo de ediciones entre textos | O(m × n)       | O(m × n)  |

---

## Consejos para explicar DP en clase

1. **Empieza por Fibonacci.** Es el ejemplo más simple y todos lo conocen.
2. **Dibuja la tabla en el tablero.** DP es visual, llena las celdas a mano.
3. **Pregunta siempre:** "¿Qué significa dp[i]?" antes de escribir código.
4. **Usa analogías cotidianas** (monedas, maletas, palabras) para conectar con la vida real.
5. **Compara con Greedy.** Muestra cuándo Greedy falla para motivar DP.
6. **No expliques la optimización de espacio al principio.** Primero entiende la tabla, luego optimiza.
