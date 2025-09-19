CREATE OR ALTER PROCEDURE existePorDni
    @dni INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Usuario WHERE dni = @dni)
    BEGIN
        -- Lanza error si ya existe
        THROW 50000, 'El usuario ya existe con ese DNI', 1;
    END
END
GO
