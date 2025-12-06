
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_interdata_catalogo_clientes_cid]
	@x_FechaInicial datetime,
	@x_FechaFinal datetime

as
--select	distinct 
--			right('000' + convert(varchar(3), case convert(varchar(3), t2.suc_interdata) when 2 then '  A' else convert(varchar(3), t2.suc_interdata) end), 3) + 
--			t1.cliente +
--			left(t1.farmacia + replicate(' ', 40), 40) +
--			left(t1.direccion + replicate(' ', 40), 40) +
--			left(t1.colonia +replicate(' ', 25), 25) +
--			left(t1.poblacion + replicate(' ', 15), 15) +
--			right(replicate('0', 3) + replace(t1.cve_estado, ' ', ''), 3) +
--			right(replicate('0', 5) + replace(t1.codigo_postal, ' ', ''), 5) +
--			'00' + 
--			right(replicate(' ', 13) + replace(t1.rfc, ' ', ''), 13)
--from		clientes_baan t1 inner join sucursales t2 on 
--			t1.sucursal = t2.sucursal and
--			t1.cliente <> '00000'

select	distinct 
			right('000' + convert(varchar(3), case convert(varchar(3), t2.suc_interdata) when 2 then '  A' else convert(varchar(3), t2.suc_interdata) end), 3) + 
			t1.cliente +
			left(t1.farmacia + replicate(' ', 40), 40) +			
			left(de.direccion + replicate(' ', 65), 65) +
			left(de.degmun + replicate(' ', 15), 15) +
			right(replicate('0', 3) + replace(t1.cve_estado, ' ', ''), 3) +
			right(replicate('0', 5) + replace(t1.codigo_postal, ' ', ''), 5) +
			'00' + 
			right(replicate(' ', 13) + replace(t1.rfc, ' ', ''), 13)
from		clientes_baan t1 inner join sucursales t2 on 
			t1.sucursal = t2.sucursal and
			t1.cliente <> '00000'
			inner join vw_direccionentrega de on t1.cliente_ibs=de.decliente_ibs
GO
