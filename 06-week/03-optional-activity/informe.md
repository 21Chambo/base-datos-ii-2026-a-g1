# INFORME · Semana 6  
## Práctica Guiada: Usuarios, Roles y Privilegios en PostgreSQL

---

## 1. Introducción

En esta práctica se abordó la gestión de seguridad en PostgreSQL mediante la implementación de usuarios, roles y privilegios. El objetivo principal fue comprender cómo controlar el acceso a los recursos de la base de datos aplicando el principio de mínimo privilegio.

El uso adecuado de roles permite organizar permisos de forma eficiente, mientras que los privilegios garantizan que cada usuario solo pueda ejecutar las acciones necesarias según su función.

---

## 2. Objetivo

### 2.1 Objetivo general
Implementar un esquema básico de seguridad en PostgreSQL aplicando el principio de mínimo privilegio.

### 2.2 Objetivos específicos
- Crear roles de grupo para organizar permisos.
- Definir usuarios con acceso controlado.
- Asignar privilegios sobre base de datos, esquemas, tablas y secuencias.
- Verificar el acceso según el perfil de cada usuario.

---

## 3. Descripción de la práctica

Se construyó un entorno con tres perfiles de usuario:

- **u_reportes**: acceso de solo lectura  
- **u_app**: acceso de lectura y escritura  
- **u_admin**: acceso administrativo  

El proceso incluyó:
1. Creación de roles
2. Creación de usuarios
3. Asignación de roles
4. Configuración de permisos
5. Aplicación de medidas de seguridad adicionales

---

## 4. Conceptos aplicados

### 4.1 Rol
Entidad de seguridad a la que se le asignan permisos.

### 4.2 Usuario
Rol con atributo `LOGIN`, que permite iniciar sesión.

### 4.3 Esquema
Estructura lógica que contiene objetos como tablas y secuencias.

### 4.4 Privilegios
Permisos otorgados sobre objetos de la base de datos:

- CONNECT
- USAGE
- SELECT
- INSERT
- UPDATE
- DELETE
- CREATE

### 4.5 Principio de mínimo privilegio
Consiste en otorgar únicamente los permisos necesarios a cada usuario.

---

## 5. Metodología

Se siguió el siguiente orden de implementación:

1. Crear base de datos  
2. Conectarse a la base  
3. Crear roles  
4. Crear usuarios  
5. Asignar roles  
6. Crear tablas  
7. Asignar permisos  
8. Configurar privilegios por defecto  
9. Aplicar restricciones adicionales  

