

CREATE TABLE pacientes (
    id_paciente SERIAL PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    departamento_asignado INT NOT NULL
);

CREATE TABLE medicos (
    id_medico SERIAL PRIMARY KEY,
    nombre VARCHAR(80),
    apellidos VARCHAR(100),
    departamento INT NOT NULL
);

CREATE TABLE citas (
    id_cita SERIAL PRIMARY KEY,
    id_paciente INT REFERENCES pacientes(id_paciente),
    id_medico INT REFERENCES medicos(id_medico),
    fecha_cita TIMESTAMP NOT NULL,
    motivo TEXT
);


CREATE ROLE rol_admin LOGIN PASSWORD 'Admin#2025';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rol_admin;

CREATE ROLE rol_medico LOGIN PASSWORD 'Medico#2025';

CREATE ROLE rol_recepcionista LOGIN PASSWORD 'Recep#2025';

CREATE ROLE rol_auditor LOGIN PASSWORD 'Auditor#2025';


ALTER TABLE pacientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE citas ENABLE ROW LEVEL SECURITY;


CREATE POLICY rls_pacientes_por_departamento
ON pacientes
FOR SELECT
TO rol_medico
USING ( departamento_asignado = current_setting('app.departamento')::INT );

CREATE POLICY rls_pacientes_recepcionista
ON pacientes
FOR SELECT
TO rol_recepcionista
USING (true);

CREATE POLICY rls_pacientes_auditor
ON pacientes
FOR SELECT
TO rol_auditor
USING (true);

ALTER TABLE pacientes FORCE ROW LEVEL SECURITY;
GRANT ALL PRIVILEGES ON pacientes TO rol_admin;


CREATE POLICY rls_citas_medico
ON citas
FOR SELECT
TO rol_medico
USING ( id_medico = current_setting('app.id_medico')::INT );

CREATE POLICY rls_citas_recepcionista
ON citas
FOR SELECT
TO rol_recepcionista
USING (true);

CREATE POLICY rls_citas_auditor
ON citas
FOR SELECT
TO rol_auditor
USING (true);

GRANT ALL PRIVILEGES ON citas TO rol_admin;


