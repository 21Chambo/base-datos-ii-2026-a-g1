# INFORME · Índices, Rendimiento y Planes de Ejecución en PostgreSQL

## 1. Objetivo

Analizar el rendimiento de consultas en PostgreSQL mediante el uso de índices y comprobar su efecto utilizando `EXPLAIN ANALYZE`, comparando el comportamiento antes y después de la optimización.

## 2. Introducción

En PostgreSQL, el rendimiento de las consultas puede verse afectado cuando el motor de base de datos necesita recorrer completamente una tabla para encontrar los datos requeridos. Este proceso se conoce como **Sequential Scan**.

Para optimizar el acceso a la información, se utilizan **índices**, los cuales permiten localizar filas de manera más eficiente mediante estructuras especializadas. Cuando un índice es utilizado correctamente, PostgreSQL puede ejecutar un **Index Scan**, reduciendo significativamente el costo de la consulta.

Sin embargo, la simple creación de índices no garantiza mejoras. Es necesario verificar su impacto mediante herramientas como `EXPLAIN ANALYZE`, que permite observar el plan de ejecución real, incluyendo tiempos, costos y operaciones realizadas por el motor.

## 3. Desarrollo

Para esta práctica se trabajó con un modelo académico compuesto por tres tablas:

- `estudiante`
- `asignatura`
- `matricula`

Sobre este modelo se analizaron consultas representativas, enfocadas en:

- Filtros por semestre
- Combinaciones de condiciones (semestre y asignatura)
- Relaciones entre tablas mediante JOIN

Con base en estas consultas, se implementaron distintos tipos de índices:

- **Índice simple** sobre la columna `semestre`
- **Índice compuesto** sobre `(semestre, asignatura_id)`
- **Índice** sobre `estudiante_id` para optimizar operaciones JOIN

El propósito fue observar cómo estos índices influyen en el comportamiento del plan de ejecución generado por PostgreSQL.

## 4. Resultados esperados

Tras la implementación de índices, se espera que:

- PostgreSQL cambie de **Sequential Scan** a **Index Scan** o estrategias más eficientes.
- Disminuya el costo estimado de las consultas.
- Se reduzca el número de filas procesadas.
- Mejore el tiempo total de ejecución.

Estas mejoras son más evidentes en consultas con filtros selectivos o en aquellas que involucran relaciones entre múltiples tablas.

## 5. Conclusión

La práctica permitió evidenciar que los índices son una herramienta fundamental para optimizar el rendimiento de consultas en PostgreSQL, especialmente cuando se aplican sobre columnas utilizadas en condiciones de filtrado y operaciones JOIN.

Asimismo, se confirmó que la forma más confiable de validar una optimización es mediante el uso de `EXPLAIN ANALYZE`, ya que proporciona una visión detallada del plan de ejecución real, permitiendo comparar de manera objetiva el rendimiento antes y después de aplicar mejoras.