-- Generado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   en:        2023-09-17 17:46:43 COT
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE clinica (
    id_clinica             NUMBER NOT NULL,
    nombre_clinica         VARCHAR2(100) NOT NULL,
    municipio_id_municipio NUMBER NOT NULL
);

ALTER TABLE clinica ADD CONSTRAINT clinica_pk PRIMARY KEY ( id_clinica );


--  ERROR: UK name length exceeds maximum allowed length(30) 
ALTER TABLE clinica ADD CONSTRAINT clinica_nombre_clinica_municipio_id_municipio_un UNIQUE ( nombre_clinica,
                                                                                             municipio_id_municipio );

CREATE TABLE departamento (
    id_departamento          NUMBER NOT NULL,
    descripcion_departamento VARCHAR2(100) NOT NULL
);

ALTER TABLE departamento ADD CONSTRAINT departamento_pk PRIMARY KEY ( id_departamento );


--  ERROR: UK name length exceeds maximum allowed length(30) 
ALTER TABLE departamento ADD CONSTRAINT departamento_descripcion_departamento_un UNIQUE ( descripcion_departamento );

CREATE TABLE examen (
    id_examen          NUMBER NOT NULL,
    periodo_id_periodo NUMBER NOT NULL,
    mascota_id_mascota NUMBER NOT NULL
);

ALTER TABLE examen ADD CONSTRAINT examen_pk PRIMARY KEY ( id_examen );


--  ERROR: UK name length exceeds maximum allowed length(30) 
ALTER TABLE examen ADD CONSTRAINT examen_periodo_id_periodo_mascota_id_mascota_un UNIQUE ( periodo_id_periodo,
                                                                                           mascota_id_mascota );

CREATE TABLE examen_tratamiento (
    id_examen_tratamiento      NUMBER NOT NULL,
    cantidad_tratamiento       NUMBER NOT NULL,
    tratamiento_id_tratamiento NUMBER NOT NULL,
    examen_id_examen           NUMBER NOT NULL
);

ALTER TABLE examen_tratamiento
    ADD CONSTRAINT examen_tratamiento_pk PRIMARY KEY ( id_examen_tratamiento,
                                                       tratamiento_id_tratamiento,
                                                       examen_id_examen );


--  ERROR: UK name length exceeds maximum allowed length(30) 
ALTER TABLE examen_tratamiento ADD CONSTRAINT examen_tratamiento_tratamiento_id_tratamiento_examen_id_examen_un UNIQUE ( tratamiento_id_tratamiento
,
                                                                                                                         examen_id_examen
                                                                                                                         );

CREATE TABLE mascota (
    id_mascota                 NUMBER NOT NULL,
    nombre_mascota             VARCHAR2(100) NOT NULL,
    clinica_id_clinica         NUMBER NOT NULL,
    propietario_id_propietario NUMBER NOT NULL
);

ALTER TABLE mascota ADD CONSTRAINT mascota_pk PRIMARY KEY ( id_mascota );


--  ERROR: UK name length exceeds maximum allowed length(30) 
ALTER TABLE mascota ADD CONSTRAINT mascota_nombre_mascota_propietario_id_propietario_clinica_id_clinica_un UNIQUE ( nombre_mascota,
                                                                                                                    propietario_id_propietario
                                                                                                                    );

CREATE TABLE municipio (
    id_municipio                 NUMBER NOT NULL,
    descripcion_municipio        VARCHAR2(100) NOT NULL,
    departamento_id_departamento NUMBER NOT NULL
);

ALTER TABLE municipio ADD CONSTRAINT municipio_pk PRIMARY KEY ( id_municipio );


--  ERROR: UK name length exceeds maximum allowed length(30) 
ALTER TABLE municipio ADD CONSTRAINT municipio_departamento_id_departamento_descripcion_municipio_un UNIQUE ( departamento_id_departamento
,
                                                                                                              descripcion_municipio )
                                                                                                              ;

CREATE TABLE periodo (
    id_periodo NUMBER NOT NULL,
    fecha      DATE NOT NULL
);

ALTER TABLE periodo ADD CONSTRAINT periodo_pk PRIMARY KEY ( id_periodo );

ALTER TABLE periodo ADD CONSTRAINT periodo_fecha_un UNIQUE ( fecha );

CREATE TABLE propietario (
    id_propietario  NUMBER NOT NULL,
    cedula          NUMBER NOT NULL,
    nombre_completo VARCHAR2(100) NOT NULL
);

ALTER TABLE propietario ADD CONSTRAINT propietario_pk PRIMARY KEY ( id_propietario );

ALTER TABLE propietario ADD CONSTRAINT propietario_cedula_un UNIQUE ( cedula );

CREATE TABLE tratamiento (
    id_tratamiento          NUMBER NOT NULL,
    descripcion_tratamiento VARCHAR2(100) NOT NULL,
    costo_tratamiento       NUMBER NOT NULL
);

ALTER TABLE tratamiento ADD CONSTRAINT tratamiento_pk PRIMARY KEY ( id_tratamiento );


--  ERROR: UK name length exceeds maximum allowed length(30) 
ALTER TABLE tratamiento ADD CONSTRAINT tratamiento_descripcion_tratamiento_un UNIQUE ( descripcion_tratamiento );

ALTER TABLE clinica
    ADD CONSTRAINT clinica_municipio_fk FOREIGN KEY ( municipio_id_municipio )
        REFERENCES municipio ( id_municipio );

ALTER TABLE examen
    ADD CONSTRAINT examen_mascota_fk FOREIGN KEY ( mascota_id_mascota )
        REFERENCES mascota ( id_mascota );

ALTER TABLE examen
    ADD CONSTRAINT examen_periodo_fk FOREIGN KEY ( periodo_id_periodo )
        REFERENCES periodo ( id_periodo );

ALTER TABLE examen_tratamiento
    ADD CONSTRAINT examen_tratamiento_examen_fk FOREIGN KEY ( examen_id_examen )
        REFERENCES examen ( id_examen );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE examen_tratamiento
    ADD CONSTRAINT examen_tratamiento_tratamiento_fk FOREIGN KEY ( tratamiento_id_tratamiento )
        REFERENCES tratamiento ( id_tratamiento );

ALTER TABLE mascota
    ADD CONSTRAINT mascota_clinica_fk FOREIGN KEY ( clinica_id_clinica )
        REFERENCES clinica ( id_clinica );

ALTER TABLE mascota
    ADD CONSTRAINT mascota_propietario_fk FOREIGN KEY ( propietario_id_propietario )
        REFERENCES propietario ( id_propietario );

ALTER TABLE municipio
    ADD CONSTRAINT municipio_departamento_fk FOREIGN KEY ( departamento_id_departamento )
        REFERENCES departamento ( id_departamento );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             9
-- CREATE INDEX                             0
-- ALTER TABLE                             26
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   8
-- WARNINGS                                 0
