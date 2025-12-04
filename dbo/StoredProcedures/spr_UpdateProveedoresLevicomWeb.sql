CREATE PROCEDURE [dbo].[spr_UpdateProveedoresLevicomWeb]--'Compras','0001','prueba2s',1,'kike','egalicia'
@identificador varchar(30),
@id nvarchar(200),
@nombre nvarchar(200),
@idftp int,
@carpeta nvarchar(200),
@usuarioreg nvarchar(30)
	as
	begin try	
	if @identificador ='Compras'
  update   proveedoresftp set nombre=@nombre,id_ftp_fk=@idftp,carpeta=@carpeta,usuarioreg=@usuarioreg where id_proveeftp=@id
 end try
 Begin Catch
		
		end Catch

		begin try
if @identificador ='Pagos'
   update  proveedoresftppagos set nombre =@nombre ,id_ftp_fk=@idftp,carpeta=@carpeta,usuarioregistra=@usuarioreg where id_proveeftp= @id
end try
 Begin Catch
		Insert Into [WebMarzam].[dbo].[Logs]( Id_Pagina,Titulo,Metodo,Descripcioncorta,Descripcionlarga,Usuario)
		Values(58,ERROR_PROCEDURE(),'spr_ObtenerProveedorLevicom',ERROR_MESSAGE(),'','SQL') 
END Catch

GO

