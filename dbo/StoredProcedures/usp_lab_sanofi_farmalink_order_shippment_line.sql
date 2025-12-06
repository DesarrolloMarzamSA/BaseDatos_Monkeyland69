
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_sanofi_farmalink_order_shippment_line] 
--DECLARE 
@pedido VARCHAR(20)

AS
--SET @pedido = '15153548494'

/*
EXECUTE usp_lab_sanofi_farmalink_order_shippment_line '15153548494'
*/

SELECT 
	line_key																										,		--	1
	orden 																			ws_line_key			,		--	2
	CONVERT(VARCHAR(10),GETDATE(), 121)					shipment_date		,
	factura																			invoice_number	,
	cantidad_surtida														quantity						--	4
FROM pedidos_lab_sanofi_order_line_historia l
WHERE 
	pedido = @pedido 
ORDER BY pedido, orden 

GO
