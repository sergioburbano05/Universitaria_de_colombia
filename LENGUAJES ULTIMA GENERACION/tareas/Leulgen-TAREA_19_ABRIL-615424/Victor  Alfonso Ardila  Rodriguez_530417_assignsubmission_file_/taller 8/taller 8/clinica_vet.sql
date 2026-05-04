-- ================================================
-- TALLER SESION 8 - BD: clinica_vet  (E7)
-- ================================================

CREATE DATABASE IF NOT EXISTS clinica_vet
  CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE clinica_vet;

-- ------------------------------------------------
-- TABLAS (en orden por dependencias)
-- ------------------------------------------------

CREATE TABLE especie (
  id_especie INT AUTO_INCREMENT PRIMARY KEY,
  nombre     VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE dueno (
  id_dueno INT AUTO_INCREMENT PRIMARY KEY,
  nombre   VARCHAR(80)  NOT NULL,
  apellido VARCHAR(80)  NOT NULL,
  email    VARCHAR(120) UNIQUE,
  ciudad   VARCHAR(80)
) ENGINE=InnoDB;

-- Atributo multivaluado: telefonos del dueno
CREATE TABLE tel_dueno (
  id_tel   INT AUTO_INCREMENT PRIMARY KEY,
  id_dueno INT NOT NULL,
  numero   VARCHAR(20) NOT NULL,
  FOREIGN KEY (id_dueno) REFERENCES dueno(id_dueno) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE mascota (
  id_mascota INT AUTO_INCREMENT PRIMARY KEY,
  nombre     VARCHAR(80) NOT NULL,
  raza       VARCHAR(80),
  fecha_nac  DATE,
  id_especie INT NOT NULL,
  id_dueno   INT NOT NULL,
  FOREIGN KEY (id_especie) REFERENCES especie(id_especie) ON DELETE RESTRICT,
  FOREIGN KEY (id_dueno)   REFERENCES dueno(id_dueno)     ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Atributo multivaluado: condiciones medicas de la mascota
CREATE TABLE condicion_medica (
  id_condicion INT AUTO_INCREMENT PRIMARY KEY,
  id_mascota   INT NOT NULL,
  descripcion  VARCHAR(200) NOT NULL,
  FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE veterinario (
  id_veterinario INT AUTO_INCREMENT PRIMARY KEY,
  nombre         VARCHAR(80) NOT NULL,
  apellido       VARCHAR(80) NOT NULL,
  especialidad   VARCHAR(80),
  activo         TINYINT(1)  DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE medicamento (
  id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
  nombre         VARCHAR(100) NOT NULL,
  stock          INT NOT NULL DEFAULT 0,
  CONSTRAINT ck_stock CHECK (stock >= 0)
) ENGINE=InnoDB;

CREATE TABLE consulta (
  id_consulta    INT AUTO_INCREMENT PRIMARY KEY,
  fecha          DATE NOT NULL DEFAULT (CURRENT_DATE),
  diagnostico    TEXT,
  id_mascota     INT NOT NULL,
  id_veterinario INT NOT NULL,
  FOREIGN KEY (id_mascota)     REFERENCES mascota(id_mascota)         ON DELETE RESTRICT,
  FOREIGN KEY (id_veterinario) REFERENCES veterinario(id_veterinario) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE tratamiento (
  id_tratamiento INT AUTO_INCREMENT PRIMARY KEY,
  id_consulta    INT NOT NULL,
  id_medicamento INT NOT NULL,
  dosis          VARCHAR(80),
  cantidad       INT NOT NULL DEFAULT 1,
  FOREIGN KEY (id_consulta)    REFERENCES consulta(id_consulta)       ON DELETE CASCADE,
  FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ------------------------------------------------
-- DATOS DE PRUEBA
-- ------------------------------------------------

INSERT INTO especie (nombre) VALUES
  ('Perro'), ('Gato'), ('Ave');

INSERT INTO veterinario (nombre, apellido, especialidad) VALUES
  ('Carlos',  'Mendoza', 'Cirugia'),
  ('Laura',   'Rios',    'Medicina General');

INSERT INTO dueno (nombre, apellido, email, ciudad) VALUES
  ('Andrea',   'Gomez', 'andrea@mail.co',   'Bogota'),
  ('Roberto',  'Silva', 'roberto@mail.co',  'Cali'),
  ('Patricia', 'Luna',  'patricia@mail.co', 'Medellin');

INSERT INTO tel_dueno (id_dueno, numero) VALUES
  (1,'310-1111'), (1,'315-2222'),
  (2,'320-3333'),
  (3,'330-4444');

INSERT INTO mascota (nombre, raza, id_especie, id_dueno) VALUES
  ('Max',   'Labrador', 1, 1),
  ('Luna',  'Siames',   2, 1),
  ('Rocky', 'Bulldog',  1, 2),
  ('Pico',  'Canario',  3, 3);

INSERT INTO condicion_medica (id_mascota, descripcion) VALUES
  (1, 'Alergia al polen'),
  (3, 'Displasia de cadera'),
  (3, 'Sobrepeso');

INSERT INTO medicamento (nombre, stock) VALUES
  ('Amoxicilina',    50),
  ('Ibuprofeno',     30),
  ('Vitamina C',    100),
  ('Antiparasitario',60);

INSERT INTO consulta (fecha, diagnostico, id_mascota, id_veterinario) VALUES
  ('2025-03-01', 'Infeccion leve',     1, 1),
  ('2025-03-05', 'Control rutinario',  2, 2),
  ('2025-03-10', 'Fractura pata',      3, 1),
  ('2025-03-15', 'Revision general',   4, 2),
  ('2025-03-20', 'Alergia estacional', 1, 2);

INSERT INTO tratamiento (id_consulta, id_medicamento, dosis, cantidad) VALUES
  (1, 1, '10mg/kg',      2),
  (1, 3, '1 tableta',    1),
  (2, 4, 'Dosis unica',  1),
  (3, 1, '15mg/kg',      3),
  (3, 2, '5mg cada 8h',  6),
  (4, 3, '1 tableta',    2),
  (5, 2, '5mg cada 12h', 4);

-- ------------------------------------------------
-- CONSULTAS SELECT (E7 - Paso 4)
-- ------------------------------------------------

SELECT
    m.nombre                        AS mascota,
    e.nombre                        AS especie,
    m.raza,
    CONCAT(d.nombre,' ',d.apellido) AS dueno,
    d.ciudad
FROM mascota m
    INNER JOIN especie e ON m.id_especie = e.id_especie
    INNER JOIN dueno d   ON m.id_dueno   = d.id_dueno
WHERE d.id_dueno = 1;

-- SELECT b) Veterinario con mas consultas
SELECT
    CONCAT(v.nombre,' ',v.apellido) AS veterinario,
    v.especialidad,
    COUNT(c.id_consulta)            AS total_consultas
FROM veterinario v
    INNER JOIN consulta c ON v.id_veterinario = c.id_veterinario
GROUP BY v.id_veterinario, v.nombre, v.apellido, v.especialidad
ORDER BY total_consultas DESC
LIMIT 1;

-- SELECT c) Medicamentos usados en el ultimo mes
SELECT DISTINCT
    med.nombre      AS medicamento,
    t.dosis,
    t.cantidad,
    c.fecha         AS fecha_consulta
FROM tratamiento t
    INNER JOIN medicamento med ON t.id_medicamento = med.id_medicamento
    INNER JOIN consulta c      ON t.id_consulta    = c.id_consulta
WHERE c.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
ORDER BY c.fecha DESC;

-- ------------------------------------------------
-- TRANSACCION: Nueva consulta + tratamiento + descuento inventario
-- ------------------------------------------------

START TRANSACTION;

  -- 1. Nueva consulta
  INSERT INTO consulta (fecha, diagnostico, id_mascota, id_veterinario)
  VALUES (CURDATE(), 'Chequeo post-operatorio', 3, 1);

  SET @nueva_consulta = LAST_INSERT_ID();

  -- 2. Tratamiento asociado
  INSERT INTO tratamiento (id_consulta, id_medicamento, dosis, cantidad)
  VALUES (@nueva_consulta, 1, '10mg/kg', 2);

  -- 3. Descontar del inventario
  UPDATE medicamento
  SET stock = stock - 2
  WHERE id_medicamento = 1;

  -- El CHECK constraint (stock >= 0) evita que quede negativo.
  -- Si stock < 0 → error automatico → hace ROLLBACK implicito.

COMMIT;

-- ------------------------------------------------
-- VERIFICACION FINAL: ver stock actualizado
-- ------------------------------------------------
SELECT id_medicamento, nombre, stock FROM medicamento;
