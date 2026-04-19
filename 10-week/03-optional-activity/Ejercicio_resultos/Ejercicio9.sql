
-- 1. CONSULTA INNER JOIN
SELECT 
    al.airline_name AS aerolinea,
    f.fare_code AS codigo_tarifa,
    fc.fare_class_name AS clase_tarifaria,
    ao.airport_name AS aeropuerto_origen,
    ad.airport_name AS aeropuerto_destino,
    c.iso_currency_code AS moneda,
    r.reservation_code AS reserva,
    s.sale_code AS venta,
    t.ticket_number AS ticket
FROM fare f
INNER JOIN airline al
    ON f.airline_id = al.airline_id
INNER JOIN fare_class fc
    ON f.fare_class_id = fc.fare_class_id
INNER JOIN airport ao
    ON f.origin_airport_id = ao.airport_id
INNER JOIN airport ad
    ON f.destination_airport_id = ad.airport_id
INNER JOIN currency c
    ON f.currency_id = c.currency_id
INNER JOIN ticket t
    ON f.fare_id = t.fare_id
INNER JOIN sale s
    ON t.sale_id = s.sale_id
INNER JOIN reservation r
    ON s.reservation_id = r.reservation_id;

-- 2. TRIGGER AFTER INSERT
DELIMITER //

CREATE TRIGGER trg_after_fare_insert
AFTER INSERT ON fare
FOR EACH ROW
BEGIN
    UPDATE airline
    SET updated_at = NOW()
    WHERE airline_id = NEW.airline_id;
END //

DELIMITER ;

-- 3. PROCEDIMIENTO ALMACENADO
DELIMITER //

CREATE PROCEDURE sp_publicar_tarifa(
    IN p_airline_id CHAR(36),
    IN p_origin_airport_id CHAR(36),
    IN p_destination_airport_id CHAR(36),
    IN p_fare_class_id CHAR(36),
    IN p_currency_id CHAR(36),
    IN p_fare_code VARCHAR(30),
    IN p_base_amount DECIMAL(12,2),
    IN p_valid_from DATE,
    IN p_valid_to DATE,
    IN p_baggage_allowance_qty INT,
    IN p_change_penalty_amount DECIMAL(12,2),
    IN p_refund_penalty_amount DECIMAL(12,2)
)
BEGIN
    INSERT INTO fare (
        fare_id,
        airline_id,
        origin_airport_id,
        destination_airport_id,
        fare_class_id,
        currency_id,
        fare_code,
        base_amount,
        valid_from,
        valid_to,
        baggage_allowance_qty,
        change_penalty_amount,
        refund_penalty_amount,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_airline_id,
        p_origin_airport_id,
        p_destination_airport_id,
        p_fare_class_id,
        p_currency_id,
        p_fare_code,
        p_base_amount,
        p_valid_from,
        p_valid_to,
        p_baggage_allowance_qty,
        p_change_penalty_amount,
        p_refund_penalty_amount,
        NOW(),
        NOW()
    );
END //

DELIMITER ;
