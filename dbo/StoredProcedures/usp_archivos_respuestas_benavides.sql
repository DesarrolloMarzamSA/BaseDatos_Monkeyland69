-- =============================================
-- Author:		mandrade
-- Create date: 20/11/2014
-- Description:	obtiene archivos que se deben de enviar respuesta
-- [dbo].[usp_archivos_respuestas_benavides] ''
-- =============================================
CREATE PROCEDURE [dbo].[usp_archivos_respuestas_benavides] @programa varchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		SELECT distinct nombre_archivo as arch_cliente,firma as hashMD5
		--,CONVERT(VARCHAR(12), fecha, 114) 
		FROM hashes_md5 
        where-- programa=@programa  and
		programa like '%BENA%'  and	firma not in(select hashmd5 from respuesta_benavides where estatus=1)
		--and CONVERT(VARCHAR(12), fecha, 114) between '18:00:00:000'  and '19:00:00:000'
		and CONVERT(VARCHAR(8), fecha, 112)>=CONVERT(VARCHAR(8), getdate()-1, 112)
		and SUBSTRING(nombre_archivo,1,4) not in('PECD') 	and datediff(minute,fecha,getdate())>=35	
END

GO

