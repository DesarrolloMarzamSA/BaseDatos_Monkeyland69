
-- =============================================
-- Author:		mandrade
-- Create date: 04-08-2014
-- Description:	usp_obtener coverturas filiales Benavides
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_coverturasBenavides]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select  REPLICATE('0',2-len(sucursal))+ cast(sucursal as varchar)
			+cia+mostrador+SUBSTRING(franquicia,1,30)+ REPLICATE(' ',30-len(franquicia))+'000'
	from [monkeyland].[dbo].view_cobertura_benavides
	where activo=1 order by franquicia
END
--select * from sucursales
--select * from cat_sucursales_benavides where cia in('N146','N256')
--update cat_sucursales_benavides set franquicia='BENAVIDES' where cia in('N146','N256')

GO

