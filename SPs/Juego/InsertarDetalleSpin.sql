USE [Tragamonedas]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[InsertarDetalleSpin]
    @id_spin INT,
    @id_simbolo INT,
    @fila INT,
    @columna INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Detalle_Spin (id_spin, id_simbolo, fila, columna)
    VALUES (@id_spin, @id_simbolo, @fila, @columna);
END
