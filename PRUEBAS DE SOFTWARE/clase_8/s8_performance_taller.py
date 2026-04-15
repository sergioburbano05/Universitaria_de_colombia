# ══════════════════════════════════════════════════════════════
# TALLER DE PRUEBAS DE RENDIMIENTO — SESIÓN 8
# Universidad de Colombia — Pruebas de Software
#
# Este script simula un sistema de API para pruebas de performance.
# Incluye: baseline, load testing, stress testing y análisis.
#
# FLUJO DE LA CLASE:
# 1. Setup e imports
# 2. Simulador de API (explica degradación bajo carga)
# 3. Funciones de medición (baseline secuencial)
# 4. Load testing (50 VUs concurrentes)
# 5. Stress testing (aumento progresivo de carga)
# 6. Comparación de endpoints
# 7. Análisis y recomendaciones
#
# INSTRUCCIONES PARA LA CLASE:
# - Ejecutar paso a paso explicando cada sección.
# - Mostrar cómo el sistema se degrada bajo carga.
# - Discutir SLA y optimizaciones.
# ══════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────
# PASO 1: IMPORTACIONES Y SETUP
# ─────────────────────────────────────────────────────────────
# Importamos las librerías necesarias para el taller.
# - time: para medir tiempos de ejecución
# - threading: para simular usuarios concurrentes (VUs)
# - statistics: para calcular percentiles (p50, p95, etc.)
# - random: para variar datos y simular jitter
# - json: para trabajar con respuestas de API
# - requests: para hacer peticiones HTTP a HTTPBin.org

import time
import threading
import statistics
import random
import json
import requests  # Necesario para HTTPBin.org

print('✅ Librerías importadas correctamente.')
print('   Usando HTTPBin.org como servidor real de pruebas.')

# ─────────────────────────────────────────────────────────────
# PASO 2: FUNCIONES PARA HTTPBIN.ORG
# ─────────────────────────────────────────────────────────────
# HTTPBin.org es un servicio público para pruebas HTTP.
# Simulamos diferentes endpoints con delays artificiales para
# replicar el comportamiento de una API real.

def get_health():
    """GET /api/health — Endpoint rápido (simulado con delay)"""
    time.sleep(0.015)  # Simular delay de 15ms
    resp = requests.get('https://httpbin.org/get')
    return {'status': resp.status_code, 'tiempo_ms': 15}

def listar_estudiantes():
    """GET /api/estudiantes — Endpoint medio (simulado con delay)"""
    time.sleep(0.085)  # Simular delay de 85ms
    resp = requests.get('https://httpbin.org/get')
    return {'status': resp.status_code, 'tiempo_ms': 85}

def consultar_notas_estudiante(estudiante_id):
    """GET /api/notas/{id} — Endpoint normal (simulado con delay)"""
    time.sleep(0.120)  # Simular delay de 120ms
    resp = requests.get('https://httpbin.org/get')
    return {'status': resp.status_code, 'tiempo_ms': 120}

def buscar_notas(query):
    """GET /api/notas/buscar — Endpoint lento (simulado con delay)"""
    time.sleep(0.800)  # Simular delay de 800ms (cuello de botella)
    resp = requests.get('https://httpbin.org/get')
    return {'status': resp.status_code, 'tiempo_ms': 800}

def registrar_nota(estudiante_id, materia, nota):
    """POST /api/notas — Endpoint de escritura (simulado con delay)"""
    time.sleep(0.200)  # Simular delay de 200ms
    resp = requests.post('https://httpbin.org/post', json={'estudiante': estudiante_id, 'materia': materia, 'nota': nota})
    return {'status': resp.status_code, 'tiempo_ms': 200}

def generar_reporte(semestre):
    """GET /api/reportes/{semestre} — Endpoint muy lento (simulado con delay)"""
    time.sleep(2.500)  # Simular delay de 2500ms (muy lento)
    resp = requests.get('https://httpbin.org/get')
    return {'status': resp.status_code, 'tiempo_ms': 2500}

# ─────────────────────────────────────────────────────────────
# PASO 2B: CREACIÓN DE LA API (HTTPBIN)
# ─────────────────────────────────────────────────────────────

# Clase wrapper para HTTPBin (para mantener compatibilidad con el código)
class APIHttpBin:
    def get_health(self): return get_health()
    def listar_estudiantes(self): return listar_estudiantes()
    def consultar_notas_estudiante(self, id): return consultar_notas_estudiante(id)
    def buscar_notas(self, q): return buscar_notas(q)
    def registrar_nota(self, id, mat, nota): return registrar_nota(id, mat, nota)
    def generar_reporte(self, sem): return generar_reporte(sem)
    def reset_stats(self): pass  # HTTPBin no tiene stats internos

api = APIHttpBin()
print('✅ API configurada con HTTPBin.org (servidor real de pruebas)')
print()
print('📡 Endpoints disponibles:')
print('   GET  /api/health              → ~15ms')
print('   GET  /api/estudiantes         → ~85ms')
print('   GET  /api/notas/{id}          → ~120ms')
print('   GET  /api/notas/buscar?q=X    → ~800ms (⚠️ lento!)')
print('   POST /api/notas               → ~200ms')
print('   GET  /api/reportes/{semestre} → ~2500ms (⚠️ muy lento!)')

# ══════════════════════════════════════════════════════════════
# FUNCIONES DE MEDICIÓN Y ANÁLISIS
# ══════════════════════════════════════════════════════════════

def medir_endpoint(funcion_endpoint, n_veces: int = 50) -> dict:
    """
    Mide el rendimiento de un endpoint ejecutándolo N veces secuencialmente.
    
    Args:
        funcion_endpoint: función que llama al endpoint
        n_veces: número de ejecuciones
    
    Returns:
        Diccionario con estadísticas: min, max, percentiles, etc.
    """
    tiempos = []  # Lista para almacenar todos los tiempos
    errores = 0   # Contador de errores
    
    for i in range(n_veces):
        # Medimos el tiempo de WALL CLOCK (tiempo real transcurrido)
        inicio = time.perf_counter()
        respuesta = funcion_endpoint()
        fin = time.perf_counter()
        
        tiempo_ms = (fin - inicio) * 1000  # Convertir a ms
        tiempos.append(tiempo_ms)
        
        if respuesta['status'] != 200:
            errores += 1
    
    # Ordenamos para calcular percentiles
    tiempos.sort()
    
    return {
        'n_peticiones': n_veces,
        'errores': errores,
        'error_rate': round(errores / n_veces * 100, 2),
        'min_ms': round(min(tiempos), 1),
        'max_ms': round(max(tiempos), 1),
        'avg_ms': round(statistics.mean(tiempos), 1),
        'p50_ms': round(tiempos[int(n_veces * 0.50)], 1),  # Mediana
        'p90_ms': round(tiempos[int(n_veces * 0.90)], 1),
        'p95_ms': round(tiempos[int(n_veces * 0.95)], 1),  # SLA típico
        'p99_ms': round(tiempos[min(int(n_veces * 0.99), n_veces-1)], 1),
        'tiempos_raw': tiempos  # Para gráficas posteriores
    }


def imprimir_resultados(nombre_endpoint: str, resultados: dict, sla_p95_ms: float = 500.0):
    """
    Imprime resultados de medición de forma clara, indicando si cumple SLA.
    
    Args:
        nombre_endpoint: nombre del endpoint probado
        resultados: dict con métricas
        sla_p95_ms: SLA para p95 (default 500ms)
    """
    p95 = resultados['p95_ms']
    cumple_sla = p95 <= sla_p95_ms
    estado = '✅ CUMPLE SLA' if cumple_sla else '❌ VIOLA SLA'
    
    print(f'\n{'═'*55}')
    print(f'  Endpoint: {nombre_endpoint}')
    print(f'{'═'*55}')
    print(f'  Peticiones:  {resultados["n_peticiones"]:>6}  |  Errores: {resultados["errores"]} ({resultados["error_rate"]}%)')
    print(f'  Min:         {resultados["min_ms"]:>6.1f} ms')
    print(f'  p50 (median):{resultados["p50_ms"]:>6.1f} ms')
    print(f'  p90:         {resultados["p90_ms"]:>6.1f} ms')
    print(f'  p95:         {resultados["p95_ms"]:>6.1f} ms  → {estado} (SLA: {sla_p95_ms}ms)')
    print(f'  p99:         {resultados["p99_ms"]:>6.1f} ms')
    print(f'  Max:         {resultados["max_ms"]:>6.1f} ms')
    print(f'{'═'*55}')


print('✅ Funciones de medición listas.')
print('   medir_endpoint(fn, n) → estadísticas completas')
print('   imprimir_resultados(nombre, resultados, sla) → reporte')

# ─────────────────────────────────────────────────────────────
# PASO 5: FUNCIÓN DE LOAD TESTING
# ─────────────────────────────────────────────────────────────
# Load testing: simula carga esperada (ej. 50 usuarios concurrentes).
# - Crea hilos para simular usuarios virtuales (VUs).
# - Mide throughput, latencia, errores.
# - Ramp-up gradual para simular llegada real de usuarios.

def load_test(
    funcion_endpoint,
    n_usuarios: int,
    duracion_s: float,
    ramp_up_s: float = 5.0
) -> dict:
    """
    Ejecuta un load test con N usuarios concurrentes.
    
    Args:
        funcion_endpoint: función que llama al endpoint a probar
        n_usuarios: número de usuarios concurrentes (VUs)
        duracion_s: duración total del test en segundos
        ramp_up_s: segundos para agregar usuarios gradualmente
    
    Returns:
        Diccionario con métricas: throughput, p95, errores, etc.
    """
    # Listas compartidas entre hilos (protegidas con lock para thread safety)
    tiempos_todos = []  # Todos los tiempos de respuesta
    errores_todos = []  # Lista de errores
    _lock = threading.Lock()
    
    fin_del_test = time.time() + duracion_s  # Timestamp de fin
    
    def simular_usuario(usuario_id: int):
        """
        Función que ejecuta UN usuario virtual.
        - Hace peticiones en loop hasta que termine el test.
        - Registra tiempos y errores en listas compartidas.
        """
        while time.time() < fin_del_test:
            inicio = time.perf_counter()
            
            # Llamada al endpoint con manejo de errores
            try:
                respuesta = funcion_endpoint()
                tiempo_ms = (time.perf_counter() - inicio) * 1000
                with _lock:
                    tiempos_todos.append(tiempo_ms)
                    if respuesta['status'] != 200:
                        errores_todos.append(1)
            except Exception as e:
                # Manejo de excepciones inesperadas
                tiempo_ms = (time.perf_counter() - inicio) * 1000
                with _lock:
                    tiempos_todos.append(tiempo_ms)
                    errores_todos.append(1)
            
            # Pausa para simular "think time" del usuario real
            time.sleep(random.uniform(0.1, 0.5))
    
    # ── LANZAMIENTO DE HILOS ──
    hilos = []
    inicio_test = time.time()
    
    for i in range(n_usuarios):
        # RAMP-UP: distribuir usuarios a lo largo de ramp_up_s
        tiempo_espera = (ramp_up_s / n_usuarios) * i
        time.sleep(tiempo_espera / n_usuarios)  # Espera proporcional
        
        # Crear y lanzar hilo
        hilo = threading.Thread(target=simular_usuario, args=(i,), daemon=True)
        hilos.append(hilo)
        hilo.start()
    
    # Esperar a que terminen todos los hilos
    for hilo in hilos:
        hilo.join(timeout=duracion_s + 10)  # Timeout de seguridad
    
    duracion_real = time.time() - inicio_test
    
    # ── CÁLCULO DE ESTADÍSTICAS ──
    if not tiempos_todos:
        return {'error': 'No se recolectaron datos — revisa simular_usuario()'}
    
    tiempos_todos.sort()  # Para percentiles
    n_total = len(tiempos_todos)
    n_errores = len(errores_todos)
    
    return {
        'n_usuarios_vus': n_usuarios,
        'duracion_s': round(duracion_real, 1),
        'n_peticiones': n_total,
        'n_errores': n_errores,
        'error_rate': round(n_errores / max(1, n_total) * 100, 2),
        'throughput_rps': round(n_total / duracion_real, 1),  # Req/s
        'p50_ms': round(tiempos_todos[int(n_total * 0.50)], 1),
        'p90_ms': round(tiempos_todos[int(n_total * 0.90)], 1),
        'p95_ms': round(tiempos_todos[int(n_total * 0.95)], 1),
        'p99_ms': round(tiempos_todos[min(int(n_total * 0.99), n_total-1)], 1),
        'max_ms': round(max(tiempos_todos), 1),
        'tiempos_raw': tiempos_todos
    }


print('✅ Función load_test() definida.')
print('   Completa el TODO en simular_usuario() antes de continuar.')

# ─────────────────────────────────────────────────────────────
# PASO 4: BASELINE — MEDICIÓN SIN CARGA
# ─────────────────────────────────────────────────────────────
# Antes de probar con carga, medimos el rendimiento base.
# - Sin usuarios concurrentes (secuencial).
# - Establece el "piso" de rendimiento.
# - Compararemos estos números con los de carga.

print('📊 Midiendo BASELINE (sin carga — secuencial)...')
print('   Esto establece el rendimiento base del sistema.')
print()

api.reset_stats()  # Reiniciamos contadores del simulador

# Definimos los endpoints a medir
endpoints_baseline = {
    'GET /api/health':          lambda: api.get_health(),
    'GET /api/estudiantes':     lambda: api.listar_estudiantes(),
    'GET /api/notas/{id}':      lambda: api.consultar_notas_estudiante('2024-001'),
    'GET /api/notas/buscar':    lambda: api.buscar_notas('pruebas de software'),
    'POST /api/notas':          lambda: api.registrar_nota('2024-001', 'INF-701', 4.5),
}

resultados_baseline = {}

for nombre, funcion in endpoints_baseline.items():
    print(f'   Midiendo {nombre}...')
    resultados_baseline[nombre] = medir_endpoint(funcion, n_veces=30)
    imprimir_resultados(nombre, resultados_baseline[nombre])

print('\n✅ Baseline completo.')
print('   Guarda estos números — los compararás con el test de carga.')

# ══════════════════════════════════════════════════════════════
# Ejemplo de Load Test
# ══════════════════════════════════════════════════════════════

print('🏋️ Iniciando Load Test...')
print('   Configuración: 50 VUs | 60 segundos | ramp-up 10s')
print('   Endpoint: GET /api/notas/{id}')
print()

api.reset_stats()

# Ejecutar el load test
resultado_load = load_test(lambda: api.consultar_notas_estudiante('2024-001'), 50, 60, 10)

if resultado_load and 'error' not in resultado_load:
    print('📊 RESULTADOS DEL LOAD TEST')
    print(f'   VUs:          {resultado_load["n_usuarios_vus"]}')
    print(f'   Duración:     {resultado_load["duracion_s"]}s')
    print(f'   Peticiones:   {resultado_load["n_peticiones"]}')
    print(f'   Error rate:   {resultado_load["error_rate"]}%  {"✅" if resultado_load["error_rate"] < 1 else "❌"}')
    print(f'   Throughput:   {resultado_load["throughput_rps"]} req/s')
    print(f'   p50:          {resultado_load["p50_ms"]}ms')
    print(f'   p95:          {resultado_load["p95_ms"]}ms  {"✅ CUMPLE SLA" if resultado_load["p95_ms"] < 500 else "❌ VIOLA SLA"}')
    print(f'   p99:          {resultado_load["p99_ms"]}ms')
    print(f'   Max:          {resultado_load["max_ms"]}ms')
else:
    print('⚠️  Completa el TODO de la celda anterior primero.')

# ══════════════════════════════════════════════════════════════
# Función de Stress Test
# ══════════════════════════════════════════════════════════════

def stress_test_progresivo(
    funcion_endpoint,
    niveles_vus: list,
    duracion_por_nivel_s: float = 30
) -> list:
    """
    Ejecuta el stress test aumentando la carga en cada nivel.
    
    Args:
        funcion_endpoint:    función del endpoint a estresar
        niveles_vus:         lista de cantidades de usuarios a probar
        duracion_por_nivel_s: cuántos segundos en cada nivel
    
    Returns:
        Lista de resultados por nivel
    """
    resultados_niveles = []
    
    for n_vus in niveles_vus:
        print(f'\n   Probando con {n_vus} VUs...', end=' ')
        
        resultado = load_test(funcion_endpoint, n_vus, duracion_por_nivel_s)
        
        if resultado and 'error' not in resultado:
            resultado['n_vus'] = n_vus
            resultados_niveles.append(resultado)
            estado = '✅' if resultado['p95_ms'] < 500 else '❌'
            print(f'p95={resultado["p95_ms"]}ms {estado} | err={resultado["error_rate"]}% | {resultado["throughput_rps"]} req/s')
        else:
            print('⚠️ Sin datos — verifica el TODO de load_test()')
    
    return resultados_niveles


print('🔥 Iniciando Stress Test progresivo...')
print('   Niveles: 10 → 50 → 100 → 200 → 300 VUs')
print('   Endpoint: GET /api/notas/{id}')
print('   Duración por nivel: 30 segundos')
print()

niveles = [10, 50, 100, 200, 300]

resultados_stress = stress_test_progresivo(lambda: api.consultar_notas_estudiante('2024-001'), niveles, 30)

# ─────────────────────────────────────────────────────────────
# PASO 8: COMPARACIÓN DE TODOS LOS ENDPOINTS BAJO CARGA
# ─────────────────────────────────────────────────────────────
# Medimos todos los endpoints con 50 VUs para identificar problemas.
# - Compara rendimiento de cada endpoint.
# - Identifica cuáles violan SLA.

print('📊 Midiendo TODOS los endpoints bajo carga (50 VUs)...')
print()

endpoints_bajo_carga = {
    'GET /api/health':          lambda: api.get_health(),
    'GET /api/estudiantes':     lambda: api.listar_estudiantes(),
    'GET /api/notas/{id}':      lambda: api.consultar_notas_estudiante('2024-001'),
    'GET /api/notas/buscar':    lambda: api.buscar_notas('pruebas de software'),
    'POST /api/notas':          lambda: api.registrar_nota('2024-001', 'INF-701', 4.5),
    'GET /api/reportes/{sem}':  lambda: api.generar_reporte('2024-2'),
}

resultados_carga_completa = {}

for nombre, funcion in endpoints_bajo_carga.items():
    print(f'Midiendo {nombre} bajo carga...')
    resultado = load_test(funcion, 50, 30)
    if resultado and 'error' not in resultado:
        resultados_carga_completa[nombre] = resultado
        cumple_sla = resultado['p95_ms'] <= 500
        estado = '✅ CUMPLE SLA' if cumple_sla else '❌ VIOLA SLA'
        print(f'  {nombre}: p95={resultado["p95_ms"]}ms {estado}')
    else:
        print(f'  {nombre}: Error en medición')

print('\n✅ Comparación completa.')

# ─────────────────────────────────────────────────────────────
# PASO 9: RESUMEN EJECUTIVO — ANÁLISIS FINAL
# ─────────────────────────────────────────────────────────────
# Convertimos números en conclusiones accionables.
# - Punto de quiebre del sistema.
# - Endpoints problemáticos.
# - Recomendaciones para producción.

from datetime import date

# Calcular métricas globales
if resultados_carga_completa:
    p95_global = max(r['p95_ms'] for r in resultados_carga_completa.values())
    error_global = sum(r['error_rate'] for r in resultados_carga_completa.values()) / len(resultados_carga_completa)
    throughput_global = sum(r['throughput_rps'] for r in resultados_carga_completa.values())
else:
    p95_global = 0
    error_global = 0
    throughput_global = 0

# Encontrar punto de quiebre
punto_quiebre = 'N/A'
if resultados_stress:
    for res in resultados_stress:
        if res['p95_ms'] > 500:
            punto_quiebre = f"{res['n_vus']} VUs"
            break

# Endpoints problemáticos
endpoints_problem = [k for k, v in resultados_carga_completa.items() if v['p95_ms'] > 500]

resumen = f"""
╔══════════════════════════════════════════════════════════════╗
║  RESUMEN EJECUTIVO — PERFORMANCE TEST REPORT                ║
║  Sistema: API Sistema de Notas Universitario                 ║
╠══════════════════════════════════════════════════════════════╣
║  Fecha: {date.today()}                                              ║
║  Elaborado por: Asistente AI                                  ║
╠══════════════════════════════════════════════════════════════╣
║  MÉTRICAS BAJO CARGA (50 VUs / 60 segundos)                  ║
║                                                              ║
║  Throughput:  {throughput_global:.1f} req/s                          ║
║  Error rate:  {error_global:.1f} %                                    ║
║  p95 global:  {p95_global:.1f} ms                                     ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  BREAKING POINT (Stress Test)                                ║
║  Punto de quiebre: {punto_quiebre}                                  ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  ENDPOINTS PROBLEMÁTICOS                                     ║
"""

for i, ep in enumerate(endpoints_problem[:2], 1):
    p95 = resultados_carga_completa[ep]['p95_ms']
    exceso = ((p95 - 500) / 500 * 100)
    resumen += f"║  {i}. {ep} → p95={p95:.1f}ms ({exceso:.0f}% sobre SLA)             ║\n"

resumen += """║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  CAUSA RAÍZ HIPÓTESIS                                        ║
║  Los endpoints de búsqueda y reportes hacen queries sin      ║
║  índices en BD, causando full table scans lentos.            ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  VEREDICTO: ¿LISTO PARA PRODUCCIÓN?                          ║
║  NO — Requiere optimización de BD antes de producción        ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  RECOMENDACIONES                                             ║
║  1. Agregar índices en BD para búsquedas                    ║
║  2. Optimizar queries de reportes                            ║
║  3. Implementar caché para endpoints críticos               ║
╚══════════════════════════════════════════════════════════════╝
"""

print(resumen)

# ══════════════════════════════════════════════════════════════
# FUNCIONES PARA EJECUCIÓN POR PARTES
# ══════════════════════════════════════════════════════════════

def ejecutar_setup():
    """PASO 1: Setup y creación de la API HTTPBin"""
    print('✅ Librerías importadas correctamente.')
    print('   Usando HTTPBin.org como servidor real de pruebas.')
    
    # API HTTPBin
    global api
    api = APIHttpBin()
    
    print('✅ API configurada con HTTPBin.org (servidor real de pruebas)')
    print()
    print('📡 Endpoints disponibles:')
    print('   GET  /api/health              → ~15ms')
    print('   GET  /api/estudiantes         → ~85ms')
    print('   GET  /api/notas/{id}          → ~120ms')
    print('   GET  /api/notas/buscar?q=X    → ~800ms (⚠️ lento!)')
    print('   POST /api/notas               → ~200ms')
    print('   GET  /api/reportes/{semestre} → ~2500ms (⚠️ muy lento!)')
    
    print('✅ Funciones de medición listas.')
    print('   medir_endpoint(fn, n) → estadísticas completas')
    print('   imprimir_resultados(nombre, resultados, sla) → reporte')
    
    print('✅ Función load_test() definida.')
    print('   Completa el TODO en simular_usuario() antes de continuar.')

def ejecutar_baseline():
    """PASO 2: Medición baseline sin carga"""
    print('📊 Midiendo BASELINE (sin carga — secuencial)...')
    print('   Esto establece el rendimiento base del sistema.')
    print('   Nota: HTTPBin.org puede tener variabilidad por red.')
    print()
    
    # HTTPBin no tiene reset_stats, así que no lo llamamos
    
    endpoints_baseline = {
        'GET /api/health':          lambda: api.get_health(),
        'GET /api/estudiantes':     lambda: api.listar_estudiantes(),
        'GET /api/notas/{id}':      lambda: api.consultar_notas_estudiante('2024-001'),
        'GET /api/notas/buscar':    lambda: api.buscar_notas('pruebas de software'),
        'POST /api/notas':          lambda: api.registrar_nota('2024-001', 'INF-701', 4.5),
    }
    
    resultados_baseline = {}
    
    for nombre, funcion in endpoints_baseline.items():
        print(f'   Midiendo {nombre}...')
        resultados_baseline[nombre] = medir_endpoint(funcion, n_veces=10)  # Reducido a 10 para no sobrecargar HTTPBin
        imprimir_resultados(nombre, resultados_baseline[nombre])
    
    print('\n✅ Baseline completo.')
    print('   Guarda estos números — los compararás con el test de carga.')

def ejecutar_load_test():
    """PASO 3: Load test con 50 VUs"""
    print('🏋️ Iniciando Load Test...')
    print('   Configuración: 50 VUs | 60 segundos | ramp-up 10s')
    print('   Endpoint: GET /api/notas/{id}')
    print()
    
    api.reset_stats()
    
    resultado_load = load_test(lambda: api.consultar_notas_estudiante('2024-001'), 50, 60, 10)
    
    if resultado_load and 'error' not in resultado_load:
        print('📊 RESULTADOS DEL LOAD TEST')
        print(f'   VUs:          {resultado_load["n_usuarios_vus"]}')
        print(f'   Duración:     {resultado_load["duracion_s"]}s')
        print(f'   Peticiones:   {resultado_load["n_peticiones"]}')
        print(f'   Error rate:   {resultado_load["error_rate"]}%  {"✅" if resultado_load["error_rate"] < 1 else "❌"}')
        print(f'   Throughput:   {resultado_load["throughput_rps"]} req/s')
        print(f'   p50:          {resultado_load["p50_ms"]}ms')
        print(f'   p95:          {resultado_load["p95_ms"]}ms  {"✅ CUMPLE SLA" if resultado_load["p95_ms"] < 500 else "❌ VIOLA SLA"}')
        print(f'   p99:          {resultado_load["p99_ms"]}ms')
        print(f'   Max:          {resultado_load["max_ms"]}ms')
    else:
        print('⚠️  Error en load test.')

def ejecutar_stress_test():
    """PASO 4: Stress test progresivo"""
    # Asegurar que el setup esté ejecutado
    if 'api' not in globals():
        ejecutar_setup()
    
    print('🔥 Iniciando Stress Test progresivo...')
    print('   Niveles: 10 → 50 → 100 → 200 → 300 VUs')
    print('   Endpoint: GET /api/notas/{id}')
    print('   Duración por nivel: 30 segundos')
    print()
    
    niveles = [10, 50, 100, 200, 300]
    
    global resultados_stress
    resultados_stress = stress_test_progresivo(lambda: api.consultar_notas_estudiante('2024-001'), niveles, 30)
    
    # Mostrar resumen de resultados
    if resultados_stress:
        print('\n📊 RESUMEN DEL STRESS TEST:')
        print('╔═══════╦════════╦════════╦════════╦════════╦════════╗')
        print('║  VUs  ║  p50   ║  p95   ║  p99   ║  Max   ║ Status ║')
        print('╠═══════╬════════╬════════╬════════╬════════╬════════╣')
        
        for res in resultados_stress:
            status = '✅ OK' if res['p95_ms'] <= 500 else '❌ FAIL'
            print(f'║ {res["n_vus"]:>5} ║ {res["p50_ms"]:>6.1f} ║ {res["p95_ms"]:>6.1f} ║ {res["p99_ms"]:>6.1f} ║ {res["max_ms"]:>6.1f} ║ {status} ║')
        
        print('╚═══════╩════════╩════════╩════════╩════════╩════════╝')
        
        # Encontrar punto de quiebre
        punto_quiebre = None
        for res in resultados_stress:
            if res['p95_ms'] > 500:
                punto_quiebre = res['n_vus']
                break
        
        if punto_quiebre:
            print(f'\n🔴 Punto de quiebre detectado: {punto_quiebre} usuarios virtuales')
            print('   El sistema viola SLA (p95 > 500ms) a partir de este nivel.')
        else:
            print('\n✅ El sistema mantiene SLA hasta 300 VUs.')
            print('   No se detectó punto de quiebre en los niveles probados.')
    else:
        print('⚠️ No se obtuvieron resultados del stress test.')

def ejecutar_comparacion_completa():
    """PASO 5: Comparación de todos los endpoints"""
    print('📊 Midiendo TODOS los endpoints bajo carga (50 VUs)...')
    print()
    
    endpoints_bajo_carga = {
        'GET /api/health':          lambda: api.get_health(),
        'GET /api/estudiantes':     lambda: api.listar_estudiantes(),
        'GET /api/notas/{id}':      lambda: api.consultar_notas_estudiante('2024-001'),
        'GET /api/notas/buscar':    lambda: api.buscar_notas('pruebas de software'),
        'POST /api/notas':          lambda: api.registrar_nota('2024-001', 'INF-701', 4.5),
        'GET /api/reportes/{sem}':  lambda: api.generar_reporte('2024-2'),
    }
    
    global resultados_carga_completa
    resultados_carga_completa = {}
    
    for nombre, funcion in endpoints_bajo_carga.items():
        print(f'Midiendo {nombre} bajo carga...')
        resultado = load_test(funcion, 50, 30)
        if resultado and 'error' not in resultado:
            resultados_carga_completa[nombre] = resultado
            cumple_sla = resultado['p95_ms'] <= 500
            estado = '✅ CUMPLE SLA' if cumple_sla else '❌ VIOLA SLA'
            print(f'  {nombre}: p95={resultado["p95_ms"]}ms {estado}')
        else:
            print(f'  {nombre}: Error en medición')
    
    print('\n✅ Comparación completa.')

def ejecutar_resumen():
    """PASO 6: Resumen ejecutivo"""
    from datetime import date
    
    if 'resultados_carga_completa' not in globals():
        print('⚠️ Ejecuta primero la comparación completa.')
        return
    
    # Calcular métricas globales
    if resultados_carga_completa:
        p95_global = max(r['p95_ms'] for r in resultados_carga_completa.values())
        error_global = sum(r['error_rate'] for r in resultados_carga_completa.values()) / len(resultados_carga_completa)
        throughput_global = sum(r['throughput_rps'] for r in resultados_carga_completa.values())
    else:
        p95_global = 0
        error_global = 0
        throughput_global = 0
    
    # Encontrar punto de quiebre
    punto_quiebre = 'N/A'
    if 'resultados_stress' in globals() and resultados_stress:
        for res in resultados_stress:
            if res['p95_ms'] > 500:
                punto_quiebre = f"{res['n_vus']} VUs"
                break
    
    # Endpoints problemáticos
    endpoints_problem = [k for k, v in resultados_carga_completa.items() if v['p95_ms'] > 500]
    
    resumen = f"""
╔══════════════════════════════════════════════════════════════╗
║  RESUMEN EJECUTIVO — PERFORMANCE TEST REPORT                ║
║  Sistema: API Sistema de Notas Universitario                 ║
╠══════════════════════════════════════════════════════════════╣
║  Fecha: {date.today()}                                              ║
║  Elaborado por: Asistente AI                                  ║
╠══════════════════════════════════════════════════════════════╣
║  MÉTRICAS BAJO CARGA (50 VUs / 60 segundos)                  ║
║                                                              ║
║  Throughput:  {throughput_global:.1f} req/s                          ║
║  Error rate:  {error_global:.1f} %                                    ║
║  p95 global:  {p95_global:.1f} ms                                     ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  BREAKING POINT (Stress Test)                                ║
║  Punto de quiebre: {punto_quiebre}                                  ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  ENDPOINTS PROBLEMÁTICOS                                     ║
"""
    
    for i, ep in enumerate(endpoints_problem[:2], 1):
        p95 = resultados_carga_completa[ep]['p95_ms']
        exceso = ((p95 - 500) / 500 * 100)
        resumen += f"║  {i}. {ep} → p95={p95:.1f}ms ({exceso:.0f}% sobre SLA)             ║\n"
    
    resumen += """║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  CAUSA RAÍZ HIPÓTESIS                                        ║
║  Los endpoints de búsqueda y reportes hacen queries sin      ║
║  índices en BD, causando full table scans lentos.            ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  VEREDICTO: ¿LISTO PARA PRODUCCIÓN?                          ║
║  NO — Requiere optimización de BD antes de producción        ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  RECOMENDACIONES                                             ║
║  1. Agregar índices en BD para búsquedas                    ║
║  2. Optimizar queries de reportes                            ║
║  3. Implementar caché para endpoints críticos               ║
╚══════════════════════════════════════════════════════════════╝
"""
    
    print(resumen)

# ══════════════════════════════════════════════════════════════
# EJECUCIÓN POR PARTES — PARA CLASES
# ══════════════════════════════════════════════════════════════
# Para ejecutar secciones individualmente, descomenta la sección deseada
# y ejecuta el script. Solo una sección a la vez.

if __name__ == "__main__":
    # ── DESCOMENTA LA SECCIÓN QUE QUIERAS EJECUTAR ──
    
    # PASO 1: Solo setup y simulador
    # ejecutar_setup()
    
    # PASO 2: Baseline
     ejecutar_baseline()
    
    # PASO 3: Load test
    # ejecutar_load_test()
    
    # PASO 4: Stress test
    ejecutar_stress_test()
    
    # PASO 5: Comparación completa
    # ejecutar_comparacion_completa()
    
    # PASO 6: Resumen ejecutivo
    # ejecutar_resumen()
    
    pass  # No ejecutar nada por defecto