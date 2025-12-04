
-- =============================================
-- Author:		ALBERTO MANZANO CABRERA
-- Create date: 19-04-16
-- Description:	BUSCA FOLIOS EN LA TABLA TBL_CambiaFolioAdenda
-- =============================================
CREATE PROCEDURE [dbo].[usp_Busca_Folios]
	-- Add the parameters for the stored procedure here
	@VAR_CFA_Cliente varchar(12),
	@VAR_CFA_RFC varchar(15),
	@VAR_CFA_Folio_Nuevo varchar(11)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	--CONSULTA FOLIO_NUEVO
	SELECT	*	
	FROM	TBL_CambiaFolioAdenda
	WHERE	CFA_Cliente = @VAR_CFA_Cliente AND CFA_RFC = @VAR_CFA_RFC AND CFA_Folio_Nuevo = @VAR_CFA_Folio_Nuevo	
	ORDER BY CFA_Cliente, CFA_Folio_Anterior, CFA_Estatus ASC

END

GO

