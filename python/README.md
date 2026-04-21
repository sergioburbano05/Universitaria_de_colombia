# Soluciones Ejercicios Resueltos â€” SesiÃ³n 12
## Testing DinÃ¡mico Â· Mutation Testing Â· Property-Based Testing

**Materia:** Pruebas de Software (7mo Semestre)  
**Universidad:** Universitaria de Colombia  
**Docente:** Mg. Sergio Alejandro Burbano Mena  
**Fecha:** abril de 2026

---

## Estructura del Proyecto

```
python/
â”œâ”€â”€ src/
â”‚   â”œâ”€â”€ __init__.py
â”‚   â”œâ”€â”€ ejercicio_1.py    â† calcular_descuento
â”‚   â”œâ”€â”€ ejercicio_2.py    â† validar_matricula
â”‚   â”œâ”€â”€ ejercicio_3.py    â† promedio_ponderado
â”‚   â””â”€â”€ ejercicio_4.py    â† revertir, es_palindromo, concatenar_lista
â”œâ”€â”€ tests/
â”‚   â”œâ”€â”€ test_ejercicio_1.py    â† 14 tests  (EP + BVA)
â”‚   â”œâ”€â”€ test_ejercicio_2.py    â† 16 tests  (Branch Coverage)
â”‚   â”œâ”€â”€ test_ejercicio_3.py    â†  5 tests  (Mutation Testing)
â”‚   â””â”€â”€ test_ejercicio_4.py    â†  3 tests  (Property-Based Testing)
â”œâ”€â”€ requirements.txt
â”œâ”€â”€ pytest.ini
â”œâ”€â”€ conftest.py
â”œâ”€â”€ QUICK_START.py
â””â”€â”€ README.md
```

---

## InstalaciÃ³n

### 1. Verificar Python
```powershell
python --version
# Python 3.8+
```

### 2. Instalar dependencias
```powershell
cd C:\Repositorio\Universitaria_de_colombia\python
pip install -r requirements.txt
```

**Paquetes:**
- `pytest==7.4.3` â€” Framework de testing
- `pytest-cov==4.1.0` â€” Reporte de cobertura
- `hypothesis==6.92.2` â€” Property-Based Testing
- `pytest-mock==3.12.0` â€” Mocking

---

## EjecuciÃ³n de Tests

### Todos los tests
```powershell
pytest
```

### Por ejercicio con cobertura individual
```powershell
# Ejercicio 1
pytest tests/test_ejercicio_1.py --cov=src.ejercicio_1 --cov-report=term-missing -v

# Ejercicio 2
pytest tests/test_ejercicio_2.py --cov=src.ejercicio_2 --cov-report=term-missing -v

# Ejercicio 3
pytest tests/test_ejercicio_3.py --cov=src.ejercicio_3 --cov-report=term-missing -v

# Ejercicio 4
pytest tests/test_ejercicio_4.py --cov=src.ejercicio_4 --cov-report=term-missing -v
```

### Cobertura completa con reporte HTML
```powershell
pytest --cov=src --cov-report=html
Start-Process "htmlcov\index.html"
```

---

## DescripciÃ³n de Ejercicios

### Ejercicio 1 â€” Clases de Equivalencia y BVA

**FunciÃ³n:** `calcular_descuento(edad, es_estudiante)`

| ID | CondiciÃ³n | Resultado |
|----|-----------|-----------|
| C1 | edad < 0 | ERROR |
| C2 | edad > 120 | ERROR |
| C3 | 0 â‰¤ edad < 18 AND estudiante | 10% |
| C4 | 0 â‰¤ edad < 18 AND NO estudiante | 0% |
| C5 | 18 â‰¤ edad < 60 AND estudiante | 15% |
| C6 | 18 â‰¤ edad < 60 AND NO estudiante | 0% |
| C7 | edad â‰¥ 60 | 25% |

**Valores lÃ­mite (BVA fuerte):** `-1, 0, 17, 18, 59, 60, 120, 121`

---

### Ejercicio 2 â€” Branch Coverage 100%

**FunciÃ³n:** `validar_matricula(estudiante)`

| Rama | CondiciÃ³n | Retorna |
|------|-----------|---------|
| R1 | `not estudiante` (None o {}) | `DATOS_VACIOS` |
| R2 | `estado == 'INACTIVO'` | `ESTUDIANTE_INACTIVO` |
| R3 | `deuda > 0` | `TIENE_DEUDA` |
| R4 | `creditos < 0 or creditos > 24` | `CREDITOS_INVALIDOS` |
| R5=True | `promedio >= 3.0` | `HABILITADO` |
| R5=False | `promedio < 3.0` | `CONDICIONAL` |

---

### Ejercicio 3 â€” Mutation Testing

**FunciÃ³n:** `promedio_ponderado(notas, pesos)`

| Mutante | Operador | Original | Mutado | Test que lo mata |
|---------|----------|----------|--------|-----------------|
| M1/M2 | ROR | `!=` | `>` / `<` | `test_longitudes_diferentes` |
| M3 | ROR | `<= 0` | `< 0` | `test_pesos_negativos_o_cero` |
| M4 | AOR | `*` | `+` | `test_pesos_diferentes` |
| M5 | AOR | `/` | `*` | `test_division_real` |
| M6 | â€” | correcto | fijo | `test_promedio_simple` |

**Score: 6/6 mutantes eliminados (100%)**

---

### Ejercicio 4 â€” Property-Based Testing con Hypothesis

**Funciones:** `revertir(s)`, `es_palindromo(s)`, `concatenar_lista(palabras, separador)`

| Propiedad | DescripciÃ³n |
|-----------|-------------|
| Involutiva | `revertir(revertir(s)) == s` para todo texto |
| Palindromo | `s + revertir(s)` siempre es palÃ­ndromo |
| Reversible | `split(concatenar(palabras, sep), sep) == palabras` |

Hypothesis genera ~100 ejemplos aleatorios por propiedad.

---

## Resumen

```
tests/test_ejercicio_1.py    14 passed   src/ejercicio_1.py   100%
tests/test_ejercicio_2.py    16 passed   src/ejercicio_2.py   100%
tests/test_ejercicio_3.py     5 passed   src/ejercicio_3.py   100%
tests/test_ejercicio_4.py     3 passed   src/ejercicio_4.py   100%
â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
TOTAL                        38 passed                        100%
```

| Ejercicio | TÃ©cnica | Herramienta |
|-----------|---------|-------------|
| 1 | Equivalence Partitioning + BVA | pytest.mark.parametrize |
| 2 | Branch Coverage 100% | pytest + pytest-cov |
| 3 | Mutation Testing | pytest (diseÃ±o manual) |
| 4 | Property-Based Testing | Hypothesis (@given) |

---

**Ãšltima actualizaciÃ³n:** 21 de abril de 2026

