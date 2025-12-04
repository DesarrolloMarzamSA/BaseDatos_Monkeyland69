USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE --	DROP
PROCEDURE [dbo].[usp_lab_sanofi_farmalink_insert_order_line]

	@b2b_order_number		VarChar (100)		,					--		 1
	@arch_cliente				VarChar (100)		,					--		 2
	@pedido							VarChar (40)		, 				--		 3
	@recepcion					DateTime				, 				--		 4
	@orden							Int							, 				--		 5
	@letra							VarChar	( 1)		, 				--		 6
	@cliente						VarChar	( 6)		, 				--		 7
	@line_key						Int							, 				--		 8
	@ean								VarChar	( 90)		, 				--		 9
--	@codigo							VarChar	( 90)		, 				--		 9
	@cantidad_pedida		Int							, 				--		10
	@sa_free_quantity		Int							, 				--		11
	@list_price					MONEY						, 				--		12
	@sell_price					MONEY						, 				--		13
	@sa_discount				MONEY						, 				--		14
	@delivery_date			Date						, 				--		15
	@l_total_amount			MONEY						, 				--		16
	@hash_md5						VarChar	( 90)							--		17

WITH ENCRYPTION
AS

DECLARE	@codigo	VarChar	( 90)
SET @codigo = 
	(SELECT TOP 1 codigo FROM maestro_productos_baan 
	WHERE codigo < dbo.gobierno() AND cod_barras = @ean)


DECLARE @sucursal INT
SET @sucursal = 
	(SELECT sucursal FROM sucursales WHERE letra = @letra)
	

DECLARE @descripcion VARCHAR(50)
SET @descripcion = 
	(SELECT descripcion FROM maestro_productos_baan 
	WHERE codigo = @codigo)

IF @codigo IS NULL
	SET @codigo = '0000000'


IF @descripcion IS NULL
	SET @descripcion = 'NO ENCONTRADO'

IF @sucursal IS NULL
	SET @sucursal = 0

IF DATEPART(HH, GETDATE()) > 6
	SET @delivery_date = DATEADD(DD, 1, @delivery_date)

/*
SELECT * FROM pedidos_lab_sanofi_header

SELECT * FROM pedidos_lab_sanofi_address

SELECT * FROM pedidos_lab_sanofi_order_line
*/

INSERT INTO pedidos_lab_sanofi_order_line 
(
	b2b_order_number		, 
	arch_cliente				, 
	pedido							, 
	recepcion						, 
	orden								, 
	sucursal						,
	letra								, 
	cliente							, 
	line_key						, 
	ean									,
	codigo							, 
	cantidad_pedida			, 
	sa_free_quantity		, 
	list_price					, 
	sell_price					, 
	sa_discount					, 
	delivery_date				, 
	l_total_amount			, 
	hash_md5						,
	descripcion
) 
	VALUES 
(
	@b2b_order_number	, 
	@arch_cliente			, 
	@pedido						, 
	@recepcion				, 
	@orden						, 
	@sucursal					,
	@letra						, 
	@cliente					, 
	@line_key					, 
	@ean							, 
	@codigo						, 
	@cantidad_pedida	, 
	@sa_free_quantity	, 
	@list_price				, 
	@sell_price				, 
	@sa_discount			, 
	@delivery_date		, 
	@l_total_amount		, 
	@hash_md5					,
	@descripcion
)
GO
