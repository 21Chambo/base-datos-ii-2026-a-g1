-- 1. CONSULTA INNER JOIN
SELECT 
    CONCAT(
        p.first_name, ' ',
        COALESCE(p.middle_name, ''), ' ',
        p.last_name, ' ',
        COALESCE(p.second_last_name, '')
    ) AS persona,
    pt.type_name AS tipo_persona,
    dt.type_name AS tipo_documento,
    pd.document_number AS numero_documento,
    ct.type_name AS tipo_contacto,
    pc.contact_value AS valor_contacto,
    r.reservation_code AS reserva_relacionada,
    rp.passenger_sequence_no AS secuencia_pasajero
FROM person p
INNER JOIN person_type pt
    ON p.person_type_id = pt.person_type_id
INNER JOIN person_document pd
    ON p.person_id = pd.person_id
INNER JOIN document_type dt
    ON pd.document_type_id = dt.document_type_id
INNER JOIN person_contact pc
    ON p.person_id = pc.person_id
INNER JOIN contact_type ct
    ON pc.contact_type_id = ct.contact_type_id
INNER JOIN reservation_passenger rp
    ON p.person_id = rp.person_id
INNER JOIN reservation r
    ON rp.reservation_id = r.reservation_id;

-- 2. TRIGGER AFTER INSERT
DELIMITER //

CREATE TRIGGER trg_after_person_contact_insert
AFTER INSERT ON person_contact
FOR EACH ROW
BEGIN
    UPDATE person
    SET updated_at = NOW()
    WHERE person_id = NEW.person_id;
END //

DELIMITER ;

-- 3. PROCEDIMIENTO ALMACENADO
DELIMITER //

CREATE PROCEDURE sp_registrar_contacto_persona(
    IN p_person_id CHAR(36),
    IN p_contact_type_id CHAR(36),
    IN p_contact_value VARCHAR(180),
    IN p_is_primary BOOLEAN
)
BEGIN
    INSERT INTO person_contact (
        person_contact_id,
        person_id,
        contact_type_id,
        contact_value,
        is_primary,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_person_id,
        p_contact_type_id,
        p_contact_value,
        p_is_primary,
        NOW(),
        NOW()
    );
END //

DELIMITER ;
