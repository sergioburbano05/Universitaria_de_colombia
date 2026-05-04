# Archivo sugerido: `taller_integrador.py`

Puedes entregar un solo archivo `.py` con todo así:

```python
# ==========================================
# Taller Integrador - Pruebas de Software
# Signey Ramirez
# ==========================================

# ---------- PARTE 2.1 Código a probar ----------

def detectar_estudiantes_riesgo(notas: list, umbral: float = 3.0) -> list:
    """
    Retorna estudiantes con promedio < umbral.
    """
    if not notas:
        return []

    riesgo = []

    for estudiante in notas:
        if not estudiante.get('materias'):
            continue

        suma = sum(m['nota'] for m in estudiante['materias'])
        promedio = suma / len(estudiante['materias'])

        if promedio < umbral:
            riesgo.append({
                'id': estudiante['id'],
                'promedio': promedio
            })

    return riesgo


# ---------- PARTE 2.2 Tests pytest ----------

def test_lista_vacia():
    assert detectar_estudiantes_riesgo([]) == []


def test_estudiante_sin_materias():
    datos = [{
        "id":1,
        "materias":[]
    }]

    assert detectar_estudiantes_riesgo(datos)==[]


def test_estudiante_en_riesgo():
    datos=[{
        "id":1,
        "materias":[
            {"nota":2.0},
            {"nota":2.5}
        ]
    }]

    r=detectar_estudiantes_riesgo(datos)

    assert r[0]["id"]==1


def test_estudiante_aprobado():
    datos=[{
        "id":2,
        "materias":[
            {"nota":4.0},
            {"nota":3.8}
        ]
    }]

    assert detectar_estudiantes_riesgo(datos)==[]


def test_umbral_personalizado():
    datos=[{
        "id":3,
        "materias":[
            {"nota":3.4},
            {"nota":3.2}
        ]
    }]

    r=detectar_estudiantes_riesgo(datos,3.5)

    assert len(r)==1


# ---------- PARTE 2.3 Hypothesis ----------
# Requiere:
# pip install hypothesis

from hypothesis import given
from hypothesis import strategies as st

@given(
    st.lists(
        st.floats(min_value=0,max_value=5),
        min_size=1,
        max_size=8
    )
)
def test_propiedad_riesgo(notas):

    estudiante=[{
      "id":1,
      "materias":[
         {"nota":n} for n in notas
      ]
    }]

    resultado=detectar_estudiantes_riesgo(estudiante)

    promedio=sum(notas)/len(notas)

    if promedio < 3:
        assert len(resultado)==1
    else:
        assert resultado==[]


# ---------- PARTE 3 Programación Dinámica ----------

def seleccionar_tests_optimos(tests, presupuesto):

    n=len(tests)

    dp=[[0]*(presupuesto+1)
       for _ in range(n+1)]

    for i in range(1,n+1):

        nombre,tiempo,valor=tests[i-1]

        for w in range(presupuesto+1):

            if tiempo<=w:
                dp[i][w]=max(
                    dp[i-1][w],
                    dp[i-1][w-tiempo]+valor
                )
            else:
                dp[i][w]=dp[i-1][w]

    seleccion=[]
    w=presupuesto

    for i in range(n,0,-1):
        if dp[i][w]!=dp[i-1][w]:
            seleccion.append(tests[i-1][0])
            w-=tests[i-1][1]

    seleccion.reverse()

    return dp[n][presupuesto],seleccion


tests=[
("test_login",3,85),
("test_calculo_promedio",5,95),
("test_deteccion_riesgo",4,90),
("test_exportar_pdf",6,70),
("test_exportar_excel",5,75),
("test_api_reportes",3,80),
("test_prediccion",8,65),
("test_ui_dashboard",7,60),
("test_concurrency",9,55),
("test_seguridad",4,88)
]


if __name__ == "__main__":
    valor, seleccion = seleccionar_tests_optimos(tests,25)

    print("Valor óptimo DP:", valor)
    print("Tests seleccionados:")

    for t in seleccion:
        print("-", t)
```

## Si te preguntan qué entregar:

Ese archivo se llamaría:

```text
TallerIntegrador_SigneyRamirez.py
```

Y ya cumpliría con lo que pide “.py + documento completado”.
