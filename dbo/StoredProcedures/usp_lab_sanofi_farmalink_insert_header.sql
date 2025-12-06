
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE	--	CREATE --	DROP	
PROCEDURE [dbo].[usp_lab_sanofi_farmalink_insert_header] (
	@b2b_order_number					VARCHAR( 60),	
	@ws_code									VARCHAR( 90),	
	@ws_customer_code					VARCHAR( 90),	
	@delivery_date						DATETIME,	
	@memo											VARCHAR(240),	
	@pedido										VARCHAR( 50),	
	@sa_order_total_discount	MONEY,	
	@total_amount							MONEY,	
	@order_date								DATETIME,	
	@payment_type							VARCHAR( 100),	
	@user_name								VARCHAR( 90), 
	@first_name								VARCHAR( 90),	
	@last_name								VARCHAR( 90), 
	@arch_cliente							VARCHAR (100)		,					--		 2
	@letra										VARCHAR( 01), 
	@cliente									VARCHAR( 05), 
	@recepcion								DATETIME
)													
WITH ENCRYPTION
AS

DECLARE @sucursal INT 
SET @sucursal = 
	(SELECT sucursal FROM clientes_baan 
		WHERE cliente = @cliente AND letra = @letra)

INSERT INTO pedidos_lab_sanofi_header 
(
	b2b_order_number,	
	ws_code,	
	ws_customer_code,	
	delivery_date,	
	memo,	
	pedido,	
	sa_order_total_discount,	
	total_amount,	
	order_date,	
	payment_type,	
	user_name, 
	first_name,	
	last_name, 
	arch_cliente	,			
	letra, 
	cliente, 
	recepcion	,sucursal
) 
VALUES 
(
	@b2b_order_number	,	
	@ws_code					,	
	@ws_customer_code,	
	@delivery_date,	
	@memo,	
	@pedido,	
	@sa_order_total_discount,	
	@total_amount,	
	@order_date,	
	@payment_type,	
	@user_name, 
	@first_name,	
	@last_name, 
	@arch_cliente			,
	@letra, 
	@cliente, 
	@recepcion	,@sucursal

) 

/*

--	CyC = country code
--	WC = Wholesaler code
--	CC = Customer Code

Order creation	The new naming convention (to ease monitoring) :
	[CyC]_[WC]_[CC]_[B2B order number]_ORDER-CREATION-WS-MARZAM_[Filler timestamp]
Order confirmation	The expected name should be as
	[CyC]_ORDER-CONFIRMATION-WS-MAPPING_[Filler timestamp]_[WC]_[CC]_[B2B order number]
Shipment notification	The expected name should be as
	[CyC]_SHIPMENT-NOTIFICATION-WS-MAPPING_[Filler timestamp]_[WC]_[CC]_[B2B order number]
Invoice creation	The expected name should be as
	[CyC]_INVOICE-CREATION-WS-MAPPING_[Filler timestamp]_[WC]_[CC]_[B2B order number]

*/

/*
UPDATE pedidos_lab_sanofi_header SET 
	order_confirmation_filename			=	REPLACE(arch_cliente, 'ORDER-WS-MX-MARZAM', 'ORDER-CONFIRMATION-WS-MAPPING')		,
	invoice_creation_filename		=	REPLACE(arch_cliente, 'ORDER-WS-MX-MARZAM', 'INVOICE-CREATION-WS-MAPPING')			,
	shipment_notification_filename	=	REPLACE(arch_cliente, 'ORDER-WS-MX-MARZAM', 'SHIPMENT-NOTIFICATION-WS-MAPPING')		
WHERE 
order_confirmation_filename IS NULL
*/

UPDATE pedidos_lab_sanofi_header SET 
	order_confirmation_filename			=	
	country + '_ORDER-CONFIRMATION-WS-MAPPING_' + CONVERT(VARCHAR(25) ,GETDATE(), 112) + '_'+ 
	ws_code + '_'+ ws_customer_code+'_' + b2b_order_number + '.CSV',

	invoice_creation_filename		=	
	country + '_INVOICE-CREATION-WS-MAPPING_' + CONVERT(VARCHAR(25) ,GETDATE(), 112) + '_'+ 
	ws_code + '_'+ ws_customer_code+'_' + b2b_order_number + '.CSV',

	shipment_notification_filename	=	
	country + '_SHIPMENT-NOTIFICATION-WS-MAPPING_' + CONVERT(VARCHAR(25) ,GETDATE(), 112) + '_'+ 
	ws_code + '_'+ ws_customer_code+'_' + b2b_order_number + '.CSV'

WHERE 
b2b_order_number = @b2b_order_number

/*
SELECT TOP 10
	country + '_ORDER_CONFIRMATION-WS-MAPPING_' + CONVERT(VARCHAR(25) ,GETDATE(), 112) + '_'+ 
	ws_code + '_'+ ws_customer_code+'_'+b2b_order_number+'.CSV',
	country + '_SHIPMENT_NOTIFICATION-WS-MAPPING_' + CONVERT(VARCHAR(25) ,GETDATE(), 112) + '_'+ 
	ws_code + '_'+ ws_customer_code+'_'+b2b_order_number+'.CSV',
	country + '_INVOICE_CREATION-WS-MAPPING_' + CONVERT(VARCHAR(25) ,GETDATE(), 112) + '_'+ 
	ws_code + '_'+ ws_customer_code+'_'+b2b_order_number+'.CSV'
	
FROM pedidos_lab_sanofi_header
*/
GO
