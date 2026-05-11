-- CREA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS veterinaria_db;
USE veterinaria_db;

-- TABLA USUARIOS
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    rol ENUM('admin', 'veterinario', 'voluntario', 'cliente') NOT NULL,
    especialidad VARCHAR(100),
    imagen_url VARCHAR(255)
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
    imagen_url VARCHAR(255),
    descripcion TEXT,
    estado_adopcion ENUM('disponible', 'adoptado', 'no_apto') DEFAULT 'no_apto',
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
    id_veterinario INT,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota),
    FOREIGN KEY (id_veterinario) REFERENCES usuarios(id_usuario)
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
    tipo_hogar VARCHAR(50),
    experiencia_previa BOOLEAN DEFAULT FALSE,
    ocupacion VARCHAR(150),
    sector_vivienda VARCHAR(150),
    motivo TEXT,
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
INSERT INTO usuarios (nombre, correo, telefono, rol, especialidad, imagen_url) VALUES
('Ana Lopez', 'ana@gmail.com', '0991111111', 'cliente', NULL, NULL),
('Dr. Carlos Perez', 'carlos@gmail.com', '0992222222', 'veterinario', 'Cirugía General', 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&q=80&w=400'),
('Dra. Sofia Mendez', 'sofia@gmail.com', '0995555555', 'veterinario', 'Medicina Interna', 'https://images.unsplash.com/photo-1594824436951-7f12bc4175de?auto=format&fit=crop&q=80&w=400'),
('Maria Ruiz', 'maria@gmail.com', '0993333333', 'voluntario', NULL, NULL);

-- MASCOTAS
INSERT INTO mascotas (nombre, especie, raza, edad, sexo, estado_salud, imagen_url, descripcion, estado_adopcion, id_usuario) VALUES
('Firulais', 'Perro', 'Labrador', 3, 'macho', 'Sano', 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&q=80&w=400', 'Juguetón y muy amigable con los niños.', 'disponible', NULL),
('Mishi', 'Gato', 'Siames', 2, 'hembra', 'Vacunada', NULL, 'Gatita muy tranquila.', 'adoptado', 1),
('Rocky', 'Perro', 'Bulldog', 1, 'macho', 'Sano', 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&q=80&w=400', 'Le encanta dormir en el sofá.', 'disponible', NULL);

-- CITAS
INSERT INTO citas (fecha, hora, motivo, estado, id_mascota, id_veterinario) VALUES
('2026-04-25', '10:00:00', 'Vacunacion anual', 'pendiente', 1, 2),
('2026-04-26', '11:30:00', 'Chequeo general', 'pendiente', 2, 3);

-- VACUNAS
INSERT INTO vacunas (nombre_vacuna, fecha_aplicacion, proxima_dosis, id_mascota) VALUES
('Rabia', '2026-04-20', '2027-04-20', 1),
('Triple felina', '2026-04-18', '2027-04-18', 2);

-- ADOPCIONES
INSERT INTO adopciones (fecha_adopcion, tipo_hogar, experiencia_previa, ocupacion, sector_vivienda, motivo, estado, id_mascota, id_usuario) VALUES
('2026-04-15', 'Casa', TRUE, 'Ingeniero', 'Norte de la ciudad', 'Queremos un nuevo miembro en la familia', 'en proceso', 1, 1);

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