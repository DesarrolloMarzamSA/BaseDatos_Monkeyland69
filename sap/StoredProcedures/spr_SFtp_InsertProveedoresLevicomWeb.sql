

CREATE PROCEDURE [sap].[spr_SFtp_InsertProveedoresLevicomWeb]
	@identificador varchar(30),
	@id nvarchar(200),
	@nombre nvarchar(200),
	@idftp int,
	@carpeta nvarchar(200),
	@usuarioreg nvarchar(30)
as
begin try	
	if @identificador ='Compras'
		insert into [sap].[ProveedoresSFtp] (id_proveesftp,nombre,id_sftp_fk,carpeta,usuarioreg) values (@id,@nombre,@idftp,@carpeta,@usuarioreg)
	else
		insert into  proveedoresftppagos (id_proveeftp,nombre,id_ftp_fk,carpeta,usuarioregistra) values (@id,@nombre,@idftp,@carpeta,@usuarioreg) 
end try
Begin Catch
		
END Catch

GO

