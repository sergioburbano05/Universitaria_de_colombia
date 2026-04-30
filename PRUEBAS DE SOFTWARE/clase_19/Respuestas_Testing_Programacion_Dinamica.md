# Respuestas: Testing y Programación Dinámica

## Respuestas - Testing

### Introducción al Testing

#### 1. ¿Cuál es la principal desventaja de las pruebas manuales a largo plazo?

**Respuesta:**
La principal desventaja es el **costo exponencial en mantenimiento y tiempo**. A medida que la aplicación crece:

- Hay que ejecutar las mismas pruebas repetidamente (miles de casos)
- Cada cambio requiere re-ejecutar todas las pruebas manualmente
- Los testers humanos son propensos a errores y cansancio
- No es escalable (agregar más testers es costoso)
- Toma mucho tiempo (horas o días para una suite completa)

**Ejemplo práctico:**
```
Aplicación pequeña: 50 casos de prueba
- Tiempo manual: 8 horas
- Costo: $500 (1 tester por día)

Aplicación grande: 5000 casos de prueba
- Tiempo manual: 1 mes completo
- Costo: $10,000+ (equipo de testers)
- Riesgo: Se olvidan pruebas o se hacen mal
```

#### 2. ¿En qué escenarios son más efectivas las pruebas manuales?

**Respuesta:**
Las pruebas manuales son más efectivas en:

| Escenario | Razón |
|-----------|-------|
| **Exploratory Testing** | Descubrir bugs inesperados sin scripts |
| **UX/Usabilidad** | Evaluar experiencia visual y navegación |
| **Cambios frecuentes** | Cuando la app cambia constantemente |
| **Interfaces complejas** | Difícil de automatizar visualmente |
| **Pruebas ad-hoc** | Casos específicos o puntuales |
| **Testing en dispositivos reales** | Probar en móviles, tablets reales |

**Ejemplo:**
```
Un tester explora la app y descubre:
"Si presiono el botón de atrás 10 veces rápidamente, 
se corrompen los datos"

Esto es difícil de automatizar pero fácil de encontrar manualmente.
```

---

### Tipos de Testing

#### 3. ¿Cuál es la diferencia principal entre unit tests e integration tests?

**Respuesta:**

| Aspecto | Unit Tests | Integration Tests |
|--------|-----------|------------------|
| **Alcance** | Un componente individual | Múltiples componentes juntos |
| **Velocidad** | Muy rápido (milisegundos) | Más lento (segundos) |
| **Aislamiento** | Totalmente aislado (usa mocks) | Con dependencias reales |
| **Objetivo** | Validar lógica individual | Validar comunicación entre módulos |
| **Ejemplo** | Probar función `calcular_impuesto()` | Probar que BD + API + Cache funcionan juntas |
| **Cobertura** | Alta (80-90%) | Más baja (40-50%) |

**Código comparativo:**
```python
# UNIT TEST - Aislado
def test_calcular_impuesto():
    resultado = calcular_impuesto(100, 0.19)
    assert resultado == 119  # Rápido, sin DB

# INTEGRATION TEST - Con dependencias
def test_crear_usuario_con_notificacion():
    usuario = crear_usuario("test@test.com")  # Usa DB real
    assert usuario.id > 0
    assert correo_enviado("test@test.com")    # Verifica email enviado
```

#### 4. ¿Por qué TDD ayuda a escribir mejor código?

**Respuesta:**
TDD mejora la calidad del código porque:

1. **Diseño antes que implementación:**
   - Piensas en la interfaz antes de escribir lógica
   - Resultado: APIs más limpias

2. **Código más modular:**
   - Para ser testeable, el código debe estar desacoplado
   - Menos dependencias entre módulos

3. **Documentación viva:**
   - Las pruebas documentan cómo usar el código
   - Ejemplos en las pruebas

4. **Menos bugs:**
   - El código se valida desde el inicio
   - Menos deuda técnica

5. **Refactorización segura:**
   - Cambias código con confianza
   - Las pruebas detectan si rompes algo

**Ejemplo del impacto:**
```python
# SIN TDD - Código acoplado, difícil de probar
class UsuarioService:
    def crear_usuario(self, datos):
        db = Database()  # Acoplado a BD
        email = EmailService()  # Acoplado a email
        usuario = db.insert(datos)
        email.enviar(usuario.email, "Bienvenido")
        return usuario

# CON TDD - Código desacoplado, fácil de probar
class UsuarioService:
    def __init__(self, db, email_service):  # Inyección de dependencias
        self.db = db
        self.email = email_service
    
    def crear_usuario(self, datos):
        usuario = self.db.insert(datos)
        self.email.enviar(usuario.email, "Bienvenido")
        return usuario

# Ahora es fácil testear con mocks:
def test_crear_usuario():
    mock_db = MockDatabase()
    mock_email = MockEmailService()
    service = UsuarioService(mock_db, mock_email)
    usuario = service.crear_usuario({"nombre": "Juan"})
    assert usuario.nombre == "Juan"
```

#### 5. ¿Qué prueba verificaría que dos módulos se comunican correctamente?

**Respuesta:**
**Integration Tests** verifican que dos módulos se comunican correctamente.

**Ejemplo:**
```python
# Módulo A: obtener usuario
class UsuarioRepository:
    def obtener(self, id):
        return api.get(f"/usuarios/{id}")

# Módulo B: procesar usuario
class UsuarioService:
    def __init__(self, repository):
        self.repository = repository
    
    def obtener_usuario_mayor(self, id):
        usuario = self.repository.obtener(id)
        return usuario.edad > 18

# INTEGRATION TEST - Verifica comunicación
def test_modulos_se_comunican():
    # Repository obtiene de API
    # Service procesa lo que retorna Repository
    
    api.mock_response({
        "id": 1,
        "nombre": "Juan",
        "edad": 25
    })
    
    service = UsuarioService(UsuarioRepository())
    es_mayor = service.obtener_usuario_mayor(1)
    
    assert es_mayor == True  # Módulos se comunicaron correctamente
```

---

### Tipos Avanzados de Testing

#### 6. ¿Cuál es la diferencia entre regression testing y smoke testing?

**Respuesta:**

| Aspecto | Regression Testing | Smoke Testing |
|--------|------------------|----------------|
| **Objetivo** | Verificar que cambios NO rompieron lo viejo | Verificar que lo crítico funciona |
| **Alcance** | Completo (toda la funcionalidad) | Solo funciones críticas |
| **Duración** | Horas o días | 5-15 minutos |
| **Cuándo** | Después de cada cambio importante | Primer filtro después de deployment |
| **Detalle** | Profundo | Superficial |
| **Ejemplo** | Probar login, logout, cambio password, etc. | ¿Abre la app? ¿Va a login? ¿Se carga dashboard? |

**Ejemplo real:**
```
Versión 2.0 se libera

1. Smoke Testing (5 min):
   ✓ App inicia
   ✓ Login funciona
   ✓ Dashboard carga
   → Si pasa, continuamos
   → Si falla, detenemos todo

2. Regression Testing (8 horas):
   - Pruebas del login
   - Pruebas del checkout
   - Pruebas de reportes
   - Pruebas de permisos
   - Pruebas de integraciones
   → Verifica que nada se rompió
```

#### 7. ¿Por qué el exploratory testing es importante si tenemos pruebas automatizadas?

**Respuesta:**
Porque **las pruebas automatizadas solo validan lo que programaste que validen**.

**Razones:**
1. **Encuentran bugs inesperados:** Un humano puede pensar "¿Qué pasa si...?" de formas que no anticipaste
2. **Mejoran cobertura:** Encuentran flujos que no documentaste
3. **Validan UX:** No solo funciona, sino ¿es usable?
4. **Efectividad:** Más bugs encontrados en menos tiempo
5. **Complementario:** Las automatizadas validan "cosas conocidas", las exploratorias buscan "lo desconocido"

**Ejemplo:**
```
Pruebas Automatizadas dicen: ✓ Todo funciona

Exploratory Testing descubre:
- Si hago click rápido 10 veces, se duplican datos
- Si pierdo conexión a internet, la app se congela
- En móvil, los botones no se ven bien con teclado activado
- Si cambio el idioma, algunos textos se cortan
```

#### 8. ¿Qué métrica es más importante en performance testing?

**Respuesta:**
Depende del contexto, pero en orden de importancia:

1. **Tiempo de respuesta (Response Time)** - MÁS IMPORTANTE
   - Cómo se siente el usuario
   - Si > 3 segundos, el usuario se aburre

2. **Throughput (Transacciones por segundo)**
   - ¿Cuántos usuarios simultáneos soporta?

3. **Latencia (Latency)**
   - Tiempo en la red

4. **Uso de recursos (CPU, Memoria)**
   - ¿Hay memory leaks?
   - ¿Está optimizado?

**Ejemplo práctico:**
```
Ecommerce en Black Friday
Requisito: 10,000 usuarios simultáneos

Métricas aceptables:
✓ Tiempo respuesta: < 500ms
✓ Throughput: 1000 transacciones/segundo
✓ CPU: < 80%
✓ Memoria: < 90% usada

Si el tiempo es 2 segundos, aunque CPU esté bajo: ❌ FALLA
```

#### 9. ¿Qué es Continuous Integration (CI)?

**Respuesta:**
Es una práctica de **integrar código frecuentemente** (varias veces al día) con **ejecución automática de pruebas**.

**Principios:**
1. Los desarrolladores hacen commits diariamente
2. Cada commit automáticamente:
   - Clona el código
   - Compila
   - Ejecuta pruebas
   - Analiza calidad
   - Genera reporte
3. Si hay error, se notifica al equipo inmediatamente

**Flujo:**
```
Dev hace push → Git recibe cambios → CI detecta → 
Ejecuta tests → Si todos pasan → Se integra → 
Si alguno falla → Notifica al dev → Dev arregla → 
Vuelve a ejecutar tests
```

**Beneficios:**
- Detecta bugs rápidamente
- Evita integrar código "roto"
- Más confianza en deployments
- Feedback inmediato

**Herramientas:**
- Jenkins, GitLab CI, GitHub Actions, Azure Pipelines

#### 10. ¿Cuáles son las ventajas de usar servicios en la nube para CI?

**Respuesta:**

| Ventaja | Explicación |
|---------|------------|
| **Escalabilidad** | Ejecuta 1000 tests en paralelo sin infra propia |
| **Sin mantenimiento** | No administras servidores |
| **Global** | Acceso desde cualquier lugar |
| **Costo flexible** | Pagas por lo que usas |
| **Integración fácil** | Se conecta con GitHub, GitLab, etc. |
| **Seguridad** | Proveedores expertos en seguridad |
| **Backups automáticos** | Tus datos están seguros |

**Comparación:**

```
On-Premises (Local):
- Servidor propio: $10,000 inversión inicial
- Administrador: $50,000/año
- Mantenimiento, electricidad: $5,000/año
- Total: $65,000+/año
- Escalamiento: Difícil y caro

Cloud (AWS, Google Cloud, Azure):
- $500-1000/mes en uso
- Total: $6,000-12,000/año
- Escalamiento: Automático
- Ahorras: $50,000+/año
```

---

## Respuestas - Programación Dinámica

### 1. ¿Cuáles son los dos requisitos principales para aplicar DP?

**Respuesta:**

#### Requisito 1: **Subestructura Óptima**
Una solución óptima del problema está compuesta por soluciones óptimas de sus subproblemas.

**Ejemplo (Problema de la mochila):**
```
Si la solución óptima de llenar una mochila de 10kg
incluye llenar 5kg óptimamente, entonces la mejor forma
de llenar esos 5kg es su solución óptima.
```

#### Requisito 2: **Subproblemas Superpuestos**
El mismo subproblema se resuelve múltiples veces.

**Ejemplo (Fibonacci):**
```
fib(5) = fib(4) + fib(3)
fib(4) = fib(3) + fib(2)

Observa: fib(3) se calcula DOS VECES
Si n es grande, fib(3) se calcula millones de veces
```

**Sin DP (ineficiente):**
```
fib(5)
├── fib(4)
│   ├── fib(3)  ← Primera vez
│   │   ├── fib(2)
│   │   └── fib(1)
│   └── fib(2)
└── fib(3)  ← Segunda vez (¡Repetido!)
    ├── fib(2)
    └── fib(1)
```

**Con DP (eficiente):**
```
Calcula fib(3) UNA sola vez
Reutiliza el resultado
```

---

### 2. ¿Cuál es la diferencia entre memoización y tabulación?

**Respuesta:**

| Aspecto | Memoización | Tabulación |
|--------|------------|-----------|
| **Enfoque** | Top-Down (de arriba hacia abajo) | Bottom-Up (de abajo hacia arriba) |
| **Recursión** | Sí | No (iterativo) |
| **Memoria** | Usa diccionario/hash | Usa tabla/array |
| **Orden de cálculo** | Según se necesite | Orden predefinido |
| **Claridad** | Más legible | Menos intuitivo inicialmente |
| **Eficiencia** | Ligeramente más lento (recursión) | Más rápido |

**Código comparativo:**

**Memoización (Top-Down):**
```python
def fib_memo(n, memo={}):
    # Revisa si ya calculamos
    if n in memo:
        return memo[n]
    
    # Caso base
    if n <= 1:
        return n
    
    # Calcula y guarda en memo
    memo[n] = fib_memo(n-1, memo) + fib_memo(n-2, memo)
    return memo[n]

# Llamada
print(fib_memo(10))  # Calcula recursivamente, pero con memoria
```

**Tabulación (Bottom-Up):**
```python
def fib_tab(n):
    # Crea tabla
    dp = [0] * (n + 1)
    dp[0], dp[1] = 0, 1
    
    # Calcula de abajo hacia arriba
    for i in range(2, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    
    return dp[n]

# Llamada
print(fib_tab(10))  # Calcula iterativamente desde el inicio
```

**Complejidad:**
- Ambas: O(n) tiempo, O(n) espacio
- Tabulación es ~10-20% más rápida (sin overhead de recursión)

---

### 3. ¿Por qué la solución de Fibonacci con DP es más rápida que sin DP?

**Respuesta:**
Porque **evita recalcular los mismos valores múltiples veces**.

**Sin DP - Explosión exponencial:**
```python
def fib_sin_dp(n):
    if n <= 1:
        return n
    return fib_sin_dp(n-1) + fib_sin_dp(n-2)

# Análisis:
# fib_sin_dp(5):
#   - fib(4) + fib(3)
#   - fib(4) necesita: fib(3), fib(2)
#   - fib(3) se calcula MÚLTIPLES VECES
#
# Complejidad: O(2^n) - EXPONENCIAL
# fib_sin_dp(30) tarda 1+ segundo
# fib_sin_dp(50) tomaría AÑOS
```

**Árbol de recursión sin DP (fib(5)):**
```
                 fib(5)
               /        \
            fib(4)       fib(3)
           /      \        /    \
        fib(3)   fib(2)  fib(2)  fib(1)
        /   \     /  \    /  \
    fib(2) fib(1) fib(1) fib(0) fib(1) fib(0)
    / \
fib(1) fib(0)

Observa: fib(2) se calcula 3 veces
         fib(3) se calcula 2 veces
         Total: 15 llamadas para n=5
```

**Con DP:**
```python
def fib_con_dp(n):
    memo = {}
    
    def helper(x):
        if x in memo:
            return memo[x]  # ← Devuelve resultado guardado
        if x <= 1:
            return x
        memo[x] = helper(x-1) + helper(x-2)
        return memo[x]
    
    return helper(n)

# Complejidad: O(n) - LINEAL
# fib_con_dp(30) es instantáneo
# fib_con_dp(50) es instantáneo
```

**Comparación de velocidad:**
```
n=30:
- Sin DP:  1.5 segundos
- Con DP:  0.0001 segundos
- Mejora:  15,000x más rápido

n=50:
- Sin DP:  Tomaría horas
- Con DP:  0.0002 segundos
- Mejora:  ∞ (prácticamente)
```

---

### 4. Explica el problema de la mochila en tus propias palabras.

**Respuesta:**

**Definición simple:**
Tienes una mochila con capacidad limitada (peso o espacio). Tienes varios ítems con peso y valor. ¿Cuáles ítems eliges para **maximizar el valor total** sin exceder la capacidad?

**Escenario real:**
```
Vas a un campamento de 3 días.
Mochila: máximo 10 kg

Opciones:
- Laptop: 2kg, lo usarás (valor 5)
- Tablet: 1kg, lo usarás (valor 4)
- Ropa: 4kg, necesaria (valor 3)
- Libros: 3kg, no tan importante (valor 1)

¿Qué llevas?
Mejor opción: Laptop (2kg, valor 5) + Tablet (1kg, valor 4) + Ropa (4kg, valor 3)
= 7kg, valor total 12 (máximo posible sin exceder 10kg)
```

**Problema más formal:**
```
Dada:
- Capacidad W de la mochila
- n ítems, cada uno con peso w[i] y valor v[i]

Encontrar:
- Subconjunto de ítems tal que:
  - Suma de pesos ≤ W
  - Suma de valores es máxima
```

**Solución con DP:**
```python
def mochila(W, pesos, valores, n):
    # dp[i][w] = máximo valor con primeros i ítems y capacidad w
    dp = [[0] * (W + 1) for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        for w in range(W + 1):
            if pesos[i-1] <= w:
                # Puedo incluir este ítem
                incluir = valores[i-1] + dp[i-1][w - pesos[i-1]]
                excluir = dp[i-1][w]
                dp[i][w] = max(incluir, excluir)
            else:
                # No cabe, lo excluyo
                dp[i][w] = dp[i-1][w]
    
    return dp[n][W]

# Ejemplo
W = 10
pesos = [2, 1, 4, 3]
valores = [5, 4, 3, 1]
print(mochila(W, pesos, valores, 4))  # 12
```

**Aplicaciones reales:**
- Asignación de presupuesto
- Carga de camión/avión
- Selección de proyectos
- Planificación de recursos

---

### 5. ¿Cómo se relaciona LCS con aplicaciones reales?

**Respuesta:**

**LCS (Longest Common Subsequence)** - Subsecuencia Común Máxima

Una **subsecuencia** es una secuencia que aparece en el mismo orden pero no necesariamente contigua.

**Ejemplo:**
```
String A: "AGGTAB"
String B: "GXTXAYB"

LCS: "GTAB" (longitud 4)

Explicación:
A: A[G][G]T[A][B]  ← Toma G, G, A, B
B: [G]X T X [A] [B] ← Aparecen en este orden
```

**Aplicaciones reales:**

1. **Diff/Version Control (Git)**
   ```
   Archivo versión 1:
   def hola():
       print("Hola")
       return True
   
   Archivo versión 2:
   def hola():
       print("Hola Mundo")
       return True
   
   Git usa LCS para mostrar:
   - Qué líneas se mantienen (común)
   - Qué cambió (diferente)
   ```

2. **DNA Sequencing (Bioinformática)**
   ```
   DNA secuencia A: AGGTAB
   DNA secuencia B: GXTXAYB
   
   LCS: GTAB - Partes similares del DNA
   Ayuda a detectar genes similares
   ```

3. **Comparación de documentos**
   ```
   Documento original: "El gato come pescado"
   Documento editado: "El gato come pescado fresco"
   
   LCS: "El gato come pescado"
   Cambio: Se agregó "fresco"
   ```

4. **Plagiarism Detection**
   ```
   Texto A: "La programación es difícil pero importante"
   Texto B: "La programación es difícil pero no importante"
   
   LCS: "La programación es difícil pero"
   Similitud: 70% - Posible plagio
   ```

5. **Autocomplete / Fuzzy Search**
   ```
   Escribes: "pthn"
   El sistema busca LCS con palabras disponibles
   Encuentra: "python" (LCS de 4 caracteres)
   Sugiere: "python"
   ```

6. **Video Compression**
   ```
   Frame anterior: datos de video
   Frame actual: datos de video
   
   LCS identifica qué no cambió
   Se transmite solo lo que cambió
   Reduce tamaño de archivo
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
    
    # Reconstruir la subsecuencia
    lcs_str = ""
    i, j = m, n
    while i > 0 and j > 0:
        if X[i-1] == Y[j-1]:
            lcs_str = X[i-1] + lcs_str
            i -= 1
            j -= 1
        elif dp[i-1][j] > dp[i][j-1]:
            i -= 1
        else:
            j -= 1
    
    return lcs_str

print(lcs("AGGTAB", "GXTXAYB"))  # "GTAB"
```

---

## Resumen Final

### Key Takeaways - Testing
✅ Las pruebas automatizadas son esenciales, pero las manuales aún tienen valor  
✅ TDD produce código mejor diseñado  
✅ CI/CD acelera la detección de bugs  
✅ La combinación de tests en la nube escala sin limite  

### Key Takeaways - Programación Dinámica
✅ DP transforma problemas exponenciales en polinomiales  
✅ Memoización es más intuitiva, tabulación es más rápida  
✅ Reconocer cuándo usar DP es la habilidad clave  
✅ Aplicaciones reales: versionado, biología, compresión, búsqueda  

---

**Este documento es una guía de estudio para evaluaciones y práctica.**
