CREATE procedure [dbo].[spr_SelectDetallesLevicomCompraserror]
   @fechainicio nvarchar(50),
@fechafin nvarchar(50)
   as
   begin
select 
has.firma as "Nombre del Buro",
 has.BuroCredito as "Ip",
 cast(has.fecha as date) as "Fecha",
   has.nombre_archivo as "Archivo",
   has.firma as "Carpeta"
 from hashes_md5Levicom has
    where has.programa='LevicomCompras' and cast(has.fecha as date) between @fechainicio and @fechafin and has.lineas = 0	
	 order by has.fecha asc
	 end

GO

