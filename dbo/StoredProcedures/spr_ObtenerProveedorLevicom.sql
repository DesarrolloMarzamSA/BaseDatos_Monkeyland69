-- =============================================
-- Author:		<Author,,enrique galicia rodriguez>
-- Create date: <Create Date,15-12-17,>
-- Description:	<Description,procedimiento para extraer los proveedores de los buros de levicom tanto de compras como de pagos,>
-- =============================================
CREATE PROCEDURE [dbo].[spr_ObtenerProveedorLevicom]
@Proveedor varchar(30)
AS
BEGIN
	Begin Try
	if @Proveedor = 'Compras'
	SELECT RTRIM(LTRIM(pf.id_proveeftp)) as provedor,
	pf.nombre as nombre,
	ft.NombreServidor as nombreservidor,
	pf.carpeta as carpeta
	 FROM proveedoresftp pf
	inner join ftpprovedores ft on ft.id_ftp =pf.id_ftp_fk 	
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
		Values(58,ERROR_PROCEDURE(),'spr_ObtenerProveedorLevicom',ERROR_MESSAGE(),'','SQL') 
END Catch
end

GO

