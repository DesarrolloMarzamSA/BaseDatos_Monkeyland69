
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_fanasa_pedidos_head_embarque_reprocess]
(@fecha as varchar(10))

as
select distinct right(REPLICATE(' ',16) + CONVERT(varchar,rtrim(pedido)),16) pedido, 
 right(REPLICATE(' ',7) + CONVERT(varchar,ped.letra + cuenta),7)cuenta, 
 right(REPLICATE(' ',9) +REPLACE(convert(varchar,fecha_pedido,103),'/','') ,9) fecha, 
 right(REPLICATE(' ',7) + CONVERT(varchar,replace(convert(varchar(6),ped.timestamp,114),':','')),7)+ '00' hora,archivo_hh,ped.orno,s.compania_ibs
 from pedidos_fanasa_historia ped inner join capa_ibs.dbo.sucursales s on ped.sucursal=s.sucursal
 where respuesta in(3,39)  and fecha_pedido=@fecha
 --and ped.pedido not in(select pedido from pedidos_fanasa_historia group by pedido having (SUM(cantidad_surtida)=0) )
and orno is not null
GO
