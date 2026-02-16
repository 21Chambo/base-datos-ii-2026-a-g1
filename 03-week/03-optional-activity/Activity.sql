DROP DATABASE IF EXISTS academia;
CREATE DATABASE academia;
USE academia;

CREATE TABLE estudiante (
    id_estudiante INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE asignatura (
    id_asignatura INT PRIMARY KEY,
    codigo VARCHAR(100),
    nombre VARCHAR(100)
);

CREATE TABLE matricula (
    id_matricula INT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_asignatura INT NOT NULL,
    nota DECIMAL(4,2),
    semestre VARCHAR(10) NOT NULL,
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id_asignatura)
);

INSERT INTO estudiante VALUES
(1,'Ana'),
(2,'Luis'),
(3,'Carlos'),
(4,'María'),
(5,'Andres'),
(6,'Valen');

INSERT INTO asignatura VALUES
(1,'BD101','Bases de Datos'),
(2,'PROG1','Programación'),
(3,'BD102','Base de Datos II'),
(4,'AQR1','Arquitectura'),
(5,'AQR2','Arquitectura II'),
(6,'CALC1','Calculo I');

INSERT INTO matricula VALUES
(1,1,1,4.5,'2026-1'),
(2,1,2,4.3,'2026-1'),
(3,2,3,4.5,'2026-1'),
(4,3,4,4.7,'2026-1'),
(5,5,5,4.7,'2026-1'),
(6,6,6,4.9,'2026-1');

SELECT 
    id_matricula,
    nota,
    (SELECT AVG(nota)
     FROM matricula
     WHERE semestre = '2026-1') AS promedio_general
FROM matricula
WHERE semestre = '2026-1';

SELECT *
FROM matricula
WHERE semestre = '2026-1'
AND nota > (
    SELECT AVG(nota)
    FROM matricula
    WHERE semestre = '2026-1'
);

SELECT *
FROM estudiante
WHERE id_estudiante IN (
    SELECT id_estudiante
    FROM matricula
    WHERE id_asignatura IN (
        SELECT id_asignatura
        FROM asignatura
        WHERE codigo LIKE 'BD%'
    )
);

SELECT *
FROM estudiante e
WHERE EXISTS (
    SELECT 1
    FROM matricula m
    WHERE m.id_estudiante = e.id_estudiante
      AND m.semestre = '2026-1'
);

SELECT *
FROM estudiante e
WHERE NOT EXISTS (
    SELECT 1
    FROM matricula m
    WHERE m.id_estudiante = e.id_estudiante
      AND m.semestre = '2026-1'
);



SELECT *
FROM matricula m1
WHERE nota > (
    SELECT AVG(m2.nota)
    FROM matricula m2
    WHERE m2.id_asignatura = m1.id_asignatura
);


DROP TABLE IF EXISTS matricula;
DROP TABLE IF EXISTS asignatura;
DROP TABLE IF EXISTS estudiante;
