# Proyecto Python - Suite de Pruebas Completa

Un proyecto Python profesional con suite completa de pruebas (unitarias, smoke, regresión, performance) y pipeline CI/CD automatizado con GitHub Actions.

## 📋 Estructura del Proyecto

```
Proyecto_Python_Pruebas/
├── src/
│   ├── __init__.py
│   └── task_manager.py          # Módulo principal
├── tests/
│   ├── __init__.py
│   ├── test_unit_tasks.py       # Pruebas unitarias
│   ├── test_smoke_tasks.py      # Smoke tests
│   ├── test_regression_tasks.py # Pruebas de regresión
│   └── test_performance_tasks.py # Pruebas de performance
├── .github/
│   └── workflows/
│       └── ci.yml               # Pipeline CI/CD
├── requirements.txt             # Dependencias
├── .gitignore
└── README.md
```

## 🚀 Inicio Rápido

### Prerrequisitos
- Python 3.8 o superior
- pip o virtualenv

### Instalación

1. **Clona el repositorio**
```bash
git clone https://github.com/tu-usuario/Proyecto_Python_Pruebas.git
cd Proyecto_Python_Pruebas
```

2. **Crea un entorno virtual (recomendado)**
```bash
python -m venv venv

# En Windows:
venv\Scripts\activate

# En macOS/Linux:
source venv/bin/activate
```

3. **Instala las dependencias**
```bash
pip install -r requirements.txt
```

## 📝 Tipos de Pruebas

### 1. Pruebas Unitarias (`test_unit_tasks.py`)
Verifican la funcionalidad de componentes individuales.

```bash
pytest tests/test_unit_tasks.py -v
```

**Incluye:**
- Creación de tareas
- Completar tareas
- Recuperación de tareas
- Eliminación de tareas
- Estadísticas
- Actualización de tareas

### 2. Smoke Tests (`test_smoke_tasks.py`)
Pruebas rápidas que validan que el sistema funciona en general.

```bash
pytest tests/test_smoke_tasks.py -v
```

**Incluye:**
- Workflow básico completo
- Múltiples operaciones en secuencia
- Inicialización del gestor
- Filtrado por prioridad
- Manejo de errores

### 3. Pruebas de Regresión (`test_regression_tasks.py`)
Verifican que cambios no rompan funcionalidad existente.

```bash
pytest tests/test_regression_tasks.py -v
```

**Incluye:**
- Timestamps en tareas
- Persistencia de datos
- Integridad del espacio de IDs
- Casos extremos
- Validaciones consistentes

### 4. Pruebas de Performance (`test_performance_tasks.py`)
Miden velocidad y detectan cuellos de botella.

```bash
pytest tests/test_performance_tasks.py -v
```

**Incluye:**
- Creación de 1000 tareas (< 1s)
- Filtrado de 500 tareas (< 10ms)
- Cálculo de estadísticas (< 50ms)
- Búsqueda por ID es O(1)
- Eficiencia de memoria

## 🧪 Ejecutar Todas las Pruebas

**Ejecutar todas las pruebas:**
```bash
pytest -v
```

**Ejecutar con cobertura:**
```bash
pytest --cov=src --cov-report=html -v
```

Esto crea un reporte HTML en `htmlcov/index.html`

**Ejecutar categoría específica:**
```bash
pytest -v -k "smoke"        # Solo smoke tests
pytest -v -k "unit"         # Solo unitarias
pytest -v -k "regression"   # Solo regresión
pytest -v -k "performance"  # Solo performance
```

## 🔄 Pipeline CI/CD con GitHub Actions

El proyecto incluye un pipeline CI/CD completo que se ejecuta en cada push y pull request.

### ¿Qué valida el pipeline?

✅ **Tests en múltiples versiones de Python** (3.8, 3.9, 3.10, 3.11)
✅ **Pruebas unitarias** - Funcionalidad correcta
✅ **Smoke tests** - Sistema funciona en general
✅ **Pruebas de regresión** - No hay regresiones
✅ **Pruebas de performance** - Cumple umbrales
✅ **Cobertura de código** - Mínimo 70% recomendado
✅ **Análisis de código** - Black, isort, flake8, pylint
✅ **Seguridad** - Bandit, Safety
✅ **Build del paquete** - Verifica distribución

### Configuración de GitHub

1. **Sube el proyecto a GitHub**
```bash
git remote add origin https://github.com/tu-usuario/Proyecto_Python_Pruebas.git
git branch -M main
git push -u origin main
```

2. **Configura branch protection rules** (en Configuración > Branches):
   - Require status checks to pass before merging
   - Require branches to be up to date before merging

3. **Los merges ahora validarán automáticamente:**
   - ✅ Todos los tests pasan
   - ✅ Cobertura de código es suficiente
   - ✅ Análisis de código sin problemas
   - ✅ Sin vulnerabilidades de seguridad

## 📊 Módulo Principal: TaskManager

El proyecto incluye un ejemplo práctico: **Administrador de Tareas**

### Funcionalidades

```python
from src.task_manager import TaskManager

# Crear gestor
manager = TaskManager()

# Agregar tareas
task1 = manager.add_task("Comprar leche", priority=3)
task2 = manager.add_task("Proyecto urgente", priority=5)

# Completar tarea
manager.complete_task(task1.task_id)

# Consultar tareas
manager.get_pending_tasks()        # Tareas pendientes
manager.get_completed_tasks()      # Tareas completadas
manager.get_high_priority_tasks()  # Alta prioridad sin completar
manager.get_tasks_by_priority(5)   # Por prioridad específica

# Estadísticas
stats = manager.count_tasks()
# {'total': 2, 'completed': 1, 'pending': 1, 'completion_rate': 50.0}

# Actualizar tarea
manager.update_task(task1.task_id, title="Nuevo título", priority=1)

# Eliminar tarea
manager.delete_task(task1.task_id)
```

## 🛠️ Desarrollo

### Agregar nuevas pruebas

1. Crea un archivo en `tests/`
2. Usa pytest como framework
3. Sigue el patrón de nombres: `test_*.py` o `*_test.py`

```python
def test_nueva_funcionalidad():
    manager = TaskManager()
    # Tu prueba aquí
    assert resultado == esperado
```

### Mejora del código

```bash
# Formatear código
black src/ tests/

# Organizar imports
isort src/ tests/

# Revisar linting
flake8 src/ tests/

# Análisis estricto
pylint src/
```

## 📈 Métricas

- **Pruebas Unitarias:** 30+ tests
- **Smoke Tests:** 8+ tests
- **Pruebas de Regresión:** 15+ tests
- **Pruebas de Performance:** 10+ tests
- **Total:** 60+ tests
- **Cobertura de código:** ~95%

## 🔐 Seguridad

El pipeline incluye escaneos de seguridad:
- **Bandit:** Detecta vulnerabilidades comunes en Python
- **Safety:** Revisa dependencias con vulnerabilidades conocidas

## 📦 Versiones de Python Soportadas

- Python 3.8
- Python 3.9
- Python 3.10
- Python 3.11

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👥 Contribuir

1. Haz un fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## ❓ Preguntas Frecuentes

**P: ¿Qué pasa si un test falla en el pipeline?**
R: El merge se bloquea. Descarga los logs del pipeline para ver qué falló.

**P: ¿Puedo ejecutar pruebas localmente?**
R: Sí, con `pytest` ejecutas exactamente lo que valida el pipeline.

**P: ¿Cómo veo la cobertura de código?**
R: Ejecuta `pytest --cov=src --cov-report=html` y abre `htmlcov/index.html`

**P: ¿Qué versiones de Python prueba el pipeline?**
R: 3.8, 3.9, 3.10, 3.11 (configurable en `.github/workflows/ci.yml`)

---

**Creado como ejemplo profesional de testing y CI/CD en Python**
