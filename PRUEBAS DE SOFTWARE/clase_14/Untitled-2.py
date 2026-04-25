def min_path_sum_con_camino(grid: list):
    """
    Retorna (costo_minimo, lista_de_celdas_del_camino)
    """
    # m = número de filas, n = número de columnas de la matriz.
    m, n = len(grid), len(grid[0])

    # dp[i][j] guarda el costo mínimo acumulado para llegar a la celda (i, j).
    dp = [[0]*n for _ in range(m)]

    # parent[i][j] indica desde dónde llegamos a (i,j): 'U' o 'L'
    parent = [[None]*n for _ in range(m)]

    # La primera celda es el punto de partida, así que su costo es el mismo valor original.
    dp[0][0] = grid[0][0]

    # Primera fila: solo se puede avanzar desde la izquierda.
    for j in range(1, n):
        dp[0][j] = dp[0][j-1] + grid[0][j]
        parent[0][j] = 'L'  # vino de la izquierda

    # Primera columna: solo se puede avanzar desde arriba.
    for i in range(1, m):
        dp[i][0] = dp[i-1][0] + grid[i][0]
        parent[i][0] = 'U'  # vino de arriba

    # Para cada celda interior elegimos el camino más barato:
    # llegar desde arriba o llegar desde la izquierda.
    for i in range(1, m):
        for j in range(1, n):
            if dp[i-1][j] < dp[i][j-1]:
                dp[i][j] = dp[i-1][j] + grid[i][j]
                parent[i][j] = 'U'
            else:
                dp[i][j] = dp[i][j-1] + grid[i][j]
                parent[i][j] = 'L'

    # Reconstruir el camino de (m-1,n-1) hacia atrás
    camino = []
    i, j = m-1, n-1
    while i > 0 or j > 0:
        # Guardamos la celda actual y retrocedemos siguiendo la matriz parent.
        camino.append((i, j))
        if parent[i][j] == 'U': i -= 1
        else: j -= 1

    # Agregamos el origen y luego invertimos la lista para obtener
    # el recorrido desde el inicio hasta el final.
    camino.append((0, 0))
    

    return dp[m-1][n-1], list(reversed(camino)),dp

def ejecutar_min_path_sum_con_camino():
    # Ejemplo de costo mínimo con reconstrucción del camino.
    grid = [[1,3,1],[1,5,1],[4,2,1]]
    costo, camino, dp = min_path_sum_con_camino(grid)
    print(f'Costo: {costo}')
    print(f'Camino: {camino}')
    print('Tabla de caminos:')
    for fila in grid:
        print(fila)
    print('Tabla de costos acumulados:')
    for fila in dp:
        print(fila)



def subset_sum_con_elementos(nums: list, target: int):
    """
    Retorna (existe, lista_de_elementos) si existe el subconjunto.
    """
    # n es la cantidad de números disponibles.
    n = len(nums)

    # dp[i][s] será True si es posible formar la suma s usando
    # solo los primeros i elementos del arreglo nums.
    dp = [[False]*(target+1) for _ in range(n+1)]

    # La suma 0 siempre se puede formar: no escogiendo ningún elemento.
    for i in range(n+1):
        dp[i][0] = True

    # Construimos la tabla probando, para cada elemento y cada suma,
    # si conviene no usarlo o usarlo.
    for i in range(1, n+1):
        for s in range(1, target+1):
            # Opción 1: no usar el elemento actual.
            dp[i][s] = dp[i-1][s]

            # Opción 2: usar el elemento actual, si no supera la suma objetivo s.
            if nums[i-1] <= s:
                dp[i][s] = dp[i][s] or dp[i-1][s-nums[i-1]]

    # Si la celda final es False, no existe subconjunto que sume target.
    if not dp[n][target]:
        return False, []

    # Reconstruir los elementos
    elementos = []
    i, s = n, target
    while i > 0 and s > 0:
        # Si dp[i][s] es True pero dp[i-1][s] es False,
        # significa que incluimos nums[i-1]
        if not dp[i-1][s]:
            elementos.append(nums[i-1])
            s -= nums[i-1]

        # Pasamos al elemento anterior para seguir reconstruyendo.
        i -= 1

    return True, elementos

def ejecutar_subset_sum_con_elementos():
    # Ejemplos de subconjunto que sí existe y otro que no existe.
    existe, elems = subset_sum_con_elementos([3,34,4,12,5,1], 51)
    print(f'{existe}, elementos: {elems}')

    existe, elems = subset_sum_con_elementos([3,34,4,12,5,1], 38)
    print(f'{existe}, elementos: {elems}')



def rod_cut_con_cortes(precios: list, n: int):
    """
    Retorna (valor_maximo, lista_de_longitudes_de_corte)
    """
    # dp[i] guarda el mayor valor posible para una varilla de longitud i.
    dp = [0] * (n + 1)

    cortes = [0] * (n + 1)  # corte[i] = mejor primer corte para longitud i

    # Probamos todas las longitudes posibles de 1 hasta n.
    for longitud in range(1, n + 1):
        max_val = 0
        mejor_corte = 0

        # Para cada longitud, evaluamos cada primer corte posible.
        for corte in range(1, longitud + 1):
            if corte <= len(precios):
                val = precios[corte-1] + dp[longitud - corte]
                if val > max_val:
                    max_val = val
                    mejor_corte = corte

        # Guardamos el mejor valor encontrado y cuál fue el primer corte elegido.
        dp[longitud] = max_val
        cortes[longitud] = mejor_corte

    # Reconstruir la secuencia de cortes
    resultado_cortes = []
    restante = n
    while restante > 0:
        # Vamos tomando el mejor corte guardado hasta consumir toda la varilla.
        resultado_cortes.append(cortes[restante])
        restante -= cortes[restante]

    return dp[n], resultado_cortes

def ejecutar_rod_cut_con_cortes():
    # Ejemplo de maximización del valor de una varilla.
    precios = [1, 5, 8, 9, 10, 17, 17, 20, 21, 23]  # precios para longitudes 1 a 10
    valor, cortes = rod_cut_con_cortes(precios, 10)
    print(f'Valor óptimo: {valor}')
    print(f'Cortes: {cortes}')



def detectar_regresiones(logs_v1: list, logs_v2: list) -> dict:
    """
    Usa LCS para encontrar logs comunes.
    Identifica errores que aparecen SOLO en v2 (regresiones).
    """
    # m y n representan la cantidad de líneas en cada versión de logs.
    m, n = len(logs_v1), len(logs_v2)

    # dp[i][j] almacena la longitud de la subsecuencia común más larga
    # entre los primeros i logs de v1 y los primeros j logs de v2.
    dp = [[0]*(n+1) for _ in range(m+1)]

    # Construimos la tabla LCS comparando línea por línea.
    for i in range(1, m+1):
        for j in range(1, n+1):
            if logs_v1[i-1] == logs_v2[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    # Extraer errores NUEVOS en v2
    errores_v1 = {l for l in logs_v1 if 'ERROR' in l or 'FAIL' in l}
    errores_v2 = {l for l in logs_v2 if 'ERROR' in l or 'FAIL' in l}
    regresiones = errores_v2 - errores_v1

    # La similitud se calcula como la proporción entre las líneas comunes
    # y el tamaño de la versión más larga.
    similitud = dp[m][n] / max(m, n) if max(m,n) > 0 else 1.0

    # Retornamos un resumen listo para usar en un pipeline o reporte.
    return {
        'similitud': similitud,
        'es_regresion': len(regresiones) > 0,
        'errores_nuevos': list(regresiones),
        'lineas_comunes': dp[m][n],
    }

def ejecutar_detectar_regresiones():
    # Ejemplo de comparación entre dos versiones de logs.
    logs_v1 = [
        'test_login OK',
        'test_pagos OK',
        'test_api OK',
    ]
    logs_v2 = [
        'test_login OK',
        'test_pagos OK',
        'test_api ERROR: timeout en respuesta',
        'test_reportes OK',
    ]

    resultado = detectar_regresiones(logs_v1, logs_v2)
    print(f'Similitud: {resultado["similitud"]:.0%}')
    print(f'¿Regresión?: {resultado["es_regresion"]}')
    print(f'Errores nuevos: {resultado["errores_nuevos"]}')


def seleccionar_optimo_tests(tests: list, presupuesto: int):
    """
    Usa 0/1 Knapsack para seleccionar los mejores tests a ejecutar
    dentro del presupuesto de tiempo disponible.
    
    Cada test tiene (nombre, tiempo_min, cobertura, mutation_score, valor).
    Queremos maximizar el VALOR total sin exceder el presupuesto de tiempo.
    """
    # n es la cantidad de tests disponibles.
    n = len(tests)
    
    # dp[i][t] = máximo valor que podemos obtener usando
    # los primeros i tests con presupuesto de tiempo t.
    dp = [[0]*(presupuesto+1) for _ in range(n+1)]
    
    # Llenar la tabla: para cada test, decidimos si lo incluimos o no.
    for i in range(1, n+1):
        # Desempaquetamos: nombre, tiempo, cobertura, mutation_score, valor
        _, tiempo, _, _, valor = tests[i-1]
        
        # Para cada minuto disponible de tiempo:
        for t in range(presupuesto+1):
            # Opción 1: no ejecutar este test.
            dp[i][t] = dp[i-1][t]
            
            # Opción 2: ejecutar este test si tenemos tiempo suficiente.
            if tiempo <= t:
                dp[i][t] = max(dp[i][t], dp[i-1][t-tiempo] + valor)
    
    return dp[n][presupuesto]

def ejecutar_seleccionar_optimo_tests():
    # Ejemplo: Pipeline CI con 15 minutos de presupuesto.
    # Cada test tiene: (nombre, tiempo_min, cobertura, mutation_score, valor).
    tests = [
        ('test_auth',      2, 0.95, 0.88, 83.6),
        ('test_pagos',     5, 0.90, 0.92, 82.8),
        ('test_reportes',  4, 0.80, 0.75, 60.0),
        ('test_api',       3, 0.85, 0.80, 68.0),
        ('test_ui_e2e',    7, 0.70, 0.65, 45.5),
        ('test_carga',     6, 0.60, 0.55, 33.0),
    ]
    
    presupuesto = 15  # 15 minutos disponibles
    valor_maximo = seleccionar_optimo_tests(tests, presupuesto)
    
    print(f'Presupuesto disponible: {presupuesto} minutos')
    print(f'Valor máximo alcanzable: {valor_maximo}')
    print('\nTests optimales: auth(2min, valor=83.6) + pagos(5min, valor=82.8) + api(3min, valor=68.0) + reportes(4min, valor=60.0)')
    print('Tiempo total usado: 2+5+3+4 = 14 minutos')
    print(f'Valor total: 83.6 + 82.8 + 68.0 + 60.0 = {83.6 + 82.8 + 68.0 + 60.0}')


def son_bugs_similares(titulo1: str, titulo2: str, umbral: float = 0.7) -> bool:
    """
    Usa Edit Distance (Levenshtein) para detectar
    reportes de bugs potencialmente duplicados en Jira.
    
    Compara dos títulos de bugs y devuelve True si la similitud
    es mayor al umbral (por defecto 70%).
    """
    # Función interna: calcula la distancia de edición entre dos strings.
    def edit_dist(s1, s2):
        # m, n son las longitudes de los dos strings.
        m, n = len(s1), len(s2)
        
        # dp[i][j] = mínimo número de operaciones (insertar, eliminar, reemplazar)
        # para transformar s1[0:i] en s2[0:j].
        dp = [[0]*(n+1) for _ in range(m+1)]
        
        # Inicializar: primer elemento son eliminaciones/inserciones.
        for i in range(m+1): dp[i][0] = i
        for j in range(n+1): dp[0][j] = j
        
        # Llenar la tabla comparando carácter por carácter.
        for i in range(1, m+1):
            for j in range(1, n+1):
                if s1[i-1] == s2[j-1]:
                    # Caracteres iguales: sin operación adicional.
                    dp[i][j] = dp[i-1][j-1]
                else:
                    # Caracteres diferentes: tomar la mejor opción entre
                    # eliminar, insertar o reemplazar.
                    dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])
        
        return dp[m][n]
    
    # Convertir a minúsculas para comparación case-insensitive.
    t1, t2 = titulo1.lower(), titulo2.lower()
    
    # Calcular distancia de edición.
    distancia = edit_dist(t1, t2)
    
    # Convertir distancia a similitud (0 a 1).
    # Similitud = 1 - (distancia / máxima longitud posible).
    similitud = 1 - distancia / max(len(t1), len(t2))
    
    return similitud >= umbral

def ejecutar_son_bugs_similares():
    # Ejemplos de detección de bugs duplicados.
    print('Comparando títulos de bugs:\n')
    
    # Caso 1: Títulos muy diferentes.
    titulo1 = 'Error al iniciar sesión'
    titulo2 = 'Error en login'
    resultado = son_bugs_similares(titulo1, titulo2)
    print(f'Titulo 1: "{titulo1}"')
    print(f'Titulo 2: "{titulo2}"')
    print(f'¿Son similares? {resultado} (similitud baja)\n')
    
    # Caso 2: Títulos casi idénticos (con pequeña variación).
    titulo1 = 'Error 500 en /api/users'
    titulo2 = 'Error 500 en /api/user'
    resultado = son_bugs_similares(titulo1, titulo2)
    print(f'Titulo 1: "{titulo1}"')
    print(f'Titulo 2: "{titulo2}"')
    print(f'¿Son similares? {resultado} (muy similar, probablemente duplicado)\n')
    
    # Caso 3: Títulos idénticos (obviamente duplicados).
    titulo1 = 'Pantalla negra al cargar dashboard'
    titulo2 = 'Pantalla negra al cargar dashboard'
    resultado = son_bugs_similares(titulo1, titulo2)
    print(f'Titulo 1: "{titulo1}"')
    print(f'Titulo 2: "{titulo2}"')
    print(f'¿Son similares? {resultado} (idénticos)')


from functools import lru_cache
import time

def optimizar_fixture_db(usar_cache: bool = False, num_tests: int = 100):
    """
    Simula consultas a Base de Datos para fixtures pytest.
    Compara tiempo de ejecución con y sin memoización usando lru_cache.
    
    Problema: En pytest, un fixture que consulta la BD puede tomar 2 segundos.
    Si 100 tests usan ese fixture sin cache: 100 x 2s = 200 segundos.
    Solucion: Usar lru_cache con scope='session' para cachear la primera ejecucion.
    """
    
    # Funcion que simula una query a BD: tarda 0.02 seg (representa 2 seg reales).
    def simular_query_bd():
        """Simula: SELECT * FROM estudiantes (tarda 2 segundos)."""
        # En este ejemplo: 0.02 = 2 segundos reales (escala 100:1).
        time.sleep(0.02)
        return {
            'total_estudiantes': 1500,
            'datos': ['estudiante_1', 'estudiante_2', '...', 'estudiante_1500']
        }
    
    # Version SIN memoizacion: cada llamada ejecuta la query.
    def fixture_sin_cache():
        """SIN optimizacion: cada test ejecuta la query."""
        return simular_query_bd()
    
    # Version CON memoizacion: solo la primera ejecucion hace la query.
    @lru_cache(maxsize=None)
    def fixture_con_cache():
        """CON optimizacion: solo 1 query para todos los tests."""
        return simular_query_bd()
    
    # Simulacion: ejecutar el fixture num_tests veces (como si fueran num_tests tests).
    print(f'\nSimulando ejecucion de {num_tests} tests cada uno con el fixture:')
    print('=' * 60)
    
    if not usar_cache:
        # SIN CACHE: cada test hace su propia query.
        print('\\nSIN MEMOIZACION (cada test ejecuta su query):')
        tiempo_inicio = time.time()
        for _ in range(num_tests):
            fixture_sin_cache()
        tiempo_total = time.time() - tiempo_inicio
        
        print(f'   Tests ejecutados: {num_tests}')
        print(f'   Queries a BD: {num_tests} queries')
        print('   Tiempo por query: 0.02 seg (representa 2 segundos reales)')
        print(f'   Tiempo total SIMULADO: {tiempo_total:.3f} seg')
        print(f'   Tiempo REAL estimado: {tiempo_total * 100:.1f} segundos')
        print(f'   Calculo: {num_tests} tests x 2 seg/test = {num_tests * 2} segundos')
    else:
        # CON CACHE: solo la primera query, luego devuelve del cache.
        print('\\nCON MEMOIZACION (@lru_cache):')
        tiempo_inicio = time.time()
        for _ in range(num_tests):
            fixture_con_cache()
        tiempo_total = time.time() - tiempo_inicio
        
        print(f'   Tests ejecutados: {num_tests}')
        print('   Queries a BD: 1 query (las demas usan cache)')
        print('   Tiempo de la 1a query: 0.02 seg (representa 2 segundos reales)')
        print(f'   Tiempo total SIMULADO: {tiempo_total:.3f} seg')
        print(f'   Tiempo REAL estimado: {tiempo_total * 100:.1f} segundos')
        print('   Calculo: 1 query x 2 seg = 2 segundos')
    
    return tiempo_total

def ejecutar_optimizar_fixture_db():
    """
    Demuestra la diferencia de rendimiento entre
    fixtures SIN cache vs CON cache (lru_cache).
    """
    print('\n' + '='*60)
    print('OPTIMIZACION DE FIXTURES PYTEST CON MEMOIZACION')
    print('='*60)
    print('\nCaso: Fixture que consulta BD estudiantes (tarda 2 segundos)')
    
    num_tests = 100
    
    # Comparacion: sin cache vs con cache.
    tiempo_sin_cache = optimizar_fixture_db(usar_cache=False, num_tests=num_tests)
    tiempo_con_cache = optimizar_fixture_db(usar_cache=True, num_tests=num_tests)
    
    # Resumen y mejora.
    print('\n' + '='*60)
    print('RESUMEN Y MEJORA:')
    print('='*60)
    print(f'\n Tiempo SIN cache:  {tiempo_sin_cache * 100:.1f} segundos (LENTO)')
    print(f'\n Tiempo CON cache:  {tiempo_con_cache * 100:.1f} segundos (RAPIDO)')
    mejora = (tiempo_sin_cache - tiempo_con_cache) / tiempo_sin_cache * 100
    print(f'\n Mejora de rendimiento: {mejora:.0f}% mas rapido')
    print('\n Conclusion: @lru_cache(maxsize=None) con scope=session hace')
    print('             que los tests sean 100x mas rapidos.')
    print('\n' + '='*60)


def main():
    while True:
        print('\n========== MENÚ PRINCIPAL ==========')
        print('Selecciona la función que quieres ejecutar:')
        print('1. min_path_sum_con_camino (Costo mínimo en matriz)')
        print('2. subset_sum_con_elementos (Subconjunto con suma objetivo)')
        print('3. rod_cut_con_cortes (Maximizar valor de varilla)')
        print('4. detectar_regresiones (Comparar logs de versiones)')
        print('5. seleccionar_optimo_tests (Knapsack: tests en pipeline CI)')
        print('6. son_bugs_similares (Edit Distance: bugs duplicados)')
        print('7. optimizar_fixture_db (Memoizacion: pytest fixtures rapidos)')
        print('0. Salir')
        print('====================================\n')
        
        opcion = input('Ingresa una opcion (0-7): ').strip()

        if opcion == '1':
            print('\n--- FUNCIÓN 1: Costo Mínimo con Camino ---')
            ejecutar_min_path_sum_con_camino()
        elif opcion == '2':
            print('\n--- FUNCIÓN 2: Subset Sum ---')
            ejecutar_subset_sum_con_elementos()
        elif opcion == '3':
            print('\n--- FUNCIÓN 3: Rod Cutting (Varilla) ---')
            ejecutar_rod_cut_con_cortes()
        elif opcion == '4':
            print('\n--- FUNCIÓN 4: Detectar Regresiones ---')
            ejecutar_detectar_regresiones()
        elif opcion == '5':
            print('\n--- FUNCIÓN 5: Seleccionar Tests Óptimos (Knapsack) ---')
            ejecutar_seleccionar_optimo_tests()
        elif opcion == '6':
            print('\n--- FUNCIÓN 6: Bugs Similares (Edit Distance) ---')
            ejecutar_son_bugs_similares()
        elif opcion == '7':
            print('\n--- FUNCION 7: Optimizar Fixtures Pytest (Memoizacion) ---')
            ejecutar_optimizar_fixture_db()
        elif opcion == '0':
            print('\n¡Hasta luego!')
            break
        else:
            print('\nOpción no válida. Intenta de nuevo.')


if __name__ == '__main__':
    main()

