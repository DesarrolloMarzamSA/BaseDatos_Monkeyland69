
-- =============================================
-- Author:		<Author,,Francisco Roberto Martínez Hernández>
-- Create date: <Create Date,14-03-2023,>
-- Description:	<Description,Se da mantenimiento a tabla de Hashes y Pediso >
-- =============================================
CREATE PROCEDURE [fbena].[MtoTablas_HashPedidos] 

AS
BEGIN

	SET NOCOUNT ON;


	DELETE --SELECT * FROM 
	hashes_md5 WHERE programa like 'PEDIDOS FBENAVIDES%' AND DATEDIFF(hh, fecha, CURRENT_TIMESTAMP) > 96
	
	DELETE --SELECT [timestamp],dateadd(hh, -24, current_timestamp) FROM 
    pedidos_fbenavides_ci where [timestamp]<dateadd(hh, -36, current_timestamp) 

		 
END

GO

