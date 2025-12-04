USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE	--	DROP	
PROCEDURE [dbo].[usp_lab_sanofi_farmalink_invoice_creation_lines]
@pedido VARCHAR(20)
WITH ENCRYPTION
AS




SELECT 	
	ean																							AS	sku									, 	
	descripcion																			AS	descripcion					, 	
	cantidad_surtida																AS	quantity						, 	
	CONVERT(DECIMAL(12,2),list_price)								AS	unit_price					, 	
	orden 																					AS	invoice_line_number	, 	
	b2b_order_number																AS	b2b_order_number		, 	
	CONVERT(DECIMAL(12,2),sell_price)								AS	final_unit_price		, 	
	CONVERT(DECIMAL(12,2),sa_discount)							AS	sa_discount					, 	
	NULL																						AS	wholesaler_discount	, 	
	sa_free_quantity																AS	sa_free_quantity		,		
	NULL 																						AS	Aux1								,		
	NULL 																						AS	Aux2								,		
	NULL 																						AS	Aux3								
FROM pedidos_lab_sanofi_order_line_historia 
WHERE pedido = @pedido	
AND cantidad_surtida > 0 
ORDER BY orden 
GO
