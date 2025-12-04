SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sanofi_get_cabecero_salida] @md5 varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @factura varchar(20)

SELECT @factura=numero_factura FROM archivos where md5=@md5

SELECT     delivery_date as invoice_date, '' AS due_date, '' AS balance, '' AS tax, 0 AS sanofi_order_total_discount, '' AS wholesaler_order_total_discount
		   ,'' AS shipping_charges,ws_code AS wholesaler_code, ws_customer_code, @factura AS invoice_number, @factura AS wholesaler_order_number, 'MXN' AS currency_code,
                0 as shipping_number,'' as shipping_charges,b2b_order_number,delivery_date,'' as rejection_reason,'' as shipping_method, memo,payment_type
                , ws_customer_code as payment_account_number,b2b_order_number as po_number
FROM         cabecero_sanofi
WHERE     (md5 = @md5)


END

GO
