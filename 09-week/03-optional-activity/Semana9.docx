Informe – Índices, rendimiento y planes de ejecución en PostgreSQL
1. Objetivo

Analizar el rendimiento de consultas en PostgreSQL mediante el uso de índices y comprobar su efecto con EXPLAIN ANALYZE, comparando el comportamiento antes y después de la optimización.

2. Introducción

En PostgreSQL, una consulta puede volverse lenta cuando la base de datos debe recorrer toda una tabla para encontrar resultados. Esto se conoce como Sequential Scan. Para mejorar el acceso a los datos, se pueden crear índices, que permiten localizar filas de manera más eficiente mediante Index Scan.

Sin embargo, no basta con crear índices. La forma correcta de comprobar si realmente ayudan es revisando el plan de ejecución con EXPLAIN ANALYZE, ya que esta herramienta muestra lo que la base de datos hace en realidad.

3. Desarrollo

Para la práctica se creó un modelo académico con tres tablas: estudiante, asignatura y matricula. Sobre este modelo se trabajaron tres consultas frecuentes:

consulta por semestre
consulta por semestre y asignatura
consulta con JOIN entre matrícula y estudiante

Primero se ejecutó cada consulta con EXPLAIN ANALYZE para observar el plan inicial. Después se crearon tres tipos de índices:

un índice simple sobre semestre
un índice compuesto sobre semestre, asignatura_id
un índice sobre estudiante_id para mejorar el JOIN

Luego se repitieron las consultas para comparar el tipo de scan, la cantidad de filas procesadas y el tiempo de ejecución.

4. Resultados esperados

Con los índices creados, se espera que PostgreSQL pueda cambiar de Seq Scan a Index Scan o a un plan más eficiente. También se espera una reducción en el costo estimado y en el tiempo total de ejecución, especialmente en consultas con filtros selectivos o relaciones entre tablas.

5. Conclusión

La práctica permitió comprobar que los índices pueden mejorar el rendimiento de las consultas cuando se aplican sobre columnas usadas en filtros y JOIN. Además, se confirmó que la mejor forma de validar una optimización es mediante EXPLAIN ANALYZE, porque muestra el plan real de ejecución y permite comparar objetivamente el antes y el después.