CREATE procedure [dbo].[usp_fahorro_importa_facturas_baan]
as
declare @contaras int
		select case replace(t_sucl, ' ', '') when '5F' then '9' else replace(t_sucl, ' ', '') end letra, right(convert(varchar(6), t_cuno), 5) cliente, convert(varchar(3), t_ttyp) tipo_doc, right('00000000' + convert(varchar(8), t_ninv), 8) factura, convert(money, t_amnt) monto, t_docd fecha into #facturas_baan from openquery([baan], '{set isolation to dirty read} select t2.t_sucl, t1.t_cuno, t1.t_ttyp, t1.t_ninv, t1.t_amnt, t1.t_docd from ttfacr200080 t1 inner join ttccom010080 t2 on t1.t_cuno = t2.t_cuno where t1.t_tdoc = ''      '' and t1.t_lino = 0 and t1.t_ttyp like ''FC%'' and t2.t_sgmt = ''C1'' and t_pctf like ''%99007'' and t1.t_docd > date(today) - 120 units day')

		select @contaras = count(*) from #facturas_baan
		if @contaras > 1000
		begin
			truncate table facturas_baan_spt_fahorro
			insert into facturas_baan_spt_fahorro(sucursal, factura, cliente, tipo_doc, monto, fecha) select t2.sucursal, t1.factura, t1.cliente, t1.tipo_doc, t1.monto, t1.fecha from #facturas_baan t1 inner join sucursales t2 on t1.letra = t2.letra
		end
		drop table #facturas_baan

GO

