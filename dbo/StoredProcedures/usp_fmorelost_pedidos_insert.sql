
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_fmorelost_pedidos_insert]

@fecha_pedido								SMALLDATETIME		,
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
SELECT * FROM pedidos_fmorelost WITH (NOLOCK) ORDER BY linea
*/


AS

/*
EXECUTE usp_fmorelost_pedidos_insert 
'2011-01-01',									
'123456789',
1,
'87476',
'7501009007111',
'0000000',
1,
--0,
0,
0,
0,
0,
0,
0,
0,
'HASH'


*/

IF @codigo = REPLICATE('0' , 7) OR LEN(@codigo)<7
	SET @codigo = (
	SELECT codigo FROM maestro_productos_baan 
	WHERE cod_barras = @cod_barras AND 
	CONVERT(INT, codigo) < dbo.gobierno()
	)
	
DECLARE @descripcion VARCHAR(100)
SET @descripcion = (SELECT descripcion FROM maestro_productos_baan 
	WHERE cod_barras = @cod_barras AND 
	CONVERT(INT, codigo) < dbo.gobierno()
	) 

INSERT INTO pedidos_fmorelost	(
	fecha_pedido							,
	pedido							,
	sucursal									,
	cliente										,
	cod_barras								,
	codigo										,
	descripcion								,
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
	timestamp											
) VALUES (
	CONVERT(DATETIME, @fecha_pedido ,12)				,
	@orden_compra								,
	@sucursal										,
	@cliente										,
	@cod_barras									,
	@codigo											,
	@descripcion								,
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
