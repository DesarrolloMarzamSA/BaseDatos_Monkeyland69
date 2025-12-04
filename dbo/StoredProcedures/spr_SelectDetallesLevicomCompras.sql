CREATE procedure [dbo].[spr_SelectDetallesLevicomCompras] 
@fechainicio nvarchar(50),
@fechafin nvarchar(50)
as
begin
select ftp.NombreServidor as "Nombre del Buro",
       has.BuroCredito as "Ip",
	   cast(has.fecha as date) as "Fecha",
	   has.nombre_archivo as "Archivo",
	   ftp.carpeta as "Carpeta"
 from hashes_md5Levicom has
   inner join ftpprovedores ftp on has.BuroCredito = ftp.servidor
     where has.programa='LevicomCompras' and cast(has.fecha as date) between @fechainicio and @fechafin	 
	   order by has.fecha asc
	   end

GO

