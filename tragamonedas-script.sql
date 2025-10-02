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

-- 3. Premios
CREATE TABLE Premio (
    id_premio INT IDENTITY(1,1) PRIMARY KEY,
    descripcion NVARCHAR(100),
    valor INT NOT NULL
);

-- 4. Combinaciones
CREATE TABLE Combinacion (
    id_combinacion INT IDENTITY(1,1) PRIMARY KEY,
    tipo NVARCHAR(20) NOT NULL, -- Ej: 'horizontal','vertical','diagonal'
    cantidad_simbolos INT NOT NULL,
    id_premio INT,
    FOREIGN KEY (id_premio) REFERENCES Premio(id_premio)
);

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
ADD id_premio INT NULL,
    FOREIGN KEY (id_premio) REFERENCES Premio(id_premio);
    

-- 7. Relación Spin - Premio (tabla intermedia)
CREATE TABLE Spin_Premio (
    id_spin_premio INT IDENTITY(1,1) PRIMARY KEY,
    id_spin INT NOT NULL,
    id_premio INT NOT NULL,
    cantidad INT DEFAULT 1, -- cuántas veces se ganó ese premio en la tirada
    FOREIGN KEY (id_spin) REFERENCES Spin(id_spin),
    FOREIGN KEY (id_premio) REFERENCES Premio(id_premio)
);


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


CREATE TABLE CombinacionesGanadoras (
    id_combinacion_ganadora INT IDENTITY(1,1) PRIMARY KEY,
    id_spin INT NOT NULL,
    tipo NVARCHAR(20) NOT NULL,           -- 'horizontal', 'vertical', 'diagonal', 'combo'
    cantidad_simbolos INT NOT NULL,       -- cantidad de símbolos consecutivos
    valor INT NOT NULL                     -- valor total del premio
);
