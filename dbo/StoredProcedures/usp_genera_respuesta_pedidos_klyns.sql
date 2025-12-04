USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_pedidos_klyns]
	@hash_md5 varchar(50),
	@arch_cliente varchar(50),  
	@cliente varchar(5),
	@orden varchar(50)
WITH ENCRYPTION
as

--declare @hash_md5 varchar(50)
--declare @arch_cliente varchar(50)
--declare @cliente varchar(5)
--declare @orden varchar(50)
--set @hash_md5 = '89304c8d3d52302a6ddd330ec30b3547'
--set @arch_cliente = 'ORD3487920120212003.TXT'
--set @cliente = '06296'
--set @orden = 'E000000889'

select	distinct
		rtrim(ltrim(eindicador)) +
		rtrim(ltrim(efecha)) +
		right(replicate('0', 14) + rtrim(ltrim(eordencompra)), 14) +
		right(replicate('0', 4) + rtrim(ltrim(esucursal)), 4) +
		right(replicate('0', 10) + rtrim(ltrim(codigo_farmacia)), 10) +
		right(replicate('0', 10) + rtrim(ltrim(orden)), 10) +
		replicate('0', 15) +
		right(replicate('0', 10) + rtrim(ltrim(eproveedor)), 10) +
		right(replicate('0', 10) + rtrim(ltrim(erenglones)), 10) +
		right(replicate('0', 20) + rtrim(ltrim(eimporteciva)), 20) +
		right(replicate('0', 20) + rtrim(ltrim(eimporteiva)), 20) +
		right(replicate('0', 20) + rtrim(ltrim(eimportesiva)), 20)
from	pedidos_klyns t1
where	t1.hash_md5 = @hash_md5 and 
		t1.arch_cliente = @arch_cliente and
		t1.cliente = @cliente and
		t1.orden = @orden and 
		isnull(t1.cant_surt, 0) > 0
union all
select	rtrim(ltrim(dindicador)) +
		right(replicate('0', 5) + rtrim(ltrim(drenglon)), 5) + 
		right(replicate('0', 16) + rtrim(ltrim(drefklyns)), 16) + 
		right(replicate('0', 16) + convert(varchar(16), cod_barras), 16) +
		right(replicate('0', 16) + convert(varchar(16), codigo), 16) +
		'000000000000000.00' +
		'00.00' + 
		'00.00' +
		'00.00' +
		'00.00' +
		'00.00' +
		right(replicate('0', 10) + convert(varchar(10), convert(int, cant_surt)), 10) +
		'000000000000000.00' +
		'000000000000000.00' +
		'000000000000000.00'
from	pedidos_klyns t1
where	t1.hash_md5 = @hash_md5 and 
		t1.arch_cliente = @arch_cliente and
		t1.cliente = @cliente and
		t1.orden = @orden and 
		isnull(t1.cant_surt, 0) > 0	

GO
