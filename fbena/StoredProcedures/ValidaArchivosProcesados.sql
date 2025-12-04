
-- =============================================
-- Author:		<Author,,Francisco Roberto Martínez Hernández>
-- Create date: <Create Date,09-03-2023,>
-- Description:	<Description,Se validan los archivos a ver si se enviaron al servidor FTP del cliente>
-- =============================================
CREATE PROCEDURE [fbena].[ValidaArchivosProcesados] 
@LstPedidosTransmitidos AS [fbena].[LstPedidosTransmitidos] READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT P.nombre,P.rutalocal,P.rutaserver,P.enviado,P.compania 
		--select *
		  FROM   fbena.PedidosTransmitidos P WITH(NOLOCK)
		  INNER JOIN @LstPedidosTransmitidos L ON P.nombre = L.nombre
		WHERE P.enviado=0
				
END

GO

