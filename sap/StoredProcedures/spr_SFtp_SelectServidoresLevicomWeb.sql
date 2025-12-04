

-- =============================================
-- Author:		<Author,,ECV>
-- Create date: <Create Date,Nov/2020,>
-- Description:	<Description,Procedimiento para consultar los distintos servidores que existen para compras o pagos,>
-- =============================================
CREATE PROCEDURE [sap].[spr_SFtp_SelectServidoresLevicomWeb]
	@tipoproveedor nvarchar(20)
as
BEGIN
	Begin Try
		if @tipoproveedor = 'Compras'
			select fc.id_sftp as id,fc.servidor as servidor, fc.usuario as usuario , dbo.fnLeeClave(fc.passwordd) as pass ,fc.carpeta as carpeta, fc.puerto as puerto, fc.NombreServidor as nombreserver
			FROM [sap].[SFtpProvedores] fc
		else
			select fp.id_ftp as id,fp.servidor as servidor,fp.usuario as usuario,dbo.fnLeeClave(fp.passwordd)as pass,fp.carpeta as carpeta,fp.puerto as puerto, fp.nombre as nombreserver
			from ftpprovedorespagos fp
	end try
	Begin Catch
		Insert Into [WebMarzam].[dbo].[Logs]( Id_Pagina,Titulo,Metodo,Descripcioncorta,Descripcionlarga,Usuario)
		Values(58,ERROR_PROCEDURE(),'spr_SFtp_SelectServidoresLevicomWeb',ERROR_MESSAGE(),'','SQL') 
	END Catch
end

GO

