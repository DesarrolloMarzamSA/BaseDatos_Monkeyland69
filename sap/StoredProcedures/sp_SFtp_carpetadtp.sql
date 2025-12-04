

CREATE procedure [sap].[sp_SFtp_carpetadtp]
	@id nvarchar(50)
as
begin
	declare @resultado nvarchar(40)
	
	select @resultado = carpeta from [sap].[ProveedoresSFtp] where id_proveesftp =@id
	
	select @resultado as carpeta
	
	if(@resultado ='')
		begin
			set @resultado = 'OTROS' 
			select @resultado
		end
	else  
	begin
		select @resultado = carpeta from [sap].[ProveedoresSFtp] where id_proveesftp =@id
	end

END

GO

