-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[RelacionArchivosSAP] 
@fechaInicio datetime,
@fechaFin datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT 
BSTKD+'_'+IDNUMBER+'.ord' AS [nombreArchivo]
,BSTKD+'_'+IDNUMBER+'.fac' AS [archivoFactura]
,B.ALTKN AS [cuentaMarzam]
,[FKDAT] as [FechaFactura]
,EAN11 as [codigoBarras]
,right([MATNR],7) as [codigo]
,IDNUMBER as [cuentaEstiloAhorro]
,BSTKD as [ordenCliente]
  FROM [192.168.90.209].[MiddleWare].[sapdo].[FacturasDevolver] as a
  inner join [192.168.90.209].[MiddleWare].[sapdm].[MClientes] b on a.KUNAG=b.[PARTNER]
  where FKDAT between @fechaInicio and @fechaFin and KDGRP IN ('AB')

END

GO

