

-- ------------------------------------------------------------
-- 1. ELIMINAR TABLAS SI YA EXISTEN
-- ------------------------------------------------------------

DROP TABLE IF EXISTS matricula CASCADE;
DROP TABLE IF EXISTS estudiante CASCADE;
DROP TABLE IF EXISTS asignatura CASCADE;

-- ------------------------------------------------------------
-- 2. CREAR TABLA ESTUDIANTE
-- ------------------------------------------------------------

CREATE TABLE estudiante (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(120) UNIQUE
);

-- ------------------------------------------------------------
-- 3. CREAR TABLA ASIGNATURA
-- ------------------------------------------------------------

CREATE TABLE asignatura (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    creditos INTEGER NOT NULL
);

-- ------------------------------------------------------------
-- 4. CREAR TABLA MATRICULA
-- ------------------------------------------------------------

CREATE TABLE matricula (
    id SERIAL PRIMARY KEY,
    estudiante_id INTEGER NOT NULL,
    asignatura_id INTEGER NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    fecha_matricula DATE DEFAULT CURRENT_DATE,
    estado VARCHAR(20) DEFAULT 'activa',
    CONSTRAINT fk_matricula_estudiante
        FOREIGN KEY (estudiante_id) REFERENCES estudiante(id),
    CONSTRAINT fk_matricula_asignatura
        FOREIGN KEY (asignatura_id) REFERENCES asignatura(id)
);

-- ------------------------------------------------------------
-- 5. INSERTAR DATOS DE EJEMPLO
-- ------------------------------------------------------------

INSERT INTO estudiante (nombre, correo) VALUES
('Ana Torres', 'ana@correo.com'),
('Luis Pérez', 'luis@correo.com'),
('María Gómez', 'maria@correo.com'),
('Carlos Ruiz', 'carlos@correo.com'),
('Sofía León', 'sofia@correo.com');

INSERT INTO asignatura (nombre, creditos) VALUES
('Bases de Datos', 4),
('Programación', 3),
('Redes', 3),
('Matemáticas', 4),
('Sistemas Operativos', 4);

INSERT INTO matricula (estudiante_id, asignatura_id, semestre, fecha_matricula, estado) VALUES
(1, 1, '2026-1', '2026-01-15', 'activa'),
(1, 2, '2026-1', '2026-01-16', 'activa'),
(2, 1, '2026-1', '2026-01-17', 'activa'),
(2, 3, '2026-1', '2026-01-18', 'activa'),
(3, 2, '2026-1', '2026-01-19', 'activa'),
(3, 4, '2026-2', '2026-07-10', 'activa'),
(4, 5, '2026-2', '2026-07-11', 'activa'),
(4, 1, '2026-2', '2026-07-12', 'cancelada'),
(5, 3, '2026-1', '2026-01-20', 'activa'),
(5, 4, '2026-2', '2026-07-13', 'activa');

-- ============================================================
-- CONSULTA 1: POR SEMESTRE
-- Índice simple
-- ============================================================

-- Antes
EXPLAIN ANALYZE
SELECT *
FROM matricula
WHERE semestre = '2026-1';

-- Crear índice simple
CREATE INDEX IF NOT EXISTS idx_matricula_semestre
ON matricula(semestre);

-- Después
EXPLAIN ANALYZE
SELECT *
FROM matricula
WHERE semestre = '2026-1';

-- ============================================================
-- CONSULTA 2: POR ASIGNATURA Y SEMESTRE
-- Índice compuesto
-- ============================================================

-- Antes
EXPLAIN ANALYZE
SELECT *
FROM matricula
WHERE asignatura_id = 1
  AND semestre = '2026-1';

-- Crear índice compuesto
CREATE INDEX IF NOT EXISTS idx_matricula_asignatura_semestre
ON matricula(asignatura_id, semestre);

-- Después
EXPLAIN ANALYZE
SELECT *
FROM matricula
WHERE asignatura_id = 1
  AND semestre = '2026-1';

-- ============================================================
-- CONSULTA 3: JOIN POR ESTUDIANTE
-- Índice para JOIN
-- ============================================================

-- Antes
EXPLAIN ANALYZE
SELECT e.nombre, COUNT(*) AS total_matriculas
FROM matricula m
JOIN estudiante e ON e.id = m.estudiante_id
WHERE m.semestre = '2026-1'
GROUP BY e.nombre
ORDER BY total_matriculas DESC;

-- Crear índice para JOIN
CREATE INDEX IF NOT EXISTS idx_matricula_estudiante
ON matricula(estudiante_id);

-- Después
EXPLAIN ANALYZE
SELECT e.nombre, COUNT(*) AS total_matriculas
FROM matricula m
JOIN estudiante e ON e.id = m.estudiante_id
WHERE m.semestre = '2026-1'
GROUP BY e.nombre
ORDER BY total_matriculas DESC;

-- ============================================================
-- ACTUALIZAR ESTADÍSTICAS
-- ============================================================

ANALYZE estudiante;
ANALYZE asignatura;
ANALYZE matricula;