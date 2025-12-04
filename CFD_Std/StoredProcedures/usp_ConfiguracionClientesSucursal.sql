-- =============================================
-- Author: Francisco Roberto Martínez Hernández
-- Create date: 25/06/2019
-- Description:	Obtiene los parametros de configuracion de los clientes estandar
--  EXEC [CFD_Std].[usp_Parametros] 03
-- =============================================
CREATE PROCEDURE [CFD_Std].[usp_ConfiguracionClientesSucursal]
	@Sucursal INT
AS
BEGIN
	
        SELECT 
		id_tarea, idcliente, sucursal, descripcion, habilitado, ftp, correo, as2, zip, pdf, archivo, direcciones, ftp_host, nc, 
		brfc, ftp_ruta_inbox, periodo, query  
		FROM cfd_parametros_estandar WITH(NOLOCK)
		WHERE sucursal = @Sucursal
		ORDER BY id_tarea DESC
END

GO

