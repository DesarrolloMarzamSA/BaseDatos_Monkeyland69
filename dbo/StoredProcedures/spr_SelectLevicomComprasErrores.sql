-- =============================================
-- Author:		<Author,,Enrique galicia rodriguez>
-- Create date: <Create Date,04-01-2018,>
-- Description:	<Description,Procedimiento para obtener los errores en los archivos de levicom compras,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_SelectLevicomComprasErrores]
AS
BEGIN
	select 
		 has.nombre_archivo as "Archivo",
		 has.BuroCredito as "Problema",	
	     cast(has.fecha as date) as "Fecha" 
	     from hashes_md5Levicom has WITH (NOLOCK) where has.programa='LevicomCompras' and has.lineas=0
		 order by has.fecha asc
END

GO

