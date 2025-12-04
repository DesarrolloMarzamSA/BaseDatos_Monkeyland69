USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP	
PROCEDURE [dbo].[usp_fardemex_pedidos_insert] 
	@arch_cliente 				VARCHAR(10)	,	--	 1
	@fecha_pedido					DATETIME		,	--	 2
	@pedido								VARCHAR(10)	,	--	 3
	@mostrador						VARCHAR(10)	,	--	 4
	@cod_barras						VARCHAR(13)	,	--	 5
	@cantidad_pedida			INT					,	--	 6
	@hash_md5							VARCHAR(100),	--	 7
	@linea								INT					,	--	 8
	@prec_farm						MONEY					--	 9
WITH ENCRYPTION
AS

DECLARE 
	@codigo								VARCHAR( 7)	,
	@sucursal							INT					,
	@cliente							VARCHAR(5)	,
	@cliente_ibs					VARCHAR(6)	

SET	@codigo = 
	(SELECT codigo FROM maestro_productos_baan 
	WHERE cod_barras = RIGHT(REPLICATE('0' ,13) + @cod_barras ,13) AND 
	codigo < dbo.gobierno() )

IF @codigo IS NULL
	SET @codigo = REPLICATE('0', 7)

SET @cliente_ibs =
	(SELECT cliente_ibs FROM cat_sucursales_fardemex 
	WHERE cliente = @mostrador )

SET @cliente =
	(SELECT cliente FROM cat_sucursales_fardemex 
	WHERE cliente = @mostrador )

SET @sucursal =
	(SELECT sucursal FROM cat_sucursales_fardemex 
	WHERE cliente = @mostrador )

IF @cliente IS NULL	
	SET @cliente = REPLICATE('0', 5)

IF @sucursal IS NULL
	SET @sucursal = 0	

IF @cliente_ibs IS NULL
	SET @cliente_ibs = 'Z99999'

INSERT INTO pedidos_fardemex 
(
	arch_cliente 				,
	fecha_pedido				,
	pedido							,
	mostrador						,
	cod_barras					,
	codigo							,
	sucursal						,
	letra								,
	cliente							,
	cliente_ibs					,
	cantidad_pedida			,
	tftp								,
	hash_md5						,
	linea								,
	prec_farm						
)
VALUES 
(
	@arch_cliente 				,
	@fecha_pedido					,
	@pedido								,
	@mostrador						,
	@cod_barras						,
	@codigo								,
	@sucursal							,
	LEFT(@cliente_ibs,1)	,
	@cliente							,
	@cliente_ibs					,
	@cantidad_pedida			,
	GETDATE()							,
	@hash_md5							,
	@linea								,
	@prec_farm						
)

UPDATE pedidos_fardemex SET 
	importe = prec_farm * cantidad_pedida 
WHERE linea = @linea
GO
