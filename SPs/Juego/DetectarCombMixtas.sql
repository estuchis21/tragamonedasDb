CREATE PROCEDURE DetectarCombinacionMixta
    @id_spin INT,
    @tipo_comb VARCHAR(20), -- 'horizontal' o 'vertical'
    @pos INT                -- fila si horizontal, columna si vertical
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @simbolo INT, @tipo INT, @count_especial INT = 0, @count_normal INT = 0, @col INT, @fila INT;

    IF @tipo_comb = 'horizontal'
    BEGIN
        SET @col = 1;
        WHILE @col <= 5
        BEGIN
            SELECT @simbolo = d.id_simbolo, @tipo = s.id_tipo
            FROM Detalle_Spin d
            JOIN Simbolo s ON d.id_simbolo = s.id_simbolo
            WHERE d.id_spin = @id_spin AND d.fila = @pos AND d.columna = @col;

            IF @tipo = 1 SET @count_normal = @count_normal + 1;
            ELSE SET @count_especial = @count_especial + 1;

            SET @col = @col + 1;
        END
    END
    ELSE IF @tipo_comb = 'vertical'
    BEGIN
        SET @fila = 1;
        WHILE @fila <= 3
        BEGIN
            SELECT @simbolo = d.id_simbolo, @tipo = s.id_tipo
            FROM Detalle_Spin d
            JOIN Simbolo s ON d.id_simbolo = s.id_simbolo
            WHERE d.id_spin = @id_spin AND d.columna = @pos AND d.fila = @fila;

            IF @tipo = 1 SET @count_normal = @count_normal + 1;
            ELSE SET @count_especial = @count_especial + 1;

            SET @fila = @fila + 1;
        END
    END

    IF @count_especial >= 2 AND @count_normal >= 1
    BEGIN
        INSERT INTO CombinacionesGanadoras(id_spin, tipo, cantidad_simbolos, valor)
        SELECT @id_spin, @tipo_comb + '_mixta', @count_especial + @count_normal,
            (SELECT valor FROM Premio WHERE descripcion='Premio combinacion mixta');
    END
END
