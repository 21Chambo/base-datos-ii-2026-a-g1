-- 1. CONSULTA INNER JOIN
SELECT 
    c.customer_id AS cliente,
    CONCAT(
        p.first_name,
        p.middle_name,
        p.last_name,
        p.second_last_name
        ) AS persona_asociada
    la.account_number AS cuenta_fidelizacion,
    lp.program_name AS programa,
    lt.tier_name AS nivel,
    lat.assigned_at AS fecha_asignacion_nivel,
    s.sale_code AS venta_relacionada
FROM customer c
INNER JOIN person p
    ON c.person_id = p.person_id
INNER JOIN loyalty_account la
    ON c.customer_id = la.customer_id
INNER JOIN loyalty_program lp
    ON la.loyalty_program_id = lp.loyalty_program_id
INNER JOIN loyalty_account_tier lat
    ON la.loyalty_account_id = lat.loyalty_account_id
INNER JOIN loyalty_tier lt
    ON lat.loyalty_tier_id = lt.loyalty_tier_id
INNER JOIN reservation r
    ON r.booked_by_customer_id = c.customer_id
INNER JOIN sale s
    ON s.reservation_id = r.reservation_id;

-- 2. TRIGGER AFTER INSERT
DELIMITER //

CREATE TRIGGER trg_after_miles_transaction
AFTER INSERT ON miles_transaction
FOR EACH ROW
BEGIN
    DECLARE v_program_id CHAR(36);
    DECLARE v_total_miles INT;
    DECLARE v_loyalty_tier_id CHAR(36);

    SELECT loyalty_program_id
    INTO v_program_id
    FROM loyalty_account
    WHERE loyalty_account_id = NEW.loyalty_account_id
    LIMIT 1;

    SELECT COALESCE(SUM(miles_delta), 0)
    INTO v_total_miles
    FROM miles_transaction
    WHERE loyalty_account_id = NEW.loyalty_account_id;

    SELECT loyalty_tier_id
    INTO v_loyalty_tier_id
    FROM loyalty_tier
    WHERE loyalty_program_id = v_program_id
      AND required_miles <= v_total_miles
    ORDER BY required_miles DESC
    LIMIT 1;

    IF v_loyalty_tier_id IS NOT NULL THEN
        INSERT INTO loyalty_account_tier (
            loyalty_account_tier_id,
            loyalty_account_id,
            loyalty_tier_id,
            assigned_at,
            expires_at,
            created_at,
            updated_at
        )
        VALUES (
            UUID(),
            NEW.loyalty_account_id,
            v_loyalty_tier_id,
            NOW(),
            NULL,
            NOW(),
            NOW()
        );
    END IF;
END //

DELIMITER ;

-- 3. PROCEDIMIENTO ALMACENADO
DELIMITER //

CREATE PROCEDURE sp_registrar_millas(
    IN p_loyalty_account_id CHAR(36),
    IN p_transaction_type VARCHAR(20),
    IN p_miles_delta INT,
    IN p_occurred_at TIMESTAMP,
    IN p_reference_code VARCHAR(60),
    IN p_notes TEXT
)
BEGIN
    INSERT INTO miles_transaction (
        miles_transaction_id,
        loyalty_account_id,
        transaction_type,
        miles_delta,
        occurred_at,
        reference_code,
        notes,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_loyalty_account_id,
        p_transaction_type,
        p_miles_delta,
        p_occurred_at,
        p_reference_code,
        p_notes,
        NOW(),
        NOW()
    );
END //

DELIMITER ;

