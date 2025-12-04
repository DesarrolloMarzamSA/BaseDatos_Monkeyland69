
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_pedido_heb] @ordenes varchar(max)
AS
BEGIN
	--[usp_obtener_pedido_heb] '50235282,50235283,50235291,50235292,50235294'
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @query varchar(max)
    
	set @query ='
	select ''001''+REPLICATE(''0'',6-len(cast(p.Buyer_id as varchar)))+ cast(p.Buyer_id as varchar)+
	+cast(cast(d.Purchase_order as int) as varchar)+
	REPLICATE('' '',10-len(cast(cast(d.Purchase_order as int) as varchar)))+
	''00000''+
	cast(cast(d.Subsidiary as int) as varchar)+REPLICATE('' '',5-len(cast(cast(d.Subsidiary as int) as varchar)))+
	cast(cast(d.bar_code as numeric)as varchar)+REPLICATE('' '',13-len(cast(cast(d.bar_code as numeric)as varchar)))+
	REPLICATE(''0'',7-len(cast(cast(d.ordered_quantity as int)as varchar)))+cast(cast(d.ordered_quantity as int)as varchar)+
	''000000000''+''00000''+''0000''+convert(varchar,d.FechaRegistro,112) as pedido
	from monkeyland..pedidoHEB_Encabezado p
	inner join monkeyland..pedidoHEB_Detalle d on p.Purchase_order=d.Purchase_order and p.Subsidiary_gln=d.Subsidiary_gln
	and p.Subsidiary=d.Subsidiary
	where p.Estatus=''PENDIENTE'' and p.EstatusEnvio=0 and p.Purchase_order in('+@ordenes+')' 
	--print(@query);
	execute(@query);
--update monkeyland..pedidoHEB_Encabezado set EstatusEnvio=1 where Estatus='PENDIENTE' and EstatusEnvio=0
--select * from monkeyland..pedidoHEB_Encabezado where Estatus='PENDIENTE'
--update monkeyland..pedidoHEB_Encabezado set EstatusEnvio=0 where Estatus='PENDIENTE'
END

--execute monkeyland.dbo.usp_obtener_pedido_heb

GO

