-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Conciliacion Farmacias del Ahorro periodo de fechas,,>
-- Example exec spr_FarmAhorroPeriodoFechaSelect '2017-03-09'
-- =============================================
CREATE PROCEDURE spr_FarmAhorroPeriodoFechaSelect 
	-- Add the parameters for the stored procedure here
	@Periodo as varchar(20)
AS
BEGIN
	 select inicio,termino,activo from periodos_facturacion_spt_fahorro where id = @Periodo
END

GO

