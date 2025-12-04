-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_actualiza_EnvioPedido_heb] @ordenes varchar(max),@archivoMzm varchar(150)
AS
BEGIN
	--execute monkeyland.dbo.[usp_actualiza_EnvioPedido_heb] '50235282,50235283,50235291,50235292,50235294','PHEB00004.PED'
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @query varchar(max)    
	set @query ='update monkeyland..[pedidoHEB_Encabezado] set EstatusEnvio=60 where EstatusEnvio=0 and Purchase_order in('+@ordenes+')'
	execute(@query);
	set @query ='update monkeyland..[pedidoHEB_Detalle] set estatus=60,archivoMarzam='''+@archivoMzm+''' where estatus=30 and Purchase_order in('+@ordenes+')'
	--print(@query);
	execute(@query);	
END

GO

