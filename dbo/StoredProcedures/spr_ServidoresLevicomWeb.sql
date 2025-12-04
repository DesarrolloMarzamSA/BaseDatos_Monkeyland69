-- =============================================
-- Author:		<Author,,enrique galicia rodriguez>
-- Create date: <Create Date,21-12-2017,>
-- Description:	<Description,Procedimiento para extraer los distintos ftp,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_ServidoresLevicomWeb]
	as
	begin try
	
  select id_ftp as id ,servidor+' '+NombreServidor as nombre from ftpprovedores
  union 
  select id_ftp as id,servidor+' '+Nombre as nombre from  ftpprovedorespagos

end try
 Begin Catch
		Insert Into [WebMarzam].[dbo].[Logs]( Id_Pagina,Titulo,Metodo,Descripcioncorta,Descripcionlarga,Usuario,Fecha,Estatus)
		Values(58,ERROR_PROCEDURE(),'spr_SetLogs',ERROR_MESSAGE(),'','SQL',SYSDATETIME(),0) 
END Catch

GO

