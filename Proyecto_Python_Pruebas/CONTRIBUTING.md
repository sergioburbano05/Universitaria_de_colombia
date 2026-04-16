# Guía de Contribución

¡Gracias por tu interés en contribuir a este proyecto! Aquí está cómo puedes hacerlo.

## 🤝 Proceso de Contribución

### 1. Fork y Clone

```bash
# Fork en GitHub (botón en esquina superior derecha)
git clone https://github.com/tu-usuario/Proyecto_Python_Pruebas.git
cd Proyecto_Python_Pruebas
```

### 2. Crea una rama para tu feature

```bash
git checkout -b feature/tu-feature-name
```

Usa nombres descriptivos:
- `feature/nueva-funcionalidad`
- `bugfix/correcion-de-bug`
- `docs/mejorar-documentacion`

### 3. Realiza tus cambios

Al agregar código:
1. **Escribe el código**
2. **Escribe las pruebas** (test-driven development)
3. **Asegúrate que todos los tests pasen**
4. **Formatea tu código**

### 4. Formatea y valida

```bash
# Instala herramientas de desarrollo
pip install -r requirements.txt

# Formatea el código
black src/ tests/
isort src/ tests/

# Ejecuta todas las pruebas
python run_tests.py

# O ejecútalas individualmente
pytest tests/test_unit_tasks.py -v
pytest tests/test_smoke_tasks.py -v
pytest tests/test_regression_tasks.py -v
pytest tests/test_performance_tasks.py -v
```

### 5. Commit y Push

```bash
# Commit con mensaje descriptivo
git commit -m "Agregar nueva funcionalidad X"
git commit -m "Corregir bug en Y"
git commit -m "Mejorar documentación de Z"

# Push a tu fork
git push origin feature/tu-feature-name
```

### 6. Abre un Pull Request

1. Ve a GitHub y haz clic en "Compare & pull request"
2. Describe qué cambios hiciste y por qué
3. Asegúrate de que:
   - Está vinculado a un issue (si aplica)
   - Los tests pasen en el pipeline CI/CD
   - Tu código sigue los estándares del proyecto

## 📋 Estándares del Código

### Estilo

- Usa **Black** para formateo
- Usa **isort** para organizar imports
- Sigue **PEP 8**

### Pruebas

Toda nueva funcionalidad debe incluir pruebas:

- **Unitarias** - Prueba componentes individuales
- **Smoke** - Verifica que todo funcione en conjunto
- **Regresión** - Asegura que no se rompió nada
- **Performance** - Si es relevante, verifica velocidad

Ejemplo:

```python
# test_feature.py
import pytest
from src.task_manager import TaskManager

def test_nueva_funcionalidad():
    """Descripción clara de qué prueba"""
    manager = TaskManager()
    
    # Arrange - Preparar datos
    task = manager.add_task("Test")
    
    # Act - Ejecutar
    result = manager.get_task(task.task_id)
    
    # Assert - Verificar
    assert result is not None
    assert result.title == "Test"
```

### Documentación

- Agrega docstrings a funciones y clases
- Actualiza el README si cambias funcionalidad
- Comenta código complejo

```python
def nueva_funcion(param):
    """
    Descripción breve.
    
    Descripción más detallada si es necesario.
    
    Args:
        param: Descripción del parámetro
        
    Returns:
        Descripción del retorno
        
    Raises:
        ValueError: Cuándo se lanza
    """
```

## 🐛 Reportar Bugs

1. Verifica que el bug no haya sido reportado
2. Abre un issue describiendo:
   - Qué esperas que pase
   - Qué realmente pasa
   - Pasos para reproducir
   - Versión de Python
   - Sistema operativo

## 💡 Sugerir Features

1. Abre un issue con la etiqueta `enhancement`
2. Describe la funcionalidad deseada
3. Explica por qué sería útil
4. Sugiere ejemplos de uso

## 📝 Convenciones de Commits

Usa mensajes claros y descriptivos:

```bash
# Bien ✓
git commit -m "Agregar validación de prioridad en TaskManager"
git commit -m "Corregir performance en get_all_tasks()"
git commit -m "Actualizar documentación de instalación"

# Evita ✗
git commit -m "Fix"
git commit -m "Updates"
git commit -m "asdf"
```

## 🚀 Checklist para Pull Requests

- [ ] Mi código sigue los estándares de estilo
- [ ] He actualizado la documentación relevante
- [ ] He agregado pruebas para nuevas funcionalidades
- [ ] Todas las pruebas pasan localmente
- [ ] Mi rama está actualizada con main
- [ ] He revisado mi propio código

## ❓ Preguntas?

- Abre un issue con la etiqueta `question`
- Discutamos en los issues del proyecto

---

**¡Gracias por contribuir! 🎉**
