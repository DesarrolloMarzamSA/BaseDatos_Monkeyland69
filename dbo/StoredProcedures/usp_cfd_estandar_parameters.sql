CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_cfd_estandar_parameters] @id_cliente VARCHAR(10)
 
AS

/*
EXECUTE usp_cfd_estandar_parameters 'FARMACONMP'
*/

SELECT 
	id_tarea					,
	idcliente					,
	sucursal					,
	descripcion				,
	segto							,
	ctepadre					,
	habilitado				,
	periodo						,
	ftp								,
	correo						,
	as2								,
	zip								,
	pdf								,
	archivo						,
	direcciones				,
	ftp_host					,
	ftp_usuario				,
	ftp_password			,
	ftp_ruta_inbox		,
	ftp_ruta_outbox		,
	ftp_ruta_resp			,
	as2_host					,
	as2_usuario				,
	as2_password			,
	as2_ruta_inbox		,
	as2_ruta_outbox		,
	as2_ruta_resp			,
	query							,
	mail_body					,
	fecha_alta				,
	nc								,
	clave_proveedor		,
	renombrar,
	archivo_xml_cliente,
	cuentas,rfc
FROM cfd_parametros_estandar WITH (NOLOCK) 
WHERE 
	idcliente = @id_cliente AND 
	habilitado = 1

GO

