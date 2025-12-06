
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_inserta_pedidos_leyva_20]
	@sucursal TINYINT,
	@cliente VARCHAR(5),
	@cod_barras VARCHAR(13),
	@cant_ped INT,
	@arch_cliente VARCHAR(50),
	@orden VARCHAR(50),
	@hash_md5 VARCHAR(50),
	@enviado_ftp CHAR(10),
	@otros VARCHAR(60)
	

AS	
	  
	--DECLARE @sucursal TINYINT
	--DECLARE @cliente VARCHAR(5)
	--DECLARE @cod_barras VARCHAR(13)
	--DECLARE @cant_ped INT
	--DECLARE @arch_cliente VARCHAR(50)
	--DECLARE @orden VARCHAR(50)
	--DECLARE @hash_md5 VARCHAR(50)
	--DECLARE @enviado_ftp	CHAR(10)
	--DECLARE @otros VARCHAR(60)

	--SET @sucursal = 1
	--SET @cliente = '84260' 
	--SET @cod_barras = '7501314705313'
	--SET @cant_ped = 1
	--SET @arch_cliente = 'PMAA1637.DAT'
	--SET @orden = '000000000AA1637'
	--SET @hash_md5 = '483e3f5cba098f1cb2118880bc19a42a'
	--SET @enviado_ftp = '0'
	--SET @otros = '00000000000000000000000000000000000000000000000'
	
	INSERT INTO	pedidos_leyva_20
					(
						sucursal, 
						cliente,
						cod_barras, 
						cant_ped, 
						arch_cliente, 
						orden, 
						hash_md5, 
						enviado_ftp, 
						fecha_pedido,
						otros
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
						CURRENT_TIMESTAMP,
						@otros
					)
GO
