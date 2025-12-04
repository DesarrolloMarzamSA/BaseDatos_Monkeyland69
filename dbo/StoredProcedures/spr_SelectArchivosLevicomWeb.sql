-- =============================================
-- Author:		<Author,,enrique galicia rodriguez>
-- Create date: <Create Date,04-01-2018,>
-- Description:	<Description,proedimiento para saber cuantos archivos se enviaron a los direrentes buros de compras (levicom,edicom,paebsa...),>
-- =============================================
CREATE PROCEDURE spr_SelectArchivosLevicomWeb
AS
BEGIN
	select 
	   ftp.NombreServidor as "Nombre del Buro",
       has.BuroCredito as "Ip",
	   cast(has.fecha as date) as "Fecha",
	   has.nombre_archivo as "Archivo",
	   ftp.carpeta as "Carpeta"
       from hashes_md5Levicom has WITH (NOLOCK)
       inner join ftpprovedores ftp WITH (NOLOCK) on has.BuroCredito = ftp.servidor
       where has.programa='LevicomCompras' and has.lineas =1
	   order by has.fecha asc	  
END

GO

