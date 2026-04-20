
--SELECT nombre, apellido del socio, nombre del plan, fecha_fin y días restantes (DATEDIFF). Solo membresías vigentes, ordenadas por días restantes ASC.

SELECT  
S.NOMBRE,
S.APELLIDO,
P.NOMBRE NOMBRE_PLAN,
M.FECHA_FIN,
DATEDIFF(M.FECHA_FIN, '2025-03-15') DIAS_RESTANTES
FROM SOCIO S
JOIN MEMBRESIA M ON S.ID_SOCIO = M.ID_SOCIO
JOIN PLAN_MEMBRESIA P ON M.ID_PLAN = P.ID_PLAN
WHERE M.FECHA_FIN >= '2025-03-15'
ORDER BY DIAS_RESTANTES ASC;
--SELECT nombre de clase, instructor, cupo_max, total inscritos activos y cupo disponible (cupo_max - COUNT). Solo clases con cupo > 0.

SELECT 
C.NOMBRE NOMBRE_CLASE,
I.NOMBRE NOMBRE_INSTRUCTOR,
C.CUPO_MAX,
COUNT(INSC.ID_SOCIO) TOTAL_INSCRITOS,
C.CUPO_MAX - COUNT(INSC.ID_SOCIO) CUPO_DISPONIBLE
FROM CLASE C
JOIN INSTRUCTOR I 
ON C.ID_INSTRUCTOR = I.ID_INSTRUCTOR
INNER JOIN INSCRIPCION INSC 
ON C.ID_CLASE = INSC.ID_CLASE 
AND INSC.ESTADO = 'activa'
WHERE C.CUPO_MAX > 0
GROUP BY NOMBRE_CLASE, NOMBRE_INSTRUCTOR,CUPO_MAX
HAVING CUPO_DISPONIBLE > 0;
--SELECT nombre e especialidad del instructor, total de socios distintos inscritos en sus clases. ORDER BY total_socios DESC.

SELECT 
I.NOMBRE NOMBRE_INSTRUCTOR,
I.ESPECIALIDAD,
COUNT(DISTINCT INSC.ID_SOCIO) TOTAL_SOCIOS
FROM INSTRUCTOR I
INNER JOIN CLASE C 
ON I.ID_INSTRUCTOR = C.ID_INSTRUCTOR
INNER JOIN INSCRIPCION INSC 
ON C.ID_CLASE = INSC.ID_CLASE 
AND INSC.ESTADO = 'activa'
GROUP BY NOMBRE_INSTRUCTOR, ESPECIALIDAD
ORDER BY TOTAL_SOCIOS DESC;

--SELECT nombre, apellido, email del socio y fecha de su última membresía. Incluir socios sin ninguna membresía (LEFT JOIN + COALESCE).
SELECT 
S.NOMBRE,
S.APELLIDO,
S.EMAIL,
COALESCE(MAX(M.FECHA_FIN), 'Sin membresía') ULTIMA_MEMBRESIA
FROM SOCIO S
LEFT JOIN MEMBRESIA M 
ON S.ID_SOCIO = M.ID_SOCIO
GROUP BY S.NOMBRE, S.APELLIDO, S.EMAIL
ORDER BY ULTIMA_MEMBRESIA DESC;

CREATE TABLE socio (
  id_socio   INT AUTO_INCREMENT PRIMARY KEY,
  nombre     VARCHAR(80)  NOT NULL,
  apellido   VARCHAR(80)  NOT NULL,
  email      VARCHAR(120) NOT NULL UNIQUE,
  fecha_nac  DATE,
  activo     TINYINT(1)   DEFAULT 1,
  created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE membresia (
  id_membresia INT AUTO_INCREMENT PRIMARY KEY,
  fecha_inicio DATE NOT NULL,
  fecha_fin    DATE NOT NULL,
  id_socio     INT NOT NULL,
  id_plan      INT NOT NULL,
  CONSTRAINT fk_mem_socio FOREIGN KEY (id_socio) REFERENCES socio(id_socio) ON DELETE RESTRICT,
  CONSTRAINT fk_mem_plan  FOREIGN KEY (id_plan)  REFERENCES plan_membresia(id_plan) ON DELETE RESTRICT,
  CONSTRAINT ck_fechas_mem CHECK (fecha_fin > fecha_inicio)
) ENGINE=InnoDB;

CREATE TABLE plan_membresia (
  id_plan  INT AUTO_INCREMENT PRIMARY KEY,
  nombre   ENUM('mensual','trimestral','anual','semestral') NOT NULL UNIQUE,
  duracion_dias INT NOT NULL,
  precio   DECIMAL(10,2) NOT NULL,
  CONSTRAINT ck_precio_plan CHECK (precio > 0),
  CONSTRAINT ck_duracion    CHECK (duracion_dias > 0)
) ENGINE=InnoDB;



CREATE TABLE tel_emergencia (
  id_tel   INT AUTO_INCREMENT PRIMARY KEY,
  id_socio INT NOT NULL,
  numero   VARCHAR(20) NOT NULL,
  tipo     ENUM('celular','fijo','trabajo') DEFAULT 'celular',
  FOREIGN KEY (id_socio) REFERENCES socio(id_socio) ON DELETE CASCADE
) ENGINE=InnoDB;



CREATE TABLE instructor (
  id_instructor INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(80) NOT NULL,
  apellido      VARCHAR(80) NOT NULL,
  especialidad  ENUM('cardio','pesas','yoga','crossfit','pilates') NOT NULL,
  activo        TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE clase (
  id_clase      INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(100) NOT NULL,
  descripcion   TEXT,
  cupo_max      INT NOT NULL DEFAULT 20,
  horario       VARCHAR(60),
  dia_semana    ENUM('lunes','martes','miercoles','jueves','viernes','sabado','domingo'),
  id_instructor INT NOT NULL,
  CONSTRAINT fk_clase_inst FOREIGN KEY (id_instructor) REFERENCES instructor(id_instructor)
             ON DELETE RESTRICT,
  CONSTRAINT ck_cupo CHECK (cupo_max > 0)
) ENGINE=InnoDB;

CREATE TABLE inscripcion (
  id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
  fecha_inscripcion DATE NOT NULL DEFAULT (CURRENT_DATE),
  estado         ENUM('activa','cancelada','completada') DEFAULT 'activa',
  id_socio       INT NOT NULL,
  id_clase       INT NOT NULL,
  CONSTRAINT fk_insc_socio  FOREIGN KEY (id_socio) REFERENCES socio(id_socio)   ON DELETE RESTRICT,
  CONSTRAINT fk_insc_clase  FOREIGN KEY (id_clase) REFERENCES clase(id_clase)   ON DELETE RESTRICT,
  CONSTRAINT uq_socio_clase UNIQUE (id_socio, id_clase)  -- evita inscripción duplicada
) ENGINE=InnoDB;

-- INSERT datos de prueba
INSERT INTO plan_membresia (nombre,duracion_dias,precio) VALUES
  ('mensual',30,89000), ('trimestral',90,230000), ('anual',365,750000);

INSERT INTO instructor (nombre,apellido,especialidad) VALUES
  ('Luis','Ramírez','yoga'), ('María','Vargas','crossfit'), ('Carlos','Bueno','pesas');

INSERT INTO socio (nombre,apellido,email) VALUES
  ('Ana','García','ana@gym.co'), ('Pedro','López','pedro@gym.co'),
  ('Sofía','Martínez','sofia@gym.co'), ('Jorge','Torres','jorge@gym.co'),
  ('Valentina','Ruiz','val@gym.co');

INSERT INTO tel_emergencia (id_socio,numero,tipo) VALUES
  (1,'310-1111','celular'),(1,'315-2222','celular'),(2,'320-3333','celular'),
  (3,'330-4444','celular'),(3,'335-5555','fijo'),(4,'340-6666','celular');

INSERT INTO membresia (fecha_inicio,fecha_fin,id_socio,id_plan) VALUES
  ('2025-01-01','2025-01-31',1,1),
  ('2025-01-15','2025-04-15',2,2),
  ('2025-02-01','2026-02-01',3,3),
  ('2024-12-01','2024-12-31',4,1),
  ('2025-03-01','2025-06-01',5,2);

INSERT INTO clase (nombre,cupo_max,horario,dia_semana,id_instructor) VALUES
  ('Yoga Matutino',20,'07:00','lunes',1), ('Crossfit Intensivo',15,'18:00','martes',2),
  ('Pesas Básico',25,'10:00','miercoles',3), ('Yoga Avanzado',15,'19:00','jueves',1);

INSERT INTO inscripcion (id_socio,id_clase,estado) VALUES
  (1,1,'activa'),(1,2,'activa'),(2,1,'activa'),(2,3,'activa'),
  (3,2,'activa'),(3,4,'activa'),(4,1,'cancelada'),(5,3,'activa');