
CREATE PROCEDURE registrar_ingreso (
    IN p_id_paciente INT,
    IN p_id_habitacion INT,
    IN p_diagnostico VARCHAR(255)
)
BEGIN
    DECLARE habitacion_estado VARCHAR(20);

    -- Verificar que la habitación esté disponible
    SELECT estado INTO habitacion_estado
    FROM habitaciones
    WHERE id_habitacion = p_id_habitacion;

    IF habitacion_estado <> 'Disponible' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La habitación no está disponible para ingreso.';
    END IF;

    -- Registrar el ingreso
    INSERT INTO ingresos (id_paciente, id_habitacion, fecha_ingreso, diagnostico)
    VALUES (p_id_paciente, p_id_habitacion, NOW(), p_diagnostico);

    -- Cambiar estado de la habitación
    UPDATE habitaciones
    SET estado = 'Ocupada'
    WHERE id_habitacion = p_id_habitacion;


CREATE PROCEDURE dar_alta_paciente (
    IN p_id_ingreso INT
)
BEGIN
    DECLARE habitacion_id INT;
    DECLARE salida_actual DATETIME;

    -- Validar que el ingreso exista y no tenga salida registrada
    SELECT id_habitacion, fecha_salida
    INTO habitacion_id, salida_actual
    FROM ingresos
    WHERE id_ingreso = p_id_ingreso;

    IF salida_actual IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El paciente ya fue dado de alta anteriormente.';
    END IF;

    -- Registrar fecha de salida
    UPDATE ingresos
    SET fecha_salida = NOW()
    WHERE id_ingreso = p_id_ingreso;

    -- Liberar habitación
    UPDATE habitaciones
    SET estado = 'Disponible'
    WHERE id_habitacion = habitacion_id;


CREATE PROCEDURE agregar_tratamiento (
    IN p_id_ingreso INT,
    IN p_id_tratamiento INT,
    IN p_notas VARCHAR(255)
)
BEGIN
    INSERT INTO historial_tratamientos (id_ingreso, id_tratamiento, fecha_aplicacion, notas)
    VALUES (p_id_ingreso, p_id_tratamiento, NOW(), p_notas);



CREATE TABLE IF NOT EXISTS auditoria_ingresos (
    id_audit INT AUTO_INCREMENT PRIMARY KEY,
    id_ingreso INT,
    fecha_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100),
    cambio JSON
);


CREATE TRIGGER trg_audit_ingresos
AFTER UPDATE ON ingresos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_ingresos (id_ingreso, usuario, cambio)
    VALUES (
        OLD.id_ingreso,
        USER(),
        JSON_OBJECT(
            'fecha_salida_old', OLD.fecha_salida,
            'fecha_salida_new', NEW.fecha_salida,
            'habitacion_old', OLD.id_habitacion,
            'habitacion_new', NEW.id_habitacion
        )
);


CREATE TRIGGER trg_validar_disponibilidad
BEFORE INSERT ON ingresos
FOR EACH ROW
BEGIN
    DECLARE estado_actual VARCHAR(20);

    SELECT estado INTO estado_actual
    FROM habitaciones
    WHERE id_habitacion = NEW.id_habitacion;

    IF estado_actual <> 'Disponible' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede ingresar un paciente en una habitación ocupada.';
    END IF;

