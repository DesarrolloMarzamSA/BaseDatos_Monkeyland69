
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_sanofi_farmalink_order_confirmation_header]
@pedido VARCHAR(50) 
WITH ENCRYPTION
AS 

/*
EXECUTE usp_lab_sanofi_farmalink_order_confirmation_header '41483583725'
*/

SELECT 
	factura																						AS	wholesale_order						,		--	01
	b2b_order_number																	AS	b2b_order_number					, 	--	02
	CONVERT(DECIMAL(12,2),tax)												AS	tax												,		--	03
	CONVERT(DECIMAL(12,2),shipping_charges)						AS	shipping_charges					,		--	04
	CONVERT(DECIMAL(12,2),sa_order_total_discount)		AS	sa_order_total_discount		,		--	05
	CONVERT(DECIMAL(12,2),ws_order_total_discount)		AS	ws_order_total_discount		,		--	06
	CONVERT(DECIMAL(12,2),total_amount)								AS	total_amount							,		--	07
	CONVERT(VARCHAR(10),delivery_date,121) 						AS	delivery_date							,		--	08
	order_status																			AS	order_status							,		--	09
	rejection_reason																	AS	rejection_reason					,		--	10
	ws_customer_code																	AS	ws_customer_code					,		--	11
	shipping_method																		AS	shipping_method						,		--	12
	Memo																							AS	Memo											,		--	13
	payment_type																			AS	payment_type							,		--	14
	ws_customer_code 																	AS	payment_account_number		,		--	15
	pedido																						AS	PONumber											--	16
FROM pedidos_lab_sanofi_header_historia WITH (NOLOCK)
WHERE b2b_order_number =  @pedido

GO
