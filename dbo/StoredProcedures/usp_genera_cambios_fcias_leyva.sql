
CREATE PROCEDURE [dbo].[usp_genera_cambios_fcias_leyva]
AS
/*
SELECT	LEFT(CONVERT(VARCHAR(13), CONVERT(BIGINT, t2.cod_barras)) + REPLICATE(' ', 13), 13) + 
		LEFT(t2.descripcion + REPLICATE(' ', 30), 30) + 
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t2.prec_pub, 2, 2) + (ROUND(t2.prec_pub, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t2.prec_pub, 2, 2))), 9)
		END +
		CASE t2.grupo_est 
			WHEN 'PC01A' THEN RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t2.prec_farm, 2, 2) + (ROUND(t2.prec_farm, 2, 2) * 0.5))), 9)
			ELSE RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR(9), CONVERT(MONEY, ROUND(t2.prec_farm, 2, 2))), 9)
		END 
FROM	cambios_precio_baan t1 INNER JOIN maestro_productos_baan t2 ON 
		t1.t_item = t2.codigo
WHERE	DATEDIFF(DD, t1.fecha_hora, CURRENT_TIMESTAMP) <= 5 AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		CONVERT(int, t2.codigo) < dbo.gobierno() AND
		SUBSTRING(t2.status, 1, 1) <> 'B'
ORDER BY t2.descripcion
*/

DECLARE @descuento VARCHAR(6)

SELECT	@descuento = RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR(6), descuento), 6)   
FROM	clientes_baan   
WHERE	sucursal = 21 AND   
		cliente = '08590'  
		
SELECT	REPLICATE(' ', 15-len(CONVERT(BIGINT, t2.cod_barras)))+ltrim(rtrim(CONVERT(BIGINT, t2.cod_barras)))+
REPLICATE(' ', 29-len(SUBSTRING(t2.descripcion,0,29)))+ltrim(rtrim(SUBSTRING(t2.descripcion,0,29)))+
REPLICATE(' ', 8-len(CONVERT(varchar,t2.prec_pub))) +  CONVERT(varchar,t2.prec_pub)+
REPLICATE(' ', 7-len(CONVERT(varchar,t2.prec_farm)))+  CONVERT(varchar,t2.prec_farm)+
REPLICATE(' ', 5-len(CONVERT(varchar,monkeyland.dbo.udf_calc_descto_prod(clas_fis,@descuento,descto_prod))))+CONVERT(varchar,monkeyland.dbo.udf_calc_descto_prod(clas_fis,@descuento,descto_prod))+
REPLICATE(' ', 8-len(CONVERT(varchar,case when t2.iva=0.00 then 0 when t2.iva=0.16 then 16 when t2.iva=0.16 then 16 end)))+CONVERT(varchar,case when t2.iva=0.00 then 0 when t2.iva=0.16 then 16 when t2.iva=0.16 then 16 end)
FROM	cambios_precio_baan t1 INNER JOIN maestro_productos_baan t2 ON 
		t1.t_item = t2.codigo
WHERE	DATEDIFF(DD, t1.fecha_hora, CURRENT_TIMESTAMP) <= 5 AND
		ISNUMERIC(t2.cod_barras) = 1 AND
		CONVERT(int, t2.codigo) < dbo.gobierno() AND
		SUBSTRING(t2.status, 1, 1) <> 'B'
ORDER BY t2.descripcion

GO

