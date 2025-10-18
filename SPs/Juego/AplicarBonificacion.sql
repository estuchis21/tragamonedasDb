
CREATE OR ALTER PROCEDURE AplicarBonificacion
    @id_bonificacion INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_usuario INT, @valor INT;

    SELECT @id_usuario = id_usuario, @valor = valor
    FROM Bonificacion
    WHERE id_bonificacion = @id_bonificacion;

    UPDATE Usuario
    SET saldo = saldo + @valor
    WHERE id_usuario = @id_usuario;
END
GO
