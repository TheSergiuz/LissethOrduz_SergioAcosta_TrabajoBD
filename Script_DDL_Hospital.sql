CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    sexo ENUM('M','F','Otro') NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(120) UNIQUE,
    direccion VARCHAR(200),
    estado ENUM('Activo','Inactivo') DEFAULT 'Activo',
    CHECK (fecha_nacimiento <= CURDATE())
);

CREATE TABLE medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(120) UNIQUE,
    estado ENUM('Activo','Inactivo') DEFAULT 'Activo'
);

CREATE TABLE departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    ubicacion VARCHAR(100) NOT NULL
);

CREATE TABLE habitaciones (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) NOT NULL UNIQUE,
    tipo ENUM('Individual','Doble','UCI') NOT NULL,
    estado ENUM('Disponible','Ocupada','Mantenimiento') DEFAULT 'Disponible',
    id_departamento INT NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);


CREATE TABLE citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_cita DATETIME NOT NULL,
    motivo VARCHAR(255),
    estado ENUM('Programada','Cancelada','Realizada') DEFAULT 'Programada',

    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico),

    CHECK (fecha_cita >= NOW())
);

CREATE TABLE ingresos (
    id_ingreso INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_habitacion INT NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
    fecha_salida DATETIME,
    diagnostico VARCHAR(255),

    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_habitacion) REFERENCES habitaciones(id_habitacion),

    CHECK (fecha_salida IS NULL OR fecha_salida >= fecha_ingreso)
);

CREATE TABLE tratamientos (
    id_tratamiento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(255),
    costo DECIMAL(10,2) CHECK (costo >= 0)
);

CREATE TABLE historial_tratamientos (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_ingreso INT NOT NULL,
    id_tratamiento INT NOT NULL,
    fecha_aplicacion DATETIME NOT NULL,
    notas VARCHAR(255),

    FOREIGN KEY (id_ingreso) REFERENCES ingresos(id_ingreso),
    FOREIGN KEY (id_tratamiento) REFERENCES tratamientos(id_tratamiento),

    CHECK (fecha_aplicacion >= '2000-01-01')
);


CREATE TABLE medicamentos (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    proveedor VARCHAR(120),
    stock INT NOT NULL CHECK (stock >= 0),
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0)
);

CREATE TABLE recetas (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha_emision DATE NOT NULL,
    observaciones VARCHAR(255),

    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico),

    CHECK (fecha_emision <= CURDATE())
);

CREATE TABLE receta_detalle (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT NOT NULL,
    id_medicamento INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad >= 1),

    FOREIGN KEY (id_receta) REFERENCES recetas(id_receta),
    FOREIGN KEY (id_medicamento) REFERENCES medicamentos(id_medicamento)
);
