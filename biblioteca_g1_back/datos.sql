-- Crear la base de datos
CREATE DATABASE biblioteca;

-- Usar la base de datos
USE biblioteca;

-- Crear tabla de secciones
CREATE TABLE secciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Crear tabla de asientos
CREATE TABLE asientos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seccion_id INT NOT NULL,
    estaReservado BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (seccion_id) REFERENCES secciones(id) ON DELETE CASCADE
);

-- Insertar datos iniciales en la tabla de secciones
INSERT INTO secciones (nombre) VALUES 
('Infantil'),
('Juvenil'),
('Adultos'),
('Referencia');

-- Insertar datos iniciales en la tabla de asientos (20 asientos por sección)
INSERT INTO asientos (seccion_id) 
SELECT id FROM secciones, (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20) nums;
