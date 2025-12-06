
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_fanasa_pedidos_head]

as
select distinct right(REPLICATE(' ',16) + CONVERT(varchar,rtrim(ped.pedido)),16) pedido, 
 right(REPLICATE(' ',7) + CONVERT(varchar,ped.cuenta),7)cuenta, 
 right(REPLICATE(' ',9) + REPLACE(convert(varchar,fecha_pedido,103),'/','') ,9) fecha, 
 right(REPLICATE(' ',7) + CONVERT(varchar,replace(convert(varchar(6),ped.timestamp,114),':','')) + '00',7)hora,ped.archivo_hh,ped.orno
 from pedidos_fanasa_historia ped where respuesta =1 --and archivo_hh like'%PFA%'

GO
