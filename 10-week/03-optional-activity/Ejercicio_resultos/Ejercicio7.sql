-- 1. CONSULTA INNER JOIN
SELECT 
    t.ticket_number AS numero_ticket,
    ts.segment_sequence_no AS secuencia_segmento_ticketed,
    f.flight_number AS numero_vuelo,
    cc.class_name AS cabina,
    aseat.seat_row_number AS fila_asiento,
    aseat.seat_column_code AS columna_asiento,
    b.baggage_tag AS etiqueta_equipaje,
    b.baggage_type AS tipo_equipaje,
    b.baggage_status AS estado_equipaje
FROM ticket t
INNER JOIN ticket_segment ts
    ON t.ticket_id = ts.ticket_id
INNER JOIN flight_segment fs
    ON ts.flight_segment_id = fs.flight_segment_id
INNER JOIN flight f
    ON fs.flight_id = f.flight_id
INNER JOIN seat_assignment sa
    ON ts.ticket_segment_id = sa.ticket_segment_id
INNER JOIN aircraft_seat aseat
    ON sa.aircraft_seat_id = aseat.aircraft_seat_id
INNER JOIN aircraft_cabin ac
    ON aseat.aircraft_cabin_id = ac.aircraft_cabin_id
INNER JOIN cabin_class cc
    ON ac.cabin_class_id = cc.cabin_class_id
INNER JOIN baggage b
    ON ts.ticket_segment_id = b.ticket_segment_id;

-- 2. TRIGGER AFTER INSERT
DELIMITER //

CREATE TRIGGER trg_after_baggage_insert
AFTER INSERT ON baggage
FOR EACH ROW
BEGIN
    UPDATE ticket_segment
    SET updated_at = NOW()
    WHERE ticket_segment_id = NEW.ticket_segment_id;
END //

DELIMITER ;

-- 3. PROCEDIMIENTO ALMACENADO
DELIMITER //

CREATE PROCEDURE sp_registrar_equipaje(
    IN p_ticket_segment_id CHAR(36),
    IN p_baggage_tag VARCHAR(30),
    IN p_baggage_type VARCHAR(20),
    IN p_baggage_status VARCHAR(20),
    IN p_weight_kg DECIMAL(6,2),
    IN p_checked_at TIMESTAMP
)
BEGIN
    INSERT INTO baggage (
        baggage_id,
        ticket_segment_id,
        baggage_tag,
        baggage_type,
        baggage_status,
        weight_kg,
        checked_at,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_ticket_segment_id,
        p_baggage_tag,
        p_baggage_type,
        p_baggage_status,
        p_weight_kg,
        p_checked_at,
        NOW(),
        NOW()
    );
END //

DELIMITER ;
