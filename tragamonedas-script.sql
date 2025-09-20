-- =========================================================
-- MODELO DE DATOS: TRAGAMONEDAS EDUCATIVO (SQL SERVER)
-- =========================================================

-- 1. Usuarios
CREATE TABLE Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    puntaje_acumulado INT DEFAULT 100,
    partidas_jugadas INT DEFAULT 0
);

ALTER TABLE Usuario
ADD saldo INT DEFAULT 300000;



-- 2. Tipos de símbolos
CREATE TABLE TipoSimbolo (
    id_tipo INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(30) NOT NULL UNIQUE -- Ej: normal, especial, comodin, bonus
);

-- 3. Símbolos
CREATE TABLE Simbolo (
    id_simbolo INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    id_tipo INT NOT NULL,
    valor INT NOT NULL,
    FOREIGN KEY (id_tipo) REFERENCES TipoSimbolo(id_tipo)
);


DROP TABLE IF EXISTS Premio;
GO

CREATE TABLE Premio (
    id_premio INT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(100),
    valor INT NOT NULL,      -- puntos que da ese premio
    cantidad INT DEFAULT 1   -- cantidad de veces que puede otorgarse
);

ALTER TABLE Premio
ADD cantidad INT DEFAULT 1;



-- 4. Combinaciones
CREATE TABLE Combinacion (
    id_combinacion INT IDENTITY(1,1) PRIMARY KEY,
    tipo NVARCHAR(20) NOT NULL, -- Ej: 'horizontal','vertical','diagonal'
    cantidad_simbolos INT NOT NULL,
    id_premio INT,
    FOREIGN KEY (id_premio) REFERENCES Premio(id_premio)
);

-- Premios
INSERT INTO Premio (descripcion, valor) VALUES
('Premio por 3 iguales', 500),
('Premio por 4 iguales', 2000),
('Premio por 5 iguales', 10000);

-- Combinaciones
INSERT INTO Combinacion (tipo, cantidad_simbolos, id_premio) VALUES
('horizontal', 3, 1),
('horizontal', 4, 2),
('horizontal', 5, 3),
('vertical', 3, 1),
('vertical', 4, 2),
('vertical', 5, 3),
('diagonal', 3, 1),
('diagonal', 4, 2),
('diagonal', 5, 3);


-- 5. Spins (tiradas del usuario)
CREATE TABLE Spin (
    id_spin INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT,
    fecha DATETIME DEFAULT GETDATE(),
    resultado_total INT DEFAULT 0,
    premio_total INT DEFAULT 0,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

ALTER TABLE Spin
ADD tipo_apuesta NVARCHAR(20) DEFAULT 'horizontal'; -- 'horizontal', 'vertical', 'diagonal', 'todas'

ALTER TABLE Spin
ADD apuesta INT DEFAULT 0;



-- 6. Detalle de cada Spin (símbolos obtenidos)
CREATE TABLE Detalle_Spin (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_spin INT,
    id_simbolo INT,
    fila INT NOT NULL,
    columna INT NOT NULL,
    FOREIGN KEY (id_spin) REFERENCES Spin(id_spin),
    FOREIGN KEY (id_simbolo) REFERENCES Simbolo(id_simbolo)
);

-- 7. Bonificaciones
CREATE TABLE Bonificacion (
    id_bonificacion INT IDENTITY(1,1) PRIMARY KEY,
    tipo NVARCHAR(30) NOT NULL, -- Ej: 'giros_gratis','multiplicador','extra'
    valor INT NOT NULL,
    duracion INT DEFAULT 0, -- Ej: cantidad de spins
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);
