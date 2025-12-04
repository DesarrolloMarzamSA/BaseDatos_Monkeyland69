-- =============================================
-- Author:		<Author,,enrique galicia rodriguez>
-- Create date: <Create Date,02-01-17,>
-- Description:	<Description,Procedimiento para guardar las caracteristicas de los servidores de pagos y compras,>
-- =============================================
Create PROCEDURE [dbo].[spr_UpdateServidorLevicomWeb] 
@servidor nvarchar(30),
@Provedor nvarchar(30),
@usuario nvarchar(30),
@password nvarchar(100),
@carpeta nvarchar(100),
@puerto nvarchar(100),
@idserver nvarchar(10),
@nombreservidor nvarchar(50),
@usuarioreg nvarchar(50)
as
BEGIN
	Begin Try
	if @Provedor = 'Compras'
	update ftpprovedores set servidor =@servidor ,usuario=@usuario ,passwordd=dbo.fnColocaClave(@password) ,carpeta=@carpeta ,puerto= @puerto,NombreServidor=@nombreservidor,Usuarioreg=@usuarioreg
	where id_ftp =@idserver
    
	else
	update ftpprovedorespagos set servidor=@servidor,usuario=@usuario,passwordd=dbo.fnColocaClave(@password),carpeta=@carpeta,puerto=@puerto,tipo='Pagos',nombre=@nombreservidor
	where id_ftp=@idserver

	end try
 Begin Catch
		Insert Into [WebMarzam].[dbo].[Logs]( Id_Pagina,Titulo,Metodo,Descripcioncorta,Descripcionlarga,Usuario)
		Values(58,ERROR_PROCEDURE(),'spr_InsertarServidorLevicomWeb',ERROR_MESSAGE(),'','SQL') 
END Catch
end

GO

