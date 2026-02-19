CREATE DATABASE taller_ventas;
USE taller_ventas;


CREATE TABLE module (
    id_module INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    status ENUM('active','inactive') NOT NULL DEFAULT 'active'
);


CREATE TABLE role (
    id_role INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    status ENUM('active','inactive') NOT NULL DEFAULT 'active'
);


CREATE TABLE person (
    id_person INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    document VARCHAR(30) UNIQUE,
    email VARCHAR(150)
);


CREATE TABLE user (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(200) NOT NULL,
    status ENUM('active','inactive') NOT NULL DEFAULT 'active',
    id_role INT NOT NULL,
    id_person INT NOT NULL,
    FOREIGN KEY (id_role) REFERENCES role(id_role),
    FOREIGN KEY (id_person) REFERENCES person(id_person)
);

CREATE TABLE permission (
    id_permission INT PRIMARY KEY AUTO_INCREMENT,
    id_module INT NOT NULL,
    id_role INT NOT NULL,
    code ENUM('READ','CREATE','EDIT','DELETE') NOT NULL,
    FOREIGN KEY (id_module) REFERENCES module(id_module),
    FOREIGN KEY (id_role) REFERENCES role(id_role)
);

CREATE TABLE bill (
    id_bill INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL,
    bill_date DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    status ENUM('issued','paid','cancelled') NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

INSERT INTO module (name, status) VALUES
('Ventas', 'active'),
('Inventario', 'active'),
('Reportes', 'inactive'),
('Compras', 'active');

INSERT INTO role (name, status) VALUES
('Admin', 'active'),
('Cajero', 'active'),
('Supervisor', 'inactive'),
('Bodeguero', 'active');

INSERT INTO person (first_name, last_name, document, email) VALUES
('Ana', 'Gomez', '1001', 'ana@gmail.com'),
('Luis', 'Perez', '1002', 'luis@gmail.com'),
('Carlos', 'Diaz', '1003', 'carlos@gmail.com'),
('Maria', 'Torres', '1004', 'maria@gmail.com'),
('Andres', 'Chambo', '1005', 'andres@gmail.com'),
('Valentina', 'Ruiz', '1006', 'vale@gmail.com');

INSERT INTO user (username, password, status, id_role, id_person) VALUES
('ana01', '123', 'active', 1, 1),
('luis02', '123', 'active', 2, 2),
('carlos03', '123', 'inactive', 2, 3),
('maria04', '123', 'active', 4, 4),
('andres05', '123', 'active', 2, 5),
('vale06', '123', 'active', 1, 6);

INSERT INTO permission (id_module, id_role, code) VALUES
(1, 1, 'READ'),
(1, 1, 'CREATE'),
(1, 1, 'EDIT'),
(1, 1, 'DELETE'),
(2, 1, 'READ'),
(2, 1, 'CREATE'),
(2, 1, 'EDIT'),
(1, 2, 'READ'),
(1, 2, 'CREATE'),
(2, 2, 'READ'),
(2, 4, 'READ'),
(2, 4, 'EDIT'),
(4, 3, 'READ'),
(4, 3, 'CREATE');

INSERT INTO bill (id_user, bill_date, total, status) VALUES
(1, '2026-01-10', 200000, 'issued'),
(1, '2026-01-12', 350000, 'paid'),
(2, '2026-01-15', 150000, 'issued'),
(2, '2026-01-16', 180000, 'paid'),
(2, '2026-01-20', 50000, 'cancelled'),
(5, '2026-01-25', 90000, 'issued'),
(6, '2026-01-30', 100000, 'paid'),
(4, '2026-02-01', 220000, 'issued');

SELECT 
    m.name AS modulo,

    COUNT(DISTINCT CASE WHEN p.code = 'READ' THEN u.id_user END) AS usuarios_read,
    COUNT(DISTINCT CASE WHEN p.code = 'CREATE' THEN u.id_user END) AS usuarios_create,
    COUNT(DISTINCT CASE WHEN p.code = 'EDIT' THEN u.id_user END) AS usuarios_edit,
    COUNT(DISTINCT CASE WHEN p.code = 'DELETE' THEN u.id_user END) AS usuarios_delete,

    COUNT(DISTINCT b.id_bill) AS total_facturas,
    SUM(b.total) AS total_monto_facturas

FROM module m

INNER JOIN permission p 
    ON p.id_module = m.id_module

INNER JOIN role r
    ON r.id_role = p.id_role

INNER JOIN user u
    ON u.id_role = r.id_role

INNER JOIN person pe
    ON pe.id_person = u.id_person

LEFT JOIN bill b
    ON b.id_user = u.id_user
    AND b.status IN ('issued','paid')

WHERE m.status = 'active'
  AND r.status = 'active'
  AND u.status = 'active'

GROUP BY m.id_module, m.name

ORDER BY total_facturas DESC;