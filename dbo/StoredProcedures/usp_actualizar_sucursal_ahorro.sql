
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_actualizar_sucursal_ahorro]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
update t8 set t8.sucursal=e.sucursal
--SELECT e.sucursal,e.serie,e.factura,e.cliente,e.ctepadre,e.orden,d.codigos,
--t8.orden,t8.codigo,t8.sucursal,t8.cuenta,e.fechaprog
 FROM Historica.dbo.encabezado e
inner join Historica.dbo.detalle d on e.factura=d.factura and e.serie=d.serie
inner join monkeyland.dbo.pedidos_spt_fahorro t8 on convert(int, t8.orden) = e.orden and t8.codigo = right(d.codigos, 7) and e.cliente = t8.cuenta 
where e.cliente in('18530','16920','51960','51962','19870','19900','19880') 
and e.ctepadre='007' and convert(varchar,e.fechaprog,112)>=convert(varchar,getdate()-3,112)


update t8 set t8.sucursal=e.sucursal
--SELECT e.sucursal,e.serie,e.factura,e.cliente,e.ctepadre,e.orden,d.codigos,
--t8.orden,t8.codigo,t8.sucursal,t8.cuenta,e.fechaprog --2255
 FROM Historica.dbo.encabezado e
inner join Historica.dbo.detalle d on e.factura=d.factura and e.serie=d.serie
inner join monkeyland.dbo.pedidos_spt_fahorro t8 on convert(int, t8.orden) = e.orden and t8.codigo = right(d.codigos, 7) and e.cliente = t8.cuenta 
where  e.ctepadre='007' and convert(varchar,e.fechaprog,112)>=convert(varchar,getdate()-3,112)
and t8.sucursal in(1,24,23,13,5,9)

END


--select cliente from Historica.dbo.encabezado where factura in('30571695','30571696','30572527',
--'30572528','30574031','30574032','30574665','30574666','30575983','30575984')
--group by cliente
--select convert(varchar,getdate()-125,112)

GO

