
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_pedidos_carer]
	@arch_cliente varchar(50),  
	@hash_md5 varchar(50)
WITH ENCRYPTION
as

--declare @arch_cliente varchar(50)  
--declare @hash_md5 varchar(50)  
--set @arch_cliente = 'Pedido.MAR'  
--set @hash_md5 = '404901fa81b06496324d452223c0d1ae'  

select	distinct
			'C' +
			right(replicate('0', 5) + convert(varchar(5), cliente), 5) +
			right(replicate('0', 10) + convert(varchar(10), orden), 10) +
			replace(convert(varchar(10), getdate(), 3), '/', '') + 
			replace(convert(varchar(10), getdate(), 3), '/', '') 
from		pedidos_carer
where	arch_cliente = @arch_cliente and  
			hash_md5 = @hash_md5
union all 			
select	'D' +
			right(replicate('0', 8) + convert(varchar(8), t1.codigo), 8) +
			right(replicate(' ', 13) + convert(varchar(13), isnull(t2.cod_barras, replicate(' ', 13))), 13) +
			right(replicate('0', 6) + convert(varchar(6), isnull(t1.cant_ped, 0)), 6) +
			right(replicate('0', 6) + convert(varchar(6), isnull(t1.cant_surt, 0)), 6) +
			right(replicate('0', 6) + convert(varchar(6), convert(int, isnull(t1.cant_ped, 0) - isnull(t1.cant_surt, 0))), 6)
from		pedidos_carer t1 left join maestro_productos_baan t2 on
			t1.codigo = t2.codigo
where	t1.arch_cliente = @arch_cliente and  
			t1.hash_md5 = @hash_md5 and
			t1.cant_ped <> isnull(t1.cant_surt, 0)
union all 		
select	'D' +
			case
				when len(t1.basura) > 8 then substring(t1.basura, len(t1.basura) - 7, 8)
				else right(replicate('0', 8) + t1.basura, 8)
			end +
			replicate(' ', 13) +
			replicate('0', 6) +
			replicate('0', 6) +
			replicate('0', 6) 
from		pedidos_carer_registros_basura t1 
where	
			t1.hash_md5 = @hash_md5

GO
