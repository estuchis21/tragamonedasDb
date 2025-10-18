CREATE OR ALTER PROCEDURE EvaluarPremioSpin
    @id_spin INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @totalPremio INT = 0;
    DECLARE @id_usuario INT;

    SELECT @id_usuario = id_usuario FROM Spin WHERE id_spin = @id_spin;

    -- ================================
    -- HORIZONTALES
    -- ================================
    ;WITH Horizontales AS (
        SELECT d.fila, d.id_simbolo, MAX(s.valor) AS valorSimbolo, COUNT(*) AS repetidos
        FROM Detalle_Spin d
        INNER JOIN Simbolo s ON d.id_simbolo = s.id_simbolo
        WHERE d.id_spin = @id_spin
        GROUP BY d.fila, d.id_simbolo
        HAVING COUNT(*) >= 3
    )
    SELECT @totalPremio += ISNULL(SUM(valorSimbolo),0) FROM Horizontales;

    -- ================================
    -- VERTICALES
    -- ================================
    ;WITH Verticales AS (
        SELECT d.columna, d.id_simbolo, MAX(s.valor) AS valorSimbolo, COUNT(*) AS repetidos
        FROM Detalle_Spin d
        INNER JOIN Simbolo s ON d.id_simbolo = s.id_simbolo
        WHERE d.id_spin = @id_spin
        GROUP BY d.columna, d.id_simbolo
        HAVING COUNT(*) >= 3
    )
    SELECT @totalPremio += ISNULL(SUM(valorSimbolo),0) FROM Verticales;

    -- ================================
    -- DIAGONAL ?
    -- ================================
    ;WITH Diagonal1 AS (
        SELECT d.id_simbolo, MAX(s.valor) AS valorSimbolo, COUNT(*) AS repetidos
        FROM Detalle_Spin d
        INNER JOIN Simbolo s ON d.id_simbolo = s.id_simbolo
        WHERE d.id_spin = @id_spin
          AND ((fila=1 AND columna=1) OR (fila=2 AND columna=2) OR (fila=3 AND columna=3))
        GROUP BY d.id_simbolo
        HAVING COUNT(*) = 3
    )
    SELECT @totalPremio += ISNULL(SUM(valorSimbolo),0) FROM Diagonal1;

    -- ================================
    -- DIAGONAL ?
    -- ================================
    ;WITH Diagonal2 AS (
        SELECT d.id_simbolo, MAX(s.valor) AS valorSimbolo, COUNT(*) AS repetidos
        FROM Detalle_Spin d
        INNER JOIN Simbolo s ON d.id_simbolo = s.id_simbolo
        WHERE d.id_spin = @id_spin
          AND ((fila=1 AND columna=5) OR (fila=2 AND columna=4) OR (fila=3 AND columna=3))
        GROUP BY d.id_simbolo
        HAVING COUNT(*) = 3
    )
    SELECT @totalPremio += ISNULL(SUM(valorSimbolo),0) FROM Diagonal2;

    -- ================================
    -- Actualizar spin y saldo usuario
    -- ================================
    UPDATE Spin
    SET premio_total = @totalPremio,
        resultado_total = resultado_total + @totalPremio
    WHERE id_spin = @id_spin;

    UPDATE Usuario
    SET saldo = saldo + @totalPremio,
        puntaje_acumulado = puntaje_acumulado + @totalPremio
    WHERE id_usuario = @id_usuario;

    -- Resultado final
    SELECT @totalPremio AS PremioGanado,
           (SELECT saldo FROM Usuario WHERE id_usuario=@id_usuario) AS SaldoFinal;
END;
GO
