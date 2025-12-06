
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE
--	CREATE
	PROCEDURE [dbo].[usp_fbenavides_pedidos_faltantes]

AS

BEGIN
	UPDATE pedidos_fbenavides SET cantidad_surtida = 0 WHERE cantidad_surtida IS NULL ;
	--UPDATE pedidos_benavides SET estatus = '0' WHERE cantidad_surtida < cantidad_pedida /*OR cantidad_surtida IS NULL*/ ;
	--UPDATE pedidos_benavides SET estatus = '1' WHERE cuenta IS NULL OR cuenta = '00000' ;
	--UPDATE pedidos_benavides SET estatus = '2' WHERE cod_barras IS NULL OR cod_barras = ' ' ;
	--UPDATE pedidos_benavides SET estatus = '9' WHERE cantidad_surtida >= cantidad_pedida ;

	SELECT   
		'05'																																								no_prov	,
		RIGHT('00'+ CONVERT(VARCHAR(2),ped.sucursal)																	, 2)  suc_mzm	,
		ped.cia																																							cia_ben	,
		ped.mostrador																																				alm_ben	,
		RIGHT(REPLICATE('0',10) + ped.pedido																					,10)  no_ped	,
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR,(cantidad_pedida-cantidad_surtida))	, 7)  can_fal	,
		RIGHT(REPLICATE('0',18) + ped.cod_bena																				,18)	cod_ben	,
		CONVERT(VARCHAR(8), fecha_pedido,112)																								fecha		
	FROM  pedidos_fbenavides  ped   
	WHERE	cantidad_pedida-cantidad_surtida > 0 and SUBSTRING(ped.arch_cliente,1,4) not in('PECD')
	--estatus in ('0')		--	, '1','2'
	ORDER BY ped.linea 
END
GO
