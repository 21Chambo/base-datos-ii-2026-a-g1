Semana 6 · Sesión 2: Práctica guiada de usuarios, roles y privilegios en PostgreSQL

2. Objetivo

Implementar un esquema de seguridad básico y verificable en PostgreSQL, aplicando el principio de mínimo privilegio, de manera que cada usuario solo tenga acceso a las acciones que realmente necesita realizar.

3. Descripción de la práctica

En esta práctica se construye un escenario de seguridad con tres perfiles de usuario:

u_reportes: usuario con permisos de solo lectura
u_app: usuario con permisos de lectura y escritura
u_admin: usuario con permisos de administración

Para lograrlo, primero se crean roles de grupo, luego se crean los usuarios con LOGIN, después se asignan los roles a cada usuario y finalmente se aplican permisos sobre la base de datos, el esquema, las tablas y las secuencias.

Este ejercicio permite comprobar cómo PostgreSQL administra accesos de forma controlada y organizada.

4. Conceptos aplicados
Rol

Un rol es una entidad de seguridad a la que se le pueden asignar permisos.

Usuario

En PostgreSQL, un usuario es un rol que tiene la opción LOGIN, es decir, puede iniciar sesión.

Esquema

Es una estructura lógica dentro de la base de datos donde se encuentran tablas, secuencias y otros objetos.

Privilegios

Son los permisos que se conceden sobre los objetos de la base de datos, por ejemplo:

CONNECT
USAGE
SELECT
INSERT
UPDATE
DELETE
CREATE
Principio de mínimo privilegio

Consiste en dar a cada usuario únicamente los permisos necesarios para cumplir su función, evitando accesos innecesarios o peligrosos.

5. Orden correcto de implementación

El orden correcto para desarrollar esta práctica es el siguiente:

Crear la base de datos
Conectarse a la base de datos
Crear roles de grupo
Crear usuarios
Asignar roles a los usuarios
Crear tablas
Otorgar permisos sobre base de datos, esquema, tablas y secuencias
Configurar privilegios por defecto
Aplicar revocaciones de seguridad si se desea reforzar restricciones

Este orden es importante porque no se pueden asignar permisos sobre objetos que todavía no existen.

6. Script SQL organizado y explicado
-- ============================================================
-- PRÁCTICA GUIADA: USUARIOS, ROLES Y PRIVILEGIOS EN POSTGRESQL
-- Tema: principio de mínimo privilegio
-- ============================================================

-- ------------------------------------------------------------
-- PASO 0. CREAR LA BASE DE DATOS
-- ------------------------------------------------------------
-- Este paso solo se realiza una vez.
-- Si la base ya existe, no es necesario repetirlo.

-- CREATE DATABASE basedatos2;

-- Luego debes conectarte a la base de datos.
-- En psql sería:
-- \c basedatos2


-- ------------------------------------------------------------
-- PASO 1. CREAR ROLES DE GRUPO
-- ------------------------------------------------------------
-- Estos roles no tienen LOGIN.
-- Se usan únicamente para agrupar permisos.

CREATE ROLE rol_lectura;
CREATE ROLE rol_escritura;
CREATE ROLE rol_admin;


-- ------------------------------------------------------------
-- PASO 2. CREAR USUARIOS
-- ------------------------------------------------------------
-- Estos roles sí tienen LOGIN, por lo tanto pueden iniciar sesión.

CREATE ROLE u_reportes LOGIN PASSWORD 'Cambiar_123';
CREATE ROLE u_app      LOGIN PASSWORD 'Cambiar_123';
CREATE ROLE u_admin    LOGIN PASSWORD 'Cambiar_123';


-- ------------------------------------------------------------
-- PASO 3. ASIGNAR ROLES A LOS USUARIOS
-- ------------------------------------------------------------
-- Se define el perfil de acceso de cada usuario.

GRANT rol_lectura TO u_reportes;
GRANT rol_lectura, rol_escritura TO u_app;
GRANT rol_admin TO u_admin;


-- ------------------------------------------------------------
-- PASO 4. DAR PERMISO DE CONEXIÓN A LA BASE DE DATOS
-- ------------------------------------------------------------
-- Permite que los roles puedan conectarse a la base.

GRANT CONNECT ON DATABASE basedatos2 TO rol_lectura, rol_escritura, rol_admin;


-- ------------------------------------------------------------
-- PASO 5. PERMISOS SOBRE EL ESQUEMA
-- ------------------------------------------------------------
-- USAGE permite usar el esquema public.
-- CREATE permite crear objetos dentro del esquema.

GRANT USAGE ON SCHEMA public TO rol_lectura, rol_escritura, rol_admin;
GRANT CREATE ON SCHEMA public TO rol_admin;


-- ------------------------------------------------------------
-- PASO 6. CREAR TABLAS
-- ------------------------------------------------------------
-- Se crean dos tablas de ejemplo para aplicar permisos.

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


-- ------------------------------------------------------------
-- PASO 7. PERMISOS SOBRE LAS TABLAS
-- ------------------------------------------------------------
-- rol_lectura: solo puede consultar
-- rol_escritura: puede insertar, actualizar y eliminar
-- rol_admin: tiene control total

GRANT SELECT ON ALL TABLES IN SCHEMA public TO rol_lectura;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO rol_escritura;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rol_admin;


-- ------------------------------------------------------------
-- PASO 8. PERMISOS SOBRE LAS SECUENCIAS
-- ------------------------------------------------------------
-- Necesarios para columnas SERIAL.

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_escritura, rol_admin;


-- ------------------------------------------------------------
-- PASO 9. ATRIBUTOS ESPECIALES PARA EL ADMINISTRADOR
-- ------------------------------------------------------------
-- CREATEDB: puede crear bases de datos
-- CREATEROLE: puede crear y administrar roles

ALTER ROLE u_admin WITH CREATEDB CREATEROLE;


-- ------------------------------------------------------------
-- PASO 10. PRIVILEGIOS POR DEFECTO
-- ------------------------------------------------------------
-- Sirve para que futuros objetos hereden permisos automáticamente.

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO rol_lectura;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT INSERT, UPDATE, DELETE ON TABLES TO rol_escritura;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO rol_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT ON SEQUENCES TO rol_escritura, rol_admin;


-- ------------------------------------------------------------
-- PASO 11. REVOKE DE SEGURIDAD
-- ------------------------------------------------------------
-- Refuerza el principio de mínimo privilegio.

REVOKE CREATE ON SCHEMA public FROM u_app;
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM u_reportes;
7. Explicación del script
Paso 1: creación de roles

Se crean tres roles de grupo:

rol_lectura
rol_escritura
rol_admin

Estos roles no acceden directamente al sistema, sino que sirven para organizar permisos de forma más ordenada.

Paso 2: creación de usuarios

Se crean tres usuarios con capacidad de iniciar sesión:

u_reportes
u_app
u_admin

Cada uno representa un perfil distinto dentro del sistema.

Paso 3: asignación de roles

Aquí se define qué rol tendrá cada usuario:

u_reportes recibe rol_lectura
u_app recibe rol_lectura y rol_escritura
u_admin recibe rol_admin
Paso 4: permiso de conexión

Con GRANT CONNECT se permite que los roles puedan acceder a la base de datos.

Paso 5: permisos sobre el esquema

Con USAGE se autoriza el uso del esquema public, y con CREATE se permite que solo el administrador cree nuevos objetos.

Paso 6: creación de tablas

Se crean las tablas estudiante y curso como ejemplo para aplicar el control de privilegios.

Paso 7: permisos sobre tablas

Se asignan permisos específicos según el rol:

lectura para consultas
escritura para inserciones, actualizaciones y eliminaciones
administración completa para el rol administrador
Paso 8: permisos sobre secuencias

Como las tablas usan SERIAL, PostgreSQL crea secuencias automáticamente. Por eso se deben otorgar permisos sobre ellas, sobre todo al rol de escritura.

Paso 9: permisos avanzados para admin

Al usuario u_admin se le conceden atributos adicionales para administrar roles y bases de datos.

Paso 10: privilegios por defecto

Se configuran permisos automáticos para futuras tablas y secuencias, evitando tener que repetir manualmente los GRANT.

Paso 11: refuerzo de seguridad

Se utiliza REVOKE para asegurar que:

u_app no pueda crear tablas
u_reportes no pueda modificar datos

9. Conclusión

La práctica permitió implementar un modelo básico de seguridad en PostgreSQL usando roles, usuarios y privilegios. Se aplicó correctamente el principio de mínimo privilegio, garantizando que cada usuario tenga acceso solo a las funciones necesarias según su perfil.

Además, se evidenció la importancia de asignar permisos no solo a las tablas, sino también al esquema, la base de datos y las secuencias. Finalmente, el uso de privilegios por defecto facilita la administración futura del sistema.

10. Recomendación final

Antes de ejecutar el script, debes cambiar esta línea:

GRANT CONNECT ON DATABASE basedatos2 TO rol_lectura, rol_escritura, rol_admin;

por el nombre real de tu base de datos.

Si quieres, te lo paso en formato más formal de informe universitario, con portada, introducción, desarrollo, conclusión y bibliografía.