-- ================================================
-- TALLER SESION 7 - BD: taller_s7
-- Importar en phpMyAdmin: Importar > este archivo
-- ================================================

CREATE DATABASE IF NOT EXISTS taller_s7 CHARACTER SET utf8mb4;
USE taller_s7;

-- ------------------------------------------------
-- TABLAS: Sistema de Productos (E5)
-- ------------------------------------------------

CREATE TABLE IF NOT EXISTS categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(60) NOT NULL,
  descripcion  TEXT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS producto (
  id_producto  INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(100) NOT NULL,
  precio       DECIMAL(12,2) NOT NULL,
  stock        INT NOT NULL DEFAULT 0,
  activo       TINYINT(1) DEFAULT 1,
  id_categoria INT NOT NULL,
  FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
) ENGINE=InnoDB;

-- ------------------------------------------------
-- TABLAS: Sistema de Biblioteca (E8)
-- ------------------------------------------------

CREATE TABLE IF NOT EXISTS autor (
  id_autor INT AUTO_INCREMENT PRIMARY KEY,
  nombre   VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS libro (
  id_libro INT AUTO_INCREMENT PRIMARY KEY,
  titulo   VARCHAR(100) NOT NULL,
  activo   TINYINT(4) DEFAULT 1
) ENGINE=InnoDB;

-- Tabla puente relacion N:M LIBRO-AUTOR
CREATE TABLE IF NOT EXISTS libro_autor (
  id_libro INT NOT NULL,
  id_autor INT NOT NULL,
  PRIMARY KEY (id_libro, id_autor),
  FOREIGN KEY (id_libro) REFERENCES libro(id_libro),
  FOREIGN KEY (id_autor) REFERENCES autor(id_autor)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS estudiante (
  id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS prestamo (
  id_prestamo      INT AUTO_INCREMENT PRIMARY KEY,
  id_estudiante    INT  DEFAULT NULL,
  id_libro         INT  DEFAULT NULL,
  fecha_prestamo   DATE DEFAULT NULL,
  fecha_devolucion DATE DEFAULT NULL,
  FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
  FOREIGN KEY (id_libro)      REFERENCES libro(id_libro)
) ENGINE=InnoDB;

-- ------------------------------------------------
-- INSERT: Categorias y Productos (E5)
-- ------------------------------------------------

INSERT INTO categoria (nombre, descripcion) VALUES
  ('Bebidas',    'Productos liquidos para consumo'),
  ('Alimentos',  'Comida en general'),
  ('Aseo',       'Productos de limpieza personal y hogar'),
  ('Tecnologia', 'Dispositivos electronicos y accesorios');

INSERT INTO producto (nombre, precio, stock, activo, id_categoria) VALUES
  ('Cafe',    5750.00, 10, 1, 1),
  ('Leche',   4600.00, 15, 0, 1),
  ('Azucar',  3000.00, 20, 1, 2),
  ('Pan',     2000.00, 30, 1, 2),
  ('Jabon',   2500.00, 50, 1, 3),
  ('Shampoo', 8000.00, 25, 1, 3),
  ('Mouse',  20000.00,  5, 1, 4),
  ('Teclado',50000.00,  3, 1, 4);

-- ------------------------------------------------
-- INSERT: Sistema Biblioteca (E8)
-- ------------------------------------------------

INSERT INTO autor (nombre) VALUES
  ('Gabriel Garcia Marquez'),
  ('Mario Vargas Llosa'),
  ('Julio Cortazar');

INSERT INTO libro (titulo, activo) VALUES
  ('Cien anios de soledad',       1),
  ('La ciudad y los perros',      1),
  ('Rayuela',                     1),
  ('El otonio del patriarca',     1),
  ('Pantaleon y las visitadoras', 1);

INSERT INTO libro_autor (id_libro, id_autor) VALUES
  (1,1),(2,2),(3,3),(4,1),(5,2);

INSERT INTO estudiante (nombre) VALUES
  ('Juan Perez'),
  ('Maria Lopez'),
  ('Carlos Ruiz'),
  ('Ana Torres');

INSERT INTO prestamo (id_estudiante, id_libro, fecha_prestamo, fecha_devolucion) VALUES
  (1, 1, '2024-01-01', NULL),
  (2, 2, '2024-01-02', NULL),
  (3, 3, '2024-01-03', '2024-01-10'),
  (1, 2, '2024-01-04', NULL),
  (2, 3, '2024-01-05', NULL),
  (4, 1, '2024-01-06', '2024-01-12');

-- ------------------------------------------------
-- SELECT E6 - Ejecuta cada una y toma captura
-- ------------------------------------------------

-- a) Productos con stock > 0, ordenados por precio DESC
SELECT nombre, precio, stock, id_categoria
FROM producto
WHERE stock > 0
ORDER BY precio DESC;

-- b) Los 3 productos mas baratos de Bebidas (id_categoria=1)
SELECT nombre, precio, stock
FROM producto
WHERE id_categoria = 1
ORDER BY precio ASC
LIMIT 3;

-- c) Productos que contienen 'Cafe' en el nombre
SELECT id_producto, nombre, precio, stock
FROM producto
WHERE nombre LIKE '%Cafe%';

-- d) Precio maximo, minimo y promedio de productos activos
SELECT
    MAX(precio)        AS precio_maximo,
    MIN(precio)        AS precio_minimo,
    ROUND(AVG(precio),2) AS precio_promedio
FROM producto
WHERE activo = 1;

-- ------------------------------------------------
-- UPDATE / DELETE E7
-- ------------------------------------------------

-- a) SELECT antes del UPDATE (verificar precios categoria 1)
SELECT id_producto, nombre, precio FROM producto WHERE id_categoria = 1;

-- Aumentar 15% los precios de categoria 1 (Bebidas)
UPDATE producto
SET precio = precio * 1.15
WHERE id_categoria = 1;

-- SELECT despues del UPDATE (verificar cambio)
SELECT id_producto, nombre, precio FROM producto WHERE id_categoria = 1;

-- b) Soft delete producto id=3 (Leche)
UPDATE producto SET activo = 0 WHERE id_producto = 3;

-- c) Eliminar productos con stock=0 Y activo=0
SELECT id_producto, nombre, stock, activo FROM producto WHERE stock = 0 AND activo = 0;
DELETE FROM producto WHERE stock = 0 AND activo = 0;

-- ------------------------------------------------
-- SELECT E8 - Consultas Biblioteca
-- ------------------------------------------------

-- Consulta 1: Libros prestados actualmente (sin devolucion)
SELECT
    e.nombre         AS estudiante,
    l.titulo         AS libro,
    p.fecha_prestamo,
    DATEDIFF(CURDATE(), p.fecha_prestamo) AS dias_prestado
FROM prestamo p
    INNER JOIN estudiante e ON p.id_estudiante = e.id_estudiante
    INNER JOIN libro l      ON p.id_libro      = l.id_libro
WHERE p.fecha_devolucion IS NULL
ORDER BY p.fecha_prestamo ASC;

-- Consulta 2: Estudiante con mas libros prestados
SELECT
    e.nombre             AS estudiante,
    COUNT(p.id_prestamo) AS total_prestamos
FROM estudiante e
    INNER JOIN prestamo p ON e.id_estudiante = p.id_estudiante
GROUP BY e.id_estudiante, e.nombre
ORDER BY total_prestamos DESC
LIMIT 1;

-- Consulta 3: Libros que NUNCA han sido prestados
SELECT l.id_libro, l.titulo
FROM libro l
    LEFT JOIN prestamo p ON l.id_libro = p.id_libro
WHERE p.id_prestamo IS NULL;

-- Consulta 4: Cantidad de libros por autor, DESC
SELECT
    a.nombre               AS autor,
    COUNT(la.id_libro)     AS total_libros
FROM autor a
    INNER JOIN libro_autor la ON a.id_autor = la.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY total_libros DESC;

-- ------------------------------------------------
-- UPDATE / DELETE E8 - Paso 4
-- ------------------------------------------------

-- Marcar prestamo id=1 como devuelto
UPDATE prestamo
SET fecha_devolucion = CURDATE()
WHERE id_prestamo = 1;

-- Verificar
SELECT id_prestamo, id_libro, fecha_prestamo, fecha_devolucion
FROM prestamo WHERE id_prestamo = 1;

-- Soft delete libro id=3 (Rayuela - danado)
UPDATE libro SET activo = 0 WHERE id_libro = 3;

-- Verificar
SELECT id_libro, titulo, activo FROM libro WHERE id_libro = 3;
