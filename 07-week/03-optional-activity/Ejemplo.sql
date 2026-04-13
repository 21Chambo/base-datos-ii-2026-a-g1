CREATE TABLE estudiante (
  id BIGSERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL
);

CREATE TABLE matricula (
  id BIGSERIAL PRIMARY KEY,
  estudiante_id BIGINT NOT NULL REFERENCES estudiante(id),
  semestre TEXT NOT NULL,
  nota_final NUMERIC NULL,
  updated_at TIMESTAMP NULL
);

2. Función trigger BEFORE para normalizar nombre y timestamps

CREATE OR REPLACE FUNCTION fn_estudiante_before()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN

  NEW.nombre := INITCAP(TRIM(NEW.nombre));

  IF TG_OP = 'INSERT' THEN
    IF NEW.created_at IS NULL THEN
      NEW.created_at := NOW();
    END IF;
    NEW.updated_at := NOW();

  ELSIF TG_OP = 'UPDATE' THEN
    NEW.updated_at := NOW();
  END IF;

  RETURN NEW;

END;
$$;

3. Creación del trigger BEFORE en estudiante

CREATE TRIGGER trg_estudiante_before
BEFORE INSERT OR UPDATE ON estudiante
FOR EACH ROW
EXECUTE FUNCTION fn_estudiante_before();

4. Función trigger BEFORE para validar nota

CREATE OR REPLACE FUNCTION fn_matricula_validar_nota()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN

  IF NEW.nota_final IS NOT NULL AND (NEW.nota_final < 0 OR NEW.nota_final > 5) THEN
    RAISE EXCEPTION 'Nota fuera de rango (0 a 5). Valor=%', NEW.nota_final;
  END IF;

  NEW.updated_at := NOW();

  RETURN NEW;

END;
$$;

5. Creación del trigger BEFORE en matrícula

CREATE TRIGGER trg_matricula_before
BEFORE INSERT OR UPDATE ON matricula
FOR EACH ROW
EXECUTE FUNCTION fn_matricula_validar_nota();

6. Creación de la tabla de auditoría

CREATE TABLE matricula_audit (
  id BIGSERIAL PRIMARY KEY,
  operacion TEXT NOT NULL,
  matricula_id BIGINT,
  fecha TIMESTAMP NOT NULL DEFAULT NOW(),
  detalle TEXT
);

7. Función trigger AFTER para auditoría

CREATE OR REPLACE FUNCTION fn_matricula_audit()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN

  IF TG_OP = 'INSERT' THEN
    INSERT INTO matricula_audit(operacion, matricula_id, detalle)
    VALUES ('INSERT', NEW.id, 'Nueva matrícula registrada');
    RETURN NEW;

  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO matricula_audit(operacion, matricula_id, detalle)
    VALUES ('UPDATE', NEW.id, 'Matrícula actualizada');
    RETURN NEW;

  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO matricula_audit(operacion, matricula_id, detalle)
    VALUES ('DELETE', OLD.id, 'Matrícula eliminada');
    RETURN OLD;

  END IF;

END;
$$;

8. Creación del trigger AFTER

CREATE TRIGGER trg_matricula_audit
AFTER INSERT OR UPDATE OR DELETE ON matricula
FOR EACH ROW
EXECUTE FUNCTION fn_matricula_audit();

9. Pruebas

Insertar estudiante

INSERT INTO estudiante(nombre)
VALUES ('   maria lopez   ');

Consultar estudiante

SELECT * FROM estudiante;

Insertar matrícula

INSERT INTO matricula(estudiante_id, semestre, nota_final)
VALUES (1, '2026-1', 4.2);

Consultar matrícula

SELECT * FROM matricula;

Consultar auditoría

SELECT * FROM matricula_audit;

Actualizar matrícula

UPDATE matricula
SET nota_final = 3.5
WHERE id = 1;

Prueba de error

UPDATE matricula
SET nota_final = 7
WHERE id = 1;