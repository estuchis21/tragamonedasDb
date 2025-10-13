CREATE PROCEDURE DetectarDiagonal
    @id_spin INT,
    @tipo_diag VARCHAR(20) -- 'diagonal_desc' o 'diagonal_asc'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @simbolo INT, @tipo INT, @simbolo_prev INT = NULL, @conteo INT = 0;
    DECLARE @i INT;

    IF @tipo_diag = 'diagonal_desc' -- izquierda superior a derecha inferior
    BEGIN
        SET @i = 1;
        WHILE @i <= 3
        BEGIN
            SELECT @simbolo = d.id_simbolo
            FROM Detalle_Spin d
            WHERE d.id_spin = @id_spin AND d.fila = @i AND d.columna = @i;

            IF @simbolo_prev IS NULL OR @simbolo = @simbolo_prev
                SET @conteo = @conteo + 1;
            ELSE
                SET @conteo = 1;

            SET @simbolo_prev = @simbolo;
            SET @i = @i + 1;
        END
    END
    ELSE IF @tipo_diag = 'diagonal_asc' -- izquierda inferior a derecha superior
    BEGIN
        SET @i = 1;
        WHILE @i <= 3
        BEGIN
            SELECT @simbolo = d.id_simbolo
            FROM Detalle_Spin d
            WHERE d.id_spin = @id_spin AND d.fila = 4 - @i AND d.columna = @i;

            IF @simbolo_prev IS NULL OR @simbolo = @simbolo_prev
                SET @conteo = @conteo + 1;
            ELSE
                SET @conteo = 1;

            SET @simbolo_prev = @simbolo;
            SET @i = @i + 1;
        END
    END

    IF @conteo >= 3
    BEGIN
        INSERT INTO CombinacionesGanadoras(id_spin, tipo, cantidad_simbolos, valor)
        SELECT @id_spin, @tipo_diag, @conteo,
            (SELECT valor FROM Premio WHERE descripcion='Premio por 3 iguales');
    END
END
