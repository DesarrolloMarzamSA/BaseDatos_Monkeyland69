-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_fbenavides_actualiza_hh]  @hash varchar(max)
AS
BEGIN
	-- [usp_fbenavides_actualiza_hh] '''b7d04198561775c7d56b999218849cc9'',''186edc2530be74960766193bdab504fc'''
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @query varchar(max)
  set @query=' 	update p set p.archivo_hh=ph.archivo_hh,p.estatus=ph.estatus,p.tftp=getdate()
--SELECT p.*,ph.*
FROM   monkeyland.dbo.pedidos_fbenavides_ci p 
inner join [monkeyland].[dbo].[pedidos_fbenavides_hh] ph 
on p.cliente=ph.cliente
and p.codigo=ph.codigo 
and p.hash_md5=ph.hash_md5 
and p.sucursal=ph.sucursal
where p.hash_md5 in('+@hash+')'
--print(@query)
execute(@query)
END

GO

