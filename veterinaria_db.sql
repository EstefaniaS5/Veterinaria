-- CREA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS veterinaria_db;
USE veterinaria_db;

-- TABLA USUARIOS
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    rol ENUM('admin', 'veterinario', 'voluntario', 'cliente') NOT NULL
);

-- TABLA MASCOTAS
CREATE TABLE mascotas (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    raza VARCHAR(50),
    edad INT,
    sexo ENUM('macho', 'hembra'),
    estado_salud VARCHAR(100),
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- TABLA CITAS
CREATE TABLE citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    motivo VARCHAR(150) NOT NULL,
    estado ENUM('pendiente', 'completada', 'cancelada') DEFAULT 'pendiente',
    id_mascota INT,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota)
);

-- TABLA VACUNAS
CREATE TABLE vacunas (
    id_vacuna INT AUTO_INCREMENT PRIMARY KEY,
    nombre_vacuna VARCHAR(100) NOT NULL,
    fecha_aplicacion DATE NOT NULL,
    proxima_dosis DATE,
    id_mascota INT,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota)
);

-- TABLA ADOPCIONES
CREATE TABLE adopciones (
    id_adopcion INT AUTO_INCREMENT PRIMARY KEY,
    fecha_adopcion DATE NOT NULL,
    estado ENUM('en proceso', 'aprobada', 'rechazada') DEFAULT 'en proceso',
    id_mascota INT,
    id_usuario INT,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- TABLA REPORTES
CREATE TABLE reportes (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    tipo_reporte VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    ubicacion VARCHAR(150),
    fecha_reporte DATE NOT NULL,
    estado ENUM('nuevo', 'en revision', 'resuelto') DEFAULT 'nuevo',
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- DATOS DE PRUEBA

-- USUARIOS
INSERT INTO usuarios (nombre, correo, telefono, rol) VALUES
('Ana Lopez', 'ana@gmail.com', '0991111111', 'cliente'),
('Carlos Perez', 'carlos@gmail.com', '0992222222', 'veterinario'),
('Maria Ruiz', 'maria@gmail.com', '0993333333', 'voluntario');

-- MASCOTAS
INSERT INTO mascotas (nombre, especie, raza, edad, sexo, estado_salud, id_usuario) VALUES
('Firulais', 'Perro', 'Labrador', 3, 'macho', 'Sano', 1),
('Mishi', 'Gato', 'Siames', 2, 'hembra', 'Vacunada', 1);

-- CITAS
INSERT INTO citas (fecha, hora, motivo, estado, id_mascota) VALUES
('2026-04-25', '10:00:00', 'Vacunacion anual', 'pendiente', 1),
('2026-04-26', '11:30:00', 'Chequeo general', 'pendiente', 2);

-- VACUNAS
INSERT INTO vacunas (nombre_vacuna, fecha_aplicacion, proxima_dosis, id_mascota) VALUES
('Rabia', '2026-04-20', '2027-04-20', 1),
('Triple felina', '2026-04-18', '2027-04-18', 2);

-- ADOPCIONES
INSERT INTO adopciones (fecha_adopcion, estado, id_mascota, id_usuario) VALUES
('2026-04-15', 'en proceso', 1, 1);

-- REPORTES
INSERT INTO reportes (tipo_reporte, descripcion, ubicacion, fecha_reporte, estado, id_usuario) VALUES
('Abandono', 'Perro encontrado en la calle en mal estado', 'Pillaro centro', '2026-04-22', 'nuevo', 3);


-- CONSULTAS DE PRUEBA

-- VER TODAS LAS TABLAS
SELECT * FROM usuarios;
SELECT * FROM mascotas;
SELECT * FROM citas;
SELECT * FROM vacunas;
SELECT * FROM adopciones;
SELECT * FROM reportes;

-- JOIN MASCOTAS Y USUARIOS
SELECT m.nombre AS mascota, u.nombre AS propietario
FROM mascotas m
JOIN usuarios u ON m.id_usuario = u.id_usuario;

-- JOIN CITAS Y MASCOTAS
SELECT c.fecha, c.hora, c.motivo, m.nombre AS mascota
FROM citas c
JOIN mascotas m ON c.id_mascota = m.id_mascota;