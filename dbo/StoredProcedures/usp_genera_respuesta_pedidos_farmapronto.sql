
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_pedidos_farmapronto]
	@arch_cliente varchar(50),
	@hash_md5 varchar(50)

as
--declare @arch_cliente varchar(50)
--declare @hash_md5 varchar(50)
--set @arch_cliente = 'PMAA1637.DAT'
--set @hash_md5 = 'ddcb41dbbcdc09b59b10528a495bed82'
select	distinct
			rtrim(idproveedor) +
			replicate(' ', 1) +
			right(replicate('0', 7) + convert(varchar(7), cliente), 7) +
			right(replicate('0', 15) + convert(varchar(15), orden), 15) +
			right(replicate('0', 8) + convert(varchar(8), fechadelpedido), 8)
from		pedidos_farmapronto
where	arch_cliente = @arch_cliente and
			hash_md5 = hash_md5
group by
			idproveedor,
			cliente,
			orden, 
			fechadelpedido
union all
select	right(replicate(' ', 14) + convert(varchar(14), cod_barras), 14) +
			right(replicate('0', 6) + convert(varchar(6), cast(isnull(cant_ped, 0) - isnull(cant_surt, 0) as int)), 6)
from		pedidos_farmapronto
where 	isnull(cant_ped, 0) <> isnull(cant_surt, 0) and
			arch_cliente = @arch_cliente and
			hash_md5 = @hash_md5
GO
