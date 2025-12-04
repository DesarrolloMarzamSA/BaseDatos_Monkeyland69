-- =============================================
-- Author:		<Author,,enrique galicia rodriguez>
-- Create date: <Create Date,26-03-18,>
-- Description:	<Description,procedimiento para controlar la ejecucion del progras de consola,>
-- =============================================
CREATE PROCEDURE spr_GetEstatusCasaley
@idprograma int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT ccl.EstatusEjecucion  FROM ConsolaCasaLey ccl where ccl.IdPrograma =@idprograma
END

GO

