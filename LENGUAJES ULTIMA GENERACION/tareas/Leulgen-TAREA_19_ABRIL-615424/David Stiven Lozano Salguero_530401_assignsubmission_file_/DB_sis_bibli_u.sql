-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS sis_bibli_u CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sis_bibli_u;

-- PASO 1: Creación de tablas

-- Tabla AUTOR
CREATE TABLE AUTOR (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
) ENGINE=InnoDB;

-- Tabla LIBRO
CREATE TABLE LIBRO (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    anio INT,
    disponible TINYINT(1) DEFAULT 1,
    CONSTRAINT chk_disponible CHECK (disponible IN (0, 1))
) ENGINE=InnoDB;

-- Tabla LIBRO_AUTOR
CREATE TABLE LIBRO_AUTOR (
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES LIBRO(id_libro) ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES AUTOR(id_autor) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Tabla ESTUDIANTE
CREATE TABLE ESTUDIANTE (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    carrera VARCHAR(100)
) ENGINE=InnoDB;

-- Tabla PRESTAMO
CREATE TABLE PRESTAMO (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_libro INT NOT NULL,
    id_estudiante INT NOT NULL,
    fecha_prestamo DATETIME DEFAULT NOW(),
    fecha_devolucion DATETIME,
    FOREIGN KEY (id_libro) REFERENCES LIBRO(id_libro),
    FOREIGN KEY (id_estudiante) REFERENCES ESTUDIANTE(id_estudiante)
) ENGINE=InnoDB;


-- PASO 2: Inserción de datos de prueba

-- Insertar autores
INSERT INTO AUTOR (nombre, nacionalidad) VALUES
('Gabriel Garcia Marquez', 'Colombiana'),
('J.K. Rowling', 'Britanica'),
('Stephen King', 'Estadounidense');

-- Insertar libros
INSERT INTO LIBRO (titulo, anio, disponible) VALUES
('Cien anos de soledad', 1967, 1),
('Harry Potter y la piedra filosofal', 1997, 1),
('It', 1986, 1),
('El amor en los tiempos del colera', 1985, 1),
('Animales fantasticos y donde encontrarlos', 2001, 1);

-- Insertar relaciones en LIBRO_AUTOR
INSERT INTO LIBRO_AUTOR (id_libro, id_autor) VALUES
(1, 1), -- Cien anos de soledad - Gabriel Garcia Marquez
(2, 2), -- Harry Potter y la piedra filosofal - J.K. Rowling
(3, 3), -- It - Stephen King
(4, 1), -- El amor en los tiempos del colera - Gabriel Garcia Marquez
(5, 2); -- Animales fantasticos y donde encontrarlos - J.K. Rowling

-- Insertar estudiantes
INSERT INTO ESTUDIANTE (nombre, apellido, carrera) VALUES
('Juan', 'Perez', 'Ingenieria de Sistemas'),
('Maria', 'Gomez', 'Medicina'),
('Carlos', 'Lopez', 'Derecho'),
('Ana', 'Martinez', 'Arquitectura');

-- Insertar prestamos
INSERT INTO PRESTAMO (id_libro, id_estudiante, fecha_devolucion) VALUES
(1, 1, NULL), -- Prestamo activo
(2, 2, NULL), -- Prestamo activo
(3, 3, '2026-04-10 10:00:00'), -- Prestamo devuelto
(4, 1, NULL), -- Prestamo activo
(5, 4, '2026-04-12 15:30:00'), -- Prestamo devuelto
(1, 3, '2026-04-11 09:15:00'); -- Prestamo devuelto


-- PASO 3: Consultas

-- Consulta 1: Libros prestados actualmente

SELECT p.id_prestamo, l.titulo, e.nombre, e.apellido, p.fecha_prestamo
FROM LIBRO l
JOIN PRESTAMO p ON l.id_libro = p.id_libro
JOIN ESTUDIANTE e ON p.id_estudiante = e.id_estudiante
WHERE p.fecha_devolucion IS NULL;

-- Consulta 2: Estudiante(s) con más libros prestados

SELECT e.nombre, e.apellido, COUNT(p.id_prestamo) AS total_prestamos
FROM ESTUDIANTE e
JOIN PRESTAMO p ON e.id_estudiante = p.id_estudiante
GROUP BY e.id_estudiante
ORDER BY total_prestamos DESC
LIMIT 1;

-- Consulta 3: Libros que nunca han sido prestados

SELECT l.id_libro, l.titulo
FROM LIBRO l
LEFT JOIN PRESTAMO p ON l.id_libro = p.id_libro
WHERE p.id_prestamo IS NULL;

-- Consulta 4: Cantidad de libros por autor

SELECT a.id_autor, a.nombre, COUNT(la.id_libro) AS total_libros
FROM AUTOR a
JOIN LIBRO_AUTOR la ON a.id_autor = la.id_autor
GROUP BY a.id_autor
ORDER BY total_libros DESC;


-- PASO 4: Actualización y eliminación

-- Marcar préstamo como devuelto:

-- Verificar el estado actual del préstamo con id_prestamo = 3
SELECT
    p.id_prestamo,
    l.titulo AS libro,
    e.nombre AS estudiante,
    e.apellido,
    p.fecha_prestamo,
    p.fecha_devolucion
FROM
    PRESTAMO p
JOIN
    LIBRO l ON p.id_libro = l.id_libro
JOIN
    ESTUDIANTE e ON p.id_estudiante = e.id_estudiante
WHERE
    p.id_prestamo = 3;

-- Actualizar la fecha de devolucion del préstamo con id_prestamo = 3
UPDATE PRESTAMO
SET fecha_devolucion = NOW()
WHERE id_prestamo = 3;

-- Verificar el préstamo actualizado
SELECT
    p.id_prestamo,
    l.titulo AS libro,
    e.nombre AS estudiante,
    e.apellido,
    p.fecha_prestamo,
    p.fecha_devolucion
FROM
    PRESTAMO p
JOIN
    LIBRO l ON p.id_libro = l.id_libro
JOIN
    ESTUDIANTE e ON p.id_estudiante = e.id_estudiante
WHERE
    p.id_prestamo = 3;

-- Desactivar libro dañado:

-- Verificar el estado actual del libro con id_libro = 3
SELECT
    id_libro,
    titulo,
    CASE
        WHEN disponible = 1 THEN 'Disponible'
        ELSE 'No disponible'
    END AS estado
FROM
    LIBRO
WHERE
    id_libro = 3;

-- Desactivar el libro con id_libro = 3
UPDATE LIBRO
SET disponible = 0
WHERE id_libro = 3;

-- Verificar el libro actualizado
SELECT
    id_libro,
    titulo,
    CASE
        WHEN disponible = 1 THEN 'Disponible'
        ELSE 'No disponible'
    END AS estado
FROM
    LIBRO
WHERE
    id_libro = 3;