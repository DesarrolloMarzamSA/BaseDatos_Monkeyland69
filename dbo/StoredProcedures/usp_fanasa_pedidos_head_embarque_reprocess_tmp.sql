
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_fanasa_pedidos_head_embarque_reprocess_tmp]

as
select distinct right(REPLICATE(' ',16) + CONVERT(varchar,rtrim(pedido)),16) pedido, 
 right(REPLICATE(' ',7) + CONVERT(varchar,ped.letra + cuenta),7)cuenta, 
 right(REPLICATE(' ',9) + REPLACE(convert(varchar,fecha_pedido,103),'/','') ,9) fecha,  
 right(REPLICATE(' ',7) + CONVERT(varchar,replace(convert(varchar(6),ped.timestamp,114),':','')),7)+ '00' hora,archivo_hh,ped.orno,s.compania_ibs
 from pedidos_fanasa_historia ped,capa_ibs.dbo.sucursales s 
 where respuesta in (38,2) 
/*orno in(
9540503,
9540595,
9540642,
9549275,
9549302,
9549307,
9549341,
9550084,
9564065,
9564074,
9564092,
9564100,
9564129,
9573571,
9574587,
9574585,
9583163,
9583166,
9583173,
9590809,
9591350,
9591356,
9604740,
9612384,
9612389)*/
 and  ped.sucursal=s.sucursal 
 --and ped.pedido not in(select pedido from pedidos_fanasa_historia group by pedido having (SUM(cantidad_surtida)=0) )
and orno is not null
GO
