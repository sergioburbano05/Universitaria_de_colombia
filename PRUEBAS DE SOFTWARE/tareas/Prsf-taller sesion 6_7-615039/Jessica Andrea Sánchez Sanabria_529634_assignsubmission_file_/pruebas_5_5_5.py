from dataclasses import dataclass

VALOR_MULTA_DIARIA = 1200


@dataclass
class Libro:
    id: int
    titulo: str
    disponible: bool = True


@dataclass
class Usuario:
    nombre: str
    multa_pendiente: int = 0
    bloqueado: bool = False
    prestamos_activos: int = 0


def calcular_multa(dias_retraso: int) -> int:
    if dias_retraso < 0:
        raise ValueError("Los días no pueden ser negativos")
    return dias_retraso * VALOR_MULTA_DIARIA


def puede_prestar(usuario: Usuario) -> bool:
    if usuario.bloqueado:
        return False
    if usuario.multa_pendiente > 0:
        return False
    return True


def registrar_prestamo(usuario: Usuario, libro: Libro) -> str:
    if not libro.disponible:
        return "El libro no está disponible"
    if not puede_prestar(usuario):
        return "El usuario no puede realizar préstamos"
    libro.disponible = False
    usuario.prestamos_activos += 1
    return "Préstamo registrado"


def registrar_devolucion(usuario: Usuario, libro: Libro, dias_retraso: int) -> str:
    libro.disponible = True
    if usuario.prestamos_activos > 0:
        usuario.prestamos_activos -= 1
    multa = calcular_multa(dias_retraso)
    usuario.multa_pendiente += multa
    if usuario.multa_pendiente > 0:
        usuario.bloqueado = True
    return f"Devolución registrada. Multa generada: {multa}"


def pagar_multa(usuario: Usuario, valor: int) -> str:
    if valor <= 0:
        return "El valor debe ser mayor a cero"
    usuario.multa_pendiente -= valor
    if usuario.multa_pendiente <= 0:
        usuario.multa_pendiente = 0
        usuario.bloqueado = False
        return "Multa pagada por completo"
    return f"Pago aplicado. Saldo pendiente: {usuario.multa_pendiente}"


# -------------------------
# 5 pruebas de regresión
# -------------------------

def regresion_1_calculo_multa_normal():
    resultado = calcular_multa(3)
    assert resultado == 3600
    return "Regresión 1 aprobada"


def regresion_2_calculo_multa_cero_dias():
    resultado = calcular_multa(0)
    assert resultado == 0
    return "Regresión 2 aprobada"


def regresion_3_no_acepta_dias_negativos():
    try:
        calcular_multa(-1)
        assert False
    except ValueError:
        assert True
    return "Regresión 3 aprobada"


def regresion_4_usuario_bloqueado_no_puede_prestar():
    usuario = Usuario("Camila", bloqueado=True)
    resultado = puede_prestar(usuario)
    assert resultado is False
    return "Regresión 4 aprobada"


def regresion_5_usuario_sin_multa_si_puede_prestar():
    usuario = Usuario("Mateo")
    resultado = puede_prestar(usuario)
    assert resultado is True
    return "Regresión 5 aprobada"


# -------------------------
# 5 pruebas smoke
# -------------------------

class BibliotecaAPI:
    def __init__(self, bd_activa=True, login_activo=True):
        self.bd_activa = bd_activa
        self.login_activo = login_activo

    def health(self):
        if self.bd_activa:
            return {"status": 200, "mensaje": "ok"}
        return {"status": 500, "mensaje": "error"}

    def login(self, usuario, clave):
        if not self.login_activo:
            return {"status": 503, "mensaje": "servicio no disponible"}
        if usuario and clave:
            return {"status": 200, "mensaje": "acceso correcto"}
        return {"status": 401, "mensaje": "credenciales incompletas"}


def smoke_1_health_responde_ok():
    api = BibliotecaAPI()
    respuesta = api.health()
    assert respuesta["status"] == 200
    return "Smoke 1 aprobada"


def smoke_2_health_detecta_fallo_bd():
    api = BibliotecaAPI(bd_activa=False)
    respuesta = api.health()
    assert respuesta["status"] == 500
    return "Smoke 2 aprobada"


def smoke_3_login_basico_funciona():
    api = BibliotecaAPI()
    respuesta = api.login("admin", "1234")
    assert respuesta["status"] == 200
    return "Smoke 3 aprobada"


def smoke_4_login_rechaza_datos_incompletos():
    api = BibliotecaAPI()
    respuesta = api.login("admin", "")
    assert respuesta["status"] == 401
    return "Smoke 4 aprobada"


def smoke_5_login_detecta_servicio_inactivo():
    api = BibliotecaAPI(login_activo=False)
    respuesta = api.login("admin", "1234")
    assert respuesta["status"] == 503
    return "Smoke 5 aprobada"


# -------------------------
# 5 pruebas de aceptación
# -------------------------

def aceptacion_1_prestamo_exitoso():
    usuario = Usuario("Laura")
    libro = Libro(1, "Algoritmos")

    mensaje = registrar_prestamo(usuario, libro)

    assert mensaje == "Préstamo registrado"
    assert libro.disponible is False
    assert usuario.prestamos_activos == 1
    return "Aceptación 1 aprobada"


def aceptacion_2_usuario_con_multa_no_logra_prestamo():
    usuario = Usuario("Daniel", multa_pendiente=2400)
    libro = Libro(2, "Bases de Datos")

    mensaje = registrar_prestamo(usuario, libro)

    assert mensaje == "El usuario no puede realizar préstamos"
    assert libro.disponible is True
    return "Aceptación 2 aprobada"


def aceptacion_3_devolucion_tardia_genera_multa_y_bloqueo():
    usuario = Usuario("Valentina", prestamos_activos=1)
    libro = Libro(3, "Redes", disponible=False)

    mensaje = registrar_devolucion(usuario, libro, 2)

    assert usuario.multa_pendiente == 2400
    assert usuario.bloqueado is True
    assert usuario.prestamos_activos == 0
    assert "2400" in mensaje
    return "Aceptación 3 aprobada"


def aceptacion_4_pago_parcial_deja_saldo():
    usuario = Usuario("Sara", multa_pendiente=3600, bloqueado=True)

    mensaje = pagar_multa(usuario, 1200)

    assert mensaje == "Pago aplicado. Saldo pendiente: 2400"
    assert usuario.multa_pendiente == 2400
    assert usuario.bloqueado is True
    return "Aceptación 4 aprobada"


def aceptacion_5_pago_total_habilita_nuevo_prestamo():
    usuario = Usuario("Andrés", multa_pendiente=2400, bloqueado=True)
    libro = Libro(4, "Python")

    pago = pagar_multa(usuario, 2400)
    prestamo = registrar_prestamo(usuario, libro)

    assert pago == "Multa pagada por completo"
    assert prestamo == "Préstamo registrado"
    assert usuario.bloqueado is False
    assert usuario.prestamos_activos == 1
    return "Aceptación 5 aprobada"


def ejecutar_todo():
    pruebas = [
        regresion_1_calculo_multa_normal,
        regresion_2_calculo_multa_cero_dias,
        regresion_3_no_acepta_dias_negativos,
        regresion_4_usuario_bloqueado_no_puede_prestar,
        regresion_5_usuario_sin_multa_si_puede_prestar,
        smoke_1_health_responde_ok,
        smoke_2_health_detecta_fallo_bd,
        smoke_3_login_basico_funciona,
        smoke_4_login_rechaza_datos_incompletos,
        smoke_5_login_detecta_servicio_inactivo,
        aceptacion_1_prestamo_exitoso,
        aceptacion_2_usuario_con_multa_no_logra_prestamo,
        aceptacion_3_devolucion_tardia_genera_multa_y_bloqueo,
        aceptacion_4_pago_parcial_deja_saldo,
        aceptacion_5_pago_total_habilita_nuevo_prestamo,
    ]

    for prueba in pruebas:
        print(prueba())


if __name__ == "__main__":
    ejecutar_todo()
