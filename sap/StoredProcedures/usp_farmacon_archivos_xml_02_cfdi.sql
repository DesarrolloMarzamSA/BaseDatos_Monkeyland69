
-- =============================================
-- Author:	Francisco Roberto Martínez Hernández
-- Create date: <21/06/2021>
-- Description:	<obtiene la extracion de facturas para farmacon >
-- EXEC [sap].[usp_farmacon_archivos_xml_02_cfdi]  '20210621'
-- =============================================
CREATE PROCEDURE [sap].[usp_farmacon_archivos_xml_02_cfdi] @fecha datetime
AS
BEGIN
    DECLARE @FacturasFarmaconSap TABLE (
		[serie]    VARCHAR(6),
		[Column1]  VARCHAR(20),
		[Column2]  VARCHAR(30),
		[Column3]  VARCHAR(40),
		[sucursal] VARCHAR(5),
		[ctepadre] VARCHAR(20),
		[filler]   VARCHAR(20)	
	)

	INSERT INTO @FacturasFarmaconSap EXEC [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionFacturacionFarmacon] @fecha
	
	SELECT 
		[serie],[Column1],[Column2],[Column3],[sucursal],[ctepadre]
	FROM @FacturasFarmaconSap		

END

GO

