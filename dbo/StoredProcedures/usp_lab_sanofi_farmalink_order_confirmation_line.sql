
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_sanofi_farmalink_order_confirmation_line] 
@pedido VARCHAR(20)
WITH ENCRYPTION
AS

/*
EXECUTE usp_lab_sanofi_farmalink_order_confirmation_line '59963544273'
*/

	--CASE WHEN cantidad_surtida = 0 AND resultado IN ( 1, 2, 5, 6, 7, 9, 0) THEN cantidad_pedida																								--	4
	--	ELSE cantidad_surtida	END	quantity				,																																															

	--CASE WHEN cantidad_surtida = 0 AND resultado IN ( 1, 2, 5, 6, 7, 9, 0) THEN cantidad_pedida * sell_price																	
	--	ELSE l_total_amount		END l_total_amount,																																																--	11

SELECT 
	line_key																		line_key																										,		--	1
	orden 																			ws_line_key																					,		--	2
	--	CONVERT(VARCHAR,	CONVERT(INT,codigo	))		sku																									,		--	3
	CONVERT(VARCHAR,	CONVERT(BIGINT,ean	))		sku																									,		--	3
	cantidad_pedida															quantity																						,		--	4
																							sa_free_quantity																		,		--	5
	l.cantidad_surtida + sa_free_quantity				confirmed_qtty																			,		--	6
	CONVERT(DECIMAL(12,2),list_price)						list_price																					,		--	7
	CONVERT(DECIMAL(12,2),sell_price)						sell_price																					,		--	8
	CONVERT(DECIMAL(12,2),sa_discount)					sa_discount																					,		--	9
	NULL																				wholesaler_discount																	,		--	10
	CONVERT(DECIMAL(12,2),l_total_amount)				l_total_amount																			,		--	11
	CASE WHEN resultado IN ( 1, 2, 5, 6, 7, 9, 0)	THEN	'Rejected'	ELSE 	'In Process' END l_status	,		--  12
	NULL 																				Field13																							,		--  13
	NULL 																				Field14																							,		--  14
	NULL 																				Field15																							,		--  15
	NULL 																				Field16																									--  16
FROM pedidos_lab_sanofi_order_line_historia l	WITH (NOLOCK)
WHERE 
	pedido = @pedido 
ORDER BY orden 

GO
