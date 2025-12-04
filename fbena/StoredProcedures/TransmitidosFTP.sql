
-- =============================================
-- Author:		<Author,,Francisco Roberto Martínez Hernández>
-- Create date: <Create Date,09-03-2023,>
-- Description:	<Description,Se guarda el estado de envio de archivos al servidor FTP del cliente>
-- =============================================
CREATE PROCEDURE [fbena].[TransmitidosFTP] 
  @LstPedidosTransmitidos AS [fbena].[LstPedidosTransmitidos] READONLY
AS
BEGIN

	SET NOCOUNT ON;
	--Falta validar duplicados de Origen  Implementar
	--*****************************************************************
	--*****************************************************************
	MERGE fbena.PedidosTransmitidos T
	USING (
			SELECT nombre,rutalocal,rutaserver, enviado,GETDATE() AS fechaenvio,compania,error
			FROM @LstPedidosTransmitidos 
	) S
	ON (S.nombre = T.nombre )	
	WHEN MATCHED THEN
	     UPDATE SET
		  T.enviado=S.enviado
		 ,T.error=S.error
		 ,T.fechaenvio = GETDATE()		
	WHEN NOT MATCHED THEN
	INSERT (nombre,rutalocal,rutaserver,enviado,fechaenvio,fechaingreso,compania,error)
    VALUES (nombre,rutalocal,rutaserver,enviado,fechaenvio, GETDATE(),compania,error);	

		 
END

GO

