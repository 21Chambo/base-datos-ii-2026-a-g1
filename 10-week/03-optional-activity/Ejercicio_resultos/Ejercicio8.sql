
-- 1. CONSULTA INNER JOIN
SELECT 
    CONCAT(
        p.first_name, ' ',
        COALESCE(p.middle_name, ''), ' ',
        p.last_name, ' ',
        COALESCE(p.second_last_name, '')
    ) AS persona,
    ua.username AS usuario,
    us.status_name AS estado_usuario,
    sr.role_name AS rol_asignado,
    ur.assigned_at AS fecha_asignacion,
    sp.permission_name AS permiso_asociado
FROM person p
INNER JOIN user_account ua
    ON p.person_id = ua.person_id
INNER JOIN user_status us
    ON ua.user_status_id = us.user_status_id
INNER JOIN user_role ur
    ON ua.user_account_id = ur.user_account_id
INNER JOIN security_role sr
    ON ur.security_role_id = sr.security_role_id
INNER JOIN role_permission rp
    ON sr.security_role_id = rp.security_role_id
INNER JOIN security_permission sp
    ON rp.security_permission_id = sp.security_permission_id;

-- 2. TRIGGER AFTER INSERT
DELIMITER //

CREATE TRIGGER trg_after_user_role_insert
AFTER INSERT ON user_role
FOR EACH ROW
BEGIN
    UPDATE user_account
    SET updated_at = NOW()
    WHERE user_account_id = NEW.user_account_id;
END //

DELIMITER ;

-- 3. PROCEDIMIENTO ALMACENADO
DELIMITER //

CREATE PROCEDURE sp_asignar_rol_usuario(
    IN p_user_account_id CHAR(36),
    IN p_security_role_id CHAR(36),
    IN p_assigned_by_user_id CHAR(36),
    IN p_assigned_at TIMESTAMP
)
BEGIN
    INSERT INTO user_role (
        user_role_id,
        user_account_id,
        security_role_id,
        assigned_at,
        assigned_by_user_id,
        created_at,
        updated_at
    )
    VALUES (
        UUID(),
        p_user_account_id,
        p_security_role_id,
        p_assigned_at,
        p_assigned_by_user_id,
        NOW(),
        NOW()
    );
END //

DELIMITER ;
