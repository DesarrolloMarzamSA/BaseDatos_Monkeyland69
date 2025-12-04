-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Ahorro.ObtenerRelacionCuentaEstiloAhorro
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

SELECT case 
            when[sucursal_remision] = 1 then 'A'
            when[sucursal_remision] = 2 then 'C'
            when[sucursal_remision] = 3 then 'C'
            when[sucursal_remision] = 4 then 'D'
            when[sucursal_remision] = 5 then 'E'
            when[sucursal_remision] = 6 then 'J'
            when[sucursal_remision] = 7 then 'G'
            when[sucursal_remision] = 8 then 'G'
            when[sucursal_remision] = 9 then 'E'
            when[sucursal_remision] = 11 then 'M'
            when[sucursal_remision] = 13 then 'M'
            when[sucursal_remision] = 16 then 'P'
            when[sucursal_remision] = 17 then 'Q'
            when[sucursal_remision] = 18 then 'R'
            when[sucursal_remision] = 19 then 'R'
            when[sucursal_remision] = 21 then 'A'
            when[sucursal_remision] = 23 then 'X'
            when[sucursal_remision] = 24 then 'X'
            when[sucursal_remision] = 25 then 'Y'
            when[sucursal_remision] = 26 then 'V'
            when[sucursal_remision] = 27 then 'G'
            else ' '
            end + [cuenta_remision] as cuentaRemicionMarzam
            ,case 
            when[sucursal_factura] = 1 then 'A'
            when[sucursal_factura] = 2 then 'C'
            when[sucursal_factura] = 3 then 'C'
            when[sucursal_factura] = 4 then 'D'
            when[sucursal_factura] = 5 then 'E'
            when[sucursal_factura] = 6 then 'J'
            when[sucursal_factura] = 7 then 'G'
            when[sucursal_factura] = 8 then 'G'
            when[sucursal_factura] = 9 then 'E'
            when[sucursal_factura] = 11 then 'M'
            when[sucursal_factura] = 13 then 'M'
            when[sucursal_factura] = 16 then 'P'
            when[sucursal_factura] = 17 then 'Q'
            when[sucursal_factura] = 18 then 'R'
            when[sucursal_factura] = 19 then 'R'
            when[sucursal_factura] = 21 then 'A'
            when[sucursal_factura] = 23 then 'X'
            when[sucursal_factura] = 24 then 'X'
            when[sucursal_factura] = 25 then 'Y'
            when[sucursal_factura] = 26 then 'V'
            when[sucursal_factura] = 27 then 'G'
            else ' '
            end + [cuenta_factura] as cuentaFacturaMarzam
            ,[cuenta_estilo_ahorro]
            FROM [dbo].[cat_cuentas_spt_fahorro]

END

GO

