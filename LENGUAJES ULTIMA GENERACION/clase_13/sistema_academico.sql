-- ============================================================================
-- SISTEMA ACADÉMICO UNIVERSITARIO – Oracle Database
-- Sesión 13: Clase Práctica II
-- Docente: Mg. Sergio Alejandro Burbano Mena
-- Universidad: Universitaria de Colombia
-- Materia: Lenguajes de Última Generación | Ing. Sistemas 4° Semestre
-- ============================================================================
-- Instrucciones:
--   1. Abrir Oracle APEX → SQL Workshop → SQL Scripts → Upload este archivo
--   2. Clic en Run → el script crea tablas, sequences, triggers e inserta datos
--   3. Verificar: SQL Commands → SELECT table_name FROM user_tables;
-- ============================================================================

SET DEFINE OFF;

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  PASO 1: ELIMINAR OBJETOS EXISTENTES (si existen)                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

BEGIN
  FOR r IN (SELECT table_name FROM user_tables WHERE table_name IN (
    'AUDIT_LOG','CALIFICACION','MATRICULA','MATERIA','SEMESTRE','ESTUDIANTE','DOCENTE','PROGRAMA'
  ) ORDER BY CASE table_name
    WHEN 'AUDIT_LOG' THEN 1 WHEN 'CALIFICACION' THEN 2 WHEN 'MATRICULA' THEN 3
    WHEN 'MATERIA' THEN 4 WHEN 'SEMESTRE' THEN 5 WHEN 'ESTUDIANTE' THEN 6
    WHEN 'DOCENTE' THEN 7 WHEN 'PROGRAMA' THEN 8 END
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || r.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
  FOR r IN (SELECT sequence_name FROM user_sequences WHERE sequence_name LIKE 'SEQ_%') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || r.sequence_name;
  END LOOP;
END;
/

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  PASO 2: CREAR SEQUENCES                                              ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

CREATE SEQUENCE seq_programa   START WITH 1    INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_docente    START WITH 501  INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_estudiante START WITH 1001 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_materia    START WITH 101  INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_semestre   START WITH 1    INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_matricula  START WITH 10001 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_calificacion START WITH 1  INCREMENT BY 1 NOCACHE;

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  PASO 3: CREAR TABLAS CON CONSTRAINTS                                 ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- 1. PROGRAMA (sin FK: tabla raíz)
CREATE TABLE programa (
    id_programa   NUMBER(6)     CONSTRAINT pk_programa PRIMARY KEY,
    nombre        VARCHAR2(120) NOT NULL,
    facultad      VARCHAR2(80)  NOT NULL,
    creditos_min  NUMBER(4,0)   DEFAULT 160 NOT NULL,
    activo        NUMBER(1,0)   DEFAULT 1 CONSTRAINT ck_prog_act CHECK(activo IN(0,1)),
    created_at    DATE          DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER trg_bi_programa
BEFORE INSERT ON programa FOR EACH ROW
BEGIN
    IF :NEW.id_programa IS NULL THEN
        SELECT seq_programa.NEXTVAL INTO :NEW.id_programa FROM DUAL;
    END IF;
END;
/

-- 2. DOCENTE
CREATE TABLE docente (
    id_docente    NUMBER(6)     CONSTRAINT pk_docente PRIMARY KEY,
    cedula        VARCHAR2(15)  NOT NULL CONSTRAINT uq_ced_doc UNIQUE,
    nombre        VARCHAR2(80)  NOT NULL,
    apellido      VARCHAR2(80)  NOT NULL,
    email         VARCHAR2(120) NOT NULL CONSTRAINT uq_email_doc UNIQUE,
    titulo        VARCHAR2(40)  DEFAULT 'Especialista',
    especialidad  VARCHAR2(80),
    activo        NUMBER(1,0)   DEFAULT 1 CONSTRAINT ck_doc_act CHECK(activo IN(0,1)),
    created_at    DATE          DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER trg_bi_docente
BEFORE INSERT ON docente FOR EACH ROW
BEGIN
    IF :NEW.id_docente IS NULL THEN
        SELECT seq_docente.NEXTVAL INTO :NEW.id_docente FROM DUAL;
    END IF;
END;
/

-- 3. ESTUDIANTE (FK → PROGRAMA)
CREATE TABLE estudiante (
    id_estudiante   NUMBER(8)     CONSTRAINT pk_estudiante PRIMARY KEY,
    codigo          VARCHAR2(12)  NOT NULL CONSTRAINT uq_cod_est UNIQUE,
    nombre          VARCHAR2(80)  NOT NULL,
    apellido        VARCHAR2(80)  NOT NULL,
    email           VARCHAR2(120) NOT NULL CONSTRAINT uq_email_est UNIQUE,
    telefono        VARCHAR2(20),
    semestre_actual NUMBER(2,0)   DEFAULT 1 NOT NULL,
    activo          NUMBER(1,0)   DEFAULT 1 CONSTRAINT ck_est_act CHECK(activo IN(0,1)),
    id_programa     NUMBER(6)     NOT NULL,
    created_at      DATE          DEFAULT SYSDATE,
    CONSTRAINT fk_est_prog FOREIGN KEY(id_programa) REFERENCES programa(id_programa)
);

CREATE OR REPLACE TRIGGER trg_bi_estudiante
BEFORE INSERT ON estudiante FOR EACH ROW
BEGIN
    IF :NEW.id_estudiante IS NULL THEN
        SELECT seq_estudiante.NEXTVAL INTO :NEW.id_estudiante FROM DUAL;
    END IF;
END;
/

-- 4. MATERIA (FK → PROGRAMA, DOCENTE)
CREATE TABLE materia (
    id_materia    NUMBER(6)     CONSTRAINT pk_materia PRIMARY KEY,
    codigo        VARCHAR2(10)  NOT NULL CONSTRAINT uq_cod_mat UNIQUE,
    nombre        VARCHAR2(120) NOT NULL,
    creditos      NUMBER(2,0)   DEFAULT 3 NOT NULL,
    id_programa   NUMBER(6)     NOT NULL,
    id_docente    NUMBER(6),
    activo        NUMBER(1,0)   DEFAULT 1,
    CONSTRAINT fk_mat_prog FOREIGN KEY(id_programa) REFERENCES programa(id_programa),
    CONSTRAINT fk_mat_doc  FOREIGN KEY(id_docente)  REFERENCES docente(id_docente)
);

CREATE OR REPLACE TRIGGER trg_bi_materia
BEFORE INSERT ON materia FOR EACH ROW
BEGIN
    IF :NEW.id_materia IS NULL THEN
        SELECT seq_materia.NEXTVAL INTO :NEW.id_materia FROM DUAL;
    END IF;
END;
/

-- 5. SEMESTRE
CREATE TABLE semestre (
    id_semestre   NUMBER(6)   CONSTRAINT pk_semestre PRIMARY KEY,
    anio          NUMBER(4,0) NOT NULL,
    periodo       CHAR(1)     NOT NULL CONSTRAINT ck_sem_per CHECK(periodo IN('1','2')),
    fecha_inicio  DATE        NOT NULL,
    fecha_fin     DATE        NOT NULL,
    CONSTRAINT uq_semestre UNIQUE(anio, periodo),
    CONSTRAINT ck_fechas_sem CHECK(fecha_fin > fecha_inicio)
);

CREATE OR REPLACE TRIGGER trg_bi_semestre
BEFORE INSERT ON semestre FOR EACH ROW
BEGIN
    IF :NEW.id_semestre IS NULL THEN
        SELECT seq_semestre.NEXTVAL INTO :NEW.id_semestre FROM DUAL;
    END IF;
END;
/

-- 6. MATRICULA (pivot N:M entre ESTUDIANTE y MATERIA)
CREATE TABLE matricula (
    id_matricula    NUMBER(8)     CONSTRAINT pk_matricula PRIMARY KEY,
    id_estudiante   NUMBER(8)     NOT NULL,
    id_materia      NUMBER(6)     NOT NULL,
    id_semestre     NUMBER(6)     NOT NULL,
    estado          VARCHAR2(12)  DEFAULT 'activa' NOT NULL
                    CONSTRAINT ck_mat_est CHECK(estado IN('activa','cancelada','completada')),
    fecha_matricula DATE          DEFAULT SYSDATE,
    CONSTRAINT fk_matr_est FOREIGN KEY(id_estudiante) REFERENCES estudiante(id_estudiante),
    CONSTRAINT fk_matr_mat FOREIGN KEY(id_materia)    REFERENCES materia(id_materia),
    CONSTRAINT fk_matr_sem FOREIGN KEY(id_semestre)   REFERENCES semestre(id_semestre),
    CONSTRAINT uq_matricula UNIQUE(id_estudiante, id_materia, id_semestre)
);

CREATE OR REPLACE TRIGGER trg_bi_matricula
BEFORE INSERT ON matricula FOR EACH ROW
BEGIN
    IF :NEW.id_matricula IS NULL THEN
        SELECT seq_matricula.NEXTVAL INTO :NEW.id_matricula FROM DUAL;
    END IF;
END;
/

-- 7. CALIFICACION (1:1 con MATRICULA)
CREATE TABLE calificacion (
    id_calificacion NUMBER(8)    CONSTRAINT pk_calificacion PRIMARY KEY,
    id_matricula    NUMBER(8)    NOT NULL CONSTRAINT uq_cal_mat UNIQUE,
    nota_1          NUMBER(4,2)  CONSTRAINT ck_n1 CHECK(nota_1 BETWEEN 0 AND 5),
    nota_2          NUMBER(4,2)  CONSTRAINT ck_n2 CHECK(nota_2 BETWEEN 0 AND 5),
    nota_3          NUMBER(4,2)  CONSTRAINT ck_n3 CHECK(nota_3 BETWEEN 0 AND 5),
    aprobado        NUMBER(1,0)  DEFAULT 0,
    CONSTRAINT fk_cal_mat FOREIGN KEY(id_matricula) REFERENCES matricula(id_matricula) ON DELETE CASCADE
);

CREATE OR REPLACE TRIGGER trg_bi_calificacion
BEFORE INSERT ON calificacion FOR EACH ROW
BEGIN
    IF :NEW.id_calificacion IS NULL THEN
        SELECT seq_calificacion.NEXTVAL INTO :NEW.id_calificacion FROM DUAL;
    END IF;
END;
/

-- 8. AUDIT_LOG (auditoría de cambios)
CREATE TABLE audit_log (
    id_audit   NUMBER(10)   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tabla_n    VARCHAR2(60)  NOT NULL,
    accion     VARCHAR2(10)  NOT NULL,
    id_reg     NUMBER(10),
    campo_mod  VARCHAR2(60),
    val_ant    VARCHAR2(500),
    val_nvo    VARCHAR2(500),
    usuario    VARCHAR2(80)  DEFAULT USER,
    fecha      TIMESTAMP     DEFAULT SYSTIMESTAMP
);

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  PASO 4: INSERTAR DATOS DE PRUEBA (20+ registros por tabla)           ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ── PROGRAMA (20 registros) ─────────────────────────────────────────────────
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Ingeniería de Sistemas', 'Facultad de Tecnología', 160);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Ingeniería Industrial', 'Facultad de Ingeniería', 160);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Administración de Empresas', 'Facultad de Ciencias Económicas', 144);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Contaduría Pública', 'Facultad de Ciencias Económicas', 150);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Derecho', 'Facultad de Ciencias Jurídicas', 168);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Psicología', 'Facultad de Ciencias Humanas', 155);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Comunicación Social', 'Facultad de Ciencias Humanas', 140);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Ingeniería Civil', 'Facultad de Ingeniería', 170);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Ingeniería Ambiental', 'Facultad de Ingeniería', 160);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Medicina', 'Facultad de Ciencias de la Salud', 200);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Enfermería', 'Facultad de Ciencias de la Salud', 155);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Arquitectura', 'Facultad de Artes', 165);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Diseño Gráfico', 'Facultad de Artes', 140);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Economía', 'Facultad de Ciencias Económicas', 148);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Trabajo Social', 'Facultad de Ciencias Humanas', 145);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Biología', 'Facultad de Ciencias Básicas', 158);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Matemáticas', 'Facultad de Ciencias Básicas', 152);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Ingeniería Electrónica', 'Facultad de Tecnología', 168);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Ciencias Políticas', 'Facultad de Ciencias Jurídicas', 144);
INSERT INTO programa(nombre, facultad, creditos_min) VALUES('Comercio Internacional', 'Facultad de Ciencias Económicas', 150);
COMMIT;

-- ── DOCENTE (20 registros) ──────────────────────────────────────────────────
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('10101010','Carlos','Mendoza','cmendoza@uni.edu','Magíster','Bases de Datos');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('20202020','Ana María','Ríos','arios@uni.edu','Doctora','Inteligencia Artificial');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('30303030','Luis Fernando','Gómez','lfgomez@uni.edu','Magíster','Redes y Telecomunicaciones');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('40404040','María Claudia','Torres','mctorres@uni.edu','Especialista','Programación Web');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('50505050','Andrés Felipe','Ramírez','aframirez@uni.edu','Magíster','Ingeniería de Software');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('60606060','Sandra Patricia','López','splopez@uni.edu','Doctora','Estadística Aplicada');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('70707070','Jorge Eduardo','Herrera','jeherrera@uni.edu','Magíster','Sistemas Operativos');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('80808080','Diana Carolina','Vargas','dcvargas@uni.edu','Especialista','Contabilidad Financiera');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('90909090','Ricardo Alberto','Peña','rapena@uni.edu','Magíster','Derecho Laboral');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('11111111','Claudia Marcela','Ruiz','cmruiz@uni.edu','Doctora','Psicología Clínica');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('12121212','Miguel Ángel','Castro','macastro@uni.edu','Magíster','Arquitectura Empresarial');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('13131313','Adriana Lucía','Morales','almorales@uni.edu','Especialista','Comunicación Digital');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('14141414','Felipe Antonio','Díaz','fadiaz@uni.edu','Magíster','Cálculo y Álgebra');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('15151515','Natalia Andrea','Jiménez','najimenez@uni.edu','Doctora','Biotecnología');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('16161616','Sergio Alejandro','Burbano','saburbano@uni.edu','Magíster','Lenguajes de Programación');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('17171717','Paola Andrea','Cifuentes','pacifuentes@uni.edu','Especialista','Economía Internacional');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('18181818','Camilo Andrés','Ortiz','caortiz@uni.edu','Magíster','Diseño Multimedia');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('19191919','Laura Valentina','Suárez','lvsuarez@uni.edu','Doctora','Matemáticas Aplicadas');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('21212121','Julián David','Acosta','jdacosta@uni.edu','Magíster','Seguridad Informática');
INSERT INTO docente(cedula,nombre,apellido,email,titulo,especialidad) VALUES('22222222','Valentina María','Rojas','vmrojas@uni.edu','Especialista','Medicina Interna');
COMMIT;

-- ── ESTUDIANTE (25 registros) ───────────────────────────────────────────────
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IS-2024-001','Juan Pablo','García','jpgarcia@est.edu','310-1000001',4,1);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IS-2024-002','María Fernanda','López','mflopez@est.edu','311-2000002',4,1);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IS-2024-003','Sofía Alejandra','Torres','satorres@est.edu','312-3000003',3,1);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IS-2024-004','Andrés Camilo','Ramírez','acramirez@est.edu','313-4000004',4,1);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IS-2024-005','Laura Carolina','Herrera','lcherrera@est.edu','314-5000005',3,1);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('II-2024-001','Carlos Eduardo','Peña','cepena@est.edu','315-6000006',2,2);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('II-2024-002','Diana Marcela','Vargas','dmvargas@est.edu','316-7000007',3,2);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('AD-2024-001','Miguel Ángel','Castro','macastro@est.edu','317-8000008',4,3);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('AD-2024-002','Valentina María','Rojas','vmrojas@est.edu','318-9000009',2,3);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('CP-2024-001','Julián David','Morales','jdmorales@est.edu','319-1000010',5,4);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('DE-2024-001','Paula Andrea','Jiménez','pajimenez@est.edu','320-1000011',3,5);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('PS-2024-001','Camila Andrea','Suárez','casuarez@est.edu','321-1000012',4,6);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('CS-2024-001','Sebastián Felipe','Ortiz','sfontiz@est.edu','322-1000013',2,7);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IC-2024-001','Natalia Lorena','Díaz','nldiaz@est.edu','323-1000014',5,8);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IA-2024-001','Felipe Andrés','Cifuentes','facifuentes@est.edu','324-1000015',3,9);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IS-2024-006','Daniela Alejandra','Acosta','daacosta@est.edu','325-1000016',2,1);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IS-2024-007','Santiago David','Muñoz','sdmunoz@est.edu','326-1000017',4,1);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('II-2024-003','Alejandra María','Prieto','amprieto@est.edu','327-1000018',1,2);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('AD-2024-003','Ricardo José','Beltrán','rjbeltran@est.edu','328-1000019',3,3);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('ME-2024-001','Gabriela Inés','Pardo','gipardo@est.edu','329-1000020',6,10);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('IS-2024-008','Martín Alejandro','Vega','mavega@est.edu','330-1000021',1,1);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('DE-2024-002','Isabella Sofía','Restrepo','isrestrepo@est.edu','331-1000022',2,5);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa) VALUES('PS-2024-002','Tomás Andrés','Guerrero','taguerrero@est.edu','332-1000023',3,6);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa,activo) VALUES('IS-2023-099','Pedro Alberto','Sánchez','pasanchez@est.edu','333-1000024',4,1,0);
INSERT INTO estudiante(codigo,nombre,apellido,email,telefono,semestre_actual,id_programa,activo) VALUES('AD-2023-099','Carolina María','Rincón','cmrincon@est.edu','334-1000025',3,3,0);
COMMIT;

-- ── MATERIA (22 registros) ──────────────────────────────────────────────────
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IS101','Programación Básica',4,1,501);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IS102','Bases de Datos I',3,1,501);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IS103','Lenguajes de Última Generación',3,1,516);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IS104','Redes de Computadores',3,1,503);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IS105','Ingeniería de Software I',4,1,505);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IS106','Inteligencia Artificial',3,1,502);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IS107','Sistemas Operativos',3,1,507);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IS108','Seguridad Informática',3,1,519);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('II201','Investigación de Operaciones',4,2,506);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('II202','Gestión de la Calidad',3,2,505);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('AD301','Administración General',3,3,511);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('AD302','Marketing Digital',3,3,513);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('CP401','Contabilidad General',4,4,508);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('CP402','Auditoría Financiera',3,4,508);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('DE501','Derecho Constitucional',4,5,509);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('PS601','Psicología General',3,6,510);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('MA001','Cálculo Diferencial',4,1,514);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('MA002','Álgebra Lineal',3,1,514);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('MA003','Estadística I',3,1,506);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('ME101','Anatomía Humana',5,10,520);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IC801','Mecánica de Suelos',4,8,503);
INSERT INTO materia(codigo,nombre,creditos,id_programa,id_docente) VALUES('IA901','Gestión Ambiental',3,9,515);
COMMIT;

-- ── SEMESTRE (6 registros) ──────────────────────────────────────────────────
INSERT INTO semestre(anio,periodo,fecha_inicio,fecha_fin) VALUES(2024,'1',DATE '2024-01-15',DATE '2024-06-15');
INSERT INTO semestre(anio,periodo,fecha_inicio,fecha_fin) VALUES(2024,'2',DATE '2024-07-15',DATE '2024-12-10');
INSERT INTO semestre(anio,periodo,fecha_inicio,fecha_fin) VALUES(2025,'1',DATE '2025-01-15',DATE '2025-06-15');
INSERT INTO semestre(anio,periodo,fecha_inicio,fecha_fin) VALUES(2025,'2',DATE '2025-07-15',DATE '2025-12-10');
INSERT INTO semestre(anio,periodo,fecha_inicio,fecha_fin) VALUES(2023,'1',DATE '2023-01-16',DATE '2023-06-16');
INSERT INTO semestre(anio,periodo,fecha_inicio,fecha_fin) VALUES(2023,'2',DATE '2023-07-17',DATE '2023-12-08');
COMMIT;

-- ── MATRICULA (40 registros – distintos estados) ────────────────────────────
-- Semestre 2025-1 (id_semestre = 3) – matrículas activas
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1001,101,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1001,102,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1001,103,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1002,101,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1002,102,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1002,117,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1003,103,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1003,105,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1004,106,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1004,107,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1005,101,3,'cancelada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1005,118,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1006,109,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1007,109,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1008,111,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1009,111,3,'cancelada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1010,113,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1011,115,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1012,116,3,'activa');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1020,120,3,'activa');
COMMIT;

-- Semestre 2024-2 (id_semestre = 2) – matrículas completadas
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1001,117,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1001,118,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1002,103,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1002,118,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1003,101,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1003,102,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1004,101,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1004,117,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1005,103,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1006,110,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1007,110,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1008,112,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1010,114,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1011,115,2,'cancelada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1013,104,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1014,121,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1015,122,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1016,101,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1017,105,2,'completada');
INSERT INTO matricula(id_estudiante,id_materia,id_semestre,estado) VALUES(1019,111,2,'completada');
COMMIT;

-- ── CALIFICACION (para matrículas completadas del semestre 2024-2) ──────────
-- IDs de matrícula 10021 a 10040 (semestre 2024-2, estado completada)
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10021,3.5,4.0,3.8,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10022,4.2,3.8,4.5,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10023,2.8,3.1,2.5,0);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10024,4.5,4.2,4.8,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10025,3.0,3.5,3.2,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10026,3.8,4.0,3.5,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10027,4.0,3.6,4.2,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10028,2.5,2.8,2.0,0);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10029,3.2,3.0,3.5,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10030,4.8,4.5,5.0,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10031,3.6,3.2,3.0,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10032,4.0,4.5,4.2,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10033,3.0,2.5,2.8,0);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10035,3.5,3.8,4.0,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10036,4.2,4.0,4.5,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10037,3.8,3.5,3.2,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10038,2.0,2.5,1.8,0);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10039,4.5,4.8,4.2,1);
INSERT INTO calificacion(id_matricula,nota_1,nota_2,nota_3,aprobado) VALUES(10040,3.2,3.5,3.8,1);
COMMIT;

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  PASO 5: CREAR PL/SQL (PACKAGE + TRIGGER DE AUDITORÍA)                ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Package de lógica académica
CREATE OR REPLACE PACKAGE pkg_academico AS
    FUNCTION fn_promedio(p_est NUMBER, p_sem NUMBER) RETURN NUMBER;
    FUNCTION fn_estado(p_id NUMBER) RETURN VARCHAR2;
    PROCEDURE sp_matricular(p_est NUMBER, p_mat NUMBER, p_sem NUMBER, p_res OUT VARCHAR2);
    PROCEDURE sp_calificar(p_mat_id NUMBER, p_n1 NUMBER, p_n2 NUMBER, p_n3 NUMBER);
END pkg_academico;
/

CREATE OR REPLACE PACKAGE BODY pkg_academico AS

    FUNCTION fn_promedio(p_est NUMBER, p_sem NUMBER) RETURN NUMBER IS
        v_prom NUMBER(4,2) := 0;
    BEGIN
        SELECT ROUND(AVG(NVL(c.nota_1,0)*0.3 + NVL(c.nota_2,0)*0.3 + NVL(c.nota_3,0)*0.4), 2)
        INTO v_prom
        FROM calificacion c
        JOIN matricula m ON c.id_matricula = m.id_matricula
        WHERE m.id_estudiante = p_est AND m.id_semestre = p_sem AND m.estado = 'completada';
        RETURN NVL(v_prom, 0);
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 0;
    END fn_promedio;

    FUNCTION fn_estado(p_id NUMBER) RETURN VARCHAR2 IS
        v_prom NUMBER;
    BEGIN
        SELECT ROUND(AVG(NVL(c.nota_1,0)*0.3 + NVL(c.nota_2,0)*0.3 + NVL(c.nota_3,0)*0.4), 2)
        INTO v_prom
        FROM calificacion c
        JOIN matricula m ON c.id_matricula = m.id_matricula
        WHERE m.id_estudiante = p_id AND m.estado = 'completada';
        RETURN CASE
            WHEN v_prom >= 4.5 THEN 'HONOR'
            WHEN v_prom >= 3.5 THEN 'BUENO'
            WHEN v_prom >= 3.0 THEN 'APROBADO'
            WHEN v_prom >= 2.5 THEN 'RIESGO'
            ELSE 'BAJO' END;
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'SIN HISTORIAL';
    END fn_estado;

    PROCEDURE sp_matricular(p_est NUMBER, p_mat NUMBER, p_sem NUMBER, p_res OUT VARCHAR2) IS
        v_count NUMBER;
        v_id    NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM matricula
        WHERE id_estudiante = p_est AND id_materia = p_mat AND id_semestre = p_sem;
        IF v_count > 0 THEN
            p_res := 'ERROR: El estudiante ya está matriculado en esta materia para este semestre';
            RETURN;
        END IF;
        INSERT INTO matricula(id_estudiante, id_materia, id_semestre)
        VALUES(p_est, p_mat, p_sem) RETURNING id_matricula INTO v_id;
        INSERT INTO calificacion(id_matricula) VALUES(v_id);
        COMMIT;
        p_res := 'OK: Matrícula #' || v_id || ' creada exitosamente';
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        p_res := 'ERROR: ' || SQLERRM;
    END sp_matricular;

    PROCEDURE sp_calificar(p_mat_id NUMBER, p_n1 NUMBER, p_n2 NUMBER, p_n3 NUMBER) IS
        v_def  NUMBER;
        v_apro NUMBER;
    BEGIN
        v_def := ROUND(NVL(p_n1,0)*0.3 + NVL(p_n2,0)*0.3 + NVL(p_n3,0)*0.4, 2);
        v_apro := CASE WHEN v_def >= 3.0 THEN 1 ELSE 0 END;
        UPDATE calificacion
        SET nota_1 = p_n1, nota_2 = p_n2, nota_3 = p_n3, aprobado = v_apro
        WHERE id_matricula = p_mat_id;
        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO calificacion(id_matricula, nota_1, nota_2, nota_3, aprobado)
            VALUES(p_mat_id, p_n1, p_n2, p_n3, v_apro);
        END IF;
        COMMIT;
    END sp_calificar;

END pkg_academico;
/

-- Trigger de auditoría polimórfico en MATRICULA
CREATE OR REPLACE TRIGGER trg_audit_matricula
AFTER INSERT OR UPDATE OR DELETE ON matricula
FOR EACH ROW
BEGIN
    INSERT INTO audit_log(tabla_n, accion, id_reg, val_ant, val_nvo)
    VALUES(
        'MATRICULA',
        CASE WHEN INSERTING THEN 'INSERT' WHEN UPDATING THEN 'UPDATE' ELSE 'DELETE' END,
        NVL(:NEW.id_matricula, :OLD.id_matricula),
        :OLD.estado,
        :NEW.estado
    );
END;
/

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  PASO 6: VISTAS PARA LOS REPORTES APEX                               ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

CREATE OR REPLACE VIEW v_estudiantes_completo AS
SELECT
    e.id_estudiante, e.codigo, e.nombre || ' ' || e.apellido AS estudiante,
    e.email, e.telefono, e.semestre_actual,
    p.nombre AS programa, p.facultad,
    CASE e.activo WHEN 1 THEN 'Activo' ELSE 'Inactivo' END AS estado,
    (SELECT COUNT(*) FROM matricula m WHERE m.id_estudiante = e.id_estudiante AND m.estado = 'activa') AS materias_activas,
    pkg_academico.fn_estado(e.id_estudiante) AS estado_academico
FROM estudiante e
JOIN programa p ON e.id_programa = p.id_programa;

CREATE OR REPLACE VIEW v_matriculas_detalle AS
SELECT
    m.id_matricula,
    e.codigo AS cod_estudiante,
    e.nombre || ' ' || e.apellido AS estudiante,
    mat.codigo || ' - ' || mat.nombre AS materia,
    mat.creditos,
    s.anio || '-' || s.periodo AS semestre,
    UPPER(m.estado) AS estado,
    TO_CHAR(m.fecha_matricula, 'DD/MM/YYYY') AS fecha_matricula,
    c.nota_1, c.nota_2, c.nota_3,
    ROUND(NVL(c.nota_1,0)*0.3 + NVL(c.nota_2,0)*0.3 + NVL(c.nota_3,0)*0.4, 2) AS definitiva,
    CASE WHEN (NVL(c.nota_1,0)*0.3 + NVL(c.nota_2,0)*0.3 + NVL(c.nota_3,0)*0.4) >= 3.0
         THEN 'APROBADA' ELSE 'REPROBADA' END AS resultado
FROM matricula m
JOIN estudiante e ON m.id_estudiante = e.id_estudiante
JOIN materia mat ON m.id_materia = mat.id_materia
JOIN semestre s ON m.id_semestre = s.id_semestre
LEFT JOIN calificacion c ON m.id_matricula = c.id_matricula;

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  PASO 7: VERIFICACIÓN FINAL                                           ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Conteo de registros por tabla
SELECT 'PROGRAMA' AS tabla, COUNT(*) AS registros FROM programa UNION ALL
SELECT 'DOCENTE', COUNT(*) FROM docente UNION ALL
SELECT 'ESTUDIANTE', COUNT(*) FROM estudiante UNION ALL
SELECT 'MATERIA', COUNT(*) FROM materia UNION ALL
SELECT 'SEMESTRE', COUNT(*) FROM semestre UNION ALL
SELECT 'MATRICULA', COUNT(*) FROM matricula UNION ALL
SELECT 'CALIFICACION', COUNT(*) FROM calificacion UNION ALL
SELECT 'AUDIT_LOG', COUNT(*) FROM audit_log
ORDER BY tabla;

-- Verificar objetos PL/SQL
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE','PACKAGE BODY','TRIGGER','VIEW')
ORDER BY object_type, object_name;

-- ============================================================================
-- FIN DEL SCRIPT – Ejecutar en SQL Workshop → SQL Scripts → Upload → Run
-- Si todo ejecutó sin errores → crear la app APEX con App Builder
-- ============================================================================
