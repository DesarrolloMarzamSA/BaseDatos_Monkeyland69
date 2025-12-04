-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 25/06/2019
-- Description:	Obtiene la configuracion del cliente indicado
--  EXEC [CFD_Std].[usp_ConfiguracionCliente] 4154
-- =============================================
CREATE PROCEDURE [CFD_Std].[usp_ConfiguracionCliente]
	@IdTarea INT
AS
BEGIN
	
        SELECT 
		id_tarea,idcliente,sucursal,descripcion,segto,ctepadre,habilitado,ftp,correo,as2,zip,pdf,archivo,direcciones
		,ftp_host,ftp_usuario,ftp_password,ftp_ruta_inbox,ftp_ruta_outbox,ftp_ruta_resp
		,as2_host,as2_usuario,as2_password,as2_ruta_inbox,as2_ruta_outbox,as2_ruta_resp
		,query,fecha_alta,periodo,clave_proveedor,mail_body,add_mailbody,nc,sc,brfc,rfc,tarea,ticket,hora,renombrar,nc_c8,cuentas,archivo_xml_cliente  
		FROM cfd_parametros_estandar WITH(NOLOCK)
		WHERE id_tarea = @IdTarea
		
END

GO

