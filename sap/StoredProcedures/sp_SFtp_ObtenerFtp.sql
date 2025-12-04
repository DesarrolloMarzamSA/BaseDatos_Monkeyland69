--[sap].[sp_SFtp_ObtenerFtp] '0021000018'

CREATE procedure [sap].[sp_SFtp_ObtenerFtp]
	@idpro nvarchar(40)
as
begin
	if @idpro in(select distinct ft.[id_proveesftp]
	FROM [sap].[SFtpProvedores] pr
	inner join [sap].[ProveedoresSFtp] ft on pr.id_sftp = ft.id_sftp_fk
	 where pr.[id_sftp]=5) 
	 begin
	 select top 1 pr.servidor,pr.usuario,dbo.fnLeeClave(pr.passwordd) as contra,pr.carpeta,pr.puerto,pr.tiposervidor,ft.carpeta AS carpetaProveedor
	FROM [sap].[SFtpProvedores] pr
	inner join [sap].[ProveedoresSFtp] ft on pr.id_sftp = ft.id_sftp_fk
	 where pr.[id_sftp]=5
	end 
	else if  @idpro in(select distinct ft.[id_proveesftp]
	FROM [sap].[SFtpProvedores] pr
	inner join [sap].[ProveedoresSFtp] ft on pr.id_sftp = ft.id_sftp_fk
	 where pr.[id_sftp]=6)
	begin
	  select top 1 pr.servidor,pr.usuario,dbo.fnLeeClave(pr.passwordd) as contra,pr.carpeta,pr.puerto,pr.tiposervidor,ft.carpeta AS carpetaProveedor
	FROM [sap].[SFtpProvedores] pr
	inner join [sap].[ProveedoresSFtp] ft on pr.id_sftp = ft.id_sftp_fk
	 where pr.[id_sftp]=6
	end
	else begin	
	select pr.servidor,pr.usuario,dbo.fnLeeClave(pr.passwordd) as contra,pr.carpeta,pr.puerto,pr.tiposervidor,ft.carpeta AS carpetaProveedor
	FROM [sap].[SFtpProvedores] pr
	inner join [sap].[ProveedoresSFtp] ft on pr.id_sftp = ft.id_sftp_fk
	 where  ft.id_proveesftp = '0021000018'
	 end
end

GO

