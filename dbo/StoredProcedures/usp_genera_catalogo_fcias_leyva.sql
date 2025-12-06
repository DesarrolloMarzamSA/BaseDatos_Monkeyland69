
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_catalogo_fcias_leyva]
	@sucursal TINYINT

AS
/*	
	DECLARE @descuento varchar(6)

--DECLARE @sucursal TINYINT
--DECLARE @descuento varchar(6)
--SET @sucursal = 1

SELECT	@descuento = RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6) 
FROM	clientes_baan 
WHERE	sucursal = @sucursal AND 
		cliente = '08590'
				
SELECT	RIGHT(REPLICATE('0', 2) + CONVERT(VARCHAR, @sucursal), 2) +
		REPLICATE(' ', 10) +
		LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t1.cod_barras)) + REPLICATE(' ', 13), 13) +
		LEFT(t1.descripcion + REPLICATE(' ', 30), 30) +
		CASE t1.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2) + (ROUND(t1.prec_farm, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t1.prec_farm, 2, 2))), 9)
		END +
		CASE 
			WHEN t1.clas_fis = 'B' THEN @descuento
			WHEN t1.clas_fis = 'BA' THEN @descuento
			WHEN t1.clas_fis = 'N' THEN '  0.00' 
			WHEN t1.clas_fis = 'NA' THEN '  0.00' 
			WHEN t1.clas_fis = 'H' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
			WHEN t1.clas_fis = 'HA' THEN RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), t1.descto_prod), 6) 
		END
FROM	maestro_productos_baan t1 INNER JOIN inventario_baan t2 ON 
		t1.codigo = t2.codigo AND 
		t2.sucursal = @sucursal
WHERE	CONVERT(INT, t1.codigo) < dbo.gobierno() AND
		ISNUMERIC(t1.cod_barras) = 1 AND
		SUBSTRING(t1.status, 1, 1) <> 'B' AND
		t2.piezas > 10
ORDER BY t1.descripcion
*/

/**************modificacion solicitada por leyva************************************************/
DECLARE @porcentaje as money;
set @porcentaje=(select descuento from clientes_baan where sucursal=21 and cliente='08590' )
select codBarras+descripcion+precPublic+precFarmacia+porceFinanciero+iva+piezas
from(
select ltrim(rtrim(CONVERT(BIGINT, mp.cod_barras)))+ REPLICATE(' ', 15-len(CONVERT(BIGINT, mp.cod_barras)))  as codBarras,
REPLICATE(' ', 29-len(SUBSTRING(mp.descripcion,0,29)))+ltrim(rtrim(SUBSTRING(mp.descripcion,0,29))) as descripcion,
REPLICATE(' ', 8-len(CONVERT(varchar,mp.prec_pub))) +  CONVERT(varchar,mp.prec_pub)   as precPublic,
REPLICATE(' ', 7-len(CONVERT(varchar,mp.prec_farm)))+CONVERT(varchar,mp.prec_farm)	  as precFarmacia,
REPLICATE(' ', 5-len(CONVERT(varchar,monkeyland.dbo.udf_calc_descto_prod(clas_fis,@porcentaje,descto_prod))))+CONVERT(varchar,monkeyland.dbo.udf_calc_descto_prod(clas_fis,@porcentaje,descto_prod))as porceFinanciero,
REPLICATE(' ', 8-len(CONVERT(varchar,case when mp.iva=0.00 then 0 when mp.iva=0.11 then 11 when mp.iva=0.16 then 16 end)))+CONVERT(varchar,case when mp.iva=0.00 then 0 when mp.iva=0.11 then 11 when mp.iva=0.16 then 16 end) as iva,
REPLICATE(' ', 28-len(substring(mp.lab_largo,0,29)))+ltrim(rtrim(substring(mp.lab_largo,0,29))) +
ltrim(rtrim(CONVERT(varchar,case when t2.piezas=0 then 0 when t2.piezas<=50 then 1 when t2.piezas>50 then 2 end)))    as piezas
from maestro_productos mp INNER JOIN inventario_baan t2 ON 
		mp.codigo = t2.codigo AND 
		t2.sucursal = 21
WHERE	CONVERT(INT, mp.codigo) < dbo.gobierno() AND
		ISNUMERIC(mp.cod_barras) = 1 AND
		SUBSTRING(mp.status, 1, 1) <> 'B'
		--AND t2.piezas > 10
		)t1 
where codBarras+descripcion+precPublic+precFarmacia+porceFinanciero+iva+piezas is not null
ORDER BY t1.descripcion
GO
