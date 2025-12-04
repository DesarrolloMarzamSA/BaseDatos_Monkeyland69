
-- =============================================
-- Author:		<Author,,Francisco Roberto Martínez Hernández>
-- Create date: <Create Date,15-03-2023,>
-- Description:	<Description,valida si existe el hash generado por el contenido del archivo>
-- =============================================
CREATE PROCEDURE [fbena].[ValidaHash] 
@ModoPedido varchar(150),
@Firma      varchar(150)
AS
BEGIN

	SET NOCOUNT ON;


	  SELECT [programa],[firma],[fecha],[nombre_archivo],[lineas],[tamanio],[folio_inicial],[folio_final] 
	    FROM [dbo].[hashes_md5] 
	  WHERE programa = @ModoPedido AND firma = @Firma

    --select top 1000 * from [dbo].[hashes_md5] where programa like 'PEDIDOS FBENAVIDEs%' order by fecha desc
	--select top 1000 * from [dbo].[hashes_md5_benavides] order by fecha desc	


	 
END

GO

