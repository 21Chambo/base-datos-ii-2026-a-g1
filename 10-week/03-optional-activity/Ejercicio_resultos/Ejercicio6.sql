-- 1. CONSULTA INNER JOIN
SELECT 
    al.airline_name AS aerolinea,
    f.flight_number AS numero_vuelo,
    f.service_date AS fecha_servicio,
    fs2.status_name AS estado_vuelo,
    fg.segment_number AS segmento,
    ao.airport_name AS aeropuerto_origen,
    ad.airport_name AS aeropuerto_destino,
    fd.delay_minutes AS minutos_demora,
    drt.reason_name AS motivo_retraso
FROM flight f
INNER JOIN airline al
    ON f.airline_id = al.airline_id
INNER JOIN flight_status fs2
    ON f.flight_status_id = fs2.flight_status_id
INNER JOIN flight_segment fg
    ON f.flight_id = fg.flight_id
INNER JOIN airport ao
    ON fg.origin_airport_id = ao.airport_id
INNER JOIN airport ad
    ON fg.destination_airport_id = ad.airport_id
INNER JOIN flight_delay fd
    ON fg.flight_segment_id = fd.flight_segment_id
INNER JOIN delay_reason_type drt
    ON fd.delay_reason_type_id = drt.delay_reason_type_id;

-- 2. TRIGGER AFTER INSERT
DELIMITER //

CREATE TRIGGER trg_after_flight_delay_insert
AFTER INSERT ON flight_delay
FOR EACH ROW
BEGIN
    UPDATE flight
    SET updated_at = NOW()
    WHERE flight_id = (
        SELECT flight_id
        FROM flight_segment
        WHERE flight_segment_id = NEW.flight_segment_id
    );
END //

DELIMITER ;

-- 3. PROCEDIMIENTO ALMACENADO
DELIMITER //

CREATE PROCEDURE sp_registrar_demora_vuelo(
    IN p_flight_segment_id CHAR(36),
    IN p_delay_reason_type_id CHAR(36),
    IN p_reported_at TIMESTAMP,
    IN p_delay_minutes INT,
    IN p_notes TEXT
)
BEGIN
    INSERT INTO flight_delay (
        flight_delay_id,
        flight_segment_id,
        delay_reason_type_id,
        reported_at,
        delay_minutes,
        notes,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_flight_segment_id,
        p_delay_reason_type_id,
        p_reported_at,
        p_delay_minutes,
        p_notes,
        NOW(),
        NOW()
    );
END //

DELIMITER ;
