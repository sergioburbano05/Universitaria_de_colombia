-- ================================================
-- TALLER SESION 8 - BD: eventos_s8
-- ================================================

CREATE DATABASE IF NOT EXISTS eventos_s8
  CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE eventos_s8;

-- ------------------------------------------------
-- TABLAS (en orden por dependencias)
-- ------------------------------------------------

CREATE TABLE sede (
  id_sede  INT AUTO_INCREMENT PRIMARY KEY,
  nombre   VARCHAR(100) NOT NULL,
  ciudad   VARCHAR(80)  NOT NULL
) ENGINE=InnoDB;

CREATE TABLE evento (
  id_evento INT AUTO_INCREMENT PRIMARY KEY,
  nombre    VARCHAR(120) NOT NULL,
  fecha     DATE         NOT NULL,
  cupo_max  INT          NOT NULL,
  id_sede   INT          NOT NULL,
  CONSTRAINT ck_cupo    CHECK (cupo_max > 0),
  CONSTRAINT fk_ev_sede FOREIGN KEY (id_sede)
    REFERENCES sede(id_sede) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE asistente (
  id_asistente INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(100) NOT NULL,
  email        VARCHAR(120) NOT NULL UNIQUE,
  CONSTRAINT ck_email CHECK (email LIKE '%@%.%')
) ENGINE=InnoDB;

-- Atributo multivaluado telefonos (Regla R4)
CREATE TABLE tel_asistente (
  id_tel       INT AUTO_INCREMENT PRIMARY KEY,
  id_asistente INT NOT NULL,
  numero       VARCHAR(20) NOT NULL,
  CONSTRAINT fk_tel_asis FOREIGN KEY (id_asistente)
    REFERENCES asistente(id_asistente) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Relacion N:M ASISTENTE inscribe EVENTO (Regla R6)
CREATE TABLE inscripcion_evento (
  id_inscripcion    INT AUTO_INCREMENT PRIMARY KEY,
  id_asistente      INT  NOT NULL,
  id_evento         INT  NOT NULL,
  fecha_inscripcion DATE NOT NULL DEFAULT (CURRENT_DATE),
  estado ENUM('pendiente','confirmada','cancelada') DEFAULT 'pendiente',
  CONSTRAINT fk_insc_asis FOREIGN KEY (id_asistente)
    REFERENCES asistente(id_asistente) ON DELETE RESTRICT,
  CONSTRAINT fk_insc_ev   FOREIGN KEY (id_evento)
    REFERENCES evento(id_evento) ON DELETE RESTRICT,
  CONSTRAINT uq_asis_ev   UNIQUE (id_asistente, id_evento)
) ENGINE=InnoDB;

-- ------------------------------------------------
-- DATOS DE PRUEBA
-- ------------------------------------------------

-- 3 sedes en diferentes ciudades
INSERT INTO sede (nombre, ciudad) VALUES
  ('Centro de Convenciones Agora', 'Bogota'),
  ('Plaza Mayor',                  'Medellin'),
  ('Palacio de los Deportes',      'Cali');

-- 5 eventos distribuidos en las sedes
INSERT INTO evento (nombre, fecha, cupo_max, id_sede) VALUES
  ('Congreso de Sistemas 2025',  '2025-06-10', 200, 1),
  ('Feria del Emprendimiento',   '2025-07-15', 150, 2),
  ('Tech Summit Colombia',       '2025-08-20', 300, 1),
  ('Festival de IA',             '2025-09-05',  50, 3),
  ('Hackathon Nacional',         '2025-10-01', 100, 2);

-- 6 asistentes con emails unicos
INSERT INTO asistente (nombre, email) VALUES
  ('Juan Perez',     'juan@correo.co'),
  ('Maria Lopez',    'maria@correo.co'),
  ('Carlos Ruiz',    'carlos@correo.co'),
  ('Ana Torres',     'ana@correo.co'),
  ('Sofia Martinez', 'sofia@correo.co'),
  ('Luis Gomez',     'luis@correo.co');

-- Telefonos de asistentes
INSERT INTO tel_asistente (id_asistente, numero) VALUES
  (1,'310-1111'),(1,'315-2222'),
  (2,'320-3333'),
  (3,'330-4444'),
  (4,'340-5555');

-- 8 inscripciones (algunos en varios eventos)
INSERT INTO inscripcion_evento (id_asistente, id_evento, estado) VALUES
  (1, 1, 'confirmada'),
  (1, 2, 'confirmada'),
  (2, 1, 'confirmada'),
  (2, 3, 'pendiente'),
  (3, 2, 'confirmada'),
  (4, 4, 'confirmada'),
  (5, 1, 'cancelada'),
  (6, 5, 'confirmada');

-- ------------------------------------------------
-- CONSULTAS SELECT (E5)
-- Ejecuta cada una por separado y toma captura
-- ------------------------------------------------

-- Consulta a) Todos los eventos con sede, ordenados por fecha ASC
SELECT
    e.nombre       AS evento,
    e.fecha,
    s.nombre       AS sede,
    s.ciudad
FROM evento e
    INNER JOIN sede s ON e.id_sede = s.id_sede
ORDER BY e.fecha ASC;

-- Consulta b) Asistentes inscritos en mas de 1 evento
SELECT
    a.nombre                AS asistente,
    COUNT(ie.id_evento)     AS total_eventos
FROM asistente a
    INNER JOIN inscripcion_evento ie ON a.id_asistente = ie.id_asistente
WHERE ie.estado != 'cancelada'
GROUP BY a.id_asistente, a.nombre
HAVING total_eventos > 1
ORDER BY total_eventos DESC;

-- Consulta c) Eventos con aforo disponible
SELECT
    e.nombre                                        AS evento,
    e.cupo_max,
    COUNT(ie.id_inscripcion)                        AS inscritos_activos,
    (e.cupo_max - COUNT(ie.id_inscripcion))         AS aforo_disponible
FROM evento e
    LEFT JOIN inscripcion_evento ie
        ON e.id_evento = ie.id_evento
        AND ie.estado != 'cancelada'
GROUP BY e.id_evento, e.nombre, e.cupo_max
HAVING aforo_disponible > 0
ORDER BY aforo_disponible ASC;

-- Consulta d) Asistentes que NUNCA se inscribieron (LEFT JOIN + IS NULL)
SELECT
    a.nombre,
    a.email
FROM asistente a
    LEFT JOIN inscripcion_evento ie ON a.id_asistente = ie.id_asistente
WHERE ie.id_inscripcion IS NULL;

-- ------------------------------------------------
-- DCL: USUARIO Y PERMISOS (E6-a y E6-b)
-- ------------------------------------------------

CREATE USER IF NOT EXISTS 'eventos_app'@'localhost' IDENTIFIED BY 'Eventos#2025!';
GRANT SELECT, INSERT ON eventos_s8.* TO 'eventos_app'@'localhost';
FLUSH PRIVILEGES;

-- Para revocar INSERT (ejecutar despues de probar el GRANT):
-- REVOKE INSERT ON eventos_s8.* FROM 'eventos_app'@'localhost';
-- FLUSH PRIVILEGES;

-- ------------------------------------------------
-- TRANSACCION: Inscribir asistente nuevo (E6-c)
-- Cambia @evento_id segun el evento que necesites
-- ------------------------------------------------

START TRANSACTION;

  INSERT INTO asistente (nombre, email)
  VALUES ('Pedro Sanchez', 'pedro@correo.co');

  SET @nuevo_id  = LAST_INSERT_ID();
  SET @evento_id = 3;

  SELECT (e.cupo_max - COUNT(ie.id_inscripcion))
  INTO @aforo_libre
  FROM evento e
      LEFT JOIN inscripcion_evento ie
          ON e.id_evento = ie.id_evento
          AND ie.estado != 'cancelada'
  WHERE e.id_evento = @evento_id
  GROUP BY e.cupo_max;

  INSERT INTO inscripcion_evento (id_asistente, id_evento, estado)
  SELECT @nuevo_id, @evento_id, 'pendiente'
  WHERE @aforo_libre > 0;

COMMIT;
-- Cambia COMMIT por ROLLBACK si el evento no tiene cupo
