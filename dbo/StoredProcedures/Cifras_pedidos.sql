SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Cifras_pedidos]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    select CONVERT(nvarchar(50), GETDATE(), 20) Cliente, 0 lineas
    union
    select 'Farmacia Smart', COUNT(*) from monkeyland.dbo.pedidos_fsmart
	where convert(nvarchar(10), tftp, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Ahorro filiales ' Cliente, COUNT(*) lineas from monkeyland.dbo.[pedidos_spt_fahorro]
	where convert(nvarchar(10), timestamp, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Ahorro Franquicias ' Cliente, COUNT(*) lineas from monkeyland.dbo.[pedidos_fahorro_franquicias]
	where convert(nvarchar(10), fecha_pedido, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Cofar ' Cliente, COUNT(*) lineas from monkeyland.dbo.[pedidos_farmatodo_cofar_historia]
	where convert(nvarchar(10), Fecha_Pedido, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Fanasa ' Cliente, COUNT(*) lineas from monkeyland.dbo.pedidos_fanasa_historia
	where convert(nvarchar(10), timestamp, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Farmacias Ahorro ', COUNT(*) from monkeyland.dbo.pedidos_spt_fahorro
	where convert(nvarchar(10), timestamp, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Farmacias benavides ', COUNT(*) from monkeyland.dbo.pedidos_fbenavides_ci
	where convert(nvarchar(10), timestamp, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select t1.cliente, SUM(t1.lineas) lineas from
	(select 'pedidos Farmacon ' Cliente, COUNT(*) lineas from monkeyland.dbo.pedidos_farmacon_historia
	where convert(nvarchar(10), FechaPedido, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Farmacon ' Cliente, COUNT(*) lineas from monkeyland.dbo.pedidos_farmacon
	where convert(nvarchar(10), FechaPedido, 101) = CONVERT(nvarchar(10), GETDATE(), 101)) t1
	group by t1.Cliente
	union
	select 'pedidos FarmaTodo', COUNT(*) from monkeyland.dbo.pedidos_farmatodo_cofar
	where convert(nvarchar(10), fecha_pedido, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Fiza20 ' Cliente, COUNT(*) lineas from monkeyland.dbo.[pedidos_fyza_20]
	where convert(nvarchar(10), timestamp, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Franquicias', COUNT(*) from monkeyland.dbo.pedidos_fahorro_franquicias
	where convert(nvarchar(10), tftp, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select t1.cliente, SUM(t1.lineas) lineas from
	(select 'pedidos Union ' Cliente, COUNT(*) lineas from monkeyland.dbo.[pedidos_funion]
	where convert(nvarchar(10), tftp, 101) = CONVERT(nvarchar(10), GETDATE(), 101)
	union
	select 'pedidos Union ' Cliente, COUNT(*) lineas from monkeyland.dbo.[pedidos_funion_historia]
	where convert(nvarchar(10), tftp, 101) = CONVERT(nvarchar(10), GETDATE(), 101)) t1
	group by t1.Cliente
	union
	select 'Pedidos estandar cliente '+s.ibs_letra+p.cuenta,count(p.cod_barras) from monkeyland.dbo.pedidos_servidor_ftp p
	inner join sucursales s on p.sucursal=s.sucursal group by p.sucursal,s.ibs_letra,p.cuenta
END
GO
