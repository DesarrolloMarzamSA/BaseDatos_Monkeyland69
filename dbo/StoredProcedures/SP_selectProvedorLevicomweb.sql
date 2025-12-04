CREATE procedure [dbo].[SP_selectProvedorLevicomweb] --'35502','Compras'
@idpr nvarchar(30),
@identificador nvarchar(30)
as
	begin try	
	if @identificador ='Compras'
    select id_proveeftp as id from  proveedoresftp  where id_proveeftp = @idpr 	
	else
	 select id_proveeftp as id from  proveedoresftppagos  where id_proveeftp = @idpr  
	 
end try
 Begin Catch
		Insert Into [WebMarzam].[dbo].[Logs]( Id_Pagina,Titulo,Metodo,Descripcioncorta,Descripcionlarga,Usuario,Fecha,Estatus)
		Values(58,ERROR_PROCEDURE(),'spr_SetLogs',ERROR_MESSAGE(),'','SQL',SYSDATETIME(),0) 
END Catch

GO

