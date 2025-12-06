
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

/*
FECHA					MODIFICADO POR				SOLICITADO POR			DESCRIPCION
2012-06-27		MIGUEL SAMAYOA				ALVARO SOSA					ELIMINAR ESPACIOS EN BLANCO


*/



--select * from facturacion_electronica_estandar where SUCURSAL = 25 AND FOLIO_FISCAL LIKE '%14267'

--select top 10 * from facturacion_electronica_estandar where factura = '00182377' and cliente = '20522' and cod_barras = '3499320002516'
/*
usp_genera_facturacion_electronica_nacional 25, 'C2', '713', 'matutino'
usp_genera_facturacion_electronica_nacional 6, 'C2', '713', 'matutino'
usp_genera_facturacion_electronica_nacional 11, 'C2', '713', 'matutino'
usp_genera_facturacion_electronica_nacional 13, 'C2',
 '713', 'matutino'
*/
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_nacional] @sucursal int, @segto varchar(2), @ctepadre varchar(3), @horario varchar(25)
WITH ENCRYPTION
as
--PROCEDIMIENTO PARA FACTURACIÓN ELECTRÓNICA FCIAS. NACIONAl DE TIJUANA
--declare @fecha_facturacion datetime
--declare @diasemana as int
--select @diasemana = datepart(dw, current_timestamp)
--if @diasemana = 6 
--	begin
--		select @fecha_facturacion = case  @horario
--		when 'matutino' then convert(datetime, convert(varchar(10), current_timestamp, 121), 121) else
--		convert(datetime, convert(varchar(10), dateadd(dd, 2, current_timestamp), 121), 121) end
--	end
--else
--	begin
--		select @fecha_facturacion = case  @horario
--		when 'matutino' then convert(datetime, convert(varchar(10), current_timestamp, 121), 121) else
--		convert(datetime, convert(varchar(10), dateadd(dd, 1, current_timestamp), 121), 121) end
--	end
--if @diasemana = 7 
--	begin
--		select @fecha_facturacion = case  @horario
--		when 'matutino' then convert(datetime, convert(varchar(10), dateadd(dd, 1, current_timestamp), 121), 121) else
--		convert(datetime, convert(varchar(10), dateadd(dd, 1, current_timestamp), 121), 121) end
--	end
declare @fecha as datetime

	select @fecha = convert(datetime, convert(varchar(10)
, current_timestamp, 121), 121)

/*
select
case 
when t1.folio_fiscal is null then left(convert(varchar(8), convert(bigint, t1.factura)) + '            ', 12)  
else  left(convert(varchar(8), convert(bigint, t1.folio_fiscal)) + '            ', 12)  end
+ '|' +
t1.cliente + '|' +
convert(varchar(10), t1.fecha_factura, 112) + '|' +
left(CONVERT(VARCHAR(13), CONVERT(BIGINT, t2.cod_barras_tandem)) + '             ', 13)+ '|' + 
right('       ' + convert(varchar(7), t1.piezas_surtidas_con_cargo), 7) + '|' + 
right('       ' + convert(varchar(7), t1.piezas_surtidas_sin_cargo), 7) + '|' + 
right('      ' + convert(varchar(10), t1.precio_farm_sin_imp), 9) + '|' + 
right('   ' + convert(varchar(6), t1.porcentaje_descto_oferta), 6) + '|' + 
right('   ' + convert(varchar(6), t1.porcentaje_descto_comercial), 6) + '|' + 
right('      ' + convert(varchar(10), t1.iva), 9)+ '|' + 
' '+ '|' + 
'19000101'+ '|' + 
orden
from facturacion_electronica_estandar t1 inner join maestro_productos t2 on t1.codigo = t2.codigo
where
t1.sucursal = @sucursal and
t1.segto = @segto and
t1.ctepadre = @ctepadre and
t1.fecha_tandem >= @fecha
--t1.fecha_factura >= convert(datetime, '2010-11-30', 121)
order by
t1.factura,
t1.codigo
*/




select
case 
when t1.folio_fiscal is null then convert(varchar, convert(bigint, t1.factura))  
else  convert(varchar, convert(bigint, t1.folio_fiscal))  end
+ '|' +
t1.cliente + '|' +
convert(varchar(10), t1.fecha_factura, 112) + '|' +
CONVERT(VARCHAR, CONVERT(BIGINT, t2.cod_barras_tandem) )+ '|' + 
convert(varchar, t1.piezas_surtidas_con_cargo) + '|' + 
 convert(varchar, t1.piezas_surtidas_sin_cargo) + '|' + 
 convert(varchar, t1.precio_farm_sin_imp) + '|' + 
 convert(varchar, t1.porcentaje_descto_oferta) + '|' + 
 convert(varchar, t1.porcentaje_descto_comercial) + '|' + 
 convert(varchar, t1.iva)+ '|' + 
 '|' + 
'19000101'+ '|' + 
orden
from facturacion_electronica_estandar t1 inner join maestro_productos t2 on t1.codigo = t2.codigo
where
t1.sucursal = @sucursal and
t1.segto = @segto and
t1.ctepadre = @ctepadre and
t1.fecha_tandem >= @fecha
--t1.fecha_factura >= convert(datetime, '2010-11-30', 121)
order by
t1.factura/*,
t1.codigo*/
GO
