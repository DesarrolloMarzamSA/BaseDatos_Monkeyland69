
-- =============================================
-- Author:		ALBERTO MANZANO CABRERA
-- Create date: 19-04-16
-- Description:	BUSCA FOLIOS REPROCESADOS EN LA TABLA TBL_CambiaFolioAdenda
-- =============================================
CREATE PROCEDURE [dbo].[usp_Busca_Folios_Dia_Actual]

	-- Add the parameters for the stored procedure here
	@VAR_CFA_Fecha_Registro datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	--BUSCA REGISTROS DEL DÍA ACTUAL
	SELECT	*		
	FROM	TBL_CambiaFolioAdenda
	WHERE	DATEADD(dd, 0, DATEDIFF(dd, 0, CONVERT(DATETIME, CFA_Fecha_Registro, 103))) = DATEADD(dd, 0, DATEDIFF(dd, 0, CONVERT(DATETIME, @VAR_CFA_Fecha_Registro, 103)))
	ORDER BY CFA_Cliente, CFA_Folio_Anterior, CFA_Estatus ASC

END

GO

