
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE	--	DROP	
PROCEDURE [dbo].[usp_fyza_20_pedidos_insert] 

@arch_cliente					VARCHAR(50)	,
@linea_buffer					VARCHAR(100),
@linea								INT					,
@fecha_pedido					DATETIME				,
@hash_md5							VARCHAR(100)--,

WITH ENCRYPTION
AS

--	TRUNCATE TABLE pedidos_fyza_20


DECLARE 

@sucursal							INT					,
@cliente							VARCHAR(5)	,
@cliente_ibs					VARCHAR(7)	,
@codigo								VARCHAR(7)	,
@descripcion					VARCHAR(30)	,
@arch_tandem					VARCHAR(20)	,
@cantidad_pedida			INT					,
@cantidad_surtida			INT					,	
@tftp									DATETIME		,
@rftp									DATETIME		,
@timestamp						DATETIME		,
@compania							VARCHAR(3)	,
@proveedor						VARCHAR(6)	,
@orden_pharmacy				VARCHAR(10)	,
@bodega								VARCHAR(5)	,
@tienda								VARCHAR(7)	,	
@upc									VARCHAR(13)	,
@cantidad_solicitada	INT					,
@precio								MONEY				,
@departamento					MONEY				,
@unid_med							VARCHAR(4)	,
@fecha_emision				VARCHAR(8)		


/*
SET @archivo_cliente			= 'PEDIDO.TXT' 
SET @linea_buffer					= '0010110870000000172000000000475004972     000000100093852000000000120071120' 
SET @linea								= 1
SET @fecha_pedido					= GETDATE()  
*/


SET @tienda								= SUBSTRING(@linea_buffer , 01, 07) 
SET @upc									= SUBSTRING(@linea_buffer , 08, 13) 
SET @cantidad_solicitada	= CONVERT(INT , SUBSTRING(@linea_buffer , 21, 03) )
SET @orden_pharmacy				= SUBSTRING(@linea_buffer , 24, 10) 

--SET @compania							= SUBSTRING(@linea_buffer , 01, 03) 
--SET @proveedor						= SUBSTRING(@linea_buffer , 04, 06) 
--SET @bodega								= SUBSTRING(@linea_buffer , 20, 05) 
--SET @precio								= CONVERT(MONEY, SUBSTRING(@linea_buffer , 50, 05) + '.' + SUBSTRING(@linea_buffer , 55, 04) )
--SET @departamento					= CONVERT(MONEY, SUBSTRING(@linea_buffer , 59, 08) )
--SET @unid_med							= SUBSTRING(@linea_buffer , 64, 04) 
--SET @fecha_emision				= SUBSTRING(@linea_buffer , 68, 08) 

--SET @sucursal							= ( SELECT sucursal			FROM cat_cuentas_yza	WHERE cuenta_estilo_yza = @tienda )
--SET @cliente							= ( SELECT cliente			FROM cat_cuentas_yza	WHERE cuenta_estilo_yza = @tienda )
--SET @cliente_ibs					= ( SELECT cliente_ibs	FROM cat_cuentas_yza	WHERE cuenta_estilo_yza = @tienda )

/*
SET @codigo								= ( SELECT codigo				FROM vi_catalogo_fyza_20					WHERE cod_prodcli = @upc )

IF @codigo IS NULL
	SET @codigo								= ( SELECT codigo				FROM vi_catalogo_fyza_20				WHERE cod_barras = RIGHT(REPLICATE('0',13) + RTRIM(LTRIM(@upc)), 13 ))

SET @descripcion					= ( SELECT descripcion	FROM vi_catalogo_fyza_20					WHERE codigo = @codigo )

--SET @arch_tandem					= 'PCHA0001'
SET @cantidad_pedida			= SUBSTRING(@linea_buffer , 01, 03) 
--SET @cantidad_surtida			= 0 
--SET @hash_md5							= 'fsadjk3485970349fvhaepr58947589034789r5' 
--SET @rftp									= NULL

IF @codigo IS NULL
	SET @codigo = '0000000'
*/
SET @tftp									= GETDATE()
SET @timestamp						= GETDATE()


/*
SELECT @archivo_cliente			 AS  archivo_cliente		                   -- UNION   
SELECT @linea_buffer				 AS  linea_buffer			                   -- UNION   
SELECT @linea								 AS  linea							                   -- UNION   
SELECT @fecha_pedido				 AS  fecha_pedido			                   -- UNION   
SELECT @tienda							 AS  tienda						                   -- UNION   
																 
SELECT @compania						 AS  compania					                   -- UNION   
SELECT @proveedor						 AS  proveedor					                   -- UNION   
SELECT @orden_pharmacy			 AS  orden_pharmacy		                   -- UNION   
SELECT @bodega							 AS  bodega						                   -- UNION   
SELECT @upc									 AS  upc								                   -- UNION   
SELECT @cantidad_solicitada	 AS  cantidad_solicitad                   -- UNION   
SELECT @precio							 AS  precio						                   -- UNION   
SELECT @departamento				 AS  departamento			                   -- UNION   
SELECT @unid_med						 AS  unid_med					                   -- UNION   
SELECT @fecha_emision				 AS  fecha_emision			                   -- UNION   
																 
SELECT @sucursal						 AS  sucursal					                   -- UNION   
SELECT @cliente							 AS  cliente						                   -- UNION   
SELECT @cliente_ibs					 AS  cliente_ibs				                   -- UNION   
SELECT @codigo							 AS  codigo						                   -- UNION   
SELECT @arch_tandem					 AS  arch_tandem				                   -- UNION   
SELECT @cantidad_pedida			 AS  cantidad_pedida		                   -- UNION   
SELECT @cantidad_surtida		 AS  cantidad_surtida	                   -- UNION   
SELECT @hash_md5						 AS  hash_md5					                   -- UNION   
SELECT @tftp								 AS  tftp							                   -- UNION   
SELECT @rftp								 AS  rftp							                   -- UNION   
SELECT @timestamp						 AS	 timestamp					
*/



INSERT INTO pedidos_fyza_20	
(
	arch_cliente				,
	linea_buffer					,
	linea									,
	hash_md5							,
	fecha_pedido					,
	--compania							,
	--proveedor							,
	orden_pharmacy				,
	--------bodega								,
	tienda								,	
	upc										,
	cantidad_solicitada		,
	--------precio								,
	--------departamento					,
	--------unid_med							,
	--------fecha_emision					,
	--cantidad_pedida			,
	tftp									,
	timestamp						--,

/*
	sucursal							,
	cliente							,
	cliente_ibs					,
	codigo								,
	descripcion					,
--	arch_tandem					,
--	cantidad_surtida			,	
--	rftp									,*/
)
VALUES
(
	@arch_cliente					,
	@linea_buffer					,
	@linea								,
	@hash_md5							,
	@fecha_pedido					,
	--@compania							,
	--@proveedor						,
	@orden_pharmacy				,
	----------@bodega								,
	@tienda								,	
	@upc									,
	@cantidad_solicitada	,
	----------@precio								,
	----------@departamento					,
	----------@unid_med							,
	----------@fecha_emision				,
	---@cantidad_pedida			,
	@tftp									,
	@timestamp						--,
	--@sucursal							,
	--@cliente							,
	--@cliente_ibs					,
	--@codigo								,
	--@descripcion					,
--	@arch_tandem					,
	------@cantidad_surtida			,	
	---@rftp									
)

GO
