-- =============================================
--Enrique Galicia Rodiguez
--27-10-16
-- =============================================
CREATE PROCEDURE [dbo].[SP_FarmaciaRivera]
	AS
BEGIN
	--ejecutamos la consulta para obtener los datos de la farmacia este proceso se ejecutara cada que 
	--la aplicacion la mande llamar
	SET NOCOUNT ON;	
	SELECT REPLACE(REPLACE(primera_parte,CHAR(10),''),CHAR(13),'')as "primera_parte",segunda_parte,cliente,sucursal 
 --select distinct primera_parte,segunda_parte,cliente,sucursal
    from vi_fact_elec_estandar_rivera
      where  fecha_tandem >= CONVERT(DATETIME, CONVERT(VARCHAR(10), CURRENT_TIMESTAMP-2, 121), 121) 
         AND sucursal = 8 AND ctepadre = '333'
		 END

GO

