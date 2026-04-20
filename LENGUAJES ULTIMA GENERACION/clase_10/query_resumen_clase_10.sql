--CREACION DE VARIABLES 
-- Variables de usuario en SQL interactivo
SET
    @limite = 5;

SET
    @categoria = 'Electrónica';

SELECT
    nombre,
    precio
FROM
    producto
WHERE
    categoria = @categoria
ORDER BY
    precio DESC
LIMIT
    @limite;

--FUNCIONES DE VENTANA 
-- Funciones de ventana (MariaDB 10.2+) – Ranking sin subquery
SELECT
    nombre,
    categoria,
    precio,
    RANK() OVER (
        PARTITION BY categoria
        ORDER BY
            precio DESC
    ) ranking,
    ROW_NUMBER() OVER (
        ORDER BY
            precio DESC
    ) fila_global,
    LAG(precio, 1) OVER (
        ORDER BY
            precio
    ) precio_anterior
FROM
    producto
WHERE
    activo = 1;

nombre | categoria | precio | ranking | fila_global | precio_anterior ------------------------------------------------------------------------
Pantalla | Electrónica | 1200 | 1 | 1 | NULL Celular | Electrónica | 950 | 2 | 2 | 850 Audífonos | Electrónica | 850 | 3 | 3 | 600 Silla | Muebles | 400 | 1 | 4 | 350 Mesa | Muebles | 350 | 2 | 5 | 300 --CTE (Common Table Expression) – Consulta legible y reutilizable
--TABLAS  LOGICAS (NO SE MATERIALIZAN)
WITH ventas_cliente (
    SELECT
        id_cliente,
        SUM(total) total_comprado,
        COUNT(*) num_ordenes
    FROM
        orden
    WHERE
        estado = 'entregada'
    GROUP BY
        id_cliente
)
SELECT
    c.nombre,
    vc.total_comprado,
    vc.num_ordenes
FROM
    cliente c
    JOIN ventas_cliente vc ON c.id_cliente = vc.id_cliente
WHERE
    vc.total_comprado > 500000
ORDER BY
    vc.total_comprado DESC;

--- LENGUAJE INMERSO 
import mariadb # Conectar a MariaDB
conn = mariadb.connect(
    host = "localhost",
    user = "tu_usuario",
    password = "tu_contraseña",
    database = "tu_base_de_datos"
) cur = conn.cursor() # SQL inmerso dentro de Python
sql_create_table = """
CREATE TABLE IF NOT EXISTS producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    precio DECIMAL(10,2),
    activo TINYINT(1) DEFAULT 1
)
""" conn.commit() cur.execute(sql_create_table) sql_SEELCT_table = """
SELECT * FROM producto 
""" salida = cur.execute(sql_SEELCT_table) print(f "salida: ", salida) conn.commit() cur.close() conn.close() -- php 
< ? php / / ═ ═ ═ CONEXIÓN PDO A MARIADB (XAMPP) ═ ═ ═ try { $ dsn = "mysql:host=localhost;dbname=mi_tienda;charset=utf8mb4";

$ pdo = new PDO(
    $ dsn,
    'root',
    '',
    [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,   // Prepared statements reales
    ]
);

} catch (PDOException $ e) { die("Error de conexión: ".$ e -> getMessage());

} / / ═ ═ ═
SELECT
    con Prepared Statement (evita SQL Injection) ═ ═ ═ $ stmt = $ pdo -> prepare(
        "SELECT nombre, precio FROM producto WHERE id_categoria=:cat AND activo=1"
    );

$ stmt -> execute(
    [':cat' => $_GET['categoria']]);  // Parámetro del usuario: SEGURO
$productos = $stmt->fetchAll();                  // Array asociativo con todos los resultados
foreach ($productos $p) {
    echo "<li>{$p['nombre'] }: $ " . number_format($p['precio']) . " < / li > ";
}

// ═══ INSERT con Prepared Statement ═══
$stmt = $pdo->prepare("
    INSERT INTO
        producto (nombre, precio, stock, id_categoria)
    VALUES
        (?, ?, ?, ?) ");
$stmt->execute([$_POST['nombre'], $_POST['precio'], 100, 1]);
echo " Producto creado.ID: " . $pdo->lastInsertId();


--vistas 
-- VISTA: Abstrae un JOIN complejo en una " tabla " simple
CREATE VIEW v_detalle_ventas 
SELECT
    o.id_orden,
    c.nombre cliente,
    p.nombre producto,
    d.cantidad,
    d.precio_unit,
    d.cantidad * d.precio_unit subtotal,
    o.fecha,
    o.estado
FROM
    orden o
    JOIN cliente c ON o.id_cliente = c.id_cliente
    JOIN detalle_orden d ON o.id_orden = d.id_orden
    JOIN producto p ON d.id_producto = p.id_producto;

-- Ahora cualquier usuario puede hacer:
SELECT
    *
FROM
    v_detalle_ventas
WHERE
    cliente = 'Ana García'
ORDER BY
    fecha DESC;

    SELECT
    cantidad,
    precio_unit,
    subtotal,
FROM
    v_detalle_ventas
WHERE
    cliente = 'Ana García'
ORDER BY
    fecha DESC;

    -- FUNCIÓN almacenada: Abstrae un cálculo de negocio
DELIMITER //
CREATE FUNCTION fn_precio_con_iva(precio DECIMAL(12,2), pct_iva DECIMAL(5,2))
RETURNS DECIMAL(12,2) DETERMINISTIC
BEGIN
    RETURN ROUND(precio * (1 + pct_iva / 100), 2);
END //
DELIMITER ;
-- Uso transparente en cualquier SELECT:
SELECT
    nombre,
    precio,
    p_iva,
    fn_precio_con_iva(precio, p_iva) AS precio_iva, --con sp_
    ROUND(precio * (1 + p_iva / 100), 2)-- sin sp
FROM
    producto;

    -- VISTA con seguridad: Muestra solo columnas permitidas (abstracción + seguridad)
CREATE VIEW v_empleados_publico AS
SELECT
    nombre,
    apellido,
    cargo,
    departamento
FROM
    empleado;

-- El rol 'rrhh_lector' solo puede SELECT en v_empleados_publico
-- Nunca ve: salario, datos_bancarios, contraseña_acceso
GRANT
SELECT
    ON empresa.v_empleados_publico TO 'rrhh_lector' @'localhost';
-------------------ejemplo  ps_
DELIMITER //
CREATE PROCEDURE sp_procesar_venta(
    IN  p_cliente  INT,
    IN  p_producto INT,
    IN  p_cantidad INT,
    OUT p_resultado VARCHAR(100)   -- Parámetro de salida
)
BEGIN
    DECLARE v_stock     INT DEFAULT 0;
    DECLARE v_precio    DECIMAL(12,2) DEFAULT 0;
    DECLARE v_id_orden  INT DEFAULT 0;
    
    -- Manejador de errores: ROLLBACK automático ante excepción
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 'ERROR: Transacción revertida';
    END;
    
    -- Encapsulamiento: toda la lógica de negocio dentro del SP
    START TRANSACTION;
    
    -- 1. Verificar stock disponible
    SELECT stock, precio INTO v_stock, v_precio
    FROM producto WHERE id_producto = p_producto FOR UPDATE;
    
    IF v_stock < p_cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
    
    -- 2. Crear la orden
    INSERT INTO orden (fecha, estado, id_cliente) VALUES (NOW(), 'pendiente', p_cliente);
    SET v_id_orden = LAST_INSERT_ID();
    
    -- 3. Registrar el detalle
    INSERT INTO detalle_orden (id_orden, id_producto, cantidad, precio_unit)
    VALUES (v_id_orden, p_producto, p_cantidad, v_precio);
    
    -- 4. Actualizar stock
    UPDATE producto SET stock = stock - p_cantidad WHERE id_producto = p_producto;
    
    COMMIT;
    SET p_resultado = CONCAT('OK: Orden #', v_id_orden, ' creada exitosamente');
END //
DELIMITER ;

-- Invocación desde SQL interactivo:
CALL sp_procesar_venta(1, 5, 3, @resultado);
SELECT @resultado;

-- Invocación desde PHP (SQL inmerso):
-- $stmt = $pdo->prepare("CALL sp_procesar_venta(?,?,?,@res)");
-- $stmt->execute([$clienteId, $prodId, $cant]);
-------------------


-- TRIGGER polimórfico: mismo propósito,
-- comportamiento diferente por evento
DELIMITER //

-- Trigger AFTER INSERT
CREATE TRIGGER tg_after_insert_prod
AFTER INSERT ON producto FOR EACH ROW
BEGIN
    INSERT INTO audit_producto (accion,id_prod,datos,usuario,fecha)
    VALUES ('INSERT', NEW.id_producto,
      JSON_OBJECT('nombre',NEW.nombre,'precio',NEW.precio),
      USER(), NOW());
END //

-- Trigger AFTER UPDATE (mismo objetivo, distinto comportamiento)
CREATE TRIGGER tg_after_update_prod
AFTER UPDATE ON producto FOR EACH ROW
BEGIN
    INSERT INTO audit_producto (accion,id_prod,datos,usuario,fecha)
    VALUES ('UPDATE', NEW.id_producto,
      JSON_OBJECT(
        'precio_antes',OLD.precio,
        'precio_ahora',NEW.precio,
        'nombre_antes',OLD.nombre
      ), USER(), NOW());
END //

-- Trigger BEFORE DELETE
CREATE TRIGGER tg_before_delete_prod
BEFORE DELETE ON producto FOR EACH ROW
BEGIN
    IF OLD.activo = 1 THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT='No eliminar prod. activo';
    END IF;
END //
DELIMITER ;
-------------------
-- FUNCIONES con comportamiento "polimórfico"
-- misma firma, diferentes tipos de entrada
DELIMITER //

-- Función para calcular descuento por tipo
CREATE FUNCTION fn_calcular_descuento(
    precio      DECIMAL(12,2),
    tipo_cliente ENUM('regular','premium','vip')
) RETURNS DECIMAL(12,2) DETERMINISTIC
BEGIN
    DECLARE v_pct DECIMAL(5,2);
    -- Polimorfismo: comportamiento según tipo
    SET v_pct = CASE tipo_cliente
        WHEN 'regular' THEN 0.00
        WHEN 'premium' THEN 5.00
        WHEN 'vip'     THEN 15.00
        ELSE 0.00
    END;
    RETURN ROUND(precio * (1 - v_pct/100), 2);
END //

-- Resultado según tipo de cliente:
-- fn_calcular_descuento(100000, 'regular') → 100000
-- fn_calcular_descuento(100000, 'premium') → 95000
-- fn_calcular_descuento(100000, 'vip')     → 85000
DELIMITER ;

SELECT nombre, precio,
  fn_calcular_descuento(precio, tipo_cliente) AS precio_final
FROM producto p JOIN cliente c ON c.tipo_cliente = c.tipo_cliente
WHERE c.id_cliente = 1;
-------------------columnas virtuales 
-- VIRTUAL COLUMNS (columnas generadas automáticamente)
ALTER TABLE producto ADD COLUMN precio_iva DECIMAL(12,2)
    AS (ROUND(precio * 1.19, 2)) STORED;  -- STORED: calculada y guardada
ALTER TABLE persona ADD COLUMN nombre_completo VARCHAR(170)
    AS (CONCAT(nombre, ' ', apellido)) VIRTUAL;  -- VIRTUAL: calculada en consulta
SELECT nombre_completo, precio_iva FROM producto JOIN persona ...;
