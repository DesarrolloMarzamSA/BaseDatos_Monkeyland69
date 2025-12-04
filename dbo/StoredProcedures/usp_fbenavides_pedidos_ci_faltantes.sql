CREATE
--	CREATE
PROCEDURE [dbo].[usp_fbenavides_pedidos_ci_faltantes] @archivo_cliente VARCHAR(50)
AS

/*
execute usp_fbenavides_pedidos_ci_faltantes 'PE20120203_190417.TXT'
*/


BEGIN
	UPDATE pedidos_fbenavides_ci SET cantidad_surtida = 0 WHERE arch_cliente = @archivo_cliente and cantidad_surtida IS NULL ;
	--UPDATE pedidos_benavides SET estatus = '0' WHERE cantidad_surtida < cantidad_pedida /*OR cantidad_surtida IS NULL*/ ;
	--UPDATE pedidos_benavides SET estatus = '1' WHERE cuenta IS NULL OR cuenta = '00000' ;
	--UPDATE pedidos_benavides SET estatus = '2' WHERE cod_barras IS NULL OR cod_barras = ' ' ;
	--UPDATE pedidos_benavides SET estatus = '9' WHERE cantidad_surtida >= cantidad_pedida ;
	
	
		SELECT   
		'05'																																														no_prov	,
		RIGHT('00'+ CONVERT(VARCHAR(2),ped.sucursal)																							, 2)  suc_mzm	,
		ped.cia																																													cia_ben	,
		ped.mostrador																																										alm_ben	,
		RIGHT(REPLICATE('0',10) + ped.pedido																											,10)  no_ped	,
		RIGHT(REPLICATE('0', 7) + CONVERT(VARCHAR,cantidad_pedida - cantidad_surtida )	, 7)  can_fal	,
		RIGHT(REPLICATE('0',18) + ped.cod_bena																										,18)	cod_ben	,
		CONVERT(VARCHAR(8), fecha_pedido,112)																														fecha		
		--	, cantidad_pedida					, cantidad_surtida															
	FROM  pedidos_fbenavides_ci  ped   
	WHERE	arch_cliente = @archivo_cliente AND
	 cantidad_surtida < cantidad_pedida and SUBSTRING(arch_cliente,1,4) not in('PECD')
	--and ped.archivo_hh is null 
	ORDER BY ped.linea 

	
END

GO

