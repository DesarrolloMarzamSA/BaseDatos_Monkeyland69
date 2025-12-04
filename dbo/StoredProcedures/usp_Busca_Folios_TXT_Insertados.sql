
-- =============================================
-- Author:		ALBERTO MANZANO CABRERA
-- Create date: 19-04-16
-- Description:	BUSCA FOLIOS EN LA TABLA TBL_CambiaFolioAdenda
-- =============================================
CREATE PROCEDURE [dbo].[usp_Busca_Folios_TXT_Insertados]
	-- Add the parameters for the stored procedure here
	@VAR_OPCION int,
	@VAR_CFA_Factura varchar (15),
	@VAR_CFA_Fecha_Insercion datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	IF @VAR_OPCION = 1
	BEGIN
		--CONSULTA FOLIOS TXT INSERTADOS DEL DIA
		SELECT	*	
		FROM	TBL_ValoresTXT_CFA
		WHERE	DATEADD(dd, 0, DATEDIFF(dd, 0, CONVERT(DATETIME, CFA_Fecha_Insercion, 103))) = DATEADD(dd, 0, DATEDIFF(dd, 0, CONVERT(DATETIME, @VAR_CFA_Fecha_Insercion, 103)))	
		ORDER BY CFA_Factura, CFA_Encontrado ASC
	END
	
	IF @VAR_OPCION = 2
	BEGIN

		--CONSULTA FOLIOS TXT INSERTADOS DEL DIA
		SELECT	*	
		FROM	TBL_ValoresTXT_CFA
		WHERE	CFA_Factura = @VAR_CFA_Factura
		ORDER BY CFA_Factura, CFA_Encontrado ASC		

	END

END

GO

