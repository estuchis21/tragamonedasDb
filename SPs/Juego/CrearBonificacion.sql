CREATE OR ALTER PROCEDURE CrearBonificacion
    @tipo NVARCHAR(30),
    @valor INT,
    @duracion INT,
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Bonificacion (tipo, valor, duracion, id_usuario)
    VALUES (@tipo, @valor, @duracion, @id_usuario);

    SELECT SCOPE_IDENTITY() AS id_bonificacion;
END
