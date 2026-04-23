-- E5: Creacion de Tablas y INSERT

CREATE DATABASE IF NOT EXISTS taller_s7 CHARACTER SET utf8mb4;
USE taller_s7;

CREATE TABLE categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(60) NOT NULL,
  descripcion  TEXT
) ENGINE=InnoDB;

CREATE TABLE producto (
  id_producto  INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(100) NOT NULL,
  precio       DECIMAL(12,2) NOT NULL,
  stock        INT NOT NULL DEFAULT 0,
  activo       TINYINT(1) DEFAULT 1,
  id_categoria INT NOT NULL,
  FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
) ENGINE=InnoDB;

INSERT INTO categoria (nombre, descripcion) VALUES
('Bebidas', 'Productos liquidos para consumo'),
('Alimentos', 'Productos comestibles no liquidos'),
('Limpieza', 'Productos para limpieza del hogar'),
('Electronicos', 'Dispositivos y accesorios electronicos');

SELECT * FROM categoria;

INSERT INTO producto (nombre, precio, stock, activo, id_categoria) VALUES
('Cafe 500g', 12.50, 50, 1, 1),
('Azucar 1kg', 3.20, 30, 1, 2),
('Leche 1L', 2.80, 20, 1, 1),
('Pan integral', 1.50, 40, 1, 2),
('Jabon liquido', 4.00, 15, 1, 3),
('Laptop', 800.00, 5, 1, 4),
('Audifonos', 50.00, 10, 1, 4),
('Detergente', 6.00, 25, 1, 3);

SELECT * FROM producto;

-- E6: SELECT con filtros y ORDER BY
-- a) Todos los productos con stock mayor a 0, ordenados por precio de mayor a menor
SELECT * FROM producto WHERE stock > 0 ORDER BY precio DESC;

-- b) Los primeros 3 productos mas baratos de la categoria "Alimentos"
SELECT * FROM producto WHERE id_categoria = 2 ORDER BY precio ASC LIMIT 3;

-- c) Los productos cuyo nombre contiene la palabra 'Cafe'
SELECT * FROM producto WHERE nombre LIKE '%Cafe%';

-- d) El precio maximo, minimo y promedio de todos los productos activos
SELECT
    MAX(precio) AS precio_maximo,
    MIN(precio) AS precio_minimo,
    AVG(precio) AS precio_promedio
FROM producto WHERE activo = 1;

-- E7: UPDATE y DELETE con condiciones
-- a) Aumentar el precio de todos los productos de la categoria con id_categoria=1 en un 15%
-- Paso 1: Verificar con SELECT antes
SELECT * FROM producto WHERE id_categoria = 1;

-- Paso 2: Ejecutar el UPDATE
UPDATE producto SET precio = precio * 1.15 WHERE id_categoria = 1;

-- Paso 3: Verificar con SELECT despues
SELECT * FROM producto WHERE id_categoria = 1;

-- b) Soft delete para el producto con id=3
UPDATE producto SET activo = 0 WHERE id_producto = 3;

-- c) Eliminar todos los productos con stock = 0 Y activo = 0
DELETE FROM producto WHERE stock = 0 AND activo = 0;

-- Verificar cuántas filas se eliminaron
SELECT ROW_COUNT() AS filas_eliminadas;