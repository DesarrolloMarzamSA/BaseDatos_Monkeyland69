

-- =============================================
-- Author:		<Author,,ECV>
-- Create date: <Create Date,Nov/2020,>
-- Description:	<Description,Procedimiento para extraer los distintos ftp,>
-- =============================================
CREATE PROCEDURE [sap].[spr_SFtp_ServidoresLevicomWeb]
as
begin try

	select id_sftp as id ,servidor+' '+NombreServidor as nombre from [sap].[SFtpProvedores]
	--union 
	--select id_ftp as id,servidor+' '+Nombre as nombre from  ftpprovedorespagos

end try
Begin Catch
	Insert Into [WebMarzam].[dbo].[Logs]( Id_Pagina,Titulo,Metodo,Descripcioncorta,Descripcionlarga,Usuario,Fecha,Estatus)
	Values(58,ERROR_PROCEDURE(),'spr_SFtp_ServidoresLevicomWeb',ERROR_MESSAGE(),'','SQL',SYSDATETIME(),0) 
END Catch

GO

