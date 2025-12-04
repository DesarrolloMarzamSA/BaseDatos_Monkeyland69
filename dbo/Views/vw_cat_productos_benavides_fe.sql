
--	VISTA ESPECIAL PARA EMITIR LA FACTURACION ELECTRONICA DE BENAVIDES
--	CUANDO SE PIDEN REPROCESOS


CREATE VIEW [dbo].[vw_cat_productos_benavides_fe] AS
	SELECT 
		ca.codigo																				cod_mar, 
		RIGHT(ca.cod_prodcli,18)												cod_ben			, 
		ISNULL(mpb.cod_barras,REPLICATE('0',13))				cod_barras	, 
		ISNULL(mpb.descripcion,'')											descripcion	, 
		ca.fecha_hora_cambio														fecha				, 
		ca.STATUS																				estatus			,
		mpb.prec_farm																		prec_farm		
	FROM catalogo_autoservicios ca
	LEFT OUTER JOIN maestro_productos mpb ON mpb.codigo = ca.codigo
	WHERE sucursal = 7 AND segto = 'C1' AND ctepadre = '319' 
		AND CONVERT(INT,ca.codigo) < dbo.gobierno()
	--	AND ca.status = 'A'

GO

