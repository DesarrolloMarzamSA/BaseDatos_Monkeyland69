USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_factura_pedidos_klyns]
	@hash_md5 varchar(50),
	@arch_cliente varchar(50),  
	@cliente varchar(5),
	@orden varchar(50),
	@consecutivo varchar(50),
	@factura varchar(50)
WITH ENCRYPTION
as

declare @renglones int
set @renglones = 0

--declare @hash_md5 varchar(50)
--declare @arch_cliente varchar(50)
--declare @cliente varchar(5)
--declare @orden varchar(50)
--declare @consecutivo varchar(50)
--declare @factura varchar(50)
--declare @renglones int
--set @hash_md5 = '463633ac1d86e42c2940478f3243b1cd'
--set @arch_cliente = 'ORD3487920120611003.TXT'
--set @cliente = '06296'
--set @orden = 'E000030688'
--set @consecutivo = '70000158409'
--set @factura = '807000973712'
--set @renglones = 0

select	@renglones	=	COUNT(*)
from	pedidos_klyns t1
where	t1.hash_md5 = @hash_md5 and 
		t1.arch_cliente = @arch_cliente and
		t1.cliente = @cliente and
		t1.orden = @orden and
		t1.consecutivo = @consecutivo and
		t1.factura = @factura and
		isnull(t1.cant_surt, 0) > 0
select	distinct
		rtrim(ltrim(eindicador)) +
		rtrim(ltrim(efecha)) +
		right(replicate('0', 14) + rtrim(ltrim(eordencompra)), 14) +
		right(replicate('0', 4) + rtrim(ltrim(esucursal)), 4) +
		right(replicate('0', 10) + rtrim(ltrim(codigo_farmacia)), 10) +
		right(replicate('0', 10) + rtrim(ltrim(orden)), 10) +
		right(replicate('0', 15) + convert(varchar(15), rtrim(ltrim(factura))), 15) +
		right(replicate('0', 10) + rtrim(ltrim(eproveedor)), 10) +
		right(replicate('0', 10) + convert(varchar(10), @renglones), 10) +
		right(replicate('0', 20) + convert(varchar(20), convert(money, e_facsiva)), 20) +
		right(replicate('0', 20) + convert(varchar(20), convert(money, e_facciva)), 20) +
		right(replicate('0', 20) + convert(varchar(20), convert(money, cast(round(e_iva, 2, 1) as decimal(18, 2)))), 20)
from	pedidos_klyns t1
where	t1.hash_md5 = @hash_md5 and 
		t1.arch_cliente = @arch_cliente and
		t1.cliente = @cliente and
		t1.orden = @orden and 
		t1.consecutivo = @consecutivo and
		t1.factura = @factura and
		isnull(t1.cant_surt, 0) > 0
union all
select	rtrim(ltrim(dindicador)) +
		right(replicate('0', 5) + rtrim(ltrim(drenglon)), 5) + 
		right(replicate('0', 16) + rtrim(ltrim(drefklyns)), 16) + 
		right(replicate('0', 16) + convert(varchar(16), cod_barras), 16) +
		right(replicate('0', 16) + convert(varchar(16), codigo), 16) +
		right(replicate('0', 18) + convert(varchar(18), convert(money, d_precio)), 18) +
		right(replicate('0', 5) + convert(varchar(5), convert(money, d_procescto1)), 5) +
		'00.00' + 
		'00.00' +
		right(replicate('0', 5) + convert(varchar(5), convert(money, d_poroferta)), 5) +
		right(replicate('0', 5) + convert(varchar(5), convert(money, d_iva)), 5) +
		right(replicate('0', 10) + convert(varchar(10), convert(int, cant_surt)), 10) +
		right(replicate('0', 18) + convert(varchar(18), convert(money, d_precio)), 18) +
		right(replicate('0', 18) + convert(varchar(18), convert(money, d_facsiva)), 18) +
		right(replicate('0', 18) + convert(varchar(18), convert(money, d_factciva)), 18)
from	pedidos_klyns t1
where	t1.hash_md5 = @hash_md5 and 
		t1.arch_cliente = @arch_cliente and
		t1.cliente = @cliente and
		t1.orden = @orden and 
		t1.consecutivo = @consecutivo and
		t1.factura = @factura and
		isnull(t1.cant_surt, 0) > 0	
		
GO
