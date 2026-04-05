--------------------------------------------------------
-- Archivo creado  - sábado-septiembre-23-2023   
--------------------------------------------------------
DROP TYPE "LOGMNR$COL_GG_REC";
DROP TYPE "LOGMNR$COL_GG_RECS";
DROP TYPE "LOGMNR$GSBA_GG_REC";
DROP TYPE "LOGMNR$GSBA_GG_RECS";
DROP TYPE "LOGMNR$KEY_GG_REC";
DROP TYPE "LOGMNR$KEY_GG_RECS";
DROP TYPE "LOGMNR$SEQ_GG_REC";
DROP TYPE "LOGMNR$SEQ_GG_RECS";
DROP TYPE "LOGMNR$TAB_GG_REC";
DROP TYPE "LOGMNR$TAB_GG_RECS";
DROP TYPE "LOGMNR$USER_GG_REC";
DROP TYPE "LOGMNR$USER_GG_RECS";
DROP SEQUENCE "LOGMNR_DIDS$";
DROP SEQUENCE "LOGMNR_EVOLVE_SEQ$";
DROP SEQUENCE "LOGMNR_SEQ$";
DROP SEQUENCE "LOGMNR_UIDS$";
DROP SEQUENCE "MVIEW$_ADVSEQ_GENERIC";
DROP SEQUENCE "MVIEW$_ADVSEQ_ID";
DROP SEQUENCE "ROLLING_EVENT_SEQ$";
DROP TABLE "PROPIETARIO" cascade constraints;
DROP TABLE "PERIODO" cascade constraints;
DROP TABLE "MASCOTA" cascade constraints;
DROP TABLE "MUNICIPIO" cascade constraints;
DROP TABLE "EXAMEN_TRATAMIENTO" cascade constraints;
DROP TABLE "EXAMEN" cascade constraints;
DROP TABLE "DEPARTAMENTO" cascade constraints;
DROP TABLE "CLINICA" cascade constraints;
DROP TABLE "TRATAMIENTO" cascade constraints;
DROP VIEW "MVIEW_EVALUATIONS";
DROP VIEW "MVIEW_EXCEPTIONS";
DROP VIEW "MVIEW_FILTER";
DROP VIEW "MVIEW_FILTERINSTANCE";
DROP VIEW "MVIEW_LOG";
DROP VIEW "MVIEW_RECOMMENDATIONS";
DROP VIEW "MVIEW_WORKLOAD";
DROP VIEW "PRODUCT_PRIVS";
DROP VIEW "SCHEDULER_JOB_ARGS";
DROP VIEW "SCHEDULER_PROGRAM_ARGS";
DROP VIEW "VISTA1";
DROP VIEW "VISTA2";
DROP VIEW "VISTA3";
DROP VIEW "VISTA4";
DROP VIEW "VISTA5";
DROP FUNCTION "LOGMNR$COL_GG_TABF_PUBLIC";
DROP FUNCTION "LOGMNR$GSBA_GG_TABF_PUBLIC";
DROP FUNCTION "LOGMNR$KEY_GG_TABF_PUBLIC";
DROP FUNCTION "LOGMNR$SEQ_GG_TABF_PUBLIC";
DROP FUNCTION "LOGMNR$TAB_GG_TABF_PUBLIC";
DROP FUNCTION "LOGMNR$USER_GG_TABF_PUBLIC";
DROP SYNONYM "CATALOG";
DROP SYNONYM "COL";
DROP SYNONYM "PRODUCT_USER_PROFILE";
DROP SYNONYM "PUBLICSYN";
DROP SYNONYM "SYSCATALOG";
DROP SYNONYM "SYSFILES";
DROP SYNONYM "TAB";
DROP SYNONYM "TABQUOTAS";
--------------------------------------------------------
--  DDL for Type LOGMNR$COL_GG_REC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$COL_GG_REC" as object
(
LOGMNR_UID NUMBER,
OBJ# NUMBER,
MD_COL_NAME VARCHAR2(384),
MD_COL_NUM NUMBER,                 /* col# */
MD_COL_SEGCOL NUMBER,              /* segcol# */
MD_COL_TYPE NUMBER,                /* type# */
MD_COL_LEN NUMBER,
MD_COL_PREC NUMBER,                /* precision */
MD_COL_SCALE NUMBER,
MD_COL_CHARSETID NUMBER,           /* character set id */
MD_COL_CHARSETFORM NUMBER,         /* character set form */
MD_COL_ALT_TYPE VARCHAR2(4000),    /* adt type if any */
MD_COL_ALT_PREC NUMBER,            /* precision of the adt attribute */
MD_COL_ALT_CHAR_USED VARCHAR2(2),  /* charset used by the adt attribute */
MD_COL_ALT_LENGTH NUMBER,          /* length of the adt attribute */
MD_COL_ALT_XML_TYPE NUMBER,        /* 0/1. is xml_type column */
MD_COL_ALT_BINARYXML_TYPE NUMBER,  /* 0/1. is xml_type stored as binary */
MD_COL_ENC_ISENC VARCHAR2(3) ,     /* 'YES'/'NO' */
MD_COL_ENC_NOSALT VARCHAR2(3) ,    /* 'YES'/'NO' */
MD_COL_ENC_ISLOB VARCHAR2(3) ,     /* 'YES'/'NO' */
MD_COL_ALT_OBJECTXML_TYPE NUMBER,  /* 0/1 xml_type stored as object */
MD_COL_HASNOTNULLDEFAULT VARCHAR2(3) ,   /* 'YES'/'NO' */
MD_COL_ALT_TYPE_OWNER VARCHAR2(384),  /* owner of the adt type if any */
PROPERTY NUMBER,
XCOLTYPEFLAGS NUMBER,
XOPQTYPEFLAGS NUMBER,
EAFLAGS NUMBER,
XFQCOLNAME VARCHAR2(4000),
SPARE1  NUMBER,                    /* col_def.nullable, based on col$.null$ */
SPARE2  NUMBER,
SPARE3  NUMBER,
SPARE4  VARCHAR2(4000),
SPARE5  VARCHAR2(4000),
SPARE6  VARCHAR2(4000),
/* Following fields added in 12.1.0.2 */
OBJV# NUMBER,
INTCOL# NUMBER,
INTERVAL_LEADING_PRECISION NUMBER,
INTERVAL_TRAILING_PRECISION NUMBER,
TOID RAW(16),
TYPENAME VARCHAR2(384),
NUMINTCOLS NUMBER,
NUMATTRS NUMBER,
ADTORDER NUMBER,
LOGMNR_SPARE1 NUMBER,             /* col$.null$ */
LOGMNR_SPARE2 NUMBER,
LOGMNR_SPARE3 VARCHAR2(1000),
LOGMNR_SPARE4 DATE,
LOGMNR_SPARE5 NUMBER,
LOGMNR_SPARE6 NUMBER,
LOGMNR_SPARE7 NUMBER,
LOGMNR_SPARE8 NUMBER,
LOGMNR_SPARE9 NUMBER,
XTYPENAME VARCHAR2(4000),
XTOPINTCOL NUMBER,
XREFFEDTABLEOBJN NUMBER,
XREFFEDTABLEOBJV NUMBER,
XOPQTYPETYPE NUMBER,
XOPQLOBINTCOL NUMBER,
XOPQOBJINTCOL NUMBER,
XXMLINTCOL    NUMBER,
LOGMNRDERIVEDFLAGS NUMBER,
/* Following fields added in 12.2 */
COLLID      NUMBER,
COLLINTCOL#  NUMBER,
ACDRRESCOL# NUMBER
);
--------------------------------------------------------
--  DDL for Type LOGMNR$COL_GG_RECS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$COL_GG_RECS" AS TABLE OF  SYSTEM.LOGMNR$COL_GG_REC;
--------------------------------------------------------
--  DDL for Type LOGMNR$GSBA_GG_REC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$GSBA_GG_REC" AS OBJECT
(
LOGMNR_UID NUMBER,
NAME           VARCHAR2(384),
VALUE          VARCHAR2(4000),
LOGMNR_SPARE1  NUMBER,
LOGMNR_SPARE2  NUMBER,
LOGMNR_SPARE3  VARCHAR2(4000),
LOGMNR_SPARE4  DATE
);
--------------------------------------------------------
--  DDL for Type LOGMNR$GSBA_GG_RECS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$GSBA_GG_RECS" AS TABLE OF  SYSTEM.LOGMNR$GSBA_GG_REC;
--------------------------------------------------------
--  DDL for Type LOGMNR$KEY_GG_REC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$KEY_GG_REC" as object
(
LOGMNR_UID NUMBER,
KEY# NUMBER,                   /* index obj# or con# */
KEY_FLAGS NUMBER,              /* index or constraint */
KEY_NAME VARCHAR2(384),        /* index name or constraint name */
INDEX_OWNER# NUMBER,
INDEX_OWNERNAME VARCHAR2(384),
COLNAME VARCHAR2(384),
INTCOL# NUMBER,
which number,
KEY_ORDER VARCHAR2(10),              /* asc or desc */
KEYCOL_FLAGS NUMBER,           /* Column properties such as is_null */
SPARE1  NUMBER,
SPARE2  NUMBER,
SPARE3  NUMBER,
SPARE4  VARCHAR2(4000),
SPARE5  VARCHAR2(4000),
SPARE6  VARCHAR2(4000)
);
--------------------------------------------------------
--  DDL for Type LOGMNR$KEY_GG_RECS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$KEY_GG_RECS" AS TABLE OF  SYSTEM.LOGMNR$KEY_GG_REC;
--------------------------------------------------------
--  DDL for Type LOGMNR$SEQ_GG_REC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$SEQ_GG_REC" as object
(
LOGMNR_UID NUMBER,
OBJ# NUMBER,
NAME VARCHAR2(384),
OWNER# NUMBER,
OWNERNAME VARCHAR2(384),
FLAGS NUMBER,
MD_TAB_SEQCACHE NUMBER,
MD_TAB_SEQINCREMENTBY NUMBER,
SPARE1  NUMBER,
SPARE2  NUMBER,
SPARE3  NUMBER,
SPARE4  VARCHAR2(4000),
SPARE5  VARCHAR2(4000),
SPARE6  VARCHAR2(4000)
);
--------------------------------------------------------
--  DDL for Type LOGMNR$SEQ_GG_RECS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$SEQ_GG_RECS" AS TABLE OF  SYSTEM.LOGMNR$SEQ_GG_REC;
--------------------------------------------------------
--  DDL for Type LOGMNR$TAB_GG_REC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$TAB_GG_REC" as object
(
LOGMNR_UID NUMBER,
OBJ# NUMBER,
BASEOBJV# NUMBER,
MD_TAB_USERID NUMBER,                /* owner# */
MD_TAB_COLCOUNT NUMBER,              /* user column count */
MD_TAB_TOTAL_COL_NUM NUMBER,         /* kernal column count */
MD_TAB_LOG_GROUP_EXISTS NUMBER,      /* Any log group exists for this table */
MD_TAB_IOT VARCHAR2(3) ,             /* 'YES'/'NO' IS IOT? */
MD_TAB_IOT_OVERFLOW VARCHAR2(3) ,    /* 'YES'/'NO' IOT with overflow ? */
MD_TAB_PARTITION  VARCHAR2(3) ,      /* 'YES'/'NO' is partitioned ? */
MD_TAB_SUBPARTITION VARCHAR2(3) ,    /* 'YES'/'NO' is sub partitioned? */
MD_TAB_XMLTYPETABLE VARCHAR2(3) ,    /* 'YES'/'NO' is xmltype table? */
MD_TAB_OBJECTID NUMBER,              /* object id if table object */
MD_TAB_OWNER VARCHAR2(384),     /* owner name */
MD_TAB_NAME VARCHAR2(384),      /* table name */
MD_TAB_OBJTYPE VARCHAR2(384),   /* Object type name */
MD_TAB_SCN NUMBER,                   /* COMMIT_SCN of this table version */
TAB_FLAGS NUMBER,
TRIGFLAG NUMBER,
OBJ_FLAGS NUMBER,
PROPERTY NUMBER,
PARTTYPE NUMBER,
SUBPARTTYPE NUMBER,
SPARE1  NUMBER,
SPARE2  NUMBER,
SPARE3  NUMBER,
SPARE4  VARCHAR2(4000),
SPARE5  VARCHAR2(4000),
SPARE6  VARCHAR2(4000),
/* Following fields added in 12.1.0.2 */
LVLCNT NUMBER,
LVL1OBJ# NUMBER,
LVL2OBJ# NUMBER,
LVL1TYPE# NUMBER,
LVL2TYPE# NUMBER,
LVL1NAME  VARCHAR2(384),
LVL2NAME  VARCHAR2(384),
INTCOLS   NUMBER,
ASSOC#    NUMBER,
XIDUSN    NUMBER,
XIDSLT    NUMBER,
XIDSQN    NUMBER,
DROP_SCN  NUMBER,
FLAGS     NUMBER,
LOGMNR_SPARE1   NUMBER,
LOGMNR_SPARE2   NUMBER,
LOGMNR_SPARE3   VARCHAR2(1000),
LOGMNR_SPARE4   DATE,
LOGMNR_SPARE5   NUMBER,
LOGMNR_SPARE6   NUMBER,
LOGMNR_SPARE7   NUMBER,
LOGMNR_SPARE8   NUMBER,
LOGMNR_SPARE9   NUMBER,
UNSUPPORTEDCOLS  NUMBER,
COMPLEXTYPECOLS  NUMBER,
NTPARENTOBJNUM   NUMBER,
NTPARENTOBJVERSION NUMBER,
NTPARENTINTCOLNUM  NUMBER,
LOGMNRTLOFLAGS    NUMBER,
LOGMNRMCV VARCHAR2(30),
/* Following fields added in 12.2 */
ACDRFLAGS        NUMBER,                                    /* automatic CDR */
ACDRTSOBJ#       NUMBER,                                    /* automatic CDR */
ACDRROWTSINTCOL# NUMBER                                     /* automatic CDR */
);
--------------------------------------------------------
--  DDL for Type LOGMNR$TAB_GG_RECS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$TAB_GG_RECS" AS TABLE OF  SYSTEM.LOGMNR$TAB_GG_REC;
--------------------------------------------------------
--  DDL for Type LOGMNR$USER_GG_REC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$USER_GG_REC" AS OBJECT
(
LOGMNR_UID     NUMBER,
USERNAME       VARCHAR2(384),
USERID         NUMBER,
LOGMNR_SPARE1  NUMBER,
LOGMNR_SPARE2  NUMBER,
LOGMNR_SPARE3  VARCHAR2(4000),
LOGMNR_SPARE4  DATE
);
--------------------------------------------------------
--  DDL for Type LOGMNR$USER_GG_RECS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "LOGMNR$USER_GG_RECS" AS TABLE OF  SYSTEM.LOGMNR$USER_GG_REC;
--------------------------------------------------------
--  DDL for Sequence LOGMNR_DIDS$
--------------------------------------------------------

   CREATE SEQUENCE  "LOGMNR_DIDS$"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
--------------------------------------------------------
--  DDL for Sequence LOGMNR_EVOLVE_SEQ$
--------------------------------------------------------

   CREATE SEQUENCE  "LOGMNR_EVOLVE_SEQ$"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
--------------------------------------------------------
--  DDL for Sequence LOGMNR_SEQ$
--------------------------------------------------------

   CREATE SEQUENCE  "LOGMNR_SEQ$"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
--------------------------------------------------------
--  DDL for Sequence LOGMNR_UIDS$
--------------------------------------------------------

   CREATE SEQUENCE  "LOGMNR_UIDS$"  MINVALUE 100 MAXVALUE 99999 INCREMENT BY 1 START WITH 100 NOCACHE  ORDER  CYCLE  NOKEEP  NOSCALE  GLOBAL
--------------------------------------------------------
--  DDL for Sequence MVIEW$_ADVSEQ_GENERIC
--------------------------------------------------------

   CREATE SEQUENCE  "MVIEW$_ADVSEQ_GENERIC"  MINVALUE 1 MAXVALUE 4294967295 INCREMENT BY 1 START WITH 1 CACHE 50 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
--------------------------------------------------------
--  DDL for Sequence MVIEW$_ADVSEQ_ID
--------------------------------------------------------

   CREATE SEQUENCE  "MVIEW$_ADVSEQ_ID"  MINVALUE 1 MAXVALUE 4294967295 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
--------------------------------------------------------
--  DDL for Sequence ROLLING_EVENT_SEQ$
--------------------------------------------------------

   CREATE SEQUENCE  "ROLLING_EVENT_SEQ$"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
--------------------------------------------------------
--  DDL for Table PROPIETARIO
--------------------------------------------------------

  CREATE TABLE "PROPIETARIO" 
   (	"ID_PROPIETARIO" NUMBER, 
	"CEDULA" NUMBER, 
	"NOMBRE_COMPLETO" VARCHAR2(100)
   )
--------------------------------------------------------
--  DDL for Table PERIODO
--------------------------------------------------------

  CREATE TABLE "PERIODO" 
   (	"ID_PERIODO" NUMBER, 
	"FECHA" DATE
   )
--------------------------------------------------------
--  DDL for Table MASCOTA
--------------------------------------------------------

  CREATE TABLE "MASCOTA" 
   (	"ID_MASCOTA" NUMBER, 
	"NOMBRE_MASCOTA" VARCHAR2(100), 
	"CLINICA_ID_CLINICA" NUMBER, 
	"PROPIETARIO_ID_PROPIETARIO" NUMBER
   )
--------------------------------------------------------
--  DDL for Table MUNICIPIO
--------------------------------------------------------

  CREATE TABLE "MUNICIPIO" 
   (	"ID_MUNICIPIO" NUMBER, 
	"DESCRIPCION_MUNICIPIO" VARCHAR2(100), 
	"DEPARTAMENTO_ID_DEPARTAMENTO" NUMBER
   )
--------------------------------------------------------
--  DDL for Table EXAMEN_TRATAMIENTO
--------------------------------------------------------

  CREATE TABLE "EXAMEN_TRATAMIENTO" 
   (	"ID_EXAMEN_TRATAMIENTO" NUMBER, 
	"CANTIDAD_TRATAMIENTO" NUMBER, 
	"TRATAMIENTO_ID_TRATAMIENTO" NUMBER, 
	"EXAMEN_ID_EXAMEN" NUMBER
   )
--------------------------------------------------------
--  DDL for Table EXAMEN
--------------------------------------------------------

  CREATE TABLE "EXAMEN" 
   (	"ID_EXAMEN" NUMBER, 
	"PERIODO_ID_PERIODO" NUMBER, 
	"MASCOTA_ID_MASCOTA" NUMBER
   )
--------------------------------------------------------
--  DDL for Table DEPARTAMENTO
--------------------------------------------------------

  CREATE TABLE "DEPARTAMENTO" 
   (	"ID_DEPARTAMENTO" NUMBER, 
	"DESCRIPCION_DEPARTAMENTO" VARCHAR2(100)
   )
--------------------------------------------------------
--  DDL for Table CLINICA
--------------------------------------------------------

  CREATE TABLE "CLINICA" 
   (	"ID_CLINICA" NUMBER, 
	"NOMBRE_CLINICA" VARCHAR2(100), 
	"MUNICIPIO_ID_MUNICIPIO" NUMBER
   )
--------------------------------------------------------
--  DDL for Table TRATAMIENTO
--------------------------------------------------------

  CREATE TABLE "TRATAMIENTO" 
   (	"ID_TRATAMIENTO" NUMBER, 
	"DESCRIPCION_TRATAMIENTO" VARCHAR2(100), 
	"COSTO_TRATAMIENTO" NUMBER
   )
--------------------------------------------------------
--  DDL for View MVIEW_EVALUATIONS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "MVIEW_EVALUATIONS" ("RUNID", "MVIEW_OWNER", "MVIEW_NAME", "RANK", "STORAGE_IN_BYTES", "FREQUENCY", "CUMULATIVE_BENEFIT", "BENEFIT_TO_COST_RATIO") AS 
  select
  t1.runid# as runid,
  summary_owner AS mview_owner,
  summary_name AS mview_name,
  rank# as rank,
  storage_in_bytes,
  frequency,
  cumulative_benefit,
  benefit_to_cost_ratio
from SYSTEM.MVIEW$_ADV_OUTPUT t1, SYSTEM.MVIEW$_ADV_LOG t2, ALL_USERS u
where
  t1.runid# = t2.runid# and
  u.username = t2.uname and
  u.user_id = userenv('SCHEMAID') and
  t1.output_type = 1
order by t1.rank#

   COMMENT ON TABLE "MVIEW_EVALUATIONS"  IS 'This view gives DBA access to summary evaluation output'
--------------------------------------------------------
--  DDL for View MVIEW_EXCEPTIONS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "MVIEW_EXCEPTIONS" ("RUNID", "OWNER", "TABLE_NAME", "DIMENSION_NAME", "RELATIONSHIP", "BAD_ROWID") AS 
  select
  t1.runid# as runid,
  owner,
  table_name,
  dimension_name,
  relationship,
  bad_rowid
from SYSTEM.MVIEW$_ADV_EXCEPTIONS t1, SYSTEM.MVIEW$_ADV_LOG t2, ALL_USERS u
where
  t1.runid# = t2.runid# and
  u.username = t2.uname and
  u.user_id = userenv('SCHEMAID')

   COMMENT ON TABLE "MVIEW_EXCEPTIONS"  IS 'This view gives DBA access to dimension validation results'
--------------------------------------------------------
--  DDL for View MVIEW_FILTER
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "MVIEW_FILTER" ("FILTERID", "SUBFILTERNUM", "SUBFILTERTYPE", "STR_VALUE", "NUM_VALUE1", "NUM_VALUE2", "DATE_VALUE1", "DATE_VALUE2") AS 
  select
      a.filterid# as filterid,
      a.subfilternum# as subfilternum,
      decode(a.subfiltertype,1,'APPLICATION',2,'CARDINALITY',3,'LASTUSE',
                             4,'FREQUENCY',5,'USER',6,'PRIORITY',7,'BASETABLE',
                             8,'RESPONSETIME',9,'COLLECTIONID',10,'TRACENAME',
                             11,'SCHEMA','UNKNOWN') AS subfiltertype,
      a.str_value,
      to_number(decode(a.num_value1,-999,NULL,a.num_value1)) AS num_value1,
      to_number(decode(a.num_value2,-999,NULL,a.num_value2)) AS num_value2,
      a.date_value1,
      a.date_value2
   from system.mview$_adv_filter a, system.mview$_adv_log b, ALL_USERS u
   WHERE a.filterid# = b.runid#
   AND b.uname = u.username
   AND u.user_id = userenv('SCHEMAID')

   COMMENT ON TABLE "MVIEW_FILTER"  IS 'Workload filter records'
--------------------------------------------------------
--  DDL for View MVIEW_FILTERINSTANCE
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "MVIEW_FILTERINSTANCE" ("RUNID", "FILTERID", "SUBFILTERNUM", "SUBFILTERTYPE", "STR_VALUE", "NUM_VALUE1", "NUM_VALUE2", "DATE_VALUE1", "DATE_VALUE2") AS 
  select
      a.runid# as runid,
      a.filterid# as filterid,
      a.subfilternum# as subfilternum,
      decode(a.subfiltertype,1,'APPLICATION',2,'CARDINALITY',3,'LASTUSE',
                             4,'FREQUENCY',5,'USER',6,'PRIORITY',7,'BASETABLE',
                             8,'RESPONSETIME',9,'COLLECTIONID',10,'TRACENAME',
                             11,'SCHEMA','UNKNOWN') AS subfiltertype,
      a.str_value,
      to_number(decode(a.num_value1,-999,NULL,a.num_value1)) AS num_value1,
      to_number(decode(a.num_value2,-999,NULL,a.num_value2)) AS num_value2,
      a.date_value1,
      a.date_value2
   from system.mview$_adv_filterinstance a

   COMMENT ON TABLE "MVIEW_FILTERINSTANCE"  IS 'Workload filter instance records'
--------------------------------------------------------
--  DDL for View MVIEW_LOG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "MVIEW_LOG" ("ID", "FILTERID", "RUN_BEGIN", "RUN_END", "TYPE", "STATUS", "MESSAGE", "COMPLETED", "TOTAL", "ERROR_CODE") AS 
  select
      m.runid# as id,
      m.filterid# as filterid,
      m.run_begin,
      m.run_end,
      decode(m.run_type,1,'EVALUATE',2,'EVALUATE_W',3,'RECOMMEND',
                      4,'RECOMMEND_W',5,'VALIDATE',6,'WORKLOAD',
                      7,'FILTER','UNKNOWN') AS type,
      decode(m.status,0,'UNUSED',1,'CANCELLED',2,'IN_PROGRESS',3,'COMPLETED',
                    4,'ERROR','UNKNOWN') AS status,
      m.message,
      m.completed,
      m.total,
      m.error_code
   from system.mview$_adv_log m, all_users u
   where m.uname = u.username
   and   u.user_id = userenv('SCHEMAID')

   COMMENT ON TABLE "MVIEW_LOG"  IS 'Advisor session log'
--------------------------------------------------------
--  DDL for View MVIEW_RECOMMENDATIONS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "MVIEW_RECOMMENDATIONS" ("RUNID", "ALL_TABLES", "FACT_TABLES", "GROUPING_LEVELS", "QUERY_TEXT", "RECOMMENDATION_NUMBER", "RECOMMENDED_ACTION", "MVIEW_OWNER", "MVIEW_NAME", "STORAGE_IN_BYTES", "PCT_PERFORMANCE_GAIN", "BENEFIT_TO_COST_RATIO") AS 
  select
  t1.runid# as runid,
  t1.from_clause as all_tables,
  fact_tables,
  grouping_levels,
  query_text,
  rank# as recommendation_number,
  action_type as recommended_action,
  summary_owner as mview_owner,
  summary_name as mview_name,
  storage_in_bytes,
  pct_performance_gain,
  benefit_to_cost_ratio
from SYSTEM.MVIEW$_ADV_OUTPUT t1, SYSTEM.MVIEW$_ADV_LOG t2, ALL_USERS u
where
  t1.runid# = t2.runid# and
  u.username = t2.uname and
  u.user_id = userenv('SCHEMAID') and
  t1.output_type = 0
order by t1.rank#

   COMMENT ON TABLE "MVIEW_RECOMMENDATIONS"  IS 'This view gives DBA access to summary recommendations'
--------------------------------------------------------
--  DDL for View MVIEW_WORKLOAD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "MVIEW_WORKLOAD" ("WORKLOADID", "IMPORT_TIME", "QUERYID", "APPLICATION", "CARDINALITY", "RESULTSIZE", "LASTUSE", "FREQUENCY", "OWNER", "PRIORITY", "QUERY", "RESPONSETIME") AS 
  select
  a.collectionid# as workloadid,
  a.collecttime as import_time,
  a.queryid# as queryid,
  a.application,
  a.cardinality,
  a.resultsize,
  a.qdate as lastuse,
  a.frequency,
  a.uname as owner,
  a.priority,
  a.sql_text as query,
  a.exec_time as responsetime
from SYSTEM.MVIEW$_ADV_WORKLOAD A, SYSTEM.MVIEW$_ADV_LOG B, ALL_USERS D
WHERE a.collectionid# = b.runid#
AND b.uname = d.username
AND d.user_id = userenv('SCHEMAID')

   COMMENT ON TABLE "MVIEW_WORKLOAD"  IS 'This view gives DBA access to shared workload'
--------------------------------------------------------
--  DDL for View PRODUCT_PRIVS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "PRODUCT_PRIVS" ("PRODUCT", "USERID", "ATTRIBUTE", "SCOPE", "NUMERIC_VALUE", "CHAR_VALUE", "DATE_VALUE", "LONG_VALUE") AS 
  SELECT PRODUCT, USERID, ATTRIBUTE, SCOPE,
         NUMERIC_VALUE, CHAR_VALUE, DATE_VALUE, LONG_VALUE
  FROM SQLPLUS_PRODUCT_PROFILE
  WHERE USERID = 'PUBLIC' OR
        USERID LIKE SYS_CONTEXT('USERENV','CURRENT_USER')
--------------------------------------------------------
--  DDL for View SCHEDULER_JOB_ARGS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "SCHEDULER_JOB_ARGS" ("OWNER", "JOB_NAME", "ARGUMENT_NAME", "ARGUMENT_POSITION", "ARGUMENT_TYPE", "VALUE", "ANYDATA_VALUE", "OUT_ARGUMENT") AS 
  SELECT "OWNER","JOB_NAME","ARGUMENT_NAME","ARGUMENT_POSITION","ARGUMENT_TYPE","VALUE","ANYDATA_VALUE","OUT_ARGUMENT" FROM sys.all_scheduler_job_args
--------------------------------------------------------
--  DDL for View SCHEDULER_PROGRAM_ARGS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "SCHEDULER_PROGRAM_ARGS" ("OWNER", "PROGRAM_NAME", "ARGUMENT_NAME", "ARGUMENT_POSITION", "ARGUMENT_TYPE", "METADATA_ATTRIBUTE", "DEFAULT_VALUE", "DEFAULT_ANYDATA_VALUE", "OUT_ARGUMENT") AS 
  SELECT "OWNER","PROGRAM_NAME","ARGUMENT_NAME","ARGUMENT_POSITION","ARGUMENT_TYPE","METADATA_ATTRIBUTE","DEFAULT_VALUE","DEFAULT_ANYDATA_VALUE","OUT_ARGUMENT" FROM sys.all_scheduler_program_args
--------------------------------------------------------
--  DDL for View VISTA1
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "VISTA1" ("DESCRIPCION_DEPARTAMENTO", "TOTAL_CLINICAS") AS 
  SELECT c.descripcion_departamento, count(a.id_clinica) as Total_Clinicas
FROM clinica a 
INNER JOIN municipio b ON a.municipio_id_municipio = b.id_municipio
INNER JOIN departamento c ON b.departamento_id_departamento = c.id_departamento
GROUP BY c.descripcion_departamento
ORDER BY c.descripcion_departamento ASC
--------------------------------------------------------
--  DDL for View VISTA2
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "VISTA2" ("DESCRIPCION_MUNICIPIO", "NOMBRE_CLINICA", "TOTAL_MASCOTAS") AS 
  SELECT c.descripcion_municipio, b.nombre_clinica, count(a.id_mascota) as Total_Mascotas
FROM mascota a 
INNER JOIN clinica b ON a.clinica_id_clinica = b.id_clinica
INNER JOIN municipio c ON b.municipio_id_municipio = c.id_municipio
GROUP BY ROLLUP(c.descripcion_municipio, b.nombre_clinica)
ORDER BY c.descripcion_municipio, b.nombre_clinica
--------------------------------------------------------
--  DDL for View VISTA3
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "VISTA3" ("DESCRIPCION_MUNICIPIO", "DESCRIPCION_TRATAMIENTO", "TOTAL_EXAMEN_MASCOTA") AS 
  SELECT f.descripcion_municipio, b.descripcion_tratamiento, count(d.id_mascota) as Total_Examen_Mascota
FROM examen_tratamiento a 
INNER JOIN tratamiento b on b.id_tratamiento = a.tratamiento_id_tratamiento
INNER JOIN examen c on c.id_examen = a.examen_id_examen
INNER JOIN mascota d on d.id_mascota = c.mascota_id_mascota
INNER JOIN clinica e on e.id_clinica = d.clinica_id_clinica
INNER JOIN municipio f on f.id_municipio = e.municipio_id_municipio
INNER JOIN departamento g on g.id_departamento = f.departamento_id_departamento
WHERE g.descripcion_departamento != 'Santander' 
GROUP BY ROLLUP (f.descripcion_municipio, b.descripcion_tratamiento)
ORDER BY f.descripcion_municipio, b.descripcion_tratamiento
--------------------------------------------------------
--  DDL for View VISTA4
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "VISTA4" ("ANIO", "MES", "TOTAL_EXAMENES_MASCOTA") AS 
  SELECT EXTRACT(YEAR from b.fecha) as Anio, EXTRACT(MONTH from b.fecha) as Mes, count(c.id_mascota) as Total_Examenes_Mascota
FROM examen a 
INNER JOIN periodo b ON a.periodo_id_periodo = b.id_periodo
INNER JOIN mascota c ON a.mascota_id_mascota = c.id_mascota
GROUP BY EXTRACT(YEAR from b.fecha), EXTRACT(MONTH from b.fecha)
ORDER BY EXTRACT(YEAR from b.fecha), EXTRACT(MONTH from b.fecha)
--------------------------------------------------------
--  DDL for View VISTA5
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE VIEW "VISTA5" ("PROPIETARIO", "TOTAL_PAGO_ESTIMADO") AS 
  SELECT e.nombre_completo as Propietario, SUM(b.costo_tratamiento*a.cantidad_tratamiento) as Total_Pago_Estimado 
FROM examen_tratamiento a 
INNER JOIN tratamiento b on b.id_tratamiento = a.tratamiento_id_tratamiento
INNER JOIN examen c on c.id_examen = a.examen_id_examen
INNER JOIN mascota d on d.id_mascota = c.mascota_id_mascota
INNER JOIN propietario e on e.id_propietario = d.propietario_id_propietario
GROUP BY e.nombre_completo
HAVING SUM(b.costo_tratamiento*a.cantidad_tratamiento) > 200000
ORDER BY Total_Pago_Estimado
REM INSERTING into PROPIETARIO
SET DEFINE OFF;
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('1','8357492','Maria Lopez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('2','1628743','Juan Martinez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('3','9573168','Ana Garcia');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('4','4238971','Luis Rodriguez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('5','5897246','Laura Perez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('6','3461987','Carlos Fernandez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('7','7204659','Isabel Gonzalez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('8','2849735','Jose Ramirez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('9','6518372','Carmen Sanchez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('10','4195867','Manuel Torres');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('11','7932168','Patricia Ruiz');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('12','5284763','Miguel Herrera');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('13','3679128','Elena Castro');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('14','8462573','Antonio Morales');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('15','1356897','Rosa Ortega');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('16','9723418','Diego Jimenez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('17','6847321','Marta Silva');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('18','2951874','Javier Vargas');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('19','7183649','Sara Rios');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('20','4679251','Daniel Bravo');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('21','5721983','Laura Mendoza');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('22','8294671','Juan Garcia');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('23','1347259','Patricia Rodriguez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('24','6813492','Andres Torres');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('25','9148276','Ana Lopez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('26','3725619','Manuel Perez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('27','5467382','Carolina Sanchez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('28','1983472','Jorge Martinez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('29','6247853','Gabriela Fernandez');
Insert into PROPIETARIO (ID_PROPIETARIO,CEDULA,NOMBRE_COMPLETO) values ('30','7359164','Raul Gonzalez');
REM INSERTING into PERIODO
SET DEFINE OFF;
Insert into PERIODO (ID_PERIODO,FECHA) values ('1',to_date('01/01/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('2',to_date('15/02/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('3',to_date('20/03/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('4',to_date('05/04/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('5',to_date('18/05/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('6',to_date('23/06/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('7',to_date('30/07/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('8',to_date('14/08/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('9',to_date('29/09/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('10',to_date('12/10/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('11',to_date('25/11/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('12',to_date('31/12/21','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('37',to_date('04/01/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('49',to_date('05/01/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('73',to_date('06/01/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('13',to_date('07/01/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('61',to_date('08/01/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('25',to_date('13/01/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('38',to_date('17/02/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('50',to_date('18/02/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('14',to_date('19/02/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('62',to_date('20/02/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('74',to_date('21/02/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('26',to_date('22/02/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('75',to_date('01/03/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('63',to_date('03/03/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('27',to_date('09/03/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('39',to_date('22/03/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('51',to_date('25/03/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('15',to_date('26/03/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('52',to_date('01/04/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('16',to_date('03/04/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('64',to_date('04/04/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('28',to_date('06/04/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('40',to_date('07/04/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('76',to_date('10/04/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('53',to_date('12/05/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('77',to_date('13/05/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('17',to_date('14/05/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('29',to_date('15/05/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('65',to_date('17/05/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('41',to_date('20/05/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('18',to_date('21/06/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('78',to_date('22/06/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('54',to_date('23/06/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('30',to_date('24/06/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('66',to_date('26/06/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('42',to_date('27/06/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('67',to_date('01/07/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('43',to_date('03/07/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('19',to_date('04/07/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('79',to_date('05/07/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('55',to_date('06/07/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('31',to_date('08/07/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('68',to_date('14/08/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('44',to_date('16/08/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('20',to_date('17/08/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('80',to_date('18/08/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('56',to_date('19/08/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('32',to_date('21/08/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('33',to_date('02/09/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('21',to_date('20/09/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('57',to_date('22/09/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('69',to_date('27/09/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('45',to_date('28/09/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('22',to_date('09/10/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('70',to_date('02/10/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('46',to_date('10/10/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('34',to_date('11/10/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('58',to_date('12/10/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('71',to_date('24/11/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('47',to_date('25/11/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('35',to_date('26/11/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('23',to_date('28/11/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('59',to_date('30/11/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('36',to_date('29/12/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('72',to_date('27/12/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('24',to_date('30/12/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('48',to_date('31/12/22','DD/MM/RR'));
Insert into PERIODO (ID_PERIODO,FECHA) values ('60',to_date('01/12/22','DD/MM/RR'));
REM INSERTING into MASCOTA
SET DEFINE OFF;
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('1','Max','1','1');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('2','Luna','2','2');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('3','Bella','3','3');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('4','Charlie','4','4');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('5','Daisy','5','5');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('6','Rocky','6','6');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('7','Lucy','7','7');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('8','Buddy','8','8');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('9','Mia','9','9');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('10','Toby','10','10');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('11','Sophie','11','11');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('12','Oliver','12','12');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('13','Lily','13','13');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('14','Leo','14','14');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('15','Rosie','15','15');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('16','Milo','16','16');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('17','Zoe','17','17');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('18','Cody','18','18');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('19','Molly','19','19');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('20','Jasper','20','20');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('21','Chloe','1','21');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('22','Bear','2','22');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('23','Sadie','3','23');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('24','Duke','4','24');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('25','Coco','5','25');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('26','Bailey','6','26');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('27','Ruby','7','27');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('28','Gus','8','28');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('29','Penny','9','29');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('30','Teddy','10','30');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('31','Daisy','11','11');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('32','Oreo','12','12');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('33','Simba','13','13');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('34','Zoey','14','14');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('35','Louie','15','15');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('36','Rosie','16','16');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('37','Marley','17','17');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('38','Pepper','18','18');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('39','Remy','19','19');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('40','Ruby','20','20');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('41','Harley','1','21');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('42','Kiki','4','22');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('43','Winston','6','23');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('44','Mocha','7','24');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('45','Nala','9','25');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('46','Finn','13','26');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('47','Willow','15','27');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('48','Ziggy','17','28');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('49','Lily','18','29');
Insert into MASCOTA (ID_MASCOTA,NOMBRE_MASCOTA,CLINICA_ID_CLINICA,PROPIETARIO_ID_PROPIETARIO) values ('50','Cooper','19','30');
REM INSERTING into MUNICIPIO
SET DEFINE OFF;
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('1','Medellin','5');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('2','Abejorral','5');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('88','Bello','5');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('35','Anapoima','25');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('19','Alban','25');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('99','Bojaca','25');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('78','Baranoa','8');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('433','Malambo','8');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('758','Soledad','8');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('104','Boyaca','15');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('176','Chiquinquira','15');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('362','Iza','15');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('861','Velez','68');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('755','Socorro','68');
Insert into MUNICIPIO (ID_MUNICIPIO,DESCRIPCION_MUNICIPIO,DEPARTAMENTO_ID_DEPARTAMENTO) values ('895','Zapatoca','68');
REM INSERTING into EXAMEN_TRATAMIENTO
SET DEFINE OFF;
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('1','3','1','1');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('2','1','2','2');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('3','3','3','3');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('4','3','4','4');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('5','1','5','5');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('6','3','6','6');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('7','1','7','7');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('8','3','8','8');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('9','3','9','9');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('10','3','10','10');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('11','3','11','11');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('12','3','12','12');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('13','3','13','13');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('14','2','14','14');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('15','3','15','15');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('16','3','16','16');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('17','2','17','17');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('18','2','18','18');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('19','2','19','19');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('20','3','20','20');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('21','2','1','21');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('22','1','2','22');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('23','3','3','23');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('24','1','4','24');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('25','1','5','25');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('26','3','6','26');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('27','1','7','27');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('28','1','8','28');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('29','2','9','29');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('30','3','10','30');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('31','1','11','31');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('32','2','12','32');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('33','3','13','33');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('34','1','14','34');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('35','3','15','35');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('36','1','16','36');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('37','3','17','37');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('38','2','18','38');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('39','2','19','39');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('40','1','20','40');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('41','2','1','41');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('42','1','2','42');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('43','3','3','43');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('44','3','4','44');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('45','2','5','45');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('46','2','6','46');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('47','1','7','47');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('48','2','8','48');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('49','3','9','49');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('50','3','10','50');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('51','3','11','51');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('52','2','12','52');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('53','1','13','53');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('54','2','14','54');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('55','2','15','55');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('56','2','16','56');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('57','1','17','57');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('58','3','18','58');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('59','1','19','59');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('60','1','20','60');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('61','3','1','61');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('62','2','2','62');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('63','2','3','63');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('64','1','4','64');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('65','2','5','65');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('66','2','6','66');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('67','1','7','67');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('68','2','8','68');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('69','2','9','69');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('70','1','10','70');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('71','1','11','71');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('72','3','12','72');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('73','1','13','73');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('74','2','14','74');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('75','3','15','75');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('76','3','16','76');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('77','1','17','77');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('78','3','18','78');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('79','1','19','79');
Insert into EXAMEN_TRATAMIENTO (ID_EXAMEN_TRATAMIENTO,CANTIDAD_TRATAMIENTO,TRATAMIENTO_ID_TRATAMIENTO,EXAMEN_ID_EXAMEN) values ('80','2','20','80');
REM INSERTING into EXAMEN
SET DEFINE OFF;
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('1','1','1');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('2','2','2');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('3','3','3');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('4','4','4');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('5','5','5');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('6','6','6');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('7','7','7');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('8','8','8');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('9','9','9');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('10','10','10');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('11','11','11');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('12','12','12');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('13','13','13');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('14','14','14');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('15','15','15');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('16','16','16');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('17','17','17');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('18','18','18');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('19','19','19');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('20','20','20');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('21','21','21');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('22','22','22');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('23','23','23');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('24','24','24');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('25','25','25');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('26','26','26');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('27','27','27');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('28','28','28');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('29','29','29');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('30','30','30');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('31','31','31');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('32','32','32');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('33','33','33');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('34','34','34');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('35','35','35');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('36','36','36');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('37','37','37');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('38','38','38');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('39','39','39');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('40','40','40');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('41','41','41');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('42','42','42');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('43','43','43');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('44','44','44');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('45','45','45');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('46','46','46');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('47','47','47');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('48','48','48');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('49','49','49');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('50','50','50');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('51','51','31');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('52','52','32');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('53','53','33');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('54','54','34');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('55','55','35');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('56','56','36');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('57','57','37');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('58','58','38');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('59','59','39');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('60','60','40');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('61','61','41');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('62','62','42');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('63','63','43');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('64','64','44');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('65','65','45');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('66','66','46');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('67','67','47');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('68','68','48');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('69','69','49');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('70','70','50');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('71','71','41');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('72','72','42');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('73','73','43');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('74','74','44');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('75','75','45');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('76','76','46');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('77','77','47');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('78','78','48');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('79','79','49');
Insert into EXAMEN (ID_EXAMEN,PERIODO_ID_PERIODO,MASCOTA_ID_MASCOTA) values ('80','80','50');
REM INSERTING into DEPARTAMENTO
SET DEFINE OFF;
Insert into DEPARTAMENTO (ID_DEPARTAMENTO,DESCRIPCION_DEPARTAMENTO) values ('5','Antioquia');
Insert into DEPARTAMENTO (ID_DEPARTAMENTO,DESCRIPCION_DEPARTAMENTO) values ('25','Cundinamarca');
Insert into DEPARTAMENTO (ID_DEPARTAMENTO,DESCRIPCION_DEPARTAMENTO) values ('8','Atlántico');
Insert into DEPARTAMENTO (ID_DEPARTAMENTO,DESCRIPCION_DEPARTAMENTO) values ('15','Boyacá');
Insert into DEPARTAMENTO (ID_DEPARTAMENTO,DESCRIPCION_DEPARTAMENTO) values ('68','Santander');
REM INSERTING into CLINICA
SET DEFINE OFF;
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('1','VetCare Animal Clinic','1');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('2','PetHealth Wellness Center','2');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('3','Animal Wellness Clinic','88');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('4','Paws and Tails Veterinary Hospital','35');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('5','Furry Friends Veterinary Care','19');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('6','Heartland Pet Clinic','99');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('7','AnimalCare Plus Veterinary Center','78');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('8','Happy Paws Veterinary Hospital','433');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('9','Guardian Animal Hospital','758');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('10','Pet Wellness Oasis','104');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('11','Loving Care Animal Hospital','176');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('12','CompassionVet Clinic','362');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('13','Animal Health Haven','861');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('14','Tender Paws Veterinary Center','755');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('15','Furry Family Vet Care','895');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('16','Harmony Pet Hospital','1');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('17','VitalPet Wellness Clinic','35');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('18','Four-Legged Friends Veterinary Care','433');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('19','Gentle Hands Animal Hospital','176');
Insert into CLINICA (ID_CLINICA,NOMBRE_CLINICA,MUNICIPIO_ID_MUNICIPIO) values ('20','Pet Comfort Clinic','1');
REM INSERTING into TRATAMIENTO
SET DEFINE OFF;
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('1','Desparasitación','135000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('2','Vacunación','280000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('3','Esterilización','420000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('4','Cepillado dental','95000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('5','Baño y aseo','165000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('6','Terapia de comportamiento','370000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('7','Nutrición especializada','210000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('8','Fisioterapia','120000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('9','Acupuntura','320000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('10','Odontología veterinaria','450000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('11','Cirugía ortopédica','150000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('12','Tratamiento contra pulgas y garrapatas','88000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('13','Quiropráctica animal','275000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('14','Terapia de masajes','190000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('15','Electrocardiograma (ECG)','260000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('16','Rehabilitación postoperatoria','410000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('17','Terapia de ozono','380000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('18','Terapia de láser','200000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('19','Terapia de ultrasonido','480000');
Insert into TRATAMIENTO (ID_TRATAMIENTO,DESCRIPCION_TRATAMIENTO,COSTO_TRATAMIENTO) values ('20','Terapia de células madre','295000');
--------------------------------------------------------
--  DDL for Index PROPIETARIO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PROPIETARIO_PK" ON "PROPIETARIO" ("ID_PROPIETARIO")
--------------------------------------------------------
--  DDL for Index PROPIETARIO_CEDULA_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "PROPIETARIO_CEDULA_UN" ON "PROPIETARIO" ("CEDULA")
--------------------------------------------------------
--  DDL for Index PERIODO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PERIODO_PK" ON "PERIODO" ("ID_PERIODO")
--------------------------------------------------------
--  DDL for Index PERIODO_FECHA_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "PERIODO_FECHA_UN" ON "PERIODO" ("FECHA")
--------------------------------------------------------
--  DDL for Index MASCOTA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "MASCOTA_PK" ON "MASCOTA" ("ID_MASCOTA")
--------------------------------------------------------
--  DDL for Index MASCOTA_NOMBRE_MASCOTA_PROPIETARIO_ID_PROPIETARIO_CLINICA_ID_CLINICA_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "MASCOTA_NOMBRE_MASCOTA_PROPIETARIO_ID_PROPIETARIO_CLINICA_ID_CLINICA_UN" ON "MASCOTA" ("NOMBRE_MASCOTA", "PROPIETARIO_ID_PROPIETARIO")
--------------------------------------------------------
--  DDL for Index MUNICIPIO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "MUNICIPIO_PK" ON "MUNICIPIO" ("ID_MUNICIPIO")
--------------------------------------------------------
--  DDL for Index MUNICIPIO_DEPARTAMENTO_ID_DEPARTAMENTO_DESCRIPCION_MUNICIPIO_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "MUNICIPIO_DEPARTAMENTO_ID_DEPARTAMENTO_DESCRIPCION_MUNICIPIO_UN" ON "MUNICIPIO" ("DEPARTAMENTO_ID_DEPARTAMENTO", "DESCRIPCION_MUNICIPIO")
--------------------------------------------------------
--  DDL for Index EXAMEN_TRATAMIENTO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "EXAMEN_TRATAMIENTO_PK" ON "EXAMEN_TRATAMIENTO" ("ID_EXAMEN_TRATAMIENTO", "TRATAMIENTO_ID_TRATAMIENTO", "EXAMEN_ID_EXAMEN")
--------------------------------------------------------
--  DDL for Index EXAMEN_TRATAMIENTO_TRATAMIENTO_ID_TRATAMIENTO_EXAMEN_ID_EXAMEN_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "EXAMEN_TRATAMIENTO_TRATAMIENTO_ID_TRATAMIENTO_EXAMEN_ID_EXAMEN_UN" ON "EXAMEN_TRATAMIENTO" ("TRATAMIENTO_ID_TRATAMIENTO", "EXAMEN_ID_EXAMEN")
--------------------------------------------------------
--  DDL for Index EXAMEN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "EXAMEN_PK" ON "EXAMEN" ("ID_EXAMEN")
--------------------------------------------------------
--  DDL for Index EXAMEN_PERIODO_ID_PERIODO_MASCOTA_ID_MASCOTA_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "EXAMEN_PERIODO_ID_PERIODO_MASCOTA_ID_MASCOTA_UN" ON "EXAMEN" ("PERIODO_ID_PERIODO", "MASCOTA_ID_MASCOTA")
--------------------------------------------------------
--  DDL for Index DEPARTAMENTO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "DEPARTAMENTO_PK" ON "DEPARTAMENTO" ("ID_DEPARTAMENTO")
--------------------------------------------------------
--  DDL for Index DEPARTAMENTO_DESCRIPCION_DEPARTAMENTO_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "DEPARTAMENTO_DESCRIPCION_DEPARTAMENTO_UN" ON "DEPARTAMENTO" ("DESCRIPCION_DEPARTAMENTO")
--------------------------------------------------------
--  DDL for Index CLINICA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "CLINICA_PK" ON "CLINICA" ("ID_CLINICA")
--------------------------------------------------------
--  DDL for Index CLINICA_NOMBRE_CLINICA_MUNICIPIO_ID_MUNICIPIO_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "CLINICA_NOMBRE_CLINICA_MUNICIPIO_ID_MUNICIPIO_UN" ON "CLINICA" ("NOMBRE_CLINICA", "MUNICIPIO_ID_MUNICIPIO")
--------------------------------------------------------
--  DDL for Index TRATAMIENTO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "TRATAMIENTO_PK" ON "TRATAMIENTO" ("ID_TRATAMIENTO")
--------------------------------------------------------
--  DDL for Index TRATAMIENTO_DESCRIPCION_TRATAMIENTO_UN
--------------------------------------------------------

  CREATE UNIQUE INDEX "TRATAMIENTO_DESCRIPCION_TRATAMIENTO_UN" ON "TRATAMIENTO" ("DESCRIPCION_TRATAMIENTO")
--------------------------------------------------------
--  DDL for Function LOGMNR$COL_GG_TABF_PUBLIC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE FUNCTION "LOGMNR$COL_GG_TABF_PUBLIC" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
8
237 185
nkvJV1w6wH1y7mRApzf9mGuebNUwgxDILkhGfHQCmP8+Vi4fyqh3SG1Fyq+pCts1OlgnK761
YuzKBA4JE5DNwZzBIF/Y4ZM5eUlquVyTkOg+AodK3vQJt9NLvPITXbP42O37gO+zKr4BQEJk
ypwrP1U/Pf6MLZONN8LUaVqHCN87T14HqHs5taX7LhLXQ2lCVBE1Ll8dyB9CDOlbyvQS/lrb
+0n1pQi9IJAWySL85ChAqnTaqFJm0YeToD4lZ8UUPQqIZNoX0x73WK9OzsmdBrvEC97iduxe
PEXVkxF6xklPod6yOGBvW7DAFMBgf+LajDLVKOAwB2EAiKCXYMuTUTtMYYkCFFf4sj1rCpsj
TLth6TSru530aM2HP6bEbm3m
--------------------------------------------------------
--  DDL for Function LOGMNR$GSBA_GG_TABF_PUBLIC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE FUNCTION "LOGMNR$GSBA_GG_TABF_PUBLIC" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
8
206 171
6gxi/CQwK1I5Rfwuw/SXrOGpVRYwgwLI1yfbfHRGEjNe54OE4QwRZCoA20oG536tzgcBrj+1
xE3tE8jIhAoTlUdUmkdYMmZycO1SdiJZwwt/6BrM1wHXl/E5+3Ip2NXzC9j8v4+KjkD9d5AT
p05eEsEWjU1CBTMSpjZZrXzbgFl9QNnQ+zJGjSug21f76ajs78m6anxz7vFcTcem6XpAgKjc
EXzd/ijP8qiOqwblTfnXcRslJn3MljD02u+5fh9NBctOmnaw/tOjRCFPUhY8I9gCoMptjG7U
rHEIFzHOFyxBEdulRGq4ngSgcm7l2yOdSHgNM8rO2vUH4gozvJoLE1S8GBBzG/wrvHPhACQ/
2w==
--------------------------------------------------------
--  DDL for Function LOGMNR$KEY_GG_TABF_PUBLIC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE FUNCTION "LOGMNR$KEY_GG_TABF_PUBLIC" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
8
2a0 1a1
3O4I5hDO715d8A2tqbxMCflFW0owg/D319xqfC9Grfg+K6yE71zMvtNS45AyRXBk77WpI5v4
nUSfE2lbvUYgk3JHySIe28XxC3xIYYpPGQjxwa3GzPw0FN5aN6kerQQTHUBp29Dd+vLSgBaC
2pAFrq059ZvN0ZPN11XG/2RuDY7HaTQu/QffhnY8rVlNxpFmbkVidwtZQahx5qIFu9Uww/tv
o1AvhjaORi898/KiPtOqv7LpsPFbyNuMnZEG48cxtZuesMBJFP/bKtgU2DN69xiT8Pxf+N2n
g0D2ximYzZqwY/4dBQj9dyQDuXRFo40hdqtWw0L96zV6723aQ8Xp0cqBaZj2wWTI4+6Ikry9
zY0Mdm3bV8TYqsOa+zT4fnikGO0eYbTFHEiW9QUbl/UwzuERwk8p
--------------------------------------------------------
--  DDL for Function LOGMNR$SEQ_GG_TABF_PUBLIC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE FUNCTION "LOGMNR$SEQ_GG_TABF_PUBLIC" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
8
249 181
++dDv/cHZatK7/vHG9lvR8DQCpYwg/D3AEhqfHQC2h6ONoOvOeHvTNX1S5GDyajM4j8vkSVz
IMw+LbYS3goujprvmrB/LUpdBF8TVvjEqZpC7MCKPXWcGnTeL7ja8C2tcOdjOpRXkwL5NmPJ
B0KqMvwepdiQDY7HUDQrBddQC1lBqHGEogWkwRJ3+2+jUC+Gpo5GTazIWS0V551NkSl3+h0W
BhkPglLbvQDPzxWTnmu4ZuJIlTiNwTf1R0WxghyyKFjES9CJsCrGT8Fn7prlF4Mr5kx1YBGf
5xaODtRnmVJgb65RlKbAN9+Xxf2QnQjKQL99RZAgsEwGVKNfx9lFKwHLGUwzjOxmIAXXYd/Z
+L9osPQJjZYkNrD0pQ==
--------------------------------------------------------
--  DDL for Function LOGMNR$TAB_GG_TABF_PUBLIC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE FUNCTION "LOGMNR$TAB_GG_TABF_PUBLIC" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
8
22e 181
PRVt0FiLRPgjIhZlCZcQhnOHXQ4wgzJp2UhGfHSKrQ843hKm3gKD9swoFAS4jVcW0CsSl7W1
6banVWdjktOVM18XyRjY4ZM5eRdquSp0ZdfHl3KJPBYqPi9LXIwum30Qh7ymgO+zTKj+R1N2
nSs/TPnknfYLwcUdAfBryDQGEIMisMuE9XT5ix3sudhHa5tLJRjsBIDKlqL7zk2CH0C1NRAZ
XrP7WgavVdNS3Yikz88VupZG21hTuAGspJBgCagmNWIwi9pgCIWP3rxF4p+uMps/ABEg+MBP
6Iykm62kO6hWhVHJXkfKF/jrQFjYBTTzatr1VTcOXt/AFuagDR7isNtb//lnXh8TXyAFWyCT
ubv6GXL0aM0PP/t+DfSl
--------------------------------------------------------
--  DDL for Function LOGMNR$USER_GG_TABF_PUBLIC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE FUNCTION "LOGMNR$USER_GG_TABF_PUBLIC" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
8
272 191
Vc+i+Mga8m7/BSlvXl0J+GmParYwg/D319wCfC8CTE6Ot30G8QRR0WzR8ohw8Z/y6DuL4pL5
IDjZApnCaZgeKa1OTjLj2B2tOYZg2ZuOAPKrxo7DeBqtn0Ahw0tubS36jP4xc+d2eQebdJMD
c/U0JxdiAl0qIPzsltBjeoGAEsxUk0aubCMJmysgc2d8ojil6ixQ37D7RA0HWMkh27QdOuXF
vSwuufDunMMT8Hue9dvy4vRXj+PhuyylJSukStsxyIb234EahCXyrjDlnzbC91eoU7v5sb4D
OvtDmggQCEViyhFXwspP9P0dOObin8JENsDJeFZYr/oVAgSHa97LRKvNZgd+f//XHlpEAOP4
rNm5mF0wTCABbb7tc5c7uo09M+79i7en8g==
--------------------------------------------------------
--  DDL for Synonymn CATALOG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE SYNONYM "CATALOG" FOR "CATALOG"
--------------------------------------------------------
--  DDL for Synonymn COL
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE SYNONYM "COL" FOR "COL"
--------------------------------------------------------
--  DDL for Synonymn PRODUCT_USER_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE SYNONYM "PRODUCT_USER_PROFILE" FOR "SQLPLUS_PRODUCT_PROFILE"
--------------------------------------------------------
--  DDL for Synonymn PUBLICSYN
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE SYNONYM "PUBLICSYN" FOR "PUBLICSYN"
--------------------------------------------------------
--  DDL for Synonymn SYSCATALOG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE SYNONYM "SYSCATALOG" FOR "SYSCATALOG"
--------------------------------------------------------
--  DDL for Synonymn SYSFILES
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE SYNONYM "SYSFILES" FOR "SYSFILES"
--------------------------------------------------------
--  DDL for Synonymn TAB
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE SYNONYM "TAB" FOR "TAB"
--------------------------------------------------------
--  DDL for Synonymn TABQUOTAS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE SYNONYM "TABQUOTAS" FOR "TABQUOTAS"
--------------------------------------------------------
--  Constraints for Table PROPIETARIO
--------------------------------------------------------

  ALTER TABLE "PROPIETARIO" MODIFY ("ID_PROPIETARIO" NOT NULL ENABLE)
  ALTER TABLE "PROPIETARIO" MODIFY ("CEDULA" NOT NULL ENABLE)
  ALTER TABLE "PROPIETARIO" MODIFY ("NOMBRE_COMPLETO" NOT NULL ENABLE)
  ALTER TABLE "PROPIETARIO" ADD CONSTRAINT "PROPIETARIO_PK" PRIMARY KEY ("ID_PROPIETARIO")
  USING INDEX  ENABLE
  ALTER TABLE "PROPIETARIO" ADD CONSTRAINT "PROPIETARIO_CEDULA_UN" UNIQUE ("CEDULA")
  USING INDEX  ENABLE
--------------------------------------------------------
--  Constraints for Table PERIODO
--------------------------------------------------------

  ALTER TABLE "PERIODO" MODIFY ("ID_PERIODO" NOT NULL ENABLE)
  ALTER TABLE "PERIODO" MODIFY ("FECHA" NOT NULL ENABLE)
  ALTER TABLE "PERIODO" ADD CONSTRAINT "PERIODO_PK" PRIMARY KEY ("ID_PERIODO")
  USING INDEX  ENABLE
  ALTER TABLE "PERIODO" ADD CONSTRAINT "PERIODO_FECHA_UN" UNIQUE ("FECHA")
  USING INDEX  ENABLE
--------------------------------------------------------
--  Constraints for Table MASCOTA
--------------------------------------------------------

  ALTER TABLE "MASCOTA" MODIFY ("ID_MASCOTA" NOT NULL ENABLE)
  ALTER TABLE "MASCOTA" MODIFY ("NOMBRE_MASCOTA" NOT NULL ENABLE)
  ALTER TABLE "MASCOTA" MODIFY ("CLINICA_ID_CLINICA" NOT NULL ENABLE)
  ALTER TABLE "MASCOTA" MODIFY ("PROPIETARIO_ID_PROPIETARIO" NOT NULL ENABLE)
  ALTER TABLE "MASCOTA" ADD CONSTRAINT "MASCOTA_PK" PRIMARY KEY ("ID_MASCOTA")
  USING INDEX  ENABLE
  ALTER TABLE "MASCOTA" ADD CONSTRAINT "MASCOTA_NOMBRE_MASCOTA_PROPIETARIO_ID_PROPIETARIO_CLINICA_ID_CLINICA_UN" UNIQUE ("NOMBRE_MASCOTA", "PROPIETARIO_ID_PROPIETARIO")
  USING INDEX  ENABLE
--------------------------------------------------------
--  Constraints for Table MUNICIPIO
--------------------------------------------------------

  ALTER TABLE "MUNICIPIO" MODIFY ("ID_MUNICIPIO" NOT NULL ENABLE)
  ALTER TABLE "MUNICIPIO" MODIFY ("DESCRIPCION_MUNICIPIO" NOT NULL ENABLE)
  ALTER TABLE "MUNICIPIO" MODIFY ("DEPARTAMENTO_ID_DEPARTAMENTO" NOT NULL ENABLE)
  ALTER TABLE "MUNICIPIO" ADD CONSTRAINT "MUNICIPIO_PK" PRIMARY KEY ("ID_MUNICIPIO")
  USING INDEX  ENABLE
  ALTER TABLE "MUNICIPIO" ADD CONSTRAINT "MUNICIPIO_DEPARTAMENTO_ID_DEPARTAMENTO_DESCRIPCION_MUNICIPIO_UN" UNIQUE ("DEPARTAMENTO_ID_DEPARTAMENTO", "DESCRIPCION_MUNICIPIO")
  USING INDEX  ENABLE
--------------------------------------------------------
--  Constraints for Table EXAMEN_TRATAMIENTO
--------------------------------------------------------

  ALTER TABLE "EXAMEN_TRATAMIENTO" MODIFY ("ID_EXAMEN_TRATAMIENTO" NOT NULL ENABLE)
  ALTER TABLE "EXAMEN_TRATAMIENTO" MODIFY ("CANTIDAD_TRATAMIENTO" NOT NULL ENABLE)
  ALTER TABLE "EXAMEN_TRATAMIENTO" MODIFY ("TRATAMIENTO_ID_TRATAMIENTO" NOT NULL ENABLE)
  ALTER TABLE "EXAMEN_TRATAMIENTO" MODIFY ("EXAMEN_ID_EXAMEN" NOT NULL ENABLE)
  ALTER TABLE "EXAMEN_TRATAMIENTO" ADD CONSTRAINT "EXAMEN_TRATAMIENTO_PK" PRIMARY KEY ("ID_EXAMEN_TRATAMIENTO", "TRATAMIENTO_ID_TRATAMIENTO", "EXAMEN_ID_EXAMEN")
  USING INDEX  ENABLE
  ALTER TABLE "EXAMEN_TRATAMIENTO" ADD CONSTRAINT "EXAMEN_TRATAMIENTO_TRATAMIENTO_ID_TRATAMIENTO_EXAMEN_ID_EXAMEN_UN" UNIQUE ("TRATAMIENTO_ID_TRATAMIENTO", "EXAMEN_ID_EXAMEN")
  USING INDEX  ENABLE
--------------------------------------------------------
--  Constraints for Table EXAMEN
--------------------------------------------------------

  ALTER TABLE "EXAMEN" MODIFY ("ID_EXAMEN" NOT NULL ENABLE)
  ALTER TABLE "EXAMEN" MODIFY ("PERIODO_ID_PERIODO" NOT NULL ENABLE)
  ALTER TABLE "EXAMEN" MODIFY ("MASCOTA_ID_MASCOTA" NOT NULL ENABLE)
  ALTER TABLE "EXAMEN" ADD CONSTRAINT "EXAMEN_PK" PRIMARY KEY ("ID_EXAMEN")
  USING INDEX  ENABLE
  ALTER TABLE "EXAMEN" ADD CONSTRAINT "EXAMEN_PERIODO_ID_PERIODO_MASCOTA_ID_MASCOTA_UN" UNIQUE ("PERIODO_ID_PERIODO", "MASCOTA_ID_MASCOTA")
  USING INDEX  ENABLE
--------------------------------------------------------
--  Constraints for Table DEPARTAMENTO
--------------------------------------------------------

  ALTER TABLE "DEPARTAMENTO" MODIFY ("ID_DEPARTAMENTO" NOT NULL ENABLE)
  ALTER TABLE "DEPARTAMENTO" MODIFY ("DESCRIPCION_DEPARTAMENTO" NOT NULL ENABLE)
  ALTER TABLE "DEPARTAMENTO" ADD CONSTRAINT "DEPARTAMENTO_PK" PRIMARY KEY ("ID_DEPARTAMENTO")
  USING INDEX  ENABLE
  ALTER TABLE "DEPARTAMENTO" ADD CONSTRAINT "DEPARTAMENTO_DESCRIPCION_DEPARTAMENTO_UN" UNIQUE ("DESCRIPCION_DEPARTAMENTO")
  USING INDEX  ENABLE
--------------------------------------------------------
--  Constraints for Table CLINICA
--------------------------------------------------------

  ALTER TABLE "CLINICA" MODIFY ("ID_CLINICA" NOT NULL ENABLE)
  ALTER TABLE "CLINICA" MODIFY ("NOMBRE_CLINICA" NOT NULL ENABLE)
  ALTER TABLE "CLINICA" MODIFY ("MUNICIPIO_ID_MUNICIPIO" NOT NULL ENABLE)
  ALTER TABLE "CLINICA" ADD CONSTRAINT "CLINICA_PK" PRIMARY KEY ("ID_CLINICA")
  USING INDEX  ENABLE
  ALTER TABLE "CLINICA" ADD CONSTRAINT "CLINICA_NOMBRE_CLINICA_MUNICIPIO_ID_MUNICIPIO_UN" UNIQUE ("NOMBRE_CLINICA", "MUNICIPIO_ID_MUNICIPIO")
  USING INDEX  ENABLE
--------------------------------------------------------
--  Constraints for Table TRATAMIENTO
--------------------------------------------------------

  ALTER TABLE "TRATAMIENTO" MODIFY ("ID_TRATAMIENTO" NOT NULL ENABLE)
  ALTER TABLE "TRATAMIENTO" MODIFY ("DESCRIPCION_TRATAMIENTO" NOT NULL ENABLE)
  ALTER TABLE "TRATAMIENTO" MODIFY ("COSTO_TRATAMIENTO" NOT NULL ENABLE)
  ALTER TABLE "TRATAMIENTO" ADD CONSTRAINT "TRATAMIENTO_PK" PRIMARY KEY ("ID_TRATAMIENTO")
  USING INDEX  ENABLE
  ALTER TABLE "TRATAMIENTO" ADD CONSTRAINT "TRATAMIENTO_DESCRIPCION_TRATAMIENTO_UN" UNIQUE ("DESCRIPCION_TRATAMIENTO")
  USING INDEX  ENABLE
--------------------------------------------------------
--  Ref Constraints for Table MASCOTA
--------------------------------------------------------

  ALTER TABLE "MASCOTA" ADD CONSTRAINT "MASCOTA_CLINICA_FK" FOREIGN KEY ("CLINICA_ID_CLINICA")
	  REFERENCES "CLINICA" ("ID_CLINICA") ENABLE
  ALTER TABLE "MASCOTA" ADD CONSTRAINT "MASCOTA_PROPIETARIO_FK" FOREIGN KEY ("PROPIETARIO_ID_PROPIETARIO")
	  REFERENCES "PROPIETARIO" ("ID_PROPIETARIO") ENABLE
--------------------------------------------------------
--  Ref Constraints for Table MUNICIPIO
--------------------------------------------------------

  ALTER TABLE "MUNICIPIO" ADD CONSTRAINT "MUNICIPIO_DEPARTAMENTO_FK" FOREIGN KEY ("DEPARTAMENTO_ID_DEPARTAMENTO")
	  REFERENCES "DEPARTAMENTO" ("ID_DEPARTAMENTO") ENABLE
--------------------------------------------------------
--  Ref Constraints for Table EXAMEN_TRATAMIENTO
--------------------------------------------------------

  ALTER TABLE "EXAMEN_TRATAMIENTO" ADD CONSTRAINT "EXAMEN_TRATAMIENTO_EXAMEN_FK" FOREIGN KEY ("EXAMEN_ID_EXAMEN")
	  REFERENCES "EXAMEN" ("ID_EXAMEN") ENABLE
  ALTER TABLE "EXAMEN_TRATAMIENTO" ADD CONSTRAINT "EXAMEN_TRATAMIENTO_TRATAMIENTO_FK" FOREIGN KEY ("TRATAMIENTO_ID_TRATAMIENTO")
	  REFERENCES "TRATAMIENTO" ("ID_TRATAMIENTO") ENABLE
--------------------------------------------------------
--  Ref Constraints for Table EXAMEN
--------------------------------------------------------

  ALTER TABLE "EXAMEN" ADD CONSTRAINT "EXAMEN_MASCOTA_FK" FOREIGN KEY ("MASCOTA_ID_MASCOTA")
	  REFERENCES "MASCOTA" ("ID_MASCOTA") ENABLE
  ALTER TABLE "EXAMEN" ADD CONSTRAINT "EXAMEN_PERIODO_FK" FOREIGN KEY ("PERIODO_ID_PERIODO")
	  REFERENCES "PERIODO" ("ID_PERIODO") ENABLE
--------------------------------------------------------
--  Ref Constraints for Table CLINICA
--------------------------------------------------------

  ALTER TABLE "CLINICA" ADD CONSTRAINT "CLINICA_MUNICIPIO_FK" FOREIGN KEY ("MUNICIPIO_ID_MUNICIPIO")
	  REFERENCES "MUNICIPIO" ("ID_MUNICIPIO") ENABLE
