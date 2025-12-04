-- =============================================
-- Author:		mandrade
-- Create date: 20/11/2014
-- Description:	obtiene archivos que se deben de enviar respuesta
-- [dbo].[usp_archivo_respuesta_benavides] 
-- =============================================
CREATE PROCEDURE [dbo].[usp_archivo_respuesta_benavides]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		SELECT distinct nombre_archivo as arch_cliente,firma as hashMD5,
		fecha,ruta,replace(ruta,'In','Out') as rutaRespuesta
		FROM [dbo].[hashes_md5_benavides] 
        where	programa like '%PEDIDOS FBENAVIDES%'  and	firma not in(select hashmd5 from respuesta_benavides where estatus=1)
		--and CONVERT(VARCHAR(12), fecha, 114) between '18:00:00:000'  and '19:00:00:000'
		and CONVERT(VARCHAR(8), fecha, 112)>=CONVERT(VARCHAR(8), getdate()-1, 112)
		and SUBSTRING(nombre_archivo,1,4) not in('PECD') 	and datediff(minute,fecha,getdate())>=35	
END

GO

