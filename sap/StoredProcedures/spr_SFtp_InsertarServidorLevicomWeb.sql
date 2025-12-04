

-- =============================================
-- Author:		<Author,,ECV>
-- Create date: <Create Date,Nov/2020,>
-- Description:	<Description,Procedimiento para guardar las caracteristicas de los servidores de pagos y compras,>
-- =============================================
CREATE PROCEDURE [sap].[spr_SFtp_InsertarServidorLevicomWeb] 
	@servidor nvarchar(30),
	@Provedor nvarchar(30),
	@usuario nvarchar(30),
	@password nvarchar(100),
	@carpeta nvarchar(100),
	@puerto nvarchar(100),
	@tiposervidor nvarchar(10),
	@nombreservidor nvarchar(50),
	@usuarioreg nvarchar(50)
as
BEGIN
	Begin Try
		if @Provedor = 'Compras'
			INSERT INTO [sap].[SFtpProvedores] (servidor,usuario,passwordd,carpeta,puerto,tiposervidor,NombreServidor,Usuarioreg)
				values(@servidor,@usuario,dbo.fnColocaClave(@password),@carpeta,@puerto,@tiposervidor,@nombreservidor,@usuarioreg)
		else
			insert into ftpprovedorespagos (servidor,usuario,passwordd,carpeta,puerto,tipo,nombre)
			values(@servidor,@usuario,dbo.fnColocaClave(@password),@carpeta,@puerto,@tiposervidor,@nombreservidor)
	end try
	Begin Catch
		Insert Into [WebMarzam].[dbo].[Logs]( Id_Pagina,Titulo,Metodo,Descripcioncorta,Descripcionlarga,Usuario)
		Values(58,ERROR_PROCEDURE(),'spr_SFtp_InsertarServidorLevicomWeb',ERROR_MESSAGE(),'','SQL') 
	END Catch
end

GO

