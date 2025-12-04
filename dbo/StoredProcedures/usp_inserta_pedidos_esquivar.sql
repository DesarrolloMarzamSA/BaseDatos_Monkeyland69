USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_inserta_pedidos_esquivar] 
	@cliente VARCHAR(5),
	@cod_barras VARCHAR(13),
	@cant_ped INT,
	@arch_cliente VARCHAR(50),
	@orden BIGINT,
	@hash_md5 VARCHAR(50),
	@enviado_ftp CHAR(10),
	@x_dummy CHAR(7),
	@porcentaje MONEY,
	@descto_prod MONEY,
	@prec_farm MONEY
WITH ENCRYPTION
AS	
	DECLARE @sucursal TINYINT

	--DECLARE @sucursal TINYINT
	--DECLARE @cliente VARCHAR(5)
	--DECLARE @cod_barras VARCHAR(13)
	--DECLARE @cant_ped INT
	--DECLARE @arch_cliente VARCHAR(50)
	--DECLARE @orden BIGINT
	--DECLARE @hash_md5 VARCHAR(50)
	--DECLARE @enviado_ftp	CHAR(10)
	--DECLARE @x_dummy CHAR(7)
	--DECLARE @porcentaje MONEY
	--DECLARE @descto_prod MONEY
	--DECLARE @prec_farm MONEY

	--SET @cliente = '12345' 
	--SET @cod_barras = '8430308012054'
	--SET @cant_ped = '      1'
	--SET @arch_cliente = '12345.678'
	--SET @orden = '1234567890'
	--SET @hash_md5 = '48b4486a5eb36b28da4f6d17a977955d'
	--SET @enviado_ftp = '0'
	--SET @x_dummy = '      0'
	--SET @porcentaje = 0 
	--SET @descto_prod = 17.5
	--SET @prec_farm = 561.60 
	
	SELECT 		@sucursal = sucursal 
	FROM		cat_esquivar
	WHERE  		cliente = CAST(@cliente AS INT)

	INSERT INTO		pedidos_esquivar 
					(
					sucursal, 
					cliente, 
					cod_barras, 
					cant_ped, 
					arch_cliente, 
					orden, 
					hash_md5, 
					enviado_ftp, 
					x_Dummy, 
					porcentaje, 
					descto_prod, 
					prec_farm
					) 
	VALUES			
					(
					@sucursal, 
					@cliente, 
					@cod_barras, 
					@cant_ped, 
					@arch_cliente, 
					@orden, 
					@hash_md5, 
					@enviado_ftp, 
					@x_Dummy, 
					@porcentaje, 
					@descto_prod, 
					@prec_farm
					)
GO
