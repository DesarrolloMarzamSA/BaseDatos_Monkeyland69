-- =============================================
-- Author:		lafernandez
-- Create date: 17/10/2014
-- Description:	<Description,/sur/cadenas/fcaapsal/out/,>

-- =============================================

CREATE PROCEDURE [dbo].[usp_rutas_floresRegalos]  @tipo int=0

AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.


	SET NOCOUNT ON;

	if @tipo=1

	begin

    SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	FROM monkeyland.dbo.ruta_archivo_ftp where cliente='Apoyo'

	end

	else if @tipo=2

	begin

    SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	FROM monkeyland.dbo.ruta_archivo_ftp where cliente='Herrera'

	end

	else if @tipo=3

	begin

	 SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	FROM monkeyland.dbo.ruta_archivo_ftp where cliente='Calderon'

	end

	else if @tipo=4

	begin

	 SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	FROM monkeyland.dbo.ruta_archivo_ftp where cliente='Hydropharma'

	end

	else if @tipo=5

	begin

	--tijuana marzam

	 SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	FROM monkeyland.dbo.ruta_archivo_ftp where cliente='tijuana1'

	end
	
	else if @tipo=8

	begin

	 SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	 FROM monkeyland.dbo.ruta_archivo_ftp where cliente='FarmaciaSantaMaria'

	end	
	
	else if @tipo=9

	begin

	 SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	 FROM monkeyland.dbo.ruta_archivo_ftp where cliente='FarmaciaRosario'

	end	

	else if @tipo=10

	begin

	 SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	 FROM monkeyland.dbo.ruta_archivo_ftp where cliente='FarmaciaJuquilita'

	end	



	else if @tipo=6

	begin

	--tijuana medicpac

	 SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	FROM monkeyland.dbo.ruta_archivo_ftp where cliente='tijuana2'

	end

	else if @tipo=7

	begin

	SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	FROM monkeyland.dbo.ruta_archivo_ftp where cliente='FarmaVida'

	end

	else 

	begin

	SELECT  ftp, usuario, contrasena, ruta, cliente,cliente	+ ' '+rutaInfo as Info

	FROM monkeyland.dbo.ruta_archivo_ftp where cliente='floresRegalos'

	end	
	
	

END

GO

