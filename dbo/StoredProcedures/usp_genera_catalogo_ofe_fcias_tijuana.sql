USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_catalogo_ofe_fcias_tijuana] --6,'C2','586'
	@sucursal TINYINT,
	@segto VARCHAR(2),
	@ctepadre VARCHAR(3)
WITH ENCRYPTION
AS

DECLARE @clavemayoristamarzam VARCHAR(10)
DECLARE @clavemayoristamedipac VARCHAR(10)
DECLARE @segunda_bolsa VARCHAR(5)
SET @clavemayoristamarzam = 'P01005    '
SET @clavemayoristamedipac = 'P01004    '
SET @segunda_bolsa = 'LIBRE'

	
--DECLARE @clavemayoristamarzam VARCHAR(10)
--DECLARE @clavemayoristamedipac VARCHAR(10)
--DECLARE @segto VARCHAR(2)
--DECLARE @ctepadre VARCHAR(3)
--DECLARE @sucursal TINYINT
--DECLARE @segunda_bolsa VARCHAR(5)
--SET @clavemayoristamarzam = 'P01005    '
--SET @clavemayoristamedipac = 'P01004    '
--SET @segto = 'C2'
--SET @ctepadre = '586'
--SET @sucursal = 25
--SET @segunda_bolsa = 'LIBRE'
	if (@sucursal = 25) begin 
SELECT	CASE
			WHEN @sucursal = 6 THEN @clavemayoristamarzam
			WHEN @sucursal = 25 THEN @clavemayoristamedipac
		END +
		'D' +
		LEFT(CONVERT(VARCHAR(15), CONVERT(BIGINT, T1.cod_barras_tandem)) + REPLICATE(' ', 15), 15) +
		LEFT('0000000' + REPLICATE(' ', 20), 20) +
		CASE WHEN t2.[PGPCA6] NOT IN (7, 8, 9) THEN '1' ELSE '0' END +'                                                 1' +
		RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, T2.OFERTA * 100)), 8)
 FROM [monkeyland].[dbo].ctlFarmaciasTijuana T2 inner join
  [monkeyland].[dbo].maestro_productos_baan t1  on T2.[PRODUCTO]=cast(t1.codigo as int)
  where T2.tipo2='Y13395' and t2.OFERTA>0
end
else
begin
SELECT	CASE
			WHEN @sucursal = 6 THEN @clavemayoristamarzam
			WHEN @sucursal = 25 THEN @clavemayoristamedipac
		END +
		'D' +
		LEFT(CONVERT(VARCHAR(15), CONVERT(BIGINT, T1.cod_barras_tandem)) + REPLICATE(' ', 15), 15) +
		LEFT('0000000' + REPLICATE(' ', 20), 20) +
		CASE WHEN t2.[PGPCA6] NOT IN (7, 8, 9) THEN '1' ELSE '0' END +'                                                 1' +
		RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, T2.OFERTA * 100)), 8)
 FROM [monkeyland].[dbo].ctlFarmaciasTijuana T2 inner join
  [monkeyland].[dbo].maestro_productos_baan t1  on T2.[PRODUCTO]=cast(t1.codigo as int)
   where T2.tipo2='J20636' and t2.OFERTA>0
end
GO
