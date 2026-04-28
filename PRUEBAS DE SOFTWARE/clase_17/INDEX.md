# 📑 ÍNDICE COMPLETO DEL TALLER

## 🎯 Por Dónde Empezar

### **👉 START HERE: [00_INICIO_AQUI.md](00_INICIO_AQUI.md)**
- ✅ Resumen ejecutivo de cambios
- ✅ Validación final (30/30 tests PASSED)
- ✅ Métricas de calidad
- ✅ Aspectos únicos del taller

---

## 📚 Archivos del Taller

### 1. **CÓDIGO PRINCIPAL** 
   📄 `taller_pd_pruebas_software.py` (850 líneas)
   
   **Contenido:**
   - ✅ PARTE I: Fibonacci (3 implementaciones: memoización, tabular, ingenua)
   - ✅ PARTE II: Mochila 0/1 (2 implementaciones: estándar, space-optimized)
   - ✅ PARTE III: Casos integradores (2 casos reales de testing)
   - ✅ 30 Tests exhaustivos (todos pasan ✅)
   
   **Funciones clave:**
   - `fibonacci(n)` — Memoización con @lru_cache
   - `fibonacci_tabular(n)` — Bottom-up
   - `fibonacci_ingenua(n)` — Para comparación
   - `mochila_01(pesos, valores, W)` — Con reconstrucción
   - `mochila_01_space_optimized(...)` — O(W) espacio
   - `comparar_fibonacci_rendimiento(n)` — Benchmarking
   - `caso_integrador_priorizar_regresion()` — Sistema de pagos real
   - `caso_integrador_multisuite()` — Análisis multi-suite

---

### 2. **GUÍAS DE APRENDIZAJE**

#### 📖 [README.md](README.md) (500+ líneas)
   **Para:** Estudiantes que quieren entender el taller
   
   **Incluye:**
   - 🎯 Objetivos claros
   - 📊 Tabla comparativa de complejidades
   - 📝 Explicación teórica de Fibonacci
   - 📝 Explicación teórica de Mochila 0/1
   - 🔍 Detalles de algoritmos y reconstrucción
   - 📋 Tests clave explicados
   - 🎓 Conceptos fundamentales
   - 🚀 Desafíos bonus

#### 📋 [EJERCICIOS_PROPUESTOS.md](EJERCICIOS_PROPUESTOS.md) (400+ líneas)
   **Para:** Estudiantes que necesitan tareas estructuradas
   
   **Incluye:**
   - Level 1: Ejercicios básicos (2)
   - Level 2: Optimización (3)
   - Level 3: Aplicación real (3)
   - Bonus: Desafíos avanzados (3)
   - ✅ Checklist de entrega
   - ⏰ Tiempo estimado por ejercicio

#### 🔧 [EJEMPLOS_EJECUCION.md](EJEMPLOS_EJECUCION.md) (300+ líneas)
   **Para:** Estudiantes que quieren ver código en acción
   
   **Incluye:**
   - 📌 Quick start (5 minutos)
   - 💻 5 ejemplos interactivos completos
   - 🎯 Cómo ejecutar tests específicos
   - 🐛 Troubleshooting
   - 🤖 Script de automatización

#### 📊 [RESUMEN_CAMBIOS.md](RESUMEN_CAMBIOS.md) (300+ líneas)
   **Para:** Docentes/revisores que quieren ver qué cambió
   
   **Incluye:**
   - ✨ Cambios principales (antes vs después)
   - 📈 Tabla comparativa
   - 📊 Resumen de tests
   - 🎓 Conceptos pedagógicos
   - ✅ Validaciones

#### 📈 [00_INICIO_AQUI.md](00_INICIO_AQUI.md) (200+ líneas)
   **Para:** Vista ejecutiva general
   
   **Incluye:**
   - ✅ Estado final
   - 📊 Cambios realizados
   - 🚀 Contenido actualizado
   - 💡 Aspectos destacables
   - ✨ Conclusión

---

## 🗂️ Estructura de Directorios

```
clase_17/
├── 📄 00_INICIO_AQUI.md              ← START HERE (resumen ejecutivo)
├── 📄 README.md                      ← Guía teórica completa
├── 📄 EJERCICIOS_PROPUESTOS.md       ← Tareas para estudiantes
├── 📄 EJEMPLOS_EJECUCION.md          ← Ejemplos y outputs
├── 📄 RESUMEN_CAMBIOS.md             ← Historial de cambios
├── 📄 INDEX.md                       ← Este archivo
│
├── 🐍 taller_pd_pruebas_software.py  ← CÓDIGO PRINCIPAL (850 líneas)
│   ├── PARTE I:  Fibonacci
│   ├── PARTE II: Mochila 0/1
│   ├── PARTE III: Casos integradores
│   └── Tests: 30/30 ✅
│
├── 📊 Sesion_17_Mochila_y_Fibonacci.pptx  ← Presentación (si existe)
│
└── .pytest_cache/                    ← Caché de tests (ignorar)
```

---

## 🎯 Cómo Usar Este Taller

### **Para Estudiantes:**

#### Ruta 1: Aprende Primero, Implementa Después
1. Leer [00_INICIO_AQUI.md](00_INICIO_AQUI.md) (5 min)
2. Leer [README.md](README.md) (30 min) — Teoría completa
3. Leer [EJEMPLOS_EJECUCION.md](EJEMPLOS_EJECUCION.md) (20 min) — Ver ejemplos
4. Implementar ejercicios en [EJERCICIOS_PROPUESTOS.md](EJERCICIOS_PROPUESTOS.md) (3-4 horas)
5. Ejecutar tests: `pytest taller_pd_pruebas_software.py -v`

**Tiempo total:** ~4-5 horas

#### Ruta 2: Aprende Haciendo
1. Leer [00_INICIO_AQUI.md](00_INICIO_AQUI.md) (5 min)
2. Ver [EJEMPLOS_EJECUCION.md](EJEMPLOS_EJECUCION.md) (10 min)
3. Saltar a [EJERCICIOS_PROPUESTOS.md](EJERCICIOS_PROPUESTOS.md) — Level 1
4. Cuando no entiendas, consultar [README.md](README.md)
5. Ejecutar tests frecuentemente

**Tiempo total:** ~3-4 horas

### **Para Docentes:**

1. Leer [00_INICIO_AQUI.md](00_INICIO_AQUI.md) (5 min) — Visión general
2. Revisar [RESUMEN_CAMBIOS.md](RESUMEN_CAMBIOS.md) (10 min) — Qué cambió
3. Ejecutar tests: `pytest taller_pd_pruebas_software.py -v` (1 min)
4. Revisar [taller_pd_pruebas_software.py](taller_pd_pruebas_software.py) (30 min)
5. Revisar criterios en [README.md](README.md#criterios-de-evaluación)

**Tiempo total:** ~45 min

---

## 📊 Estadísticas del Taller

| Métrica | Valor |
|---------|-------|
| **Líneas de código** | 850 |
| **Tests** | 30 (todos pasan ✅) |
| **Funciones** | 8 principales + helpers |
| **Páginas de documentación** | 1500+ líneas |
| **Archivos entregables** | 6 + 1 código principal |
| **Ejemplos de ejecución** | 5 + 20+ snippets |
| **Tiempo estimado** | 3-5 horas |
| **Complejidad** | Programación Dinámica (Fibonacci, Mochila) |
| **Enfoque** | Testing real de software |

---

## ✨ Características Principales

### ✅ Completitud
- [x] Código implementado y validado
- [x] 30/30 tests pasan
- [x] Documentación exhaustiva
- [x] Ejemplos interactivos
- [x] Ejercicios progresivos

### ✅ Calidad
- [x] Docstrings en todas las funciones
- [x] Manejo de errores (ValueError, casos límite)
- [x] Validación de entrada
- [x] Reconstrucción completa (no solo valores)
- [x] Benchmarking incluido

### ✅ Pedagogía
- [x] Teoría clara y concisa
- [x] Ejemplos del mundo real
- [x] Exercicios de dificultad escalada
- [x] Aplicación a testing real
- [x] Desafíos opcionales avanzados

### ✅ Usabilidad
- [x] Fácil de ejecutar
- [x] Errores informativos
- [x] Interfaz clara
- [x] Directorios bien organizados

---

## 🚀 Quick Commands

### Ejecutar todos los tests
```bash
cd "c:\Repositorio\Universitaria_de_colombia\PRUEBAS DE SOFTWARE\clase_17"
pytest taller_pd_pruebas_software.py -v
```

### Ejecutar tests de Fibonacci
```bash
pytest taller_pd_pruebas_software.py::TestFibonacci -v
```

### Ejecutar tests de Mochila
```bash
pytest taller_pd_pruebas_software.py::TestMochila01 -v
```

### Ver un test específico
```bash
pytest taller_pd_pruebas_software.py::TestFibonacci::test_fibonacci_vs_ingenua_rendimiento -vv
```

### Ejecutar como script Python
```bash
python taller_pd_pruebas_software.py
```

---

## 🎓 Competencias Adquiridas

Al completar este taller, habrás aprendido:

### Programación Dinámica
- ✅ Identificación de problemas DP
- ✅ Diseño de recurrencias
- ✅ Memoización (top-down)
- ✅ Tabulación (bottom-up)
- ✅ Reconstrucción de soluciones
- ✅ Análisis de complejidad

### Aplicación a Testing
- ✅ Priorización de pruebas
- ✅ Asignación de presupuestos
- ✅ Optimización bajo restricciones
- ✅ Análisis de trade-offs
- ✅ Benchmarking de rendimiento

### Programación
- ✅ Uso de decoradores (@lru_cache)
- ✅ Tipado estático (Type hints)
- ✅ Manejo de errores
- ✅ Testing con pytest
- ✅ Documentación de código

---

## 📞 Soporte

| Tipo | Recurso |
|------|---------|
| **Teoría** | [README.md](README.md) |
| **Ejercicios** | [EJERCICIOS_PROPUESTOS.md](EJERCICIOS_PROPUESTOS.md) |
| **Ejemplos** | [EJEMPLOS_EJECUCION.md](EJEMPLOS_EJECUCION.md) |
| **Código** | [taller_pd_pruebas_software.py](taller_pd_pruebas_software.py) |
| **Contexto** | [00_INICIO_AQUI.md](00_INICIO_AQUI.md) |
| **Cambios** | [RESUMEN_CAMBIOS.md](RESUMEN_CAMBIOS.md) |

---

## ✅ Checklist de Entrega

- [x] Código implementado y funcionando
- [x] 30/30 tests pasan
- [x] README.md completo
- [x] EJERCICIOS_PROPUESTOS.md con 9 ejercicios
- [x] EJEMPLOS_EJECUCION.md con 5 ejemplos
- [x] RESUMEN_CAMBIOS.md documentado
- [x] 00_INICIO_AQUI.md resumen ejecutivo
- [x] INDEX.md (este archivo)
- [x] Documentación inline en código
- [x] Casos límite cubiertos

---

## 🎉 Conclusión

Este taller proporciona una introducción **completa, profunda y práctica** a la programación dinámica aplicada a pruebas de software.

**Está listo para usar inmediatamente.**

---

**Última actualización:** 28 de abril de 2026  
**Estado:** ✅ Completo y validado  
**Tests:** 30/30 PASSED  

---

## 📋 Navegación Rápida

- [📄 README.md](README.md) — Aprende
- [📋 EJERCICIOS_PROPUESTOS.md](EJERCICIOS_PROPUESTOS.md) — Practica
- [🔧 EJEMPLOS_EJECUCION.md](EJEMPLOS_EJECUCION.md) — Experimenta
- [📊 RESUMEN_CAMBIOS.md](RESUMEN_CAMBIOS.md) — Contexto
- [📈 00_INICIO_AQUI.md](00_INICIO_AQUI.md) — Resumen
- [🐍 taller_pd_pruebas_software.py](taller_pd_pruebas_software.py) — Código

---

**¡Éxito en el taller!** 🚀
