# Taller paso a paso: CI/CD con GitHub para el sistema de notas

## Objetivo

Construir un ejercicio guiado donde el estudiante cree un repositorio en GitHub, implemente una API Python, agregue pruebas automáticas y configure un pipeline CI/CD con GitHub Actions.

## Resultado esperado

Al finalizar el taller, el estudiante habra logrado:

1. Crear o clonar un repositorio en GitHub.
2. Ejecutar una API Python con 3 endpoints.
3. Correr 10 pruebas unitarias con pytest.
4. Configurar un workflow de integracion continua.
5. Medir cobertura y exigir al menos 70%.
6. Construir una imagen Docker despues de pasar pruebas.
7. Observar el pipeline en una rama y en un Pull Request.
8. Analizar el fallo de una ejecucion rota.

## Estructura sugerida para la sesion

- Parte 1. Setup: 15 minutos
- Parte 2. Workflow CI: 25 minutos
- Parte 3. CD y mejoras: 20 minutos

## Parte 1. Setup

### Paso 1. Crear el repositorio en GitHub

1. Entrar a GitHub.
2. Crear un repositorio nuevo llamado sistema-notas-ci.
3. Marcar la opcion Add a README file solo si deseas iniciar desde GitHub.
4. Copiar la URL del repositorio.

### Paso 2. Clonar el repositorio en local

```bash
git clone https://github.com/TU_USUARIO/sistema-notas-ci.git
cd sistema-notas-ci
```

### Paso 3. Crear el entorno virtual e instalar dependencias

```bash
python -m venv .venv
.venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements-dev.txt
```

Nota para clase:

Las dependencias quedan separadas asi:

- requirements.txt: API y ejecucion.
- requirements-dev.txt: pruebas, cobertura y lint.

### Paso 4. Explicar la estructura base del proyecto

Usa como referencia la plantilla incluida en la carpeta del curso:

- app.py: contiene la API Flask.
- tests/test_app.py: contiene las pruebas unitarias.
- requirements.txt: dependencias de ejecucion.
- requirements-dev.txt: dependencias de desarrollo y pruebas.
- .github/workflows/ci.yml: pipeline de GitHub Actions.
- Dockerfile: construccion del contenedor.

### Paso 5. Probar la API localmente

```bash
python app.py
```

Pruebas manuales recomendadas:

```bash
curl http://127.0.0.1:5000/health
curl http://127.0.0.1:5000/students/1001/summary
curl -X POST http://127.0.0.1:5000/grades/evaluate -H "Content-Type: application/json" -d "{\"grades\":[4,5,3]}"
```

### Paso 6. Ejecutar las pruebas unitarias

```bash
python -m pytest
```

Punto de control para clase:

- Verificar que se ejecutan 10 pruebas.
- Confirmar que todas pasan localmente.

## Parte 2. Workflow CI 

### Paso 7. Crear la carpeta de workflows

Crear la ruta .github/workflows y agregar el archivo ci.yml.

### Paso 8. Explicar que hace el workflow

El workflow incluido en la plantilla realiza estas acciones:

1. Hace checkout del codigo.
2. Configura Python 3.12.
3. Activa cache de pip.
4. Instala dependencias.
5. Ejecuta lint con python -m ruff.
6. Ejecuta python -m pytest con cobertura.
7. Falla si la cobertura es menor a 70%.
8. Construye la imagen Docker solo si las pruebas pasaron.

### Paso 9. Hacer el primer commit y push

```bash
git add .
git commit -m "feat: base del taller CI/CD"
git branch -M main
git push -u origin main
```

### Paso 10. Verificar el pipeline en GitHub

1. Abrir la pestana Actions del repositorio.
2. Entrar a la ejecucion mas reciente.
3. Revisar el job test.
4. Revisar que despues se ejecute el job docker.

Preguntas para guiar a los estudiantes:

- Que pasa si falla el lint.
- Que pasa si la cobertura es menor al 70%.
- Por que el job docker depende del job test.

## Parte 3. CD y mejoras

### Paso 11. Construir Docker en local

Si Docker no esta instalado en el equipo, este paso se puede omitir en local y validar directamente en GitHub Actions.

### Paso 12. Agregar badge al README

Insertar esta linea en el README del repositorio:

```md
![CI](https://github.com/sergioburbano05/taller_ci_cd_sistema_notas/actions/workflows/ci.yml/badge.svg)
```

Luego guardar el archivo y ejecutar:

```bash
git add README.md
git commit -m "docs: agregar badge de GitHub Actions"
git push
```

### Paso 13. Crear una rama y abrir un Pull Request

```bash
git checkout -b feature/mejora-promedio
```

Hacer un cambio pequeno, por ejemplo modificar un mensaje de respuesta o agregar un estudiante nuevo, luego:

```python
STUDENTS = {
    1001: {"name": "Ana", "grades": [4.5, 3.8, 4.2]},
    1002: {"name": "Luis", "grades": [2.8, 3.1, 2.9]},
    1003: {"name": "Marta", "grades": [5.0, 4.7, 4.9]},
    1004: {"name": "Carlos", "grades": [3.5, 4.0, 3.7]},
}
```

```bash
git add .
git commit -m "feat: mejora ejemplo para PR"
git push -u origin feature/mejora-promedio
```

Despues:

1. Abrir el Pull Request en GitHub.
2. Observar que el workflow se ejecuta tambien para PR.
3. Revisar checks, logs y tiempos de ejecucion.

### Paso 14. Generar un fallo intencional

Opciones recomendadas para el ejercicio:

1. Cambiar un valor esperado en una prueba para que falle.
2. Bajar el umbral de calidad introduciendo codigo sin pruebas.
3. Romper el estilo para que Ruff detecte el error.

Ejemplo simple:

En [clase_9/taller_ci_cd_sistema_notas/tests/test_app.py](clase_9/taller_ci_cd_sistema_notas/tests/test_app.py), cambiar la prueba del endpoint health por esta version incorrecta:

```python
def test_health_returns_service_name(client):
    response = client.get("/health")

    assert response.get_json() == {"status": "ok", "service": "SERVICIO_INCORRECTO"}

def test_health_returns_service_name(client):
    response = client.get("/health")

    assert response.get_json() == {"status": "ok", "service": "sistema-notas"}    
```

Con este cambio, el pipeline debe fallar en el paso de pruebas porque la API devuelve `sistema-notas` y la prueba espera `SERVICIO_INCORRECTO`.

Cambiar en tests/test_app.py la expectativa del endpoint health para esperar un valor incorrecto.

### Paso 15. Analizar el output del pipeline

Pedir a los estudiantes que respondan:

1. En que job fallo.
2. En que paso exacto se rompio.
3. Cual fue el mensaje de error.
4. Que archivo y que linea originaron el problema.
5. Que evidencia dejo GitHub Actions en los logs.

---

## Paso 16. Practica adicional: agregar nuevas pruebas (20 min)

### Objetivo

Ampliar la cobertura del proyecto agregando pruebas para los casos que actualmente no estan cubiertos. Ver las lineas sin cubrir y escribir pruebas que las alcancen.

### Paso 16.1. Identificar lineas sin cobertura

Ejecutar:

```bash
python -m pytest --cov=app --cov-report=term-missing
```

En la columna `Missing` veras las lineas de `app.py` que no tienen prueba. Actualmente son:

- Linea 13: `raise ValueError("La lista de notas no puede estar vacia")`
- Linea 23: `raise ValueError("Todas las notas deben ser numericas")`
- Linea 53: respuesta 404 del endpoint `/students/<id>/summary`
- Lineas 63-64: payload vacio o sin clave `grades` en `/grades/evaluate`
- Linea 82: bloque `if __name__ == "__main__"`

### Paso 16.2. Escribir las pruebas faltantes

Agregar estos 4 tests al final de `tests/test_app.py`:

```python
def test_student_summary_returns_404_for_unknown_student(client):
    response = client.get("/students/9999/summary")

    assert response.status_code == 404
    assert response.get_json() == {"error": "Estudiante no encontrado"}


def test_evaluate_grades_rejects_missing_grades_key(client):
    response = client.post("/grades/evaluate", json={"otro": "dato"})

    assert response.status_code == 400


def test_evaluate_grades_rejects_non_numeric_grade(client):
    response = client.post("/grades/evaluate", json={"grades": [4.0, "cinco"]})

    assert response.status_code == 400


def test_calculate_average_raises_on_empty_list():
    from app import calculate_average
    import pytest

    with pytest.raises(ValueError, match="La lista de notas no puede estar vacia"):
        calculate_average([])
```

### Paso 16.3. Verificar nueva cobertura

```bash
python -m ruff check .
python -m pytest --cov=app --cov-report=term-missing --cov-fail-under=70
```

La cobertura deberia subir de 87% a cerca de 95%.

### Paso 16.4. Subir los cambios y observar el pipeline

```bash
git checkout -b feature/mas-pruebas
git add tests\test_app.py
git commit -m "test: agregar pruebas para casos sin cobertura"
git push -u origin feature/mas-pruebas
```

Abrir un Pull Request y confirmar que GitHub Actions pasa con la nueva cobertura.

---

## Criterios de evaluacion sugeridos

- El repositorio contiene los archivos base del proyecto.
- La API responde correctamente en local.
- Existen al menos 10 pruebas automatizadas.
- El workflow corre en push y pull request.
- La cobertura exigida es de al menos 70%.
- El job Docker se ejecuta despues de pruebas.
- El estudiante puede explicar una falla del pipeline.

## Material listo para usar en esta clase

La plantilla completa del ejercicio fue preparada en la carpeta:

- clase_9/taller_ci_cd_sistema_notas

Desde ahi puedes copiar el proyecto al repositorio del estudiante o usarlo como base demostrativa durante la clase.