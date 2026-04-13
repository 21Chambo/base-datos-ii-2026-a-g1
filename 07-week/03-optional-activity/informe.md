# INFORME · Semana 7  
## Triggers y Automatización en PostgreSQL

---

## 1. Introducción

En esta práctica se estudió el uso de **triggers en PostgreSQL** como mecanismo de automatización dentro de una base de datos. Los triggers permiten ejecutar lógica automáticamente ante eventos como inserciones, actualizaciones o eliminaciones, garantizando consistencia, validación de datos y auditoría independientemente de la aplicación que interactúe con la base.

El objetivo principal fue implementar triggers de tipo **BEFORE** y **AFTER**, comprender sus diferencias y aplicarlos en un caso académico utilizando tablas de estudiantes y matrículas.

---

## 2. Objetivos

### 2.1 Objetivo general
Implementar triggers en PostgreSQL para automatizar validaciones, normalización de datos y auditoría.

### 2.2 Objetivos específicos
- Comprender la estructura de un trigger y su función asociada.
- Aplicar triggers BEFORE para modificar y validar datos.
- Implementar triggers AFTER para auditoría.
- Verificar el funcionamiento mediante pruebas.

---

## 3. Marco teórico

### 3.1 Definición de trigger

Un trigger es un mecanismo que ejecuta automáticamente una función cuando ocurre un evento en una tabla:

- INSERT
- UPDATE
- DELETE

### 3.2 Componentes principales

- **Función trigger**: función en PL/pgSQL que contiene la lógica.
- **NEW**: representa la nueva fila.
- **OLD**: representa la fila anterior.

### 3.3 Tipos de triggers

| Tipo   | Momento de ejecución | Uso principal |
|--------|---------------------|--------------|
| BEFORE | Antes de guardar    | Validación y modificación |
| AFTER  | Después de guardar  | Auditoría y registro |