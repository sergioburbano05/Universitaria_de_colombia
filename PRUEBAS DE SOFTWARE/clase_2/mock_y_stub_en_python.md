# Mock y Stub en Pruebas Unitarias con Python

## ¿Qué es un Mock?

Un **Mock** es un objeto simulado que reemplaza a un objeto real durante las pruebas. Permite:
- Verificar que se llamaron ciertos métodos.
- Controlar los valores de retorno.
- Simular comportamientos sin depender de sistemas externos (bases de datos, APIs, etc.).

## ¿Qué es un Stub?

Un **Stub** es una implementación simplificada de un objeto o función que devuelve valores predefinidos. A diferencia del mock, el stub **no verifica interacciones**, solo proporciona respuestas controladas.

| Característica        | Mock                          | Stub                         |
|-----------------------|-------------------------------|------------------------------|
| Verifica llamadas     | Sí                            | No                           |
| Devuelve valores fijos| Puede hacerlo                 | Sí                           |
| Propósito principal   | Verificar comportamiento      | Aislar dependencias          |

---

## Librería utilizada: `unittest.mock`

Python incluye la librería estándar `unittest.mock` que proporciona `Mock`, `MagicMock` y `patch`.

```python
from unittest.mock import Mock, MagicMock, patch
```

---

## Ejemplos

---

### Ejemplo 1: Mock básico — Simular un objeto con métodos

**Escenario:** Tienes un servicio de correo electrónico y quieres verificar que se llama al método `enviar()` sin enviar un correo real.

```python
from unittest.mock import Mock

# Creamos un mock del servicio de correo
servicio_correo = Mock()

# Simulamos que el código bajo prueba llama al método
servicio_correo.enviar("usuario@ejemplo.com", "Bienvenido")

# Verificamos que el método fue llamado con los argumentos correctos
servicio_correo.enviar.assert_called_once_with("usuario@ejemplo.com", "Bienvenido")

print("Test pasado: el método enviar fue llamado correctamente.")
```

**Explicación:**  
`Mock()` crea un objeto falso. Cualquier atributo o método que intentes acceder en él es también un mock automáticamente. Con `assert_called_once_with(...)` verificamos que el método fue invocado exactamente una vez y con los argumentos esperados.

---

### Ejemplo 2: Stub con `return_value` — Controlar el valor de retorno

**Escenario:** Una función que consulta el precio de un producto desde una base de datos. Queremos probar la lógica sin conectarnos a la BD.

```python
from unittest.mock import Mock

# Stub del repositorio de productos
repositorio = Mock()
repositorio.obtener_precio.return_value = 150.0

# Función bajo prueba
def calcular_total(repositorio, cantidad):
    precio = repositorio.obtener_precio("PROD-001")
    return precio * cantidad

# Ejecutamos la prueba
total = calcular_total(repositorio, 3)
assert total == 450.0, f"Se esperaba 450.0 pero se obtuvo {total}"

print(f"Test pasado: total calculado = {total}")
```

**Explicación:**  
Con `return_value` definimos qué valor devolverá el método cuando sea llamado. Esto convierte al mock en un **stub**: proporciona una respuesta fija y predecible para aislar la lógica de negocio.

---

### Ejemplo 3: `patch` — Reemplazar una función de una librería externa

**Escenario:** Tu código usa `requests.get()` para llamar a una API. Quieres probar sin hacer peticiones HTTP reales.

```python
from unittest.mock import patch
import requests

def obtener_datos_usuario(user_id):
    respuesta = requests.get(f"https://api.ejemplo.com/usuarios/{user_id}")
    if respuesta.status_code == 200:
        return respuesta.json()
    return None

# Prueba con patch
with patch("requests.get") as mock_get:
    # Configuramos el stub de la respuesta
    mock_get.return_value.status_code = 200
    mock_get.return_value.json.return_value = {"id": 1, "nombre": "Ana"}

    resultado = obtener_datos_usuario(1)

    assert resultado == {"id": 1, "nombre": "Ana"}
    mock_get.assert_called_once_with("https://api.ejemplo.com/usuarios/1")

print("Test pasado: la función manejó correctamente la respuesta HTTP.")
```

**Explicación:**  
`patch()` reemplaza temporalmente `requests.get` con un mock dentro del bloque `with`. Al salir del bloque, se restaura el original. Esto es una técnica fundamental para aislar dependencias externas.

---

### Ejemplo 4: `side_effect` — Simular excepciones

**Escenario:** Queremos verificar que nuestra función maneja correctamente un error de conexión a la base de datos.

```python
from unittest.mock import Mock

class ErrorConexion(Exception):
    pass

# Stub que lanza una excepción
repositorio = Mock()
repositorio.guardar.side_effect = ErrorConexion("No se puede conectar con la BD")

# Función bajo prueba
def registrar_pedido(repositorio, pedido):
    try:
        repositorio.guardar(pedido)
        return {"estado": "exitoso"}
    except ErrorConexion:
        return {"estado": "error", "mensaje": "Fallo en la conexión"}

# Ejecutamos la prueba
resultado = registrar_pedido(repositorio, {"producto": "Laptop", "cantidad": 1})
assert resultado["estado"] == "error"

print(f"Test pasado: el error fue manejado correctamente → {resultado}")
```

**Explicación:**  
`side_effect` permite que el mock lance una excepción cuando se le llama, o que devuelva diferentes valores en cada llamada. Es ideal para probar el manejo de errores en tu código.

---

### Ejemplo 5: `MagicMock` — Soporte para métodos mágicos de Python

**Escenario:** Quieres simular un objeto que se use como contexto (`with`), como una conexión a base de datos.

```python
from unittest.mock import MagicMock

# MagicMock permite usar __enter__ y __exit__ (protocolo de contexto)
conexion_bd = MagicMock()
conexion_bd.__enter__.return_value = conexion_bd
conexion_bd.ejecutar.return_value = [{"id": 1, "nombre": "Carlos"}]

# Función bajo prueba
def buscar_usuarios(conexion_bd):
    with conexion_bd as conn:
        return conn.ejecutar("SELECT * FROM usuarios")

# Ejecutamos la prueba
resultado = buscar_usuarios(conexion_bd)
assert resultado == [{"id": 1, "nombre": "Carlos"}]

print(f"Test pasado: usuarios encontrados → {resultado}")
```

**Explicación:**  
`MagicMock` extiende `Mock` y soporta automáticamente los métodos mágicos de Python (`__len__`, `__iter__`, `__enter__`, `__exit__`, etc.). Es la opción preferida cuando el objeto que simulas usa estas características.

---

### Ejemplo 6: `patch` como decorador — Prueba con `unittest.TestCase`

**Escenario:** Usar `patch` de forma más ordenada con clases de prueba.

```python
import unittest
from unittest.mock import patch

def obtener_temperatura(ciudad):
    import requests
    respuesta = requests.get(f"https://api.clima.com/temperatura?ciudad={ciudad}")
    datos = respuesta.json()
    return datos["temperatura"]

class TestClima(unittest.TestCase):

    @patch("requests.get")
    def test_obtener_temperatura_madrid(self, mock_get):
        # Configuramos el stub
        mock_get.return_value.json.return_value = {"temperatura": 22}

        temp = obtener_temperatura("Madrid")

        # Verificaciones
        self.assertEqual(temp, 22)
        mock_get.assert_called_once_with(
            "https://api.clima.com/temperatura?ciudad=Madrid"
        )

if __name__ == "__main__":
    unittest.main()
```

**Explicación:**  
Cuando `patch` se usa como decorador (`@patch`), el mock se pasa como argumento al método de prueba. Esta es la forma más común y limpia de escribir tests con mocks en proyectos Python que usan `unittest`.

---

### Ejemplo 7: `call_count` y `call_args_list` — Verificar múltiples llamadas

**Escenario:** Una función que procesa una lista de facturas y llama a un servicio de notificación por cada una.

```python
from unittest.mock import Mock

# Mock del servicio de notificaciones
notificador = Mock()

# Función bajo prueba
def procesar_facturas(facturas, notificador):
    for factura in facturas:
        notificador.notificar(factura["cliente"], factura["monto"])

# Datos de prueba
facturas = [
    {"cliente": "Empresa A", "monto": 1000},
    {"cliente": "Empresa B", "monto": 2500},
    {"cliente": "Empresa C", "monto": 750},
]

procesar_facturas(facturas, notificador)

# Verificamos el número de llamadas
assert notificador.notificar.call_count == 3, "Se esperaban 3 notificaciones"

# Verificamos los argumentos de cada llamada
llamadas = notificador.notificar.call_args_list
assert llamadas[0].args == ("Empresa A", 1000)
assert llamadas[1].args == ("Empresa B", 2500)
assert llamadas[2].args == ("Empresa C", 750)

print(f"Test pasado: se enviaron {notificador.notificar.call_count} notificaciones correctamente.")
```

**Explicación:**  
- `call_count`: número total de veces que fue llamado el método.
- `call_args_list`: lista con los argumentos de cada llamada individual.  
Estas propiedades son muy útiles cuando la función bajo prueba realiza llamadas múltiples y necesitas verificarlas todas.

---

### Ejemplo 8: `patch.object` — Reemplazar un método de una clase existente

**Escenario:** Tienes una clase `ServicioFacturacion` y quieres reemplazar solo un método al hacer pruebas, sin mockear toda la clase.

```python
import unittest
from unittest.mock import patch

class ServicioFacturacion:
    def calcular_impuesto(self, monto):
        # Lógica real compleja (llama a un servicio externo)
        raise NotImplementedError("Requiere conexión al servicio fiscal")

    def calcular_total(self, monto):
        impuesto = self.calcular_impuesto(monto)
        return monto + impuesto

class TestServicioFacturacion(unittest.TestCase):

    def test_calcular_total(self):
        servicio = ServicioFacturacion()

        # Reemplazamos solo el método que tiene dependencia externa
        with patch.object(ServicioFacturacion, "calcular_impuesto", return_value=190.0):
            total = servicio.calcular_total(1000.0)

        self.assertEqual(total, 1190.0)
        print(f"Test pasado: total con impuesto = {total}")

if __name__ == "__main__":
    unittest.main()
```

**Explicación:**  
`patch.object(Clase, "nombre_método")` reemplaza un método específico de una clase existente. A diferencia de `patch()`, aquí no necesitas el path completo en forma de string: trabajas directamente con la clase. Es ideal cuando solo quieres aislar un método puntual de una clase real.

---

## Resumen de las técnicas cubiertas

| Ejemplo | Técnica                    | Cuándo usarla                                              |
|---------|----------------------------|------------------------------------------------------------|
| 1       | `Mock()` básico            | Verificar que un método fue llamado                        |
| 2       | `return_value` (Stub)      | Controlar el valor de retorno de un método                 |
| 3       | `patch()` con contexto     | Reemplazar librerías externas como `requests`              |
| 4       | `side_effect`              | Simular excepciones o comportamientos variables            |
| 5       | `MagicMock`                | Simular objetos con métodos mágicos (`with`, `len`, etc.)  |
| 6       | `@patch` como decorador    | Tests estructurados con `unittest.TestCase`                |
| 7       | `call_count` / `call_args` | Verificar múltiples llamadas y sus argumentos              |
| 8       | `patch.object()`           | Reemplazar un método específico de una clase real          |

---

## Buenas prácticas

- **Mockea solo lo necesario**: no abuses de los mocks o tus pruebas perderán valor.
- **Prefiere `patch` sobre inyección manual** cuando no puedes modificar la función original.
- **Usa `MagicMock`** cuando el objeto simulado necesite soportar operadores o contextos de Python.
- **Verifica las llamadas** para asegurarte de que el código actúa como esperas, no solo que no falla.
- **Mantén los tests independientes**: cada test debe poder ejecutarse solo, sin depender de otros.
