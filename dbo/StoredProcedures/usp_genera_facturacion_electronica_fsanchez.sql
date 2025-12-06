
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_fsanchez] (@fecha varchar(10))

as
begin
SET NOCOUNT OFF

/*
  FACTURACION ELECTRONICA FARMACIAS SANCHEZ
  ULTIMA MODIFICACION NOV 2008
  ULTIMA MODIFICACION
			16 jul 2009:	ORDENAR POR CLIENTE, FOLIO FISCAL
			03 jun 2009:	CAMBIO DE REMISION POR FOLIO CFD

  PROGRAMADO PARA LAS 17:00 HRS. TODOS LOS DIAS DE LA SEMANA


  SE RECIBE EL PARAMETRO DE LA SUCURSAL EN CASO DE QUE SE LLEGARA 
  EN UN FUTURO A ASIGNAR A OTRA SUCURSAL O ABRIR OTRA RAMAL.

  GENERA 1 ENCABEZADO POR FACTURA CON EL NUMERO DE LINEAS
  LUEGO EL DETALLE DE LAS n LINEAS REPORTADAS
  SE DEFINE UN CURSOR A PARTIR DE LOS ENCABEZADOS Y POSTERIORMENTE SE RECORRE
  PARA EMITIR LAS LINEAS DE DETALLE
*/


/*declare @fecha as varchar(10)

set @fecha = '20081115'
*/
declare @encabezado as varchar(500)
declare @sucursal tinyint
declare @factura varchar(8)
declare @registros varchar(10)

create table #resultados(linea int identity, col1 varchar(500))

SELECT * INTO #fact_elect_fsanchez
FROM facturacion_electronica_estandar 
WHERE fecha_tandem = CONVERT(datetime,@fecha,121) AND
  sucursal = 3 AND
  ctepadre = '232' AND
  segto = 'C2'
  order by factura



declare  cur_encabezados cursor fast_forward for 

SELECT sucursal,
        factura,
        convert(char,fecha_factura,12)/*+' # REGTOS'+cast(
        (SELECT count(*) registros from facturacion_electronica_estandar
            WHERE factura = @factura) as char) registros */
FROM #fact_elect_fsanchez t1 
/*WHERE fecha_factura BETWEEN CONVERT(datetime,@fecha,121) AND
  CONVERT(datetime,@fecha,121) AND
  sucursal = 3 AND
  ctepadre = '232' AND
  segto = 'C2'
  order by factura
*/

open cur_encabezados

fetch next from cur_encabezados into @sucursal, @factura, @encabezado




    set @registros = CAST ( (SELECT count(*) registros 
            from #fact_elect_fsanchez
--            WHERE sucursal = @sucursal and fecha_factura = CONVERT(datetime,@fecha,121)
--            AND ctepadre = '232'
--            AND segto = 'C2'
        ) as char(5) )





    set @encabezado = left(@encabezado,10)  + 'CON '+ @registros + ' REGTOS'

	insert into #resultados(col1) values(@encabezado)

	insert into #resultados(col1)
        select
            left(cod_barras,13)+' '+
            cliente+' '+  
--            right('00000000' +factura                                           ,8 )+' '+
            right(replicate(' ',8) +CONVERT(VARCHAR(8),CONVERT(BIGINT,folio_fiscal)), 8) +' '+
            right('000000000'+codigo                                            , 9) +' '+
            LEFT(t1.descripcion + '                                        '    ,32) +' '+
            right('0000'     + cast(piezas_surtidas_con_cargo as varchar(4))    ,4 ) +' '+
            right('00000000' + cast(precio_farm_sin_imp as varchar(11))        ,11) +' '+
            right('000000'   + cast(porcentaje_descto_oferta as varchar(6))  ,6 ) +' '+
            right('0000'     + cast(piezas_surtidas_sin_cargo as varchar(4))    ,6 ) +' '+
            LEFT(clas_fis    + '   '                                            ,2)  +' '+
            right('000000'   + cast(porcentaje_descto_comercial as varchar(6) )         ,6 )
        FROM facturacion_electronica_estandar t1 
        where sucursal = @sucursal 
            and fecha_factura = CONVERT(datetime,@fecha,121)
            AND ctepadre = '232'
            AND segto = 'C2'
				order by cliente,folio_fiscal	--	agregado a peticio de Jorge becerra y Fsanchez  16 / jul / 2009

            


	fetch next from cur_encabezados into @sucursal, @factura, @encabezado


close cur_encabezados
deallocate cur_encabezados
select col1 from #resultados order by linea asc
drop table #resultados


end
GO
