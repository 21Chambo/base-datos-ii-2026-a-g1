-----1. Consulta----
SELECT 
    s.sale_code AS codigo_venta,
    i.invoice_number AS numero_factura,
    ist.status_name AS estado_factura,
    il.line_number AS linea_facturable,
    il.line_description AS descripcion_linea,
    il.quantity AS cantidad,
    il.unit_price AS precio_unitario,
    t.tax_name AS impuesto_aplicado,
    c.iso_currency_code AS moneda
FROM sale s
INNER JOIN invoice i
    ON s.sale_id = i.sale_id
INNER JOIN invoice_status ist
    ON i.invoice_status_id = ist.invoice_status_id
INNER JOIN invoice_line il
    ON i.invoice_id = il.invoice_id
INNER JOIN tax t
    ON il.tax_id = t.tax_id
INNER JOIN currency c
    ON i.currency_id = c.currency_id;

----2. Trigger AFTER INSERT
DELIMITER //

CREATE TRIGGER trg_after_invoice_line_insert
AFTER INSERT ON invoice_line
FOR EACH ROW
BEGIN
    UPDATE invoice
    SET updated_at = NOW()
    WHERE invoice_id = NEW.invoice_id;
END //

DELIMITER ;


--3. Procedimiento almacenado----
DELIMITER //

CREATE PROCEDURE sp_registrar_invoice_line(
    IN p_invoice_id CHAR(36),
    IN p_tax_id CHAR(36),
    IN p_line_number INT,
    IN p_line_description VARCHAR(200),
    IN p_quantity DECIMAL(12,2),
    IN p_unit_price DECIMAL(12,2)
)
BEGIN
    INSERT INTO invoice_line (
        invoice_line_id,
        invoice_id,
        tax_id,
        line_number,
        line_description,
        quantity,
        unit_price,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_invoice_id,
        p_tax_id,
        p_line_number,
        p_line_description,
        p_quantity,
        p_unit_price,
        NOW(),
        NOW()
    );
END //

DELIMITER ;