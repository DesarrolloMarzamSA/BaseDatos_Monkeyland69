
CREATE PROCEDURE [dbo].[usp_genera_cambios_precio_fregis]
AS
--PROCEDIMIENTO PARA  CAMBIOS FCIAS. REGIS DE REYNOSA



DECLARE @sucursal INT
set @sucursal = 7


SET NOCOUNT ON
CREATE TABLE #cambios (
	codigo VARCHAR(7), fecha_hora DATETIME, cadena VARCHAR(200)
)

CREATE TABLE #presentacion (cadena VARCHAR(200), i INT IDENTITY)

INSERT INTO #cambios(codigo, fecha_hora, cadena) 
SELECT 
	mpb.codigo,
	cpb.fecha_hora, 
	LEFT(CONVERT(VARCHAR, CONVERT(BIGINT, mpb.cod_barras)) + REPLICATE(' ',13), 13) +
	LEFT(mpb.descripcion + REPLICATE(' ',30), 30) +
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, cpb.t_prpn),  9) +
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, cpb.t_prfn),  9) +
	' ' + mpb.codigo

FROM maestro_productos_baan mpb 
INNER JOIN inventario_baan ib on mpb.codigo = ib.codigo
INNER JOIN cambios_precio_baan cpb on mpb.codigo = cpb.t_item
WHERE
	DATEDIFF(d, cpb.fecha_hora, CURRENT_TIMESTAMP) < 5 AND
	ib.sucursal = @sucursal AND
	ISNUMERIC(mpb.cod_barras) = 1 AND 
	CONVERT(INT, mpb.codigo) < dbo.gobierno()
ORDER BY
mpb.descripcion
ASC

--CURSOR PARA EVITAR ENVIAR DOS CAMBIOS DE PRECIO DE UN SÓLO
--CODIGO EN CASO DE QUE CAMBIE MÁS DE UNA VEZ DE PRECIO EN LOS
--ÚLTIMOS DÍAS

DECLARE @codigo VARCHAR(7)
DECLARE @fecha_hora DATETIME
DECLARE @cadena VARCHAR(200)
DECLARE cur_codigos CURSOR FAST_FORWARD FOR 
	SELECT DISTINCT codigo, MAX(fecha_hora) FROM #cambios GROUP BY codigo

OPEN cur_codigos
FETCH NEXT FROM cur_codigos INTO @codigo, @fecha_hora


WHILE @@fetch_status = 0
BEGIN
      SELECT @cadena = cadena from #cambios where codigo = @codigo and fecha_hora = @fecha_hora
      INSERT INTO #presentacion values(@cadena)
      FETCH NEXT FROM cur_codigos into @codigo, @fecha_hora
END
CLOSE cur_codigos
DEALLOCATE cur_codigos

SELECT cadena FROM #presentacion

DROP TABLE #presentacion
DROP TABLE #cambios

SET NOCOUNT OFF

GO

