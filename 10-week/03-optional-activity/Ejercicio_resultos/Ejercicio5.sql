-- 1. CONSULTA INNER JOIN
SELECT 
    a.registration_number AS matricula_aeronave,
    al.airline_name AS aerolinea,
    am.model_name AS modelo,
    afm.manufacturer_name AS fabricante,
    mt.type_name AS tipo_mantenimiento,
    mp.provider_name AS proveedor,
    me.status_code AS estado_evento,
    me.started_at AS fecha_inicio,
    me.completed_at AS fecha_finalizacion
FROM aircraft a
INNER JOIN airline al
    ON a.airline_id = al.airline_id
INNER JOIN aircraft_model am
    ON a.aircraft_model_id = am.aircraft_model_id
INNER JOIN aircraft_manufacturer afm
    ON am.aircraft_manufacturer_id = afm.aircraft_manufacturer_id
INNER JOIN maintenance_event me
    ON a.aircraft_id = me.aircraft_id
INNER JOIN maintenance_type mt
    ON me.maintenance_type_id = mt.maintenance_type_id
INNER JOIN maintenance_provider mp
    ON me.maintenance_provider_id = mp.maintenance_provider_id;

-- 2. TRIGGER AFTER UPDATE
DELIMITER //

CREATE TRIGGER trg_after_update_maintenance_event
AFTER UPDATE ON maintenance_event
FOR EACH ROW
BEGIN
    IF NEW.status_code = 'COMPLETED' THEN
        UPDATE aircraft
        SET updated_at = NOW()
        WHERE aircraft_id = NEW.aircraft_id;
    END IF;
END //

DELIMITER ;

-- 3. PROCEDIMIENTO ALMACENADO
DELIMITER //

CREATE PROCEDURE sp_registrar_mantenimiento(
    IN p_aircraft_id CHAR(36),
    IN p_maintenance_type_id CHAR(36),
    IN p_maintenance_provider_id CHAR(36),
    IN p_status_code VARCHAR(20),
    IN p_started_at TIMESTAMP,
    IN p_notes TEXT
)
BEGIN
    INSERT INTO maintenance_event (
        maintenance_event_id,
        aircraft_id,
        maintenance_type_id,
        maintenance_provider_id,
        status_code,
        started_at,
        completed_at,
        notes,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_aircraft_id,
        p_maintenance_type_id,
        p_maintenance_provider_id,
        p_status_code,
        p_started_at,
        NULL,
        p_notes,
        NOW(),
        NOW()
    );
END //

DELIMITER ;

