# Fallo Intencional: Romper el Pipeline

## Objetivo
Mostrar a los estudiantes cómo GitHub Actions reporta fallos y cómo interpretarlos.

## Escenario del fallo
Se introducirá un error deliberado en una prueba para que el pipeline de GitHub Actions falle en el job de pruebas.

---

## Opción 1: Fallo en una prueba (RECOMENDADO)

### Cambio a hacer en `tests/test_app.py`

Línea actual (correcta):
```python
def test_health_returns_service_name(client):
    response = client.get("/health")

    assert response.get_json() == {"status": "ok", "service": "sistema-notas"}
```

Cambiar a (rompe el test):
```python
def test_health_returns_service_name(client):
    response = client.get("/health")

    assert response.get_json() == {"status": "ok", "service": "SERVICIO_INCORRECTO"}
```

### Por qué falla
La respuesta real del endpoint es `"sistema-notas"`, pero la prueba espera `"SERVICIO_INCORRECTO"`. El test fallará.

### Evidencia en GitHub Actions
- **Job afectado**: test
- **Paso**: Ejecutar pruebas con cobertura
- **Error**: AssertionError
- **Línea**: archivo y número de línea exacto del assert

### Cómo se vería en los logs
```
FAILED tests/test_app.py::test_health_returns_service_name - AssertionError
assert {'status': 'ok', 'service': 'sistema-notas'} == {'status': 'ok', 'service': 'SERVICIO_INCORRECTO'}
```

---

## Opción 2: Fallo en linting (alternativa rápida)

### Cambio a hacer en `app.py`

Agregar una línea con estilo incorrecto, por ejemplo:

```python
def health_check():
    x=1  # Sin espacios alrededor del operador (viola estilo)
    return jsonify({"status": "ok", "service": "sistema-notas"})
```

### Por qué falla
Ruff detecta que los espacios alrededor del operator `=` violan PEP 8.

### Evidencia en GitHub Actions
- **Job afectado**: test
- **Paso**: Lint con Ruff
- **Error**: E225 missing whitespace around operator

---

## Opción 3: Fallo en cobertura (educativo)

### Cambio a hacer en `tests/test_app.py`

Eliminar dos pruebas para que la cobertura caiga por debajo de 70%:

```python
# Comentar estas dos pruebas
# def test_student_summary_marks_student_as_passed():
#     summary = student_summary(1003)
#     assert summary["passed"] is True

# def test_validate_grades_rejects_grade_out_of_range():
#     with pytest.raises(ValueError, match="Cada nota debe estar entre 0 y 5"):
#         validate_grades([4.0, 6.0])
```

### Por qué falla
Menos pruebas significa menos líneas de código cubiertas. La cobertura caería a ~65%, por debajo del 70% obligatorio.

### Evidencia en GitHub Actions
```
FAILED Required test coverage of 70% reached. Total coverage: 65%
```

---

## Procedimiento del taller para ver el fallo

### Paso 1: Preparar el fallo

Usar **Opción 1** (fallo en prueba) como predeterminada:

```bash
cd c:\Repositorio\Universitaria_de_colombia\PRUEBAS DE SOFTWARE\clase_9\taller_ci_cd_sistema_notas

# Editar tests/test_app.py y cambiar "sistema-notas" por "SERVICIO_INCORRECTO"
```

### Paso 2: Verificar el fallo localmente

```bash
python -m pytest --cov=app --cov-report=term-missing --cov-fail-under=70
```

Resultado esperado:
```
FAILED tests/test_app.py::test_health_returns_service_name
```

### Paso 3: Hacer commit con el fallo

```bash
git add tests/test_app.py
git commit -m "test: cambio de valor esperado (fallo intencional)"
git push
```

### Paso 4: Revisar GitHub Actions

1. Abrir el repositorio en GitHub
2. Ir a la pestaña "Actions"
3. Ver la ejecución más reciente
4. Entrar en el job "test"
5. Buscar el paso "Ejecutar pruebas con cobertura"
6. Leer el log completo

### Preguntas para guiar el análisis

- ¿En qué job falló el pipeline?
- ¿En qué paso exacto?
- ¿Cuál fue el mensaje de error?
- ¿Qué prueba falló y por qué?
- ¿Qué línea del código está mal?
- ¿Qué evidencia deja GitHub Actions en los logs?

---

## Paso 5: Revertir el fallo

Una vez analizado, revertir el cambio:

```bash
# Editar tests/test_app.py y restaurar "SERVICIO_INCORRECTO" por "sistema-notas"

git add tests/test_app.py
git commit -m "test: revertir cambio (fallo intencional completado)"
git push
```

Verificar que GitHub Actions pasa nuevamente.

---

## Notas para el instructor

- Este ejercicio enseña a leer logs de CI/CD y entender cómo GitHub Actions reporta errores.
- Es una experiencia controlada y segura para aprender sin miedo a romper en producción.
- Los estudiantes pueden experimentar con distintos tipos de fallos (código, lint, cobertura).
- La reversión rápida solidifica el ciclo de: escribir → fallar → entender → fijar → pasar.
