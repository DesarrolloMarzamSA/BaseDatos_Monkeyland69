
-- =============================================
-- Author:		ALBERTO MANZANO CABRERA
-- Create date: 19-04-16
-- Description:	INSERTA FOLIOS EN LA TABLA TBL_ValoresTXT_CFA
-- =============================================
CREATE PROCEDURE [dbo].[usp_Inserta_Folios_TXT_Insertados]
	-- Add the parameters for the stored procedure here
	@VAR_CFA_Factura varchar(15),
	@VAR_CFA_Reference varchar(15),
	@VAR_CFA_Encontrado varchar(2),
	@VAR_CFA_Fecha_Insercion datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO TBL_ValoresTXT_CFA
				(CFA_Factura
				,CFA_Reference
				,CFA_Encontrado
				,CFA_Fecha_Insercion)
	VALUES
				(@VAR_CFA_Factura
				,@VAR_CFA_Reference
				,@VAR_CFA_Encontrado				
				,@VAR_CFA_Fecha_Insercion)				

END

GO

