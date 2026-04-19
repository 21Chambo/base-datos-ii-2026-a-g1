-----1. Consulta-----

SELECT 
    s.sale_code AS codigo_venta,
    r.reservation_code AS codigo_reserva,
    p.payment_reference AS referencia_pago,
    ps.status_name AS estado_pago,
    pm.method_name AS metodo_pago,
    pt.transaction_reference AS referencia_transaccion,
    pt.transaction_type AS tipo_transaccion,
    pt.transaction_amount AS monto_procesado,
    c.iso_currency_code AS moneda
FROM sale s
INNER JOIN reservation r 
    ON s.reservation_id = r.reservation_id
INNER JOIN payment p 
    ON s.sale_id = p.sale_id
INNER JOIN payment_status ps 
    ON p.payment_status_id = ps.payment_status_id
INNER JOIN payment_method pm 
    ON p.payment_method_id = pm.payment_method_id
INNER JOIN payment_transaction pt 
    ON p.payment_id = pt.payment_id
INNER JOIN currency c 
    ON p.currency_id = c.currency_id;

---2. Trigger AFTER INSERT----
DELIMITER //

CREATE TRIGGER trg_after_payment_transaction_refund
AFTER INSERT ON payment_transaction
FOR EACH ROW
BEGIN
    IF NEW.transaction_type IN ('REFUND', 'REVERSAL') THEN
        INSERT INTO refund (
            refund_id,
            payment_id,
            refund_reference,
            amount,
            requested_at,
            processed_at,
            refund_reason,
            created_at,
            updated_at
        )
        VALUES (
            UUID(),
            NEW.payment_id,
            CONCAT('REF-', REPLACE(NEW.transaction_reference, ' ', '')),
            NEW.transaction_amount,
            NEW.processed_at,
            NEW.processed_at,
            NEW.provider_message,
            NOW(),
            NOW()
        );
    END IF;
END //

DELIMITER ;

-----3.Procedimiento almacenado-----
DELIMITER //

CREATE PROCEDURE sp_registrar_transaccion_pago(
    IN p_payment_id CHAR(36),
    IN p_transaction_reference VARCHAR(60),
    IN p_transaction_type VARCHAR(20),
    IN p_transaction_amount DECIMAL(12,2),
    IN p_processed_at TIMESTAMP,
    IN p_provider_message TEXT
)
BEGIN
    INSERT INTO payment_transaction (
        payment_transaction_id,
        payment_id,
        transaction_reference,
        transaction_type,
        transaction_amount,
        processed_at,
        provider_message,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_payment_id,
        p_transaction_reference,
        p_transaction_type,
        p_transaction_amount,
        p_processed_at,
        p_provider_message,
        NOW(),
        NOW()
    );
END //

DELIMITER ;
