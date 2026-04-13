
CREATE DATABASE basedatos2;

-- ============================================================
-- 1. CONECTARSE A LA BASE DE DATOS
-- ============================================================
-- En psql:
-- \c basedatos2

CREATE ROLE rol_lectura;
CREATE ROLE rol_escritura;
CREATE ROLE rol_admin;


CREATE ROLE u_reportes LOGIN PASSWORD 'Cambiar_123';
CREATE ROLE u_app      LOGIN PASSWORD 'Cambiar_123';
CREATE ROLE u_admin    LOGIN PASSWORD 'Cambiar_123';

-- ============================================================
-- 4. ASIGNAR ROLES A USUARIOS
-- ============================================================

GRANT rol_lectura TO u_reportes;
GRANT rol_lectura, rol_escritura TO u_app;
GRANT rol_admin TO u_admin;

-- ============================================================
-- 5. PERMISOS A NIVEL DE BASE DE DATOS
-- ============================================================

GRANT CONNECT ON DATABASE basedatos2 TO rol_lectura, rol_escritura, rol_admin;

-- ============================================================
-- 6. PERMISOS A NIVEL DE ESQUEMA
-- ============================================================

GRANT USAGE ON SCHEMA public TO rol_lectura, rol_escritura, rol_admin;
GRANT CREATE ON SCHEMA public TO rol_admin;

-- ============================================================
-- 7. CREAR TABLAS
-- ============================================================

CREATE TABLE estudiante (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(120) UNIQUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    cupos INTEGER NOT NULL DEFAULT 0
);

-- ============================================================
-- 8. PERMISOS SOBRE TABLAS
-- ============================================================

GRANT SELECT ON ALL TABLES IN SCHEMA public TO rol_lectura;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO rol_escritura;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rol_admin;

-- ============================================================
-- 9. PERMISOS SOBRE SECUENCIAS
-- ============================================================

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_escritura, rol_admin;

-- ============================================================
-- 10. PRIVILEGIOS ESPECIALES PARA ADMIN
-- ============================================================

ALTER ROLE u_admin WITH CREATEDB CREATEROLE;

-- ============================================================
-- 11. PRIVILEGIOS POR DEFECTO PARA OBJETOS FUTUROS
-- ============================================================

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO rol_lectura;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT INSERT, UPDATE, DELETE ON TABLES TO rol_escritura;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO rol_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT ON SEQUENCES TO rol_escritura, rol_admin;

-- ============================================================
-- 12. REVOKE DE SEGURIDAD
-- ============================================================

REVOKE CREATE ON SCHEMA public FROM u_app;
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM u_reportes;

