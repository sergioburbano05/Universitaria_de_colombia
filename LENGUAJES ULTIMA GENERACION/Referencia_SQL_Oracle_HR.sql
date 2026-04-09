-- ============================================================
--   REFERENCIA COMPLETA DE SQL EN ORACLE
--   Esquema HR (Human Resources) - freesql.com / Oracle LiveSQL
-- ============================================================
-- Tablas disponibles en el esquema HR:
--   REGIONS       : REGION_ID, REGION_NAME
--   COUNTRIES     : COUNTRY_ID, COUNTRY_NAME, REGION_ID
--   LOCATIONS     : LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID
--   DEPARTMENTS   : DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID
--   JOBS          : JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY
--   EMPLOYEES     : EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER,
--                   HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
--   JOB_HISTORY   : EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID
-- ============================================================


-- ============================================================
-- 1. SELECT BASICO
-- ============================================================
-- Uso: Recuperar columnas de una tabla.
-- Cuándo: Siempre que necesites consultar datos.

-- Seleccionar todas las columnas
SELECT * FROM HR.EMPLOYEES;

-- Seleccionar columnas específicas
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM   HR.EMPLOYEES;

-- Alias de columnas
SELECT FIRST_NAME || ' ' || LAST_NAME AS NOMBRE_COMPLETO,
       SALARY                          AS SALARIO
FROM   HR.EMPLOYEES;

-- Alias de tabla
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, d.DEPARTMENT_NAME
FROM   HR.EMPLOYEES   e,
       HR.DEPARTMENTS d
WHERE  e.DEPARTMENT_ID = d.DEPARTMENT_ID;


-- ============================================================
-- 2. WHERE  (Filtrado de filas)
-- ============================================================
-- Uso: Aplicar condiciones para filtrar resultados.
-- Cuándo: Cuando no quieres todas las filas de la tabla.

-- Comparación simple
SELECT FIRST_NAME, SALARY
FROM   HR.EMPLOYEES
WHERE  SALARY > 10000;

-- Múltiples condiciones con AND / OR
SELECT FIRST_NAME, SALARY, DEPARTMENT_ID
FROM   HR.EMPLOYEES
WHERE  SALARY > 5000
  AND  DEPARTMENT_ID = 50;

-- Rango con BETWEEN
SELECT FIRST_NAME, SALARY
FROM   HR.EMPLOYEES
WHERE  SALARY BETWEEN 6000 AND 10000;

-- Lista de valores con IN
SELECT FIRST_NAME, JOB_ID
FROM   HR.EMPLOYEES
WHERE  JOB_ID IN ('IT_PROG', 'SA_REP', 'FI_ACCOUNT');

-- Texto con LIKE  (% = cualquier secuencia, _ = un carácter)
SELECT FIRST_NAME, LAST_NAME
FROM   HR.EMPLOYEES
WHERE  LAST_NAME LIKE 'K%';        -- Apellidos que empiezan con K

-- Nulos con IS NULL / IS NOT NULL
SELECT FIRST_NAME, COMMISSION_PCT
FROM   HR.EMPLOYEES
WHERE  COMMISSION_PCT IS NOT NULL; -- Solo empleados con comisión


-- ============================================================
-- 3. ORDER BY  (Ordenamiento)
-- ============================================================
-- Uso: Ordenar el resultado de una consulta.
-- Cuándo: Cuando el orden de las filas importa (reportes, listados).

-- Orden ascendente (por defecto)
SELECT FIRST_NAME, SALARY
FROM   HR.EMPLOYEES
ORDER BY SALARY;

-- Orden descendente
SELECT FIRST_NAME, SALARY
FROM   HR.EMPLOYEES
ORDER BY SALARY DESC;

-- Múltiples columnas
SELECT DEPARTMENT_ID, LAST_NAME, SALARY
FROM   HR.EMPLOYEES
ORDER BY DEPARTMENT_ID ASC, SALARY DESC;

-- Ordenar por alias
SELECT FIRST_NAME || ' ' || LAST_NAME AS NOMBRE, SALARY
FROM   HR.EMPLOYEES
ORDER BY NOMBRE;


-- ============================================================
-- 4. FUNCIONES DE GRUPO / AGREGACIÓN
-- ============================================================
-- Uso: Calcular valores resumen sobre un conjunto de filas.
-- Cuándo: Totales, promedios, conteos, máximos, mínimos.

-- COUNT  – Contar filas
SELECT COUNT(*)                   AS TOTAL_EMPLEADOS
FROM   HR.EMPLOYEES;

SELECT COUNT(COMMISSION_PCT)      AS EMPLEADOS_CON_COMISION  -- Ignora NULLs
FROM   HR.EMPLOYEES;

-- SUM – Suma
SELECT SUM(SALARY)               AS MASA_SALARIAL
FROM   HR.EMPLOYEES;

-- AVG – Promedio
SELECT AVG(SALARY)               AS SALARIO_PROMEDIO
FROM   HR.EMPLOYEES;

-- MAX / MIN
SELECT MAX(SALARY) AS SALARIO_MAX,
       MIN(SALARY) AS SALARIO_MIN
FROM   HR.EMPLOYEES;

-- Combinar varias funciones
SELECT DEPARTMENT_ID,
       COUNT(*)         AS CANTIDAD,
       SUM(SALARY)      AS TOTAL_SALARIO,
       ROUND(AVG(SALARY),2) AS PROMEDIO,
       MAX(SALARY)      AS MAXIMO,
       MIN(SALARY)      AS MINIMO
FROM   HR.EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;


-- ============================================================
-- 5. GROUP BY y HAVING
-- ============================================================
-- Uso: Agrupar filas y filtrar grupos.
-- Cuándo:
--   GROUP BY : cuando usas funciones de agregación por categoría.
--   HAVING   : para filtrar GRUPOS (equivale al WHERE sobre grupos).

-- Salario promedio por departamento
SELECT DEPARTMENT_ID,
       ROUND(AVG(SALARY), 2) AS PROMEDIO
FROM   HR.EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- Solo departamentos con promedio > 8000
SELECT DEPARTMENT_ID,
       ROUND(AVG(SALARY), 2) AS PROMEDIO
FROM   HR.EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 8000
ORDER BY PROMEDIO DESC;

-- Cantidad de empleados por puesto, solo puestos con más de 2 empleados
SELECT JOB_ID, COUNT(*) AS CANTIDAD
FROM   HR.EMPLOYEES
GROUP BY JOB_ID
HAVING COUNT(*) > 2
ORDER BY CANTIDAD DESC;


-- ============================================================
-- 6. JOINS  (Combinación de tablas)
-- ============================================================
-- Uso: Combinar datos de múltiples tablas relacionadas.

-- ---------- INNER JOIN ----------
-- Devuelve solo filas con coincidencia en ambas tablas.
SELECT e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME
FROM   HR.EMPLOYEES   e
INNER JOIN HR.DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID;

-- ---------- LEFT OUTER JOIN ----------
-- Devuelve TODAS las filas de la tabla izquierda; NULLs si no hay coincidencia derecha.
SELECT e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME
FROM   HR.EMPLOYEES   e
LEFT OUTER JOIN HR.DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID;
-- Incluye empleados sin departamento asignado

-- ---------- RIGHT OUTER JOIN ----------
-- Devuelve TODAS las filas de la tabla derecha.
SELECT e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME
FROM   HR.EMPLOYEES   e
RIGHT OUTER JOIN HR.DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID;
-- Incluye departamentos sin empleados

-- ---------- FULL OUTER JOIN ----------
-- Devuelve todas las filas de ambas tablas.
SELECT e.FIRST_NAME, d.DEPARTMENT_NAME
FROM   HR.EMPLOYEES   e
FULL OUTER JOIN HR.DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID;

-- ---------- SELF JOIN ----------
-- Une la tabla consigo misma (p.ej.: empleado y su gerente).
SELECT e.FIRST_NAME   AS EMPLEADO,
       m.FIRST_NAME   AS GERENTE
FROM   HR.EMPLOYEES e
LEFT JOIN HR.EMPLOYEES m ON e.MANAGER_ID = m.EMPLOYEE_ID;

-- ---------- JOIN con múltiples tablas ----------
SELECT e.FIRST_NAME, e.LAST_NAME,
       d.DEPARTMENT_NAME,
       l.CITY,
       c.COUNTRY_NAME
FROM   HR.EMPLOYEES   e
JOIN   HR.DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN   HR.LOCATIONS   l ON d.LOCATION_ID   = l.LOCATION_ID
JOIN   HR.COUNTRIES   c ON l.COUNTRY_ID    = c.COUNTRY_ID;

-- ---------- CROSS JOIN (producto cartesiano) ----------
-- Cuándo: Para combinar cada fila de una tabla con cada fila de la otra.
SELECT r.REGION_NAME, c.COUNTRY_NAME
FROM   HR.REGIONS   r
CROSS JOIN HR.COUNTRIES c;


-- ============================================================
-- 7. SUBCONSULTAS (Subqueries)
-- ============================================================
-- Uso: Consulta anidada dentro de otra consulta.
-- Cuándo: Cuando el resultado de una consulta depende del resultado de otra.

-- Subconsulta en WHERE (escalar)
-- Empleados con salario mayor al promedio general
SELECT FIRST_NAME, SALARY
FROM   HR.EMPLOYEES
WHERE  SALARY > (SELECT AVG(SALARY) FROM HR.EMPLOYEES);

-- Subconsulta en WHERE con IN
-- Empleados en departamentos ubicados en Seattle
SELECT FIRST_NAME, DEPARTMENT_ID
FROM   HR.EMPLOYEES
WHERE  DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID
    FROM   HR.DEPARTMENTS
    WHERE  LOCATION_ID IN (
        SELECT LOCATION_ID
        FROM   HR.LOCATIONS
        WHERE  CITY = 'Seattle'
    )
);

-- Subconsulta en FROM (tabla derivada / inline view)
SELECT dept_stat.DEPARTMENT_ID,
       dept_stat.PROMEDIO
FROM   (
    SELECT DEPARTMENT_ID, AVG(SALARY) AS PROMEDIO
    FROM   HR.EMPLOYEES
    GROUP BY DEPARTMENT_ID
) dept_stat
WHERE  dept_stat.PROMEDIO > 9000;

-- Subconsulta correlacionada
-- Empleados cuyo salario es mayor al promedio de su propio departamento
SELECT e.FIRST_NAME, e.SALARY, e.DEPARTMENT_ID
FROM   HR.EMPLOYEES e
WHERE  e.SALARY > (
    SELECT AVG(e2.SALARY)
    FROM   HR.EMPLOYEES e2
    WHERE  e2.DEPARTMENT_ID = e.DEPARTMENT_ID
);

-- EXISTS / NOT EXISTS
-- Departamentos que tienen al menos un empleado
SELECT d.DEPARTMENT_NAME
FROM   HR.DEPARTMENTS d
WHERE  EXISTS (
    SELECT 1
    FROM   HR.EMPLOYEES e
    WHERE  e.DEPARTMENT_ID = d.DEPARTMENT_ID
);


-- ============================================================
-- 8. FUNCIONES DE CADENA (String Functions)
-- ============================================================
-- Uso: Manipular y transformar texto.

-- UPPER / LOWER / INITCAP
SELECT UPPER(FIRST_NAME)   AS EN_MAYUSCULA,
       LOWER(LAST_NAME)    AS EN_MINUSCULA,
       INITCAP(FIRST_NAME) AS PRIMER_LETRA_MAYUS
FROM   HR.EMPLOYEES;

-- LENGTH – Longitud de una cadena
SELECT FIRST_NAME, LENGTH(FIRST_NAME) AS LONGITUD
FROM   HR.EMPLOYEES;

-- SUBSTR(cadena, inicio, longitud)
SELECT SUBSTR(FIRST_NAME, 1, 3) AS ABREVIACION
FROM   HR.EMPLOYEES;

-- INSTR(cadena, subcadena) – Posición de una subcadena
SELECT EMAIL, INSTR(EMAIL, '@') AS POSICION_ARROBA
FROM   HR.EMPLOYEES;

-- REPLACE(cadena, buscar, reemplazar)
SELECT REPLACE(PHONE_NUMBER, '.', '-') AS TELEFONO_GUIONES
FROM   HR.EMPLOYEES;

-- TRIM / LTRIM / RTRIM – Eliminar espacios o caracteres
SELECT TRIM('  Hola Mundo  ') AS SIN_ESPACIOS FROM DUAL;

-- LPAD / RPAD – Rellenar cadena
SELECT LPAD(EMPLOYEE_ID, 5, '0') AS ID_FORMATEADO
FROM   HR.EMPLOYEES;

-- CONCAT / ||  – Concatenar
SELECT CONCAT(FIRST_NAME, ' ') || LAST_NAME AS NOMBRE_COMPLETO
FROM   HR.EMPLOYEES;

-- TO_CHAR – Convertir número/fecha a texto con formato
SELECT EMPLOYEE_ID,
       TO_CHAR(SALARY, '$999,999.00') AS SALARIO_FORMATO
FROM   HR.EMPLOYEES;


-- ============================================================
-- 9. FUNCIONES NUMÉRICAS
-- ============================================================

-- ROUND(número, decimales)
SELECT SALARY, ROUND(SALARY / 12, 2) AS SALARIO_MENSUAL
FROM   HR.EMPLOYEES;

-- TRUNC(número, decimales)  – Trunca sin redondear
SELECT TRUNC(SALARY / 12, 0) AS SALARIO_MENSUAL_TRUNCADO
FROM   HR.EMPLOYEES;

-- CEIL / FLOOR
SELECT CEIL(15.3)  AS TECHO   FROM DUAL;  -- 16
SELECT FLOOR(15.9) AS PISO    FROM DUAL;  -- 15

-- MOD(dividendo, divisor)
SELECT EMPLOYEE_ID,
       MOD(EMPLOYEE_ID, 2) AS ES_PAR_O_IMPAR  -- 0=par, 1=impar
FROM   HR.EMPLOYEES;

-- ABS – Valor absoluto
SELECT ABS(-500) AS VALOR_ABSOLUTO FROM DUAL;

-- POWER(base, exponente)
SELECT POWER(2, 10) AS DOS_A_LA_10 FROM DUAL;  -- 1024

-- SQRT – Raíz cuadrada
SELECT SQRT(MAX_SALARY) AS RAIZ_SALARIO_MAX
FROM   HR.JOBS;


-- ============================================================
-- 10. FUNCIONES DE FECHA
-- ============================================================

-- SYSDATE – Fecha y hora actuales del servidor
SELECT SYSDATE AS HOY FROM DUAL;

-- CURRENT_DATE – Fecha actual de sesión
SELECT CURRENT_DATE AS FECHA_SESION FROM DUAL;

-- ADD_MONTHS
SELECT FIRST_NAME,
       HIRE_DATE,
       ADD_MONTHS(HIRE_DATE, 6) AS FECHA_PRUEBA_SUPERADA
FROM   HR.EMPLOYEES;

-- MONTHS_BETWEEN – Meses entre dos fechas
SELECT FIRST_NAME,
       ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12, 1) AS ANIOS_EXPERIENCIA
FROM   HR.EMPLOYEES;

-- NEXT_DAY(fecha, dia_semana)
SELECT NEXT_DAY(SYSDATE, 'MONDAY') AS PROXIMO_LUNES FROM DUAL;

-- LAST_DAY – Último día del mes
SELECT LAST_DAY(SYSDATE) AS FIN_DE_MES FROM DUAL;

-- TO_DATE – Convertir texto a fecha
SELECT TO_DATE('2024-01-15', 'YYYY-MM-DD') AS FECHA_CONV FROM DUAL;

-- TO_CHAR – Fecha a texto con formato
SELECT FIRST_NAME,
       TO_CHAR(HIRE_DATE, 'DD/MM/YYYY')  AS CONTRATACION,
       TO_CHAR(HIRE_DATE, 'Month YYYY')  AS MES_ANIO
FROM   HR.EMPLOYEES;

-- EXTRACT – Extraer parte de una fecha
SELECT FIRST_NAME,
       EXTRACT(YEAR  FROM HIRE_DATE) AS ANIO,
       EXTRACT(MONTH FROM HIRE_DATE) AS MES,
       EXTRACT(DAY   FROM HIRE_DATE) AS DIA
FROM   HR.EMPLOYEES;

-- TRUNC(fecha, 'unidad')
SELECT TRUNC(SYSDATE, 'MONTH') AS INICIO_MES,
       TRUNC(SYSDATE, 'YEAR')  AS INICIO_ANIO
FROM   DUAL;


-- ============================================================
-- 11. FUNCIONES DE CONVERSIÓN Y MANEJO DE NULOS
-- ============================================================

-- NVL(valor, valor_si_nulo) – Sustituir NULL por un valor
SELECT FIRST_NAME,
       NVL(COMMISSION_PCT, 0) AS COMISION
FROM   HR.EMPLOYEES;

-- NVL2(valor, si_no_nulo, si_nulo)
SELECT FIRST_NAME,
       NVL2(COMMISSION_PCT,
            SALARY + (SALARY * COMMISSION_PCT),
            SALARY) AS SALARIO_TOTAL
FROM   HR.EMPLOYEES;

-- NULLIF(a, b) – Retorna NULL si a = b, de lo contrario retorna a
SELECT NULLIF(JOB_ID, 'SA_REP') AS JOB_SIN_SALES
FROM   HR.EMPLOYEES;

-- COALESCE – Primer valor no nulo de una lista
SELECT FIRST_NAME,
       COALESCE(COMMISSION_PCT, 0) AS COMISION_SEGURA
FROM   HR.EMPLOYEES;

-- TO_NUMBER – Convertir texto a número
SELECT TO_NUMBER('12345.67', '99999.99') AS NUMERO FROM DUAL;


-- ============================================================
-- 12. EXPRESIONES CONDICIONALES
-- ============================================================

-- CASE SEARCHED (buscado)
SELECT FIRST_NAME, SALARY,
       CASE
           WHEN SALARY < 5000  THEN 'BAJO'
           WHEN SALARY < 10000 THEN 'MEDIO'
           WHEN SALARY < 15000 THEN 'ALTO'
           ELSE                     'MUY ALTO'
       END AS RANGO_SALARIAL
FROM   HR.EMPLOYEES;

-- CASE SIMPLE
SELECT JOB_ID,
       CASE JOB_ID
           WHEN 'IT_PROG'    THEN 'Tecnología'
           WHEN 'SA_REP'     THEN 'Ventas'
           WHEN 'FI_ACCOUNT' THEN 'Finanzas'
           ELSE                   'Otro'
       END AS AREA
FROM   HR.EMPLOYEES;

-- DECODE (Oracle clásico, equivale a CASE simple)
SELECT JOB_ID,
       DECODE(JOB_ID,
              'IT_PROG',    'Tecnología',
              'SA_REP',     'Ventas',
              'FI_ACCOUNT', 'Finanzas',
                            'Otro') AS AREA
FROM   HR.EMPLOYEES;


-- ============================================================
-- 13. FUNCIONES ANALÍTICAS (Window Functions)
-- ============================================================
-- Uso: Calcular valores sobre una "ventana" de filas sin colapsar el resultado.
-- Cuándo: Rankings, acumulados, comparaciones con filas anteriores/siguientes.

-- ROW_NUMBER – Número de fila dentro de una partición
SELECT EMPLOYEE_ID, FIRST_NAME, DEPARTMENT_ID, SALARY,
       ROW_NUMBER() OVER (PARTITION BY DEPARTMENT_ID
                          ORDER BY SALARY DESC) AS RANKING_EN_DEPTO
FROM   HR.EMPLOYEES;

-- RANK – Rank con saltos (1,1,3...)
-- DENSE_RANK – Rank continuo (1,1,2...)
SELECT FIRST_NAME, DEPARTMENT_ID, SALARY,
       RANK()       OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS RANK,
       DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS DENSE_RANK
FROM   HR.EMPLOYEES;

-- SUM acumulado (running total)
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY,
       SUM(SALARY) OVER (ORDER BY EMPLOYEE_ID) AS SALARIO_ACUMULADO
FROM   HR.EMPLOYEES;

-- Promedio móvil por departamento
SELECT EMPLOYEE_ID, DEPARTMENT_ID, SALARY,
       ROUND(AVG(SALARY) OVER (PARTITION BY DEPARTMENT_ID), 2) AS PROMEDIO_DEPTO
FROM   HR.EMPLOYEES;

-- LAG / LEAD – Acceder a filas anteriores o siguientes
SELECT EMPLOYEE_ID, FIRST_NAME, HIRE_DATE,
       LAG(HIRE_DATE)  OVER (ORDER BY HIRE_DATE) AS CONTRATACION_ANTERIOR,
       LEAD(HIRE_DATE) OVER (ORDER BY HIRE_DATE) AS CONTRATACION_SIGUIENTE
FROM   HR.EMPLOYEES;

-- NTILE – Dividir en N grupos iguales (cuartiles, quintiles, etc.)
SELECT FIRST_NAME, SALARY,
       NTILE(4) OVER (ORDER BY SALARY) AS CUARTIL
FROM   HR.EMPLOYEES;

-- FIRST_VALUE / LAST_VALUE
SELECT FIRST_NAME, DEPARTMENT_ID, SALARY,
       FIRST_VALUE(SALARY) OVER (PARTITION BY DEPARTMENT_ID
                                  ORDER BY SALARY
                                  ROWS BETWEEN UNBOUNDED PRECEDING
                                           AND UNBOUNDED FOLLOWING) AS SALARIO_MINIMO_DEPTO,
       LAST_VALUE(SALARY)  OVER (PARTITION BY DEPARTMENT_ID
                                  ORDER BY SALARY
                                  ROWS BETWEEN UNBOUNDED PRECEDING
                                           AND UNBOUNDED FOLLOWING) AS SALARIO_MAXIMO_DEPTO
FROM   HR.EMPLOYEES;

-- Empleado con mayor salario por departamento (TOP 1 por grupo)
SELECT *
FROM (
    SELECT FIRST_NAME, DEPARTMENT_ID, SALARY,
           RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS RK
    FROM   HR.EMPLOYEES
)
WHERE RK = 1;


-- ============================================================
-- 14. WITH (Common Table Expressions - CTE)
-- ============================================================
-- Uso: Nombrar subconsultas para reutilizarlas y mejorar la legibilidad.
-- Cuándo: Consultas complejas con múltiples niveles o referencias repetidas.

WITH salario_depto AS (
    SELECT DEPARTMENT_ID,
           AVG(SALARY) AS PROMEDIO
    FROM   HR.EMPLOYEES
    GROUP BY DEPARTMENT_ID
),
depto_info AS (
    SELECT d.DEPARTMENT_ID, d.DEPARTMENT_NAME, s.PROMEDIO
    FROM   HR.DEPARTMENTS d
    JOIN   salario_depto  s ON d.DEPARTMENT_ID = s.DEPARTMENT_ID
)
SELECT DEPARTMENT_NAME,
       ROUND(PROMEDIO, 2) AS PROMEDIO_SALARIO
FROM   depto_info
WHERE  PROMEDIO > 8000
ORDER BY PROMEDIO DESC;


-- ============================================================
-- 15. SET OPERATIONS (Operaciones de conjuntos)
-- ============================================================
-- UNION    : Combina resultados eliminando duplicados.
-- UNION ALL: Combina resultados incluyendo duplicados (más rápido).
-- INTERSECT: Solo filas que aparecen en AMBAS consultas.
-- MINUS    : Filas de la primera consulta que NO están en la segunda (Oracle).

-- UNION: Empleados actuales + histórico de puestos
SELECT EMPLOYEE_ID, JOB_ID, DEPARTMENT_ID FROM HR.EMPLOYEES
UNION
SELECT EMPLOYEE_ID, JOB_ID, DEPARTMENT_ID FROM HR.JOB_HISTORY;

-- UNION ALL (con duplicados)
SELECT EMPLOYEE_ID FROM HR.EMPLOYEES
UNION ALL
SELECT EMPLOYEE_ID FROM HR.JOB_HISTORY;

-- INTERSECT: Empleados que TAMBIÉN aparecen en JOB_HISTORY
SELECT EMPLOYEE_ID FROM HR.EMPLOYEES
INTERSECT
SELECT EMPLOYEE_ID FROM HR.JOB_HISTORY;

-- MINUS: Empleados que NUNCA tuvieron historial de trabajo
SELECT EMPLOYEE_ID FROM HR.EMPLOYEES
MINUS
SELECT EMPLOYEE_ID FROM HR.JOB_HISTORY;


-- ============================================================
-- 16. DML – Manipulación de Datos
-- ============================================================
-- INSERT / UPDATE / DELETE / MERGE

-- INSERT de una fila
INSERT INTO HR.DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
VALUES (280, 'Marketing Digital', 1700);

-- INSERT con subconsulta
INSERT INTO HR.DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
SELECT 290, 'Innovacion' FROM DUAL;

-- UPDATE simple
UPDATE HR.EMPLOYEES
SET    SALARY = SALARY * 1.10
WHERE  DEPARTMENT_ID = 50;

-- UPDATE con subconsulta
UPDATE HR.EMPLOYEES
SET    JOB_ID = (SELECT JOB_ID FROM HR.JOBS WHERE JOB_TITLE = 'Programmer')
WHERE  EMPLOYEE_ID = 105;

-- DELETE con condición
DELETE FROM HR.DEPARTMENTS
WHERE  DEPARTMENT_ID = 280;

-- MERGE (UPSERT: INSERT si no existe, UPDATE si existe)
MERGE INTO HR.EMPLOYEES e
USING (SELECT 999 AS EID, 'Nuevo' AS FNAME FROM DUAL) src
ON (e.EMPLOYEE_ID = src.EID)
WHEN MATCHED THEN
    UPDATE SET e.FIRST_NAME = src.FNAME
WHEN NOT MATCHED THEN
    INSERT (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID, SALARY)
    VALUES (999, 'Nuevo', 'Empleado', 'NUEVOEMP', SYSDATE, 'IT_PROG', 5000);

-- COMMIT / ROLLBACK / SAVEPOINT
SAVEPOINT antes_de_cambios;
UPDATE HR.EMPLOYEES SET SALARY = SALARY + 500 WHERE DEPARTMENT_ID = 60;
-- Si algo sale mal:
ROLLBACK TO antes_de_cambios;
-- Si todo está bien:
COMMIT;


-- ============================================================
-- 17. DDL – Definición de Datos
-- ============================================================

-- CREATE TABLE
CREATE TABLE evaluaciones (
    eval_id      NUMBER(10)    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id  NUMBER(6)     NOT NULL,
    eval_date    DATE          DEFAULT SYSDATE,
    puntaje      NUMBER(3,1)   CHECK (puntaje BETWEEN 0 AND 10),
    comentario   VARCHAR2(500),
    CONSTRAINT fk_eval_emp FOREIGN KEY (employee_id)
        REFERENCES HR.EMPLOYEES(EMPLOYEE_ID)
);

-- ALTER TABLE – Agregar columna
ALTER TABLE evaluaciones ADD estado VARCHAR2(20) DEFAULT 'PENDIENTE';

-- ALTER TABLE – Modificar columna
ALTER TABLE evaluaciones MODIFY comentario VARCHAR2(1000);

-- ALTER TABLE – Renombrar columna
ALTER TABLE evaluaciones RENAME COLUMN comentario TO observaciones;

-- ALTER TABLE – Eliminar columna
ALTER TABLE evaluaciones DROP COLUMN estado;

-- CREATE INDEX
CREATE INDEX idx_eval_emp ON evaluaciones(employee_id);

-- DROP TABLE
DROP TABLE evaluaciones;

-- TRUNCATE TABLE (elimina filas sin ROLLBACK, más rápido que DELETE)
-- TRUNCATE TABLE evaluaciones;


-- ============================================================
-- 18. VISTAS (VIEWS)
-- ============================================================
-- Uso: Guardar una consulta como objeto de base de datos reutilizable.
-- Cuándo: Para simplificar consultas complejas o controlar el acceso a datos.

CREATE OR REPLACE VIEW v_empleados_depto AS
SELECT e.EMPLOYEE_ID,
       e.FIRST_NAME || ' ' || e.LAST_NAME AS NOMBRE_COMPLETO,
       e.SALARY,
       d.DEPARTMENT_NAME,
       l.CITY,
       j.JOB_TITLE
FROM   HR.EMPLOYEES   e
JOIN   HR.DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN   HR.LOCATIONS   l ON d.LOCATION_ID   = l.LOCATION_ID
JOIN   HR.JOBS        j ON e.JOB_ID        = j.JOB_ID;

-- Usar la vista como si fuera una tabla
SELECT * FROM v_empleados_depto WHERE CITY = 'Seattle';

-- Vista con CHECK OPTION (impide modificar datos fuera del filtro)
CREATE OR REPLACE VIEW v_emp_ventas AS
SELECT * FROM HR.EMPLOYEES
WHERE  JOB_ID LIKE 'SA%'
WITH   CHECK OPTION;


-- ============================================================
-- 19. SECUENCIAS (SEQUENCES)
-- ============================================================
-- Uso: Generar valores numéricos únicos y automáticos (IDs).
-- Cuándo: Para columnas de llave primaria.

CREATE SEQUENCE seq_evaluaciones
    START WITH  1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Obtener el siguiente valor
SELECT seq_evaluaciones.NEXTVAL FROM DUAL;

-- Obtener el valor actual (después de haber llamado NEXTVAL al menos una vez)
SELECT seq_evaluaciones.CURRVAL FROM DUAL;

-- Usar en INSERT
INSERT INTO evaluaciones (eval_id, employee_id, puntaje)
VALUES (seq_evaluaciones.NEXTVAL, 100, 9.5);


-- ============================================================
-- 20. PROCEDIMIENTOS ALMACENADOS Y FUNCIONES PL/SQL
-- ============================================================
-- Uso: Lógica de negocio encapsulada en la base de datos.

-- Procedimiento: Aumentar salario de un departamento
CREATE OR REPLACE PROCEDURE aumentar_salario (
    p_deptid    IN NUMBER,
    p_porcentaje IN NUMBER
)
IS
BEGIN
    UPDATE HR.EMPLOYEES
    SET    SALARY = SALARY * (1 + p_porcentaje / 100)
    WHERE  DEPARTMENT_ID = p_deptid;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Salarios actualizados para departamento ' || p_deptid);
END aumentar_salario;
/

-- Ejecutar el procedimiento
BEGIN
    aumentar_salario(50, 10);  -- Aumenta 10% al departamento 50
END;
/

-- Función: Calcular salario anual
CREATE OR REPLACE FUNCTION salario_anual (
    p_employee_id IN NUMBER
) RETURN NUMBER
IS
    v_salario NUMBER;
    v_comision NUMBER;
BEGIN
    SELECT SALARY, NVL(COMMISSION_PCT, 0)
    INTO   v_salario, v_comision
    FROM   HR.EMPLOYEES
    WHERE  EMPLOYEE_ID = p_employee_id;

    RETURN v_salario * 12 * (1 + v_comision);
END salario_anual;
/

-- Usar la función en una consulta
SELECT EMPLOYEE_ID, FIRST_NAME,
       salario_anual(EMPLOYEE_ID) AS SALARIO_ANUAL
FROM   HR.EMPLOYEES
WHERE  DEPARTMENT_ID = 90;


-- ============================================================
-- 21. CURSORES EN PL/SQL
-- ============================================================
-- Uso: Recorrer fila a fila el resultado de una consulta.

DECLARE
    CURSOR c_empleados IS
        SELECT EMPLOYEE_ID, FIRST_NAME, SALARY
        FROM   HR.EMPLOYEES
        WHERE  DEPARTMENT_ID = 80
        ORDER BY SALARY DESC;

    v_emp c_empleados%ROWTYPE;
BEGIN
    OPEN c_empleados;
    LOOP
        FETCH c_empleados INTO v_emp;
        EXIT WHEN c_empleados%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            v_emp.FIRST_NAME || ' -> $' || v_emp.SALARY
        );
    END LOOP;
    CLOSE c_empleados;
END;
/

-- Cursor FOR (más conciso, cierre automático)
BEGIN
    FOR rec IN (SELECT FIRST_NAME, SALARY FROM HR.EMPLOYEES WHERE ROWNUM <= 5) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.FIRST_NAME || ': ' || rec.SALARY);
    END LOOP;
END;
/


-- ============================================================
-- 22. TRIGGERS
-- ============================================================
-- Uso: Ejecutar código automáticamente ante eventos DML o DDL.
-- Cuándo: Auditoría, validaciones, acciones automáticas.

-- Trigger BEFORE INSERT: asignar fecha de creación
CREATE OR REPLACE TRIGGER trg_evaluacion_fecha
BEFORE INSERT ON evaluaciones
FOR EACH ROW
BEGIN
    :NEW.eval_date := SYSDATE;
END;
/

-- Trigger de auditoría sobre cambio de salario
CREATE TABLE auditoria_salarios (
    audit_id      NUMBER GENERATED ALWAYS AS IDENTITY,
    employee_id   NUMBER,
    salario_ant   NUMBER,
    salario_nuevo NUMBER,
    fecha_cambio  DATE DEFAULT SYSDATE,
    usuario       VARCHAR2(50)
);

CREATE OR REPLACE TRIGGER trg_auditoria_salario
AFTER UPDATE OF SALARY ON HR.EMPLOYEES
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_salarios
        (employee_id, salario_ant, salario_nuevo, usuario)
    VALUES
        (:OLD.EMPLOYEE_ID, :OLD.SALARY, :NEW.SALARY, USER);
END;
/


-- ============================================================
-- 23. ROWNUM, FETCH FIRST y OFFSET (Paginación)
-- ============================================================

-- ROWNUM (Oracle clásico) – Los 5 empleados mejor pagados
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY
FROM (
    SELECT EMPLOYEE_ID, FIRST_NAME, SALARY
    FROM   HR.EMPLOYEES
    ORDER BY SALARY DESC
)
WHERE ROWNUM <= 5;

-- FETCH FIRST (Oracle 12c+, ANSI estándar) – Más limpio
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY
FROM   HR.EMPLOYEES
ORDER BY SALARY DESC
FETCH FIRST 5 ROWS ONLY;

-- OFFSET + FETCH (paginación)
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY
FROM   HR.EMPLOYEES
ORDER BY EMPLOYEE_ID
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;  -- Página 3 (filas 11-15)

-- PERCENT (Oracle 12c+)
SELECT FIRST_NAME, SALARY
FROM   HR.EMPLOYEES
ORDER BY SALARY DESC
FETCH FIRST 10 PERCENT ROWS ONLY;


-- ============================================================
-- 24. EXPRESIONES REGULARES (REGEXP)
-- ============================================================
-- Uso: Búsquedas y validaciones de patrones complejos en texto.

-- REGEXP_LIKE – Filtrar con expresión regular
SELECT FIRST_NAME, PHONE_NUMBER
FROM   HR.EMPLOYEES
WHERE  REGEXP_LIKE(PHONE_NUMBER, '^\d{3}\.\d{3}\.\d{4}$');

-- REGEXP_SUBSTR – Extraer parte de una cadena
SELECT EMAIL,
       REGEXP_SUBSTR(EMAIL, '[^@]+', 1, 1) AS USUARIO_EMAIL
FROM   HR.EMPLOYEES;

-- REGEXP_REPLACE – Reemplazar con patrón
SELECT PHONE_NUMBER,
       REGEXP_REPLACE(PHONE_NUMBER, '[^\d]', '') AS SOLO_NUMEROS
FROM   HR.EMPLOYEES;

-- REGEXP_COUNT – Contar ocurrencias de un patrón
SELECT FIRST_NAME,
       REGEXP_COUNT(FIRST_NAME, '[aeiouAEIOU]') AS VOCALES
FROM   HR.EMPLOYEES;


-- ============================================================
-- 25. CONSULTAS JERÁRQUICAS (CONNECT BY)
-- ============================================================
-- Uso: Recorrer estructuras de árbol (org. chart, categorías).
-- Cuándo: Relaciones padre-hijo en la misma tabla.

-- Jerarquía de empleados (organigrama)
SELECT LEVEL,
       LPAD(' ', (LEVEL-1)*4) || FIRST_NAME AS EMPLEADO,
       EMPLOYEE_ID,
       MANAGER_ID,
       JOB_ID
FROM   HR.EMPLOYEES
START WITH MANAGER_ID IS NULL       -- Raíz: el CEO (sin gerente)
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
ORDER SIBLINGS BY LAST_NAME;

-- SYS_CONNECT_BY_PATH – Ruta completa desde la raíz
SELECT SYS_CONNECT_BY_PATH(FIRST_NAME, '/') AS RUTA
FROM   HR.EMPLOYEES
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID;


-- ============================================================
-- RESUMEN RÁPIDO DE FUNCIONES
-- ============================================================
/*
┌──────────────────────────┬─────────────────────────────────────────────────────────────┐
│ FUNCIÓN / CLÁUSULA       │ DESCRIPCIÓN Y CUÁNDO USARLA                                 │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ SELECT ... FROM          │ Base de toda consulta. Siempre.                              │
│ WHERE                    │ Filtrar filas antes de agrupar.                              │
│ GROUP BY                 │ Agrupar filas para funciones de agregación.                  │
│ HAVING                   │ Filtrar grupos (después de GROUP BY).                        │
│ ORDER BY                 │ Ordenar resultado final. ASC/DESC.                           │
│ DISTINCT                 │ Eliminar filas duplicadas en el resultado.                   │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ COUNT/SUM/AVG/MAX/MIN    │ Agregación numérica sobre grupos de filas.                   │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ INNER JOIN               │ Solo filas con coincidencia en ambas tablas.                 │
│ LEFT/RIGHT OUTER JOIN    │ Incluir filas sin coincidencia del lado izq/der.             │
│ FULL OUTER JOIN          │ Todas las filas de ambas tablas.                             │
│ SELF JOIN                │ Tabla unida consigo misma (jerarquías).                      │
│ CROSS JOIN               │ Producto cartesiano (todas las combinaciones posibles).      │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ NVL / NVL2               │ Reemplazar NULL por un valor por defecto.                    │
│ COALESCE                 │ Primer valor no nulo de una lista de expresiones.            │
│ NULLIF                   │ Devuelve NULL si dos valores son iguales.                    │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ UPPER/LOWER/INITCAP      │ Cambiar capitalización de texto.                             │
│ LENGTH / SUBSTR / INSTR  │ Longitud, subcadena, posición en texto.                     │
│ REPLACE / TRIM           │ Reemplazar o limpiar texto.                                  │
│ LPAD / RPAD              │ Rellenar texto por izquierda o derecha.                      │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ ROUND / TRUNC            │ Redondear / truncar decimales.                               │
│ CEIL / FLOOR             │ Redondear siempre hacia arriba / abajo.                      │
│ MOD / ABS / POWER / SQRT │ Operaciones matemáticas diversas.                            │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ SYSDATE / CURRENT_DATE   │ Fecha/hora actual del servidor / sesión.                     │
│ ADD_MONTHS               │ Sumar meses a una fecha.                                     │
│ MONTHS_BETWEEN           │ Diferencia en meses entre dos fechas.                        │
│ LAST_DAY / NEXT_DAY      │ Último día del mes / próximo día de la semana.               │
│ TO_DATE / TO_CHAR        │ Convertir entre texto y fecha con formato.                   │
│ EXTRACT                  │ Extraer año, mes, día de una fecha.                          │
│ TRUNC(fecha, unidad)     │ Truncar fecha al inicio del día, mes o año.                  │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ CASE / DECODE            │ Lógica condicional dentro de una consulta.                   │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ ROW_NUMBER / RANK        │ Numerar/rankear filas dentro de particiones.                  │
│ DENSE_RANK               │ Rank sin saltos (1,1,2 en lugar de 1,1,3).                  │
│ LAG / LEAD               │ Acceder a filas anteriores o siguientes.                     │
│ SUM/AVG OVER(...)        │ Acumulados o promedios móviles sin colapsar filas.            │
│ NTILE                    │ Dividir conjunto en N grupos iguales (cuartiles, etc.).       │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ WITH (CTE)               │ Subconsultas nombradas y reutilizables.                      │
│ UNION / UNION ALL        │ Combinar resultados de dos consultas.                        │
│ INTERSECT / MINUS        │ Intersección / diferencia entre conjuntos de resultados.     │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ ROWNUM / FETCH FIRST     │ Limitar el número de filas devueltas (paginación).            │
│ OFFSET...FETCH NEXT      │ Paginación por rango de filas (Oracle 12c+).                 │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ REGEXP_LIKE/SUBSTR       │ Búsqueda con expresiones regulares.                          │
│ CONNECT BY               │ Consultas jerárquicas (árbol padre-hijo).                    │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ INSERT / UPDATE / DELETE │ Agregar, modificar, eliminar datos (DML).                    │
│ MERGE                    │ Upsert: INSERT si no existe, UPDATE si existe.               │
│ COMMIT / ROLLBACK        │ Confirmar o deshacer transacciones.                          │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ CREATE/ALTER/DROP TABLE  │ Gestionar estructura de tablas (DDL).                        │
│ CREATE VIEW              │ Guardar consulta como objeto reutilizable.                   │
│ CREATE SEQUENCE          │ Generar IDs autonuméricos.                                   │
│ CREATE INDEX             │ Acelerar búsquedas en columnas frecuentemente consultadas.   │
├──────────────────────────┼─────────────────────────────────────────────────────────────┤
│ CREATE PROCEDURE         │ Bloque PL/SQL reutilizable sin retorno.                      │
│ CREATE FUNCTION          │ Bloque PL/SQL que retorna un valor.                          │
│ TRIGGER                  │ Código auto-ejecutado ante eventos DML/DDL.                  │
│ CURSOR                   │ Recorrer fila a fila el resultado de una consulta.           │
└──────────────────────────┴─────────────────────────────────────────────────────────────┘
*/
