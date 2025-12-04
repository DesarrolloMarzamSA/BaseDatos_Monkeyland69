
-- =============================================
-- Author:	Francisco Roberto Martínez Hernández
-- Create date: 21/06/2021
-- Description: Obtiene los RFCs de farmacon 
-- EXEC [sap].[usp_RFCsFarmacon]
-- =============================================
CREATE PROCEDURE [sap].[usp_RFCsFarmacon]
AS
BEGIN

    DECLARE @RfcsFarmaconSap TABLE (		
		    [NATREG]   VARCHAR(20)	
	)

	INSERT INTO @RfcsFarmaconSap EXEC [192.168.90.209].[MiddleWare].[IEmbarque].[ExtraccionRFCsFarmacon]

	SELECT 
		[NATREG]
	FROM @RfcsFarmaconSap  

END

GO

