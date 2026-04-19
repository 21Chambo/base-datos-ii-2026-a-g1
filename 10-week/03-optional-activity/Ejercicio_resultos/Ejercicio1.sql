---1. consulta -----
SELECT 
    r.reservation_code AS codigo_reserva,
    f.flight_number AS numero_vuelo,
    f.service_date AS fecha_servicio,
    t.ticket_number AS numero_ticket,
    rp.passenger_sequence_no AS secuencia_pasajero,
    CONCAT(
        p.first_name,
        p.middle_name,
        p.last_name, 
        p.second_last_name, 
    ) AS nombre_pasajero,
    fs.segment_number AS segmento_vuelo,
    fs.scheduled_departure_at AS hora_programada_salida
FROM reservation r
INNER JOIN reservation_passenger rp 
    ON r.reservation_id = rp.reservation_id
INNER JOIN person p 
    ON rp.person_id = p.person_id
INNER JOIN ticket t 
    ON rp.reservation_passenger_id = t.reservation_passenger_id
INNER JOIN ticket_segment ts 
    ON t.ticket_id = ts.ticket_id
INNER JOIN flight_segment fs 
    ON ts.flight_segment_id = fs.flight_segment_id
INNER JOIN flight f 
    ON fs.flight_id = f.flight_id;

---- 2.Trigger AFTER INSERT
DELIMITER //

CREATE TRIGGER trg_after_check_in_create_boarding_pass
AFTER INSERT ON check_in
FOR EACH ROW
BEGIN
    INSERT INTO boarding_pass (
        boarding_pass_id,
        check_in_id,
        boarding_pass_code,
        barcode_value,
        issued_at,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        NEW.check_in_id,
        CONCAT('BP-', REPLACE(NEW.check_in_id, '-', '')),
        CONCAT('BAR-', REPLACE(NEW.check_in_id, '-', '')),
        NEW.checked_in_at,
        NOW(),
        NOW()
    );
END //

DELIMITER ;

Descripción corta:
Cuando se registra un check-in, crea automáticamente el boarding pass.

----3. Procedimiento almacenado

DELIMITER //

CREATE PROCEDURE sp_registrar_check_in(
    IN p_ticket_segment_id CHAR(36),
    IN p_check_in_status_id CHAR(36),
    IN p_boarding_group_id CHAR(36),
    IN p_checked_in_by_user_id CHAR(36),
    IN p_checked_in_at TIMESTAMP
)
BEGIN
    INSERT INTO check_in (
        check_in_id,
        ticket_segment_id,
        check_in_status_id,
        boarding_group_id,
        checked_in_by_user_id,
        checked_in_at,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_ticket_segment_id,
        p_check_in_status_id,
        p_boarding_group_id,
        p_checked_in_by_user_id,
        p_checked_in_at,
        NOW(),
        NOW()
    );
END //

DELIMITER ;