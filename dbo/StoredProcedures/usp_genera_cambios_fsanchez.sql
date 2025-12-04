
CREATE PROCEDURE [dbo].[usp_genera_cambios_fsanchez] (@dias int)
AS 

--	HECHO POR:	MIGUEL SAMAYOA
--	CREACION:	2010/03/24
--	MODIFICACION:	2010-03-25

--	usp_genera_cambios_fsanchez 5


CREATE TABLE #cambios (
    codigo			VARCHAR(7), 
    fecha_hora	datetime, 
    cadena			VARCHAR(200)  
)

CREATE TABLE #presentacion  ( 
	cadena VARCHAR(200), 
	i INT IDENTITY  
)
	
	
INSERT INTO #cambios  ( codigo, fecha_hora, cadena  )
	SELECT mpb.codigo, cpb.fecha_hora, 
		LEFT(mpb.descripcion + '                                        ', 31) + 
		mpb.codigo +
		LEFT( RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, mpb.prec_farm ) ,7),10) +
		LEFT( RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, CASE mpb.grupo_est WHEN 'PC1A' THEN mpb.prec_pub + (mpb.prec_pub * 0.5) ELSE mpb.prec_pub END),10), 7) +  
		LEFT( RIGHT(REPLICATE('0',10) + CONVERT(VARCHAR, CASE mpb.grupo_est WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5) ELSE mpb.prec_farm END),10), 7) +
		mpb.cod_barras
	FROM maestro_productos_baan mpb 
	INNER JOIN cambios_precio_baan cpb  ON mpb.codigo = cpb.t_item 
	WHERE datediff(d, cpb.fecha_hora, CURRENT_TIMESTAMP) < @dias
		AND isnumeric(mpb.cod_barras) = 1 
		AND CONVERT(INT, mpb.codigo) < dbo.gobierno()
  
  
  --CURSOR PARA EVITAR ENVIAR DOS CAMBIOS DE PRECIO DE UN SÓLO
  --CODIGO EN CASO DE QUE CAMBIE MÁS DE UNA VEZ DE PRECIO EN LOS
  --ÚLTIMOS DÍAS
  
DECLARE @codigo VARCHAR(7) 
DECLARE @fecha_hora datetime 
DECLARE @cadena VARCHAR(200) 
DECLARE cur_codigos CURSOR fast_forward FOR 
  SELECT DISTINCT codigo, MAX(fecha_hora) 
  FROM #cambios 
  GROUP BY codigo OPEN cur_codigos 
  
FETCH NEXT FROM cur_codigos INTO	@codigo, @fecha_hora 
	
WHILE @@fetch_status = 0 
BEGIN
  SELECT 
    @cadena = cadena 
  FROM #cambios 
  WHERE codigo = @codigo 
    AND fecha_hora = @fecha_hora 
  
  INSERT INTO #presentacion VALUES ( @cadena )
  FETCH NEXT FROM cur_codigos INTO	@codigo, @fecha_hora 
END 

CLOSE cur_codigos 
DEALLOCATE cur_codigos  
SELECT cadena FROM #presentacion 
DROP TABLE #presentacion 
DROP TABLE #cambios

GO

