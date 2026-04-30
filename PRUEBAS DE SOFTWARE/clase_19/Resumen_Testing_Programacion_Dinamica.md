# Resumen: Testing y Programación Dinámica

## Tabla de Contenidos
1. [Introducción al Testing](#introducción-al-testing)
2. [Tipos de Testing](#tipos-de-testing)
3. [Automatización de Pruebas](#automatización-de-pruebas)
4. [Programación Dinámica](#programación-dinámica)

---

## Introducción al Testing

### Manual vs Automated Testing

#### Pruebas Manuales
Son aquellas ejecutadas por un QA o tester de forma manual, sin automatización.

**Ventajas:**
- Flexibilidad en la exploración
- Rápidas para cambios pequeños
- Buen para UX testing

**Desventajas:**
- Lentas a escala
- Propenso a errores humanos
- Alto costo en mantenimiento

**Ejemplo:**
```
Un tester abre la aplicación, hace clic en "Login", 
ingresa credenciales y verifica que aparezca el dashboard.
```

#### Pruebas Automatizadas
Se utilizan scripts y herramientas para ejecutar pruebas.

**Ventajas:**
- Rápidas y escalables
- Consistentes
- Bajo costo a largo plazo

**Desventajas:**
- Require inversión inicial
- Requiere habilidades técnicas

**Ejemplo:**
```python
def test_login():
    driver.get("https://app.com/login")
    driver.find_element("email").send_keys("user@test.com")
    driver.find_element("password").send_keys("password123")
    driver.find_element("login_btn").click()
    assert "dashboard" in driver.current_url
```

### Preguntas de Repaso
1. ¿Cuál es la principal desventaja de las pruebas manuales a largo plazo?
2. ¿En qué escenarios son más efectivas las pruebas manuales?

---

## Tipos de Testing

### Unit Tests (Pruebas Unitarias)
Prueban componentes individuales en aislamiento.

**Objetivo:** Validar que cada función/método funcione correctamente.

**Ejemplo en Python:**
```python
def suma(a, b):
    return a + b

def test_suma():
    assert suma(2, 3) == 5
    assert suma(-1, 1) == 0
    assert suma(0, 0) == 0
```

**Características:**
- Rápidas de ejecutar
- Fáciles de mantener
- Detectan bugs tempranamente

### Integration Tests (Pruebas de Integración)
Prueban la interacción entre múltiples componentes.

**Objetivo:** Validar que los módulos funcionen bien juntos.

**Ejemplo:**
```python
# Módulo A: obtener usuario
def get_user(user_id):
    return database.query(f"SELECT * FROM users WHERE id={user_id}")

# Módulo B: obtener órdenes del usuario
def get_user_orders(user_id):
    user = get_user(user_id)  # Depende de Módulo A
    return database.query(f"SELECT * FROM orders WHERE user_id={user_id}")

def test_integration():
    orders = get_user_orders(1)
    assert len(orders) > 0
```

### Functional Tests (Pruebas Funcionales)
Prueban la funcionalidad completa de extremo a extremo (E2E).

**Objetivo:** Validar flujos completos desde la perspectiva del usuario.

**Ejemplo:**
```
Flujo: Crear una orden
1. Usuario inicia sesión
2. Navega a catálogo
3. Selecciona producto
4. Agrega al carrito
5. Realiza checkout
6. Sistema envía confirmación
7. Verifica que la orden aparezca en historial
```

### Test Driven Development (TDD)
Metodología donde se escriben las pruebas ANTES del código.

**Ciclo:**
1. Red (Rojo) - Escribir prueba que falla
2. Green (Verde) - Escribir código mínimo para pasar
3. Refactor (Refactorización) - Mejorar el código

**Ejemplo TDD:**
```python
# PASO 1: Escribir prueba (falla)
def test_calcular_descuento():
    assert calcular_descuento(100, 0.10) == 90

# PASO 2: Escribir código mínimo (pasa)
def calcular_descuento(precio, descuento):
    return precio * (1 - descuento)

# PASO 3: Refactorizar si es necesario
```

### Preguntas de Repaso
1. ¿Cuál es la diferencia principal entre unit tests e integration tests?
2. ¿Por qué TDD ayuda a escribir mejor código?
3. ¿Qué prueba verificaría que dos módulos se comunican correctamente?

---

## Tipos Avanzados de Testing

### Regression Testing (Pruebas de Regresión)
Verifica que los cambios nuevos no rompan funcionalidad existente.

**Objetivo:** Prevenir bugs que afecten características que ya funcionaban.

**Escenario:**
```
Se actualiza la función de login para soportar 2FA.
Las pruebas de regresión verifican que:
- El login básico sigue funcionando
- Las sesiones se mantienen correctamente
- No se afectó el logout
```

### Smoke Testing (Pruebas de Humo)
Pruebas rápidas que verifican funcionalidad crítica.

**Objetivo:** Detectar rápidamente problemas graves sin entrar en detalles.

**Ejemplo:**
```
Suite de Smoke Testing:
✓ ¿La app inicia?
✓ ¿Aparece la página de login?
✓ ¿Se puede hacer login?
✓ ¿Se carga el dashboard?
```

**Duración:** Minutos (no horas)

### Acceptance Testing (Pruebas de Aceptación)
Valida que el software cumple los requisitos del cliente.

**Criterios de Aceptación:**
```
Requisito: Un usuario debe poder cambiar su contraseña
Aceptación:
- El usuario puede acceder a la sección de perfil
- El sistema pide la contraseña actual
- Valida que la nueva contraseña sea fuerte
- Envía email de confirmación
- El nuevo password funciona en el próximo login
```

### Performance Testing (Pruebas de Rendimiento)
Mide velocidad, escalabilidad y estabilidad del sistema.

**Métricas Clave:**
- Tiempo de respuesta
- Throughput (transacciones por segundo)
- Uso de CPU y memoria
- Tiempo bajo carga

**Ejemplo:**
```
Prueba de carga: 1000 usuarios simultáneos
Resultado:
- Tiempo promedio respuesta: 200ms ✓
- 99% de requests < 500ms ✓
- CPU: 65% ✓
- Memoria: 2GB ✓
```

### Exploratory Testing (Pruebas Exploratorias)
Enfoque flexible donde el tester explora la aplicación sin scripts predefinidos.

**Ventajas:**
- Encuentra bugs inesperados
- Adapta las pruebas sobre la marcha
- Prueba flujos reales de usuario

**Ejemplo:**
```
Tester: "¿Qué pasa si presiono el botón de atrás rápidamente?"
"¿Y si dejo una sesión abierta por días?"
"¿Qué ocurre con caracteres especiales en nombres?"
```

### Preguntas de Repaso
1. ¿Cuál es la diferencia entre regression testing y smoke testing?
2. ¿Por qué el exploratory testing es importante si tenemos pruebas automatizadas?
3. ¿Qué métrica es más importante en performance testing?

---

## Automatización de Pruebas

### ¿Por Qué Automatizar?

**Beneficios:**
- Ejecución rápida (miles de pruebas en minutos)
- Repetibilidad exacta
- Reducción de costos a largo plazo
- Detección temprana de bugs

### Continuous Integration (CI)

**Concepto:** Integrar cambios frecuentemente y ejecutar pruebas automáticamente.

**Flujo CI:**
```
1. Developer hace push de código
   ↓
2. Sistema detecta cambios
   ↓
3. Clona el repositorio
   ↓
4. Ejecuta todas las pruebas automáticamente
   ↓
5. Genera reporte de resultados
   ↓
6. Notifica al equipo (éxito/fallo)
```

**Herramientas populares:**
- Jenkins
- GitLab CI/CD
- GitHub Actions
- Azure DevOps

### Servicios en la Nube

**Ventajas de ejecutar pruebas en la nube:**
- Escalabilidad ilimitada
- No requiere infraestructura local
- Ejecución paralela de tests
- Acceso desde cualquier lugar

**Proveedores:**
- AWS CodePipeline
- Google Cloud Build
- Azure Pipelines

### Ejemplo de Pipeline CI/CD:
```yaml
stages:
  - build
  - test
  - deploy

unit_tests:
  stage: test
  script:
    - pytest tests/unit/ -v
  
integration_tests:
  stage: test
  script:
    - pytest tests/integration/ -v
  
smoke_tests:
  stage: test
  script:
    - pytest tests/smoke/ -v
```

### Preguntas de Repaso
1. ¿Qué es Continuous Integration?
2. ¿Cuáles son las ventajas de usar servicios en la nube para CI?

---

## Métricas de Calidad

### Métricas CK (Chidamber Kemerer)

Métricas de orientación a objetos para medir complejidad y calidad.

#### 1. **WMC (Weighted Methods per Class)**
Suma de la complejidad de los métodos de una clase.

```python
class UserService:
    def get_user(self, id):  # Complejidad 1
        return db.query(id)
    
    def validate_email(self, email):  # Complejidad 3 (varias condiciones)
        if '@' not in email:
            return False
        if len(email) < 5:
            return False
        if not email.endswith('.com'):
            return False
        return True
    
    def process_registration(self):  # Complejidad 2
        # ...
```
**WMC = 1 + 3 + 2 = 6** (Indicador de complejidad)

#### 2. **DIT (Depth of Inheritance Tree)**
Profundidad de la jerarquía de herencia.

```python
class Animal:
    pass

class Mamífero(Animal):
    pass

class Perro(Mamífero):
    pass

# DIT = 3
```

**Interpretación:** Valores altos pueden indicar diseño complejo.

#### 3. **RFC (Response For a Class)**
Número de métodos que pueden ser invocados por una clase.

### Procedimiento de Verificación

**Paso 1:** Identificar la métrica aplicable
**Paso 2:** Calcular el valor
**Paso 3:** Comparar con umbral aceptable
**Paso 4:** Tomar acciones correctivas si es necesario

---

## Programación Dinámica

### Generalidades

La Programación Dinámica (DP) es una técnica para resolver problemas optimizando subproblemas superpuestos.

**Características:**
- Descompone el problema en subproblemas
- Almacena resultados para evitar recálculos (memoización)
- Usa un enfoque bottom-up (tabulation)

**Requisitos para aplicar DP:**
1. Subestructura óptima
2. Subproblemas superpuestos

### El Problema de la Mochila (Knapsack Problem)

**Problema:** Llenar una mochila de capacidad W con ítems de peso y valor máximo.

**Ejemplo:**
```
Mochila: capacidad = 10 kg
Ítems:
- Laptop: 2kg, $2000
- Tablet: 1kg, $800
- Libro: 0.5kg, $20

¿Qué ítems seleccionar para maximizar valor?
Solución: Laptop + Tablet = 3kg, $2800
```

**Código:**
```python
def knapsack(W, weights, values, n):
    # Crear tabla DP
    dp = [[0] * (W + 1) for _ in range(n + 1)]
    
    # Llenar tabla
    for i in range(1, n + 1):
        for w in range(1, W + 1):
            if weights[i-1] <= w:
                dp[i][w] = max(
                    values[i-1] + dp[i-1][w - weights[i-1]],  # Incluir ítem
                    dp[i-1][w]                                  # Excluir ítem
                )
            else:
                dp[i][w] = dp[i-1][w]
    
    return dp[n][W]

# Uso
W = 10
weights = [2, 1, 0.5]
values = [2000, 800, 20]
print(knapsack(W, weights, values, 3))  # Salida: 2800
```

### Números de Fibonacci

**Definición:** F(n) = F(n-1) + F(n-2), con F(0)=0, F(1)=1

**Sin DP (Recursión pura - LENTO):**
```python
def fib_simple(n):
    if n <= 1:
        return n
    return fib_simple(n-1) + fib_simple(n-2)

# fib_simple(30) tarda segundos (recalcula muchas veces)
```

**Con DP (Memoización - RÁPIDO):**
```python
def fib_memo(n, memo={}):
    if n in memo:
        return memo[n]
    if n <= 1:
        return n
    
    memo[n] = fib_memo(n-1, memo) + fib_memo(n-2, memo)
    return memo[n]

# fib_memo(30) es instantáneo
```

**Con DP (Tabulation - MÁS EFICIENTE):**
```python
def fib_tab(n):
    if n <= 1:
        return n
    
    dp = [0] * (n + 1)
    dp[1] = 1
    
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]

print(fib_tab(10))  # 55
```

### Coeficientes Binomiales C(n, k)

**Fórmula:** C(n, k) = C(n-1, k-1) + C(n-1, k)

**Ejemplo:** C(5, 2) = 10 (5 elige 2)

```python
def binomial(n, k):
    # Crear tabla DP
    dp = [[0] * (k + 1) for _ in range(n + 1)]
    
    # Casos base
    for i in range(n + 1):
        dp[i][0] = 1
    
    # Llenar tabla
    for i in range(1, n + 1):
        for j in range(1, min(i, k) + 1):
            dp[i][j] = dp[i-1][j-1] + dp[i-1][j]
    
    return dp[n][k]

print(binomial(5, 2))  # 10
```

### Subsecuencia Común Máxima (LCS)

**Problema:** Encontrar la secuencia más larga común en dos strings.

**Ejemplo:**
```
String 1: "AGGTAB"
String 2: "GXTXAYB"
LCS: "GTAB" (longitud 4)
```

**Código:**
```python
def lcs(X, Y):
    m, n = len(X), len(Y)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    
    # Llenar tabla
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if X[i-1] == Y[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
    
    return dp[m][n]

print(lcs("AGGTAB", "GXTXAYB"))  # 4
```

### Problema del Camino de Mínimo Costo

**Problema:** Encontrar el camino desde (0,0) a (m,n) con costo mínimo.

**Ejemplo:**
```
Matriz de costos:
1  2  3
4  8  2
1  5  3

Camino mínimo: 1 → 2 → 3 → 2 → 3 = 11
```

**Código:**
```python
def min_cost_path(cost):
    m, n = len(cost), len(cost[0])
    dp = [[0] * n for _ in range(m)]
    
    # Inicializar
    dp[0][0] = cost[0][0]
    
    # Primera fila
    for j in range(1, n):
        dp[0][j] = dp[0][j-1] + cost[0][j]
    
    # Primera columna
    for i in range(1, m):
        dp[i][0] = dp[i-1][0] + cost[i][0]
    
    # Llenar tabla
    for i in range(1, m):
        for j in range(1, n):
            dp[i][j] = cost[i][j] + min(
                dp[i-1][j],      # desde arriba
                dp[i][j-1],      # desde izquierda
                dp[i-1][j-1]     # desde diagonal
            )
    
    return dp[m-1][n-1]

cost = [
    [1, 2, 3],
    [4, 8, 2],
    [1, 5, 3]
]
print(min_cost_path(cost))  # 11
```

### Asignación de Recursos

**Problema:** Distribuir recursos entre actividades para maximizar beneficio.

**Enfoque DP:**
```python
def resource_allocation(n, resources, benefits):
    # n = número de actividades
    # resources = cantidad total disponible
    # benefits[i][j] = beneficio de asignar j unidades a actividad i
    
    dp = [[0] * (resources + 1) for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        for r in range(resources + 1):
            for k in range(r + 1):
                dp[i][r] = max(
                    dp[i][r],
                    benefits[i-1][k] + dp[i-1][r-k]
                )
    
    return dp[n][resources]
```

### Preguntas de Repaso Programación Dinámica

1. ¿Cuáles son los dos requisitos principales para aplicar DP?
2. ¿Cuál es la diferencia entre memoización y tabulación?
3. ¿Por qué la solución de Fibonacci con DP es más rápida que sin DP?
4. Explica el problema de la mochila en tus propias palabras.
5. ¿Cómo se relaciona LCS con aplicaciones reales?

---

## Conclusión

El dominio de testing y programación dinámica son habilidades fundamentales en desarrollo de software:

- **Testing:** Garantiza que el código funcione correctamente y sea mantenible
- **Programación Dinámica:** Resuelve problemas complejos de manera eficiente

Ambas disciplinas requieren **práctica constante** y comprensión profunda de los conceptos.

---

## Referencias y Recursos

- Software Testing Best Practices
- Introduction to Algorithms (CLRS)
- Dynamic Programming Problems and Solutions
- CI/CD Best Practices

---

**Documento de estudio preparado para evaluación y repaso**
