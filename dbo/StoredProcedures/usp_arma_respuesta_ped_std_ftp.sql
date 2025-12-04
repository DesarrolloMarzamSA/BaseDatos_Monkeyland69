SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
--select * from pedidos_servidor_ftp where arch_cliente = 'FF04200012.DAT'
--exec usp_arma_respuesta_ped_std_ftp 'FF04200012.DAT' , '18d2994c7af01fa48a998b9cdaa85975', 'express', 95
CREATE procedure [dbo].[usp_arma_respuesta_ped_std_ftp] @arch_cliente varchar(30), @hash_md5 varchar(50), @nombre varchar(30), @longitud_registro int
as
select
left(
right('00' + convert(varchar(2), t1.sucursal), 2) +
t1.cuenta +
t1.cod_barras + 
case motivo 
when '3' then right('000' + convert(varchar(5), isnull(t1.cantidad_surtida, 0)), 3) 
when '4' then right('000' + convert(varchar(5), isnull(t1.cantidad_surtida, 0)), 3) 
when '8' then right('000' + convert(varchar(5), isnull(t1.cantidad_surtida, 0)), 3) 
--else '000' end +
else 
	case when t1.nombre = 'fcasaly' then right('000' + convert (varchar, t1.cantidad_pedida -  isnull(t1.cantidad_surtida, 0)), 3)
	else '000' end 
end +
t1.num_pedido +
t1.filler1 +
'00' +
t1.codigo +
t1.filler2 +
t1.filler3 + 
right('0000000000' + convert(varchar(10), precio) , 10) +
right('00000' + convert(varchar(10), isnull(porcentaje_oferta, 0)) , 5) +
convert(varchar(1), t1.cod_credito), @longitud_registro)
from
pedidos_servidor_ftp t1
where
t1.arch_cliente = @arch_cliente and
t1.hash_md5 = @hash_md5 and
t1.nombre = @nombre
order by
t1.orden 
asc

GO
