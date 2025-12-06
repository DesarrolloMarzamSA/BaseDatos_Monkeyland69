
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_ftrebol_pedidos_insert]

@orden_compra								VARCHAR(9)			,
@sucursal										INT							,
@cliente										VARCHAR(5)			,
@cod_barras									VARCHAR(13)			,
@codigo											VARCHAR(7)			,
@cantidad_pedida						INT							,
--@cantidad_surtida						INT							,
@piezas_con_cargo						INT							,
@piezas_sin_cargo						INT							,
@precio_farnacia_sin_iva		MONEY						,
@importe_descto_oferta			MONEY						,
@importe_descto_comercial		MONEY						,
@linea											INT							,
@arch_cliente								VARCHAR(100)		,
@hash_md5										VARCHAR(50)		

/*
SELECT * FROM pedidos_ftrebol WITH (NOLOCK) ORDER BY linea
*/



AS

INSERT INTO pedidos_ftrebol	(
	fecha_pedido							,
	pedido							,
	sucursal									,
	cliente										,
	cod_barras								,
	codigo										,
	cantidad_pedida						,
	--cantidad_surtida					,
	piezas_con_cargo					,
	piezas_sin_cargo					,
	precio_farnacia_sin_iva		,
	importe_descto_oferta			,
	importe_descto_comercial	,
	linea											,
	arch_cliente							,
	hash_md5									,
	rftp											
) VALUES (
	GETDATE()										,
	@orden_compra								,
	@sucursal										,
	@cliente										,
	@cod_barras									,
	@codigo											,
	@cantidad_pedida						,
	--@cantidad_surtida						,
	@piezas_con_cargo						,
	@piezas_sin_cargo						,
	@precio_farnacia_sin_iva		,
	@importe_descto_oferta			,
	@importe_descto_comercial		,
	@linea											,
	@arch_cliente								,
	@hash_md5										,
	GETDATE()										
)
GO
