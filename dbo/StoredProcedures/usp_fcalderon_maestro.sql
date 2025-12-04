

CREATE	--	CREATE
PROCEDURE usp_fcalderon_maestro AS



DECLARE @porc_comerc MONEY, @fecha_ini_porc DATETIME
SET @porc_comerc = 
(SELECT descuento FROM clientes_baan WHERE sucursal = 8 AND cliente = '00309')
SET @fecha_ini_porc = 
(SELECT fecha_alta FROM clientes_baan WHERE sucursal = 8 AND cliente = '00309')

SELECT 
	mpb.cod_barras																							,
	mpb.descripcion																							,
	mpb.lab_largo																								,
	mpb.prec_farm																								,
	mpb.prec_pub																								,
	ofe.porcentaje																							,
	CONVERT(VARCHAR(10),ofe.vigencia_inicial,3)		Fecha_Ini_Ofe	,
	CONVERT(VARCHAR(10),ofe.vigencia_final,3)			Fecha_Fin_Ofe	,
	ofe.cant_base																								,
	0 Min_Ofe																										,
	@porc_comerc porc_comerc																		,
	
	CONVERT(VARCHAR(10),@fecha_ini_porc,3)				Fecha_Ini_PC	,
	CONVERT(VARCHAR(10),CURRENT_TIMESTAMP,3)			Fecha_Din_PC	,
	@porc_comerc porc_com_limit																	--,
	
	
	
FROM maestro_productos_baan mpb
INNER JOIN dboferta ofe ON mpb.codigo = ofe.codigo 
	AND ofe.bolsa = 'PLUS7' AND ofe.sucursal = 8
WHERE LEFT(mpb.status,1) <> 'B'

GO

