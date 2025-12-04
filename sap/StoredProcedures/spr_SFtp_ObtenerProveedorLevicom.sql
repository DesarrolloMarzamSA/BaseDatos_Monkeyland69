
-- =============================================
-- Author:		<Author,,ECV>
-- Create date: <Create Date,Nov/2020,>
-- Description:	<Description,procedimiento para extraer los proveedores de los buros de levicom tanto de compras como de pagos,>
-- =============================================
CREATE PROCEDURE [sap].[spr_SFtp_ObtenerProveedorLevicom]
	@Proveedor varchar(30)
AS
BEGIN
	Begin Try
		if @Proveedor = 'Compras'
			SELECT RTRIM(LTRIM(pf.id_proveesftp)) as provedor,
			pf.nombre as nombre,
			ft.NombreServidor as nombreservidor,
			pf.carpeta as carpeta
			FROM [sap].[ProveedoresSFtp] pf
			inner join [sap].[SFtpProvedores] ft on ft.id_sftp =pf.id_sftp_fk 	
		else
			SELECT RTRIM(LTRIM(pf.id_proveeftp)) as provedor,
			pf.nombre as nombre
			,ft.nombre as nombreservidor,
			pf.carpeta as carpeta
			FROM proveedoresftppagos pf
			inner join ftpprovedorespagos ft on pf.id_ftp_fk = ft.id_ftp	
	end try
	Begin Catch
		Insert Into [WebMarzam].[dbo].[Logs]( Id_Pagina,Titulo,Metodo,Descripcioncorta,Descripcionlarga,Usuario)
		Values(58,ERROR_PROCEDURE(),'spr_SFtp_ObtenerProveedorLevicom',ERROR_MESSAGE(),'','SQL') 
	END Catch
end

GO

