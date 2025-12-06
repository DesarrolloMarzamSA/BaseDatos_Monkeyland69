
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_pedidos_solicitud_klyns]
	@hash_md5 varchar(50),
	@arch_cliente varchar(50),  
	@cliente varchar(5)
WITH ENCRYPTION
as

--declare @hash_md5 varchar(50)
--declare @arch_cliente varchar(50)
--declare @cliente varchar(5)
--set @hash_md5 = 'aeb8ea88cbcea167ad4c3a96905d5ae1'
--set @arch_cliente = 'SOL3487920120210002.TXT'
--set @cliente = '06296'

select	distinct (@cliente),
		rtrim(ltrim(eindicador)) +
		right(replicate(' ', 10) + convert(varchar(10), rtrim(ltrim(codigo_farmacia))), 10) + 
		right(replicate(' ', 14) + convert(varchar(14), rtrim(ltrim(orden))), 14) + 
		right(replicate(' ', 2) + convert(varchar(2), rtrim(ltrim(noenvio))), 2) + 
		right(replicate(' ', 5) + convert(varchar(5), rtrim(ltrim(folio))), 5) valor1
from	pedidos_solicitud_klyns t1
where	t1.hash_md5 = @hash_md5 and 
		t1.arch_cliente = @arch_cliente and
		t1.cliente = @cliente 
union all
select	'x_Dummy',
		rtrim(ltrim(dindicador)) + 
		right(replicate('0', 16) + convert(varchar(16), rtrim(ltrim(cod_barras))), 16) + 
		right(replicate('0', 16) + convert(varchar(16), rtrim(ltrim(refklyns))), 16) + 
		right(replicate('0', 16) + convert(varchar(16), rtrim(ltrim(codigo))), 16) +
		right(replicate('0', 5) + convert(varchar(5), convert(varchar(5), isnull(cant_ped, 0))), 5) +
		case
			when t1.preciofact = t1.preciofactmarzam and preciofinal = preciofinalmarzam then right(replicate('0', 5) + convert(varchar(5), convert(varchar(5), isnull(cant_ped, 0))), 5) 
			else '00000'
		end 
from	pedidos_solicitud_klyns t1
where	t1.hash_md5 = @hash_md5 and 
		t1.arch_cliente = @arch_cliente and
		t1.cliente = @cliente
GO
