
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_respuesta_farmacon_faltante] --'0b615773a201e976b8c512fb38f9f0d3'
	@hash_md5 varchar(50)
WITH ENCRYPTION
as

--declare @hash_md5 varchar(50)
--set @hash_md5 = 'c42469420d26d3b075dea2aa2fb73d7f'
/*update pedidos_farmaconv2 set estatus=50 where cantidad_surtida is null and estatus=60 and hash_md5 = @hash_md5;

select	right(replicate('0', 10) + convert(varchar(10), t1.num_pedido), 10) +
			right(replicate('0', 7) + convert(varchar(7), t1.cuenta), 7) +
			right(replicate('0', 13) + convert(varchar(13), t1.cod_barras), 13) +
			right(replicate('0', 6) + convert(varchar(6), cast(isnull(t1.cantidad_pedida, 0)-isnull(t1.cantidad_surtida, 0) as int)), 6) +
			----case
				--when t1.cantidad_surtida is null and t1.motivo_no_surtido is null and t1.tamano_archivo_respuesta is null and t1.arch_tandem is null and t1.poferta <> t1.porcentaje_oferta_dboferta then '07' 
				--when t1.cantidad_surtida is null and t1.motivo_no_surtido is null and t1.tamano_archivo_respuesta is null and t1.codigo is null and t1.arch_tandem is null and t1.poferta = t1.porcentaje_oferta_dboferta then '03' 
				--when t1.cantidad_surtida is null and t1.motivo_no_surtido is null and t1.tamano_archivo_respuesta is null and convert(bigint, t1.codigo) > 0 and t1.arch_tandem is not null and hora_resp_tandem is null and t1.poferta = t1.porcentaje_oferta_dboferta then '13' 
				--when t1.cantidad_surtida is null and t1.motivo_no_surtido is null and convert(bigint, t1.codigo) > 0 and t1.tamano_archivo_respuesta >= 54  then '05'
				--when t1.cantidad_pedida > t1.cantidad_surtida and t1.cantidad_surtida > 0 and t1.cantidad_surtida is not null and t1.motivo_no_surtido = 0 then '02'
				----when t1.motivo_no_surtido = 7 and t1.pOferta = t1.porcentaje_oferta_dboferta  then '01'
				----when t1.motivo_no_surtido = 7 and t1.pOferta <> t1.porcentaje_oferta_dboferta  then '07'
				----when t1.motivo_no_surtido is null and t1.pOferta <> t1.porcentaje_oferta_dboferta  and enviado_ftp = 1 then '07'
				--when t1.motivo_no_surtido = 0 then '02'
				--when t1.motivo_no_surtido = 1 then '12'
				--when t1.motivo_no_surtido = 2 then '11'
				--when t1.sucursal is null then '09'
				--when t1.tamano_archivo_respuesta < 700 then '01'
				--else '01'
			----end +
			'01' +
			right(replicate('0', 5) + convert(varchar(5), convert(int, (t1.porcentaje_oferta_dboferta * 100))), 5) +
			case
				when isnull(t2.clas_fis, 'N') = 'N' then replicate('0', 4)
				when isnull(t2.clas_fis, 'N') = 'NA' then replicate('0', 4)
				when isnull(t2.clas_fis, 'N') = 'B' then replicate('9', 4)
				when isnull(t2.clas_fis, 'N') = 'BA' then replicate('9', 4)
				when isnull(t2.clas_fis, 'N') = 'H' then right(replicate('0', 4) + convert(varchar(4), cast(isnull(t2.descto_prod, 0)*100 as int)), 4)
				when isnull(t2.clas_fis, 'N') = 'HA' then right(replicate('0', 4) + convert(varchar(4), cast(isnull(t2.descto_prod, 0)*100 as int)), 4)
			end +
			right( replicate('0', 8) + convert(varchar(13), cast(isnull(t2.prec_farm, 0)*100 as int)), 8) +
			replicate('0', 13) valor1
into		#respuesta
from 		pedidos_farmaconv2 t1 left join maestro_productos_baan t2 ON
			t1.codigo = t2.codigo 
where	((isnull(t1.cantidad_pedida, 0) <> isnull(t1.cantidad_surtida, 0)) or (isnull(t1.cantidad_surtida, 0) is null)) and 
			t1.hash_md5 = @hash_md5 and
			t1.enviado_ftp = 1 --and t1.pOferta <> t1.porcentaje_oferta_dboferta or (t1.pOferta = t1.porcentaje_oferta_dboferta and t1.motivo_no_surtido = 7)

		

select	*
from		#respuesta
where	valor1 is not null

drop table #respuesta*/


select	right(replicate('0', 10) + convert(varchar(10), t1.num_pedido), 10) +
			right(replicate('0', 7) + convert(varchar(7), t1.cuenta), 7) +
			right(replicate('0', 13) + convert(varchar(13), t1.cod_barras), 13) +
			right(replicate('0', 6) + convert(varchar(6), cast(isnull(t1.cantidad_pedida, 0)-isnull(t1.cantidad_surtida, 0) as int)), 6) +
			----case
				--when t1.cantidad_surtida is null and t1.motivo_no_surtido is null and t1.tamano_archivo_respuesta is null and t1.arch_tandem is null and t1.poferta <> t1.porcentaje_oferta_dboferta then '07' 
				--when t1.cantidad_surtida is null and t1.motivo_no_surtido is null and t1.tamano_archivo_respuesta is null and t1.codigo is null and t1.arch_tandem is null and t1.poferta = t1.porcentaje_oferta_dboferta then '03' 
				--when t1.cantidad_surtida is null and t1.motivo_no_surtido is null and t1.tamano_archivo_respuesta is null and convert(bigint, t1.codigo) > 0 and t1.arch_tandem is not null and hora_resp_tandem is null and t1.poferta = t1.porcentaje_oferta_dboferta then '13' 
				--when t1.cantidad_surtida is null and t1.motivo_no_surtido is null and convert(bigint, t1.codigo) > 0 and t1.tamano_archivo_respuesta >= 54  then '05'
				--when t1.cantidad_pedida > t1.cantidad_surtida and t1.cantidad_surtida > 0 and t1.cantidad_surtida is not null and t1.motivo_no_surtido = 0 then '02'
				----when t1.motivo_no_surtido = 7 and t1.pOferta = t1.porcentaje_oferta_dboferta  then '01'
				----when t1.motivo_no_surtido = 7 and t1.pOferta <> t1.porcentaje_oferta_dboferta  then '07'
				----when t1.motivo_no_surtido is null and t1.pOferta <> t1.porcentaje_oferta_dboferta  and enviado_ftp = 1 then '07'
				--when t1.motivo_no_surtido = 0 then '02'
				--when t1.motivo_no_surtido = 1 then '12'
				--when t1.motivo_no_surtido = 2 then '11'
				--when t1.sucursal is null then '09'
				--when t1.tamano_archivo_respuesta < 700 then '01'
				--else '01'
			----end +
			'01' +
			right(replicate('0', 5) + convert(varchar(5), convert(int, (t1.porcentaje_oferta_dboferta * 100))), 5) +
			case
				when isnull(t2.clas_fis, 'N') = 'N' then replicate('0', 4)
				when isnull(t2.clas_fis, 'N') = 'NA' then replicate('0', 4)
				when isnull(t2.clas_fis, 'N') = 'B' then replicate('9', 4)
				when isnull(t2.clas_fis, 'N') = 'BA' then replicate('9', 4)
				when isnull(t2.clas_fis, 'N') = 'H' then right(replicate('0', 4) + convert(varchar(4), cast(isnull(t2.descto_prod, 0)*100 as int)), 4)
				when isnull(t2.clas_fis, 'N') = 'HA' then right(replicate('0', 4) + convert(varchar(4), cast(isnull(t2.descto_prod, 0)*100 as int)), 4)
			end +
			right( replicate('0', 8) + convert(varchar(13), cast(isnull(t2.prec_farm, 0)*100 as int)), 8) +
			replicate('0', 13) valor1
into		#respuesta
from 		pedidos_farmacon t1 left join maestro_productos_baan t2 ON
			t1.codigo = t2.codigo 
where	((isnull(t1.cantidad_pedida, 0) <> isnull(t1.cantidad_surtida, 0)) or (isnull(t1.cantidad_surtida, 0) is null)) and 
			t1.hash_md5 = @hash_md5 and
			t1.enviado_ftp = 1 --and t1.pOferta <> t1.porcentaje_oferta_dboferta or (t1.pOferta = t1.porcentaje_oferta_dboferta and t1.motivo_no_surtido = 7)

select	*
from		#respuesta
where	valor1 is not null

drop table #respuesta
GO
