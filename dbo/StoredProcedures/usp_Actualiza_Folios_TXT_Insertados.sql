
-- =============================================
-- Author:		ALBERTO MANZANO CABRERA
-- Create date: 19-04-16
-- Description:	ACTUALIZA FOLIOS EN LA TABLA TBL_ValoresTXT_CFA
-- =============================================
CREATE PROCEDURE [dbo].[usp_Actualiza_Folios_TXT_Insertados]
	-- Add the parameters for the stored procedure here
	
	@VAR_CFA_Factura varchar(15),
	@VAR_CFA_Reference varchar(15),
	@VAR_CFA_Encontrado varchar(5),
	@VAR_CFA_Fecha_Insercion varchar(20)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	--ACTUALIZA ESTATUS DE ENCONTRADO
	UPDATE	TBL_ValoresTXT_CFA
	SET		CFA_Encontrado = @VAR_CFA_Encontrado,
			CFA_Fecha_Insercion = CONVERT(DATETIME, CONVERT(VARCHAR(10), CAST(@VAR_CFA_Fecha_Insercion AS datetime), 103) + ' ' + 
													CONVERT(VARCHAR(8), CAST(@VAR_CFA_Fecha_Insercion AS datetime), 108), 103)
	WHERE	CFA_Factura = @VAR_CFA_Factura AND CFA_Reference = @VAR_CFA_Reference
END

GO

