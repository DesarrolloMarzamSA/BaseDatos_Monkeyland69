
-- =============================================
-- Author:		ALBERTO MANZANO CABRERA
-- Create date: 19-04-16
-- Description:	INSERTA FOLIOS EN LA TABLA TBL_CambiaFolioAdenda
-- =============================================
CREATE PROCEDURE [dbo].[usp_Inserta_Folios]
	-- Add the parameters for the stored procedure here
	@VAR_CFA_Cliente varchar(12),
	@VAR_CFA_RFC varchar(15),
	@VAR_CFA_Serie varchar(5),
	@VAR_CFA_Folio_Anterior varchar(15),
	@VAR_CFA_Fecha_Registro datetime,
	@VAR_CFA_Estatus varchar (5),
	@VAR_CFA_Observaciones varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO TBL_CambiaFolioAdenda
				(CFA_Cliente
				,CFA_RFC
				,CFA_Serie
				,CFA_Folio_Anterior
				,CFA_Fecha_Registro
				,CFA_Estatus
				,CFA_Observaciones)
	VALUES
				(@VAR_CFA_Cliente
				,@VAR_CFA_RFC
				,@VAR_CFA_Serie
				,@VAR_CFA_Folio_Anterior				
				,@VAR_CFA_Fecha_Registro
				,@VAR_CFA_Estatus
				,@VAR_CFA_Observaciones)				

END

GO

