CREATE OR REPLACE VIEW Vista1 AS
SELECT c.descripcion_departamento, count(a.id_clinica) as Total_Clinicas
FROM clinica a 
INNER JOIN municipio b ON a.municipio_id_municipio = b.id_municipio
INNER JOIN departamento c ON b.departamento_id_departamento = c.id_departamento
GROUP BY c.descripcion_departamento
ORDER BY c.descripcion_departamento ASC 
;

SELECT * FROM vista1;

CREATE OR REPLACE VIEW Vista2 AS
SELECT c.descripcion_municipio, b.nombre_clinica, count(a.id_mascota) as Total_Mascotas
FROM mascota a 
INNER JOIN clinica b ON a.clinica_id_clinica = b.id_clinica
INNER JOIN municipio c ON b.municipio_id_municipio = c.id_municipio
GROUP BY ROLLUP(c.descripcion_municipio, b.nombre_clinica)
ORDER BY c.descripcion_municipio, b.nombre_clinica
;

SELECT * FROM vista2;

CREATE OR REPLACE VIEW Vista3 AS
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
;

SELECT * FROM vista3;

CREATE OR REPLACE VIEW Vista4 AS
SELECT EXTRACT(YEAR from b.fecha) as Anio, EXTRACT(MONTH from b.fecha) as Mes, count(c.id_mascota) as Total_Examenes_Mascota
FROM examen a 
INNER JOIN periodo b ON a.periodo_id_periodo = b.id_periodo
INNER JOIN mascota c ON a.mascota_id_mascota = c.id_mascota
GROUP BY EXTRACT(YEAR from b.fecha), EXTRACT(MONTH from b.fecha)
ORDER BY EXTRACT(YEAR from b.fecha), EXTRACT(MONTH from b.fecha)
;

SELECT * FROM vista4;

CREATE OR REPLACE VIEW Vista5 AS
SELECT e.nombre_completo as Propietario, SUM(b.costo_tratamiento*a.cantidad_tratamiento) as Total_Pago_Estimado 
FROM examen_tratamiento a 
INNER JOIN tratamiento b on b.id_tratamiento = a.tratamiento_id_tratamiento
INNER JOIN examen c on c.id_examen = a.examen_id_examen
INNER JOIN mascota d on d.id_mascota = c.mascota_id_mascota
INNER JOIN propietario e on e.id_propietario = d.propietario_id_propietario
GROUP BY e.nombre_completo
HAVING SUM(b.costo_tratamiento*a.cantidad_tratamiento) > 200000
ORDER BY Total_Pago_Estimado
;

SELECT * FROM vista5;




