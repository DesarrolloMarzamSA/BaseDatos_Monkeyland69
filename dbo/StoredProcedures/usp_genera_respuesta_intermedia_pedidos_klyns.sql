
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_genera_respuesta_intermedia_pedidos_klyns] 
	@hash_md5 varchar(50)

as
	--declare @hash_md5 varchar(50)
	--declare @consecutivo varchar(5000)
	--declare @sql varchar(5000)
	--declare @fecha AS varchar(8)
	--set @consecutivo = ''
	--set @sql = ''
	--set @hash_md5 = 'a07b438ee809a4dc02b86f8da8d67890'

	declare @consecutivo varchar(5000)
	declare @sql varchar(5000)
	declare @fecha varchar(8)
	set @consecutivo = ''
	set @sql = ''
	set @fecha = ''
	
select	@fecha = convert(varchar, DATEADD(hh, -100, getdate()), 112)
select	distinct convert(varchar, t1.consecutivo) consecutivo, SUBSTRING(archivo, 1, 8) arch_tandem
into	#consecutivo
from	Capa_ibs.dbo.pedidos_traductor t1
where	substring(t1.archivo, 1, 8) in	(	select	distinct t2.arch_tandem  
											from	pedidos_klyns t2 
											where	t2.hash_md5 = @hash_md5 and 
													t2.arch_tandem is not null
										) 
select	@consecutivo = @consecutivo + '''' + '''' + consecutivo + '''' + '''' + ', ' 
from	#consecutivo
select	@consecutivo = SUBSTRING(@consecutivo, 1, LEN(@consecutivo) - 1) 
select	@sql = '	SELECT	IHOREF AS "consecutivo",
							IHINVN AS "factura", 
							IHCUNO AS "cliente", 
							IDPRDC AS "codigo",
							IDPCA5 AS "clas_fis", 
							IHIAET AS "e_facsiva",
							IHIAIT AS "e_facciva",
							(IHIAIT - IHIAET) AS "e_iva", 
							IDSALP AS "d_precio",
							COALESCE(SRBGDT1.DTDCPR,0) AS "d_procescto1",
							COALESCE(SRBGDT2.DTDCPR,0) AS "d_poroferta",
							COALESCE(HCVATC,0)  AS "d_iva",
							IDITET AS "d_facsiva", 
							IDITIT AS "d_factciva",
							OLOQTY AS "cant_ped",
							IDQTY  AS "cant_surt",
							COALESCE(RMPESI,0)  AS "CodigoIEPS", 
							IDAMOU AS "total",
							IHIDAT AS "fecha" 
					FROM	MA4620EF04.Z18ISH LEFT JOIN MA4620EF04.SR9ISD ON 
							IDINVN = IHINVN AND  
							IDTYPP = 1 LEFT JOIN MA4620EF04.SRBGDT AS SRBGDT1 ON 
							SRBGDT1.DTGDSQ = IDGDSQ AND 
							SRBGDT1.DTDITY = ''''H'''' LEFT JOIN MA4620EF04.SRBGDT AS SRBGDT2 ON 
							SRBGDT2.DTGDSQ = IDGDSQ AND 
							SRBGDT2.DTDITY <> ''''H'''' LEFT JOIN MA4620EF04.SRBSOL ON 
							OLORNO = IDORNO AND 
							OLPRDC = IDPRDC LEFT JOIN MA4620EF04.SRBVHC ON 
							HCVAHC = IDVAHC LEFT JOIN MA4620EF04.SRBRPM ON 
							RPPRDC = IDPRDC LEFT JOIN MA4620EF04.SRBCTLRM ON 
							RMMACO = RPMACO
					WHERE	IHOREF IN ('
select @sql = @sql + @consecutivo + ') AND IHIDAT >= ' + @fecha + ' ORDER BY IHOREF'
execute('select * into enc_det_ibs from openquery(as400, ''' + @sql + ''')')  
ALTER TABLE	enc_det_ibs 
ADD			arch_tandem varchar(8) NULL
update	enc_det_ibs 
set		arch_tandem = t1.arch_tandem 
from	#consecutivo t1 inner join enc_det_ibs t2 on 
		t1.consecutivo = t2.consecutivo
update	pedidos_klyns 
set		factura = t1.factura,
		cant_surt = t1.cant_surt,
		consecutivo = t1.consecutivo,
		e_facsiva = t1.e_facsiva,
		e_facciva = t1.e_facciva,
		e_iva = t1.e_iva,
		d_precio = t1.d_precio,
		d_procescto1 = t1.d_procescto1,
		d_poroferta = t1.d_poroferta,
		d_iva = t1.d_iva,
		d_facsiva = t1.d_facsiva,
		d_factciva = t1.d_factciva,
		total = t1.total,
		hora_resp_tandem = CURRENT_TIMESTAMP,
		tamano_archivo_respuesta = 1234
from	enc_det_ibs t1 inner join pedidos_klyns t2 on
		t2.cliente = substring(t1.cliente, 2, 5) and
		t1.codigo = t2.codigo and 
		t1.arch_tandem = t2.arch_tandem
where	t2.hash_md5 = @hash_md5
SELECT @@ROWCOUNT
drop table #consecutivo
drop table enc_det_ibs

GO
