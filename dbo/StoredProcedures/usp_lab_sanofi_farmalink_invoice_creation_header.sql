
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE --	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_sanofi_farmalink_invoice_creation_header]

@pedido VARCHAR(20)

AS

/*
EXECUTE usp_lab_sanofi_farmalink_invoice_creation_header '41483583725'
*/

SELECT 	
	CONVERT(VARCHAR(10),delivery_date,121					)						AS	invoice_date										, 	
	''																												AS	due_date												, 	
	CONVERT(DECIMAL(12,2),total_amount						)						AS	total_amount										,		
	NULL																											AS	balance													, 	
	CONVERT(DECIMAL(12,2),tax											)						AS	tax															,		
	CONVERT(DECIMAL(12,2),sa_order_total_discount	)						AS	sa_order_total_discount					,		
	CONVERT(DECIMAL(12,2),ws_order_total_discount	)						AS	ws_order_total_discount					,		
	CONVERT(DECIMAL(12,2),shipping_charges				)						AS	shipping_charges								,		
	ws_code																										AS	ws_code													,		
	ws_customer_code																					AS	ws_customer_code								,		
	serie_cfd + CONVERT(VARCHAR,CONVERT(INT,folio_fiscal))		AS	invoice_number									, 	
	factura																										AS	ws_order_number									, 	
	'MXN'																											AS	Currency_Code										 	
FROM pedidos_lab_sanofi_header_historia 
WHERE b2b_order_number = @pedido 
GO
