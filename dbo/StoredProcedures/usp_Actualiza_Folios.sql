
-- =============================================
-- Author:		ALBERTO MANZANO CABRERA
-- Create date: 19-04-16
-- Description:	ACTUALIZA FOLIOS EN LA TABLA TBL_CambiaFolioAdenda
-- =============================================
CREATE PROCEDURE [dbo].[usp_Actualiza_Folios]
	-- Add the parameters for the stored procedure here
	@VAR_Opcion varchar(1),
	@VAR_CFA_Cliente varchar(12),
	@VAR_CFA_RFC varchar(15),
	@VAR_CFA_Folio_Anterior varchar(15),
	@VAR_CFA_Fecha_Registro varchar(20),
	@VAR_CFA_Folio_Nuevo varchar(15),
	@VAR_CFA_Estatus varchar(5),
	@VAR_CFA_Fecha_Actualizacion  varchar(20),
	@VAR_CFA_Reproceso numeric(18,0),
	@VAR_CFA_Fecha_Reproceso varchar(20),
	@VAR_CFA_Observaciones varchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	--ACTUALIZA FOLIO_NUEVO
	IF @VAR_Opcion = 1
	BEGIN
		UPDATE	TBL_CambiaFolioAdenda
		SET		CFA_Folio_Nuevo = @VAR_CFA_Folio_Nuevo
				,CFA_Estatus = @VAR_CFA_Estatus
				,CFA_Fecha_Actualizacion = CONVERT(DATETIME, CONVERT(VARCHAR(10), CAST(@VAR_CFA_Fecha_Actualizacion AS datetime), 103) + ' ' + CONVERT(VARCHAR(8), CAST(@VAR_CFA_Fecha_Actualizacion AS datetime), 108), 103)
				,CFA_Observaciones = @VAR_CFA_Observaciones
		WHERE	CFA_Cliente = @VAR_CFA_Cliente AND CFA_RFC = @VAR_CFA_RFC AND CFA_Folio_Anterior = @VAR_CFA_Folio_Anterior
	END 

	--ACTUALIZA SI ES REPROCESO
	IF @VAR_Opcion = 2
	BEGIN
		UPDATE	TBL_CambiaFolioAdenda						
		SET		CFA_Fecha_Registro = CONVERT(DATETIME, CONVERT(VARCHAR(10), CAST(@VAR_CFA_Fecha_Registro AS datetime), 103) + ' ' + CONVERT(VARCHAR(8), CAST(@VAR_CFA_Fecha_Registro AS datetime), 108), 103)
				,CFA_Folio_Nuevo = @VAR_CFA_Folio_Nuevo
				,CFA_Estatus = @VAR_CFA_Estatus
				,CFA_Reproceso = @VAR_CFA_Reproceso
				,CFA_Fecha_Reproceso = CONVERT(DATETIME, CONVERT(VARCHAR(10), CAST(@VAR_CFA_Fecha_Reproceso AS datetime), 103) + ' ' + CONVERT(VARCHAR(8), CAST(@VAR_CFA_Fecha_Reproceso AS datetime), 108), 103)
				,CFA_Observaciones = @VAR_CFA_Observaciones
		WHERE	CFA_Cliente = @VAR_CFA_Cliente AND CFA_RFC = @VAR_CFA_RFC AND CFA_Folio_Anterior = @VAR_CFA_Folio_Anterior
	END
END

/****** Object:  StoredProcedure [dbo].[usp_Actualiza_Folios_TXT_Insertados]    Script Date: 23/05/2016 03:38:21 p.m. ******/
SET ANSI_NULLS ON

GO

