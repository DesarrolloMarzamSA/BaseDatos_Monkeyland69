USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_catalogo_art_fcias_tijuana]-- 6,'C2','586'
	@sucursal TINYINT,
	@segto VARCHAR(5),
	@ctepadre VARCHAR(5)
WITH ENCRYPTION
AS 
DECLARE @clavemayoristamarzam VARCHAR(10)
DECLARE @clavemayoristamedipac VARCHAR(10)
SET @clavemayoristamarzam = 'P01005    '
SET @clavemayoristamedipac = 'P01004    '

--DECLARE @clavemayoristamarzam VARCHAR(10)
--DECLARE @clavemayoristamedipac VARCHAR(10)
--DECLARE @segto VARCHAR(5)
--DECLARE @ctepadre VARCHAR(5)
--DECLARE @sucursal TINYINT
--SET @clavemayoristamarzam = 'P01005    '
--SET @clavemayoristamedipac = 'P01004    '
--SET @segto = 'C2'
--SET @ctepadre = '586'
--SET @sucursal = 25
if (@sucursal = 25) begin 
SELECT CASE
			WHEN @sucursal = 6 THEN @clavemayoristamarzam
			WHEN @sucursal = 25 THEN @clavemayoristamedipac
		END +'A'+LEFT(CONVERT(VARCHAR(15), CONVERT(BIGINT, t1.cod_barras_tandem)) + REPLICATE(' ', 15), 15)+
		LEFT( REPLICATE(' ', 20), 20)+
		CASE
			WHEN [PGPCA6] NOT IN (7, 8, 9) THEN '1'
			ELSE '0'
		END+LEFT(REPLACE([PGDESC], '"', '') + REPLICATE(' ', 50), 50)+
		 CASE
			WHEN t1.iva > 0 
			THEN RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, CASE t1.grupo_est WHEN 'PC01A' THEN t1.prec_pub * 1.10 + (t1.prec_pub * 1.10 * 0.5) ELSE t1.prec_pub * 1.10 END * 100)), 8)
			ELSE RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end * 100)), 8)
		END+RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, CASE t1.grupo_est WHEN 'PC01A' THEN t1.prec_farm + (t1.prec_farm * 0.5) ELSE t1.prec_farm END * 100)), 8)+
		RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, [COMERCIAL] * 100)), 8)+
		RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, CASE t1.grupo_est WHEN 'PC01A' THEN t1.prec_farm + (t1.prec_farm * 0.5) ELSE t1.prec_farm END * 100)), 8)+
		CASE
			WHEN t1.iva > 0 THEN RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), CONVERT(INT, t2.iva )), 2)
			ELSE '00'
		END+'       PZA'+
		' ' +
		CASE
			WHEN t2.PGPCA5 = 'N' THEN 'N'
			WHEN t2.PGPCA5 = 'NA' THEN 'N'
			WHEN t2.PGPCA5 = 'B' THEN 'B'
			WHEN t2.PGPCA5 = 'BA' THEN 'B'
			WHEN t2.PGPCA5 = 'H' THEN 'L'
			WHEN t2.PGPCA5 = 'HA' THEN 'L'
			WHEN t2.PGPCA5 = 'F' THEN 'N'
			WHEN t2.PGPCA5 = 'FA' THEN 'N'
		END +case
			when SUBSTRING(t1.status, 1, 1) = 'B' then '2'
			else case
							WHEN t2.PGPCA5 in ('F','FA') THEN '3'
							else '1'
						end end+case when t2.IEPS is null then '   0'
		else RIGHT(REPLICATE(' ', 4) + CONVERT(VARCHAR(4), T2.IEPS), 4) end +
		 '     1'		
		  FROM [monkeyland].[dbo].ctlFarmaciasTijuana T2 inner join
  [monkeyland].[dbo].maestro_productos_baan t1  on T2.[PRODUCTO]=cast(t1.codigo as int)
  where T2.tipo2='Y13395'
end
else
begin
			SELECT CASE
			WHEN @sucursal = 6 THEN @clavemayoristamarzam
			WHEN @sucursal = 25 THEN @clavemayoristamedipac
		END +'A'+LEFT(CONVERT(VARCHAR(15), CONVERT(BIGINT, t1.cod_barras_tandem)) + REPLICATE(' ', 15), 15)+
		LEFT( REPLICATE(' ', 20), 20)+
		CASE
			WHEN [PGPCA6] NOT IN (7, 8, 9) THEN '1'
			ELSE '0'
		END+LEFT(REPLACE([PGDESC], '"', '') + REPLICATE(' ', 50), 50)+
		 CASE
			WHEN t1.iva > 0 
			THEN RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, CASE t1.grupo_est WHEN 'PC01A' THEN t1.prec_pub * 1.10 + (t1.prec_pub * 1.10 * 0.5) ELSE t1.prec_pub * 1.10 END * 100)), 8)
			ELSE RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end * 100)), 8)
		END+RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, CASE t1.grupo_est WHEN 'PC01A' THEN t1.prec_farm + (t1.prec_farm * 0.5) ELSE t1.prec_farm END * 100)), 8)+
		RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, [COMERCIAL] * 100)), 8)+
		RIGHT(REPLICATE(' ', 8) + CONVERT(VARCHAR(8), CONVERT(INT, CASE t1.grupo_est WHEN 'PC01A' THEN t1.prec_farm + (t1.prec_farm * 0.5) ELSE t1.prec_farm END * 100)), 8)+
		CASE
			WHEN t1.iva > 0 THEN RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR(2), CONVERT(INT, t2.iva )), 2)
			ELSE '00'
		END+'       PZA'+
		' ' +
		CASE
			WHEN t2.PGPCA5 = 'N' THEN 'N'
			WHEN t2.PGPCA5 = 'NA' THEN 'N'
			WHEN t2.PGPCA5 = 'B' THEN 'B'
			WHEN t2.PGPCA5 = 'BA' THEN 'B'
			WHEN t2.PGPCA5 = 'H' THEN 'L'
			WHEN t2.PGPCA5 = 'HA' THEN 'L'
			WHEN t2.PGPCA5 = 'F' THEN 'N'
			WHEN t2.PGPCA5 = 'FA' THEN 'N'
		END +case
			when SUBSTRING(t1.status, 1, 1) = 'B' then '2'
			else case
							WHEN t2.PGPCA5 in ('F','FA') THEN '3'
							else '1'
						end end+case when t2.IEPS is null then '   0'
		else RIGHT(REPLICATE(' ', 4) + CONVERT(VARCHAR(4), T2.IEPS), 4) end +
		 '     1'		
		  FROM [monkeyland].[dbo].ctlFarmaciasTijuana T2 inner join
  [monkeyland].[dbo].maestro_productos_baan t1  on T2.[PRODUCTO]=cast(t1.codigo as int)
  where T2.tipo2='J20636'
		end
		--select * from capa_ibs.dbo.pedidos_traductor where archivo like '%PFB99647%'
		--select * from [monkeyland].[dbo].[ctlTijuana]
GO
