
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


	CREATE	--	DROP
PROCEDURE [dbo].[usp_fbenavides_pedidos_ci_insert_historia]

@linea											INT							,
@fecha_pedido								SMALLDATETIME		,
@orden_compra								VARCHAR(10)			,
@cia												VARCHAR( 4)			,
@mostrador									VARCHAR( 4)			,
@cod_bena										VARCHAR(18)			,
@cantidad_pedida						INT							,
@arch_cliente								VARCHAR(50)		,
@hash_md5										VARCHAR(50)			

/*
SELECT * FROM pedidos_fbenavides_ci WITH (NOLOCK) ORDER BY linea
*/

WITH ENCRYPTION
AS
SET NOCOUNT on;

/*
EXECUTE 
[usp_fbenavides_pedidos_ci_insert_historia] 
1,
'2011-01-01',									
'123456789',
'M029',
'0001',
'000000000000364509',
15,
'PE20111128_150029.TXT',
'8f4098ba0a7d46c4dce3ced0f2b8be0d'
*/

DECLARE 
@letra											VARCHAR(1)					,
@sucursal										INT							,
@cliente										VARCHAR(5)			,
@cod_barras									VARCHAR(13)			,
@codigo											VARCHAR(7)			

SET @sucursal = (
	SELECT TOP 1 sucursal FROM cat_sucursales_benavides 
	WHERE cia = @cia 
	)

SET @cliente = (
	SELECT TOP 1 cuenta FROM cat_sucursales_benavides 
	WHERE cia = @cia 
	)

SET @letra = (
	SELECT ibs_letra FROM sucursales 
	WHERE sucursal = @sucursal 
	)


SET @codigo = (
	SELECT TOP 1 cod_mar FROM cat_productos_benavides 
	WHERE cod_ben = @cod_bena AND 
	CONVERT(INT, cod_mar) < dbo.gobierno()
	)

IF @codigo IS NULL
	SET @codigo = REPLICATE('0' , 7)
		
IF @cliente IS NULL
	SET @cliente = '00000'
	
IF @sucursal IS NULL
	SET @sucursal = 0
	
IF @letra IS NULL
	SET @letra = '0'	
	
DECLARE @descripcion VARCHAR(100)
SET @descripcion = (SELECT descripcion FROM maestro_productos_baan 
	WHERE cod_barras = @cod_barras AND 
	CONVERT(INT, codigo) < dbo.gobierno()
	) 

--	CHIHUAHUA

DECLARE @psi BIT, @cuenta_psi VARCHAR(6)
SET @psi = (
	SELECT CASE WHEN clas_ssa IN ( '1', '2', '3') THEN 1 ELSE 0 END psi 
	FROM maestro_productos_baan 
	WHERE codigo = @codigo AND
	CONVERT(INT, codigo) < dbo.gobierno() 
	) 

IF @sucursal IN (23, 24) AND @psi = 1
	SET @cliente = (SELECT TOP 1 cuenta FROM cat_sucursales_benavides 
	WHERE cia = @cia AND controlados = 1 AND activo = 1 )


INSERT INTO pedidos_fbenavides_ci_historia	(
	linea											,
	fecha_pedido							,
	pedido										,
	letra											,
	sucursal									,
	cliente										,
	cia												,
	mostrador									,
	codigo										,
	cod_bena									,
	descripcion								,
	cantidad_pedida						,
	arch_cliente							,
	hash_md5									,
	timestamp											
) VALUES (
	@linea											,
	@fecha_pedido								,
	@orden_compra								,
	@letra											,
	@sucursal										,
	@cliente										,
	@cia												,
	@mostrador									,
	@codigo											,
	@cod_bena										,
	@descripcion								,
	@cantidad_pedida						,
	@arch_cliente								,
	@hash_md5										,
	GETDATE()										
)
GO
