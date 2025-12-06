
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_intermedia_pedidos_farmacon_reproceso] 
	@hash_md5 varchar(50)

as

declare @x_Dummy varchar(5000)
set @x_Dummy = ''

update	pedidos_farmacon 
set		cantidad_surtida = t2.cant_surt,
		motivonosurtido_preibs = t2.motivo_no_surtido,
		tamano_archivo_respuesta = 12345,
		factura = t2.ibs_orno,
		hora_resp_tandem = CURRENT_TIMESTAMP
from	pedidos_farmacon_historia t1 inner join Capa_ibs.dbo.pedidos_traductor t2 on
		t1.sucursal = t2.sucursal and 
		t1.cuenta = t2.cliente and 
		t1.codigo = t2.codigo and 
		t1.arch_tandem = substring(t2.archivo, 1, 8)
where	t1.hash_md5 = @hash_md5 
select	distinct arch_tandem
into	#arch_tandem
from	pedidos_farmacon_historia
where	hash_md5 = @hash_md5 and
		arch_tandem is not null
group by 
		arch_tandem
having	SUM(isnull(cantidad_surtida, 0)) = 0
select	@x_Dummy = @x_Dummy + arch_tandem + ';'
from	#arch_tandem
if(LEN(@x_Dummy) > 0)
	select	SUBSTRING(@x_Dummy, 1, len(@x_Dummy) - 1)
else
	select	''
drop table #arch_tandem 	
GO
