
CREATE procedure [dbo].[usp_interdata_catalogo_productos_cid] 
as

create table #listaProductos(
	codigoMarzam varchar(100) not null,
	descripcionProducto varchar(250) null,
	clasificacionFiscal varchar(3) null,
	codigoProveedor varchar(6) null,
	nombreProveedor varchar(250) null,
	codigoBarras varchar(250) null, 
	estatus varchar(5) null,
	precioFarmacia float null,
	precioProveedor float null
)

create table #ExcepcionCodigos(
	codigoMarzam varchar(10) not null
)

insert into #ExcepcionCodigos (codigoMarzam)
values ('9235695'),
	   ('0525242'),
	   ('0646254'),
	   ('1401201'),
	   ('1961001'),
	   ('3400680'),
	   ('3400682'),
	   ('9200177'),
	   ('9200311'),
	   ('9201206'),
	   ('9201561'),
	   ('9202097'),
	   ('9231697'),
	   ('9231701'),
	   ('9231702'),
	   ('9231703'),
	   ('9231705'),
	   ('9231706'),
	   ('9231709'),
	   ('9231711'),
	   ('9231713'),
	   ('9231715'),
	   ('9231716'),
	   ('9231717'),
	   ('9231721'),
	   ('9231722'),
	   ('9231725'),
	   ('1253945'),
	   ('2451506'),
	   ('9235695'),
	   ('1416151'),
	   ('1459039'),
	   ('0862001'),
	   ('9235264'),
	   ('0172702'),
	   ('0724705'),
	   ('9200315'),
	   ---------2020-06-30
	   ('9240243'),
	   ('9241438'),
	   ('9241663'),
	   ('9241681'),
	   ('9240241'),
	   ('9240242'),
	   ('9240245'),
	   ('9240246'),
	   ('9240247'),
	   ('9240250'),
	   ('9240252'),
	   ('9240253'),
	   ('9240254'),
	   ('9241435'),
	   ('9241436'),
	   ('9241664'),
	   ('9241682')

insert into #listaProductos (codigoMarzam,descripcionProducto,clasificacionFiscal,codigoProveedor,nombreProveedor,codigoBarras,estatus,precioFarmacia,precioProveedor)
select RTRIM(pgprdc) as codigoMarzam,
	   RTRIM(pgdesc) as descripcionProducto,
	   RTRIM(pgpca5) as clasificacionFiscal,
	   RTRIM(pgpca1) as codigoProveedor,
	   isnull(RTRIM(ctpct1),'') as nombreProveedor,
	   RTRIM(isnull(pcxprc,'00000000000')) as codigoBarras,
	   RTRIM(PGHSTC) as estatus,
	   precioFarmacia,
	   precioProveedor
from openquery(as400, 'select trim(pgprdc) as pgprdc, pgdesc, pgpca5, pgpca1, ctpct1, pcxprc,PGHSTC, PF.pssalp AS precioFarmacia, PP.pssalp as precioProveedor
from ma4620ef04.srbprg
left join ma4620ef04.srbpcr on pgprdc = pciprc and pcxrty = ''IA''
left join ma4620ef04.srbctlp1 on pgpca1 = ctpca1
left join ma4620ef04.srbprs as PF on pgprdc = PF.psprdc and PF.pspril = 2 and pgdsun = PF.psunit
left join ma4620ef04.srbprs as PP on pgprdc = PP.psprdc and PP.pspril = 4 and pgdsun = PP.psunit
where pgprdc<>''.'' and pgstat<>''D''
 with ur')
 
 select RIGHT(REPLICATE('0',9)+ SUBSTRING(codigoMarzam,1,9) ,9)+
		LEFT(descripcionProducto+REPLICATE(' ',31),31)+
		LEFT(REPLACE (clasificacionFiscal,' ','')+ ' ',2)+
		RIGHT(REPLICATE('0',9)+CONVERT(varchar(30),CONVERT(int,CONVERT(money,ISNULL(precioProveedor,precioFarmacia)*100))),9)+
		RIGHT(REPLICATE('0',4)+LEFT(codigoProveedor,4),4)+
		LEFT(nombreProveedor+REPLICATE(' ',40),40)+
		LEFT(CONVERT(varchar(13), CONVERT(bigint,SUBSTRING(rtrim(ltrim(codigoBarras)),1,13))) + REPLICATE(' ',13),13)
 from(
 select codigoMarzam,descripcionProducto,clasificacionFiscal,codigoProveedor,nombreProveedor,codigoBarras,estatus,precioFarmacia,precioProveedor
 from #listaProductos
 where ISNUMERIC(rtrim(ltrim(codigoMarzam)))=1 and ISNUMERIC(rtrim(ltrim(codigoBarras)))=1 and
 --PATINDEX('%[^0-9]%', codigoBarras) = 0  and  -- te busca que solo tenga numeros pero de origen tiene espacios que hay que tomar en cuenta
 estatus <> 'B01' 
 --and LEN(codigoMarzam)<=7
    and substring(codigoMarzam, 1, 2) <> '99' --and convert(bigint,codigoMarzam) < 9999901
	and codigoMarzam not between '9100000' and '9399999' -- Actualización de rangos 27/05/2015
union
select lp.codigoMarzam,descripcionProducto,clasificacionFiscal,codigoProveedor,nombreProveedor,codigoBarras,estatus,precioFarmacia,precioProveedor
 from #listaProductos as lp
inner join #ExcepcionCodigos as e on lp.codigoMarzam= e.codigoMarzam) as  x
where --LEN(codigoBarras)<=13 and 
codigoBarras<>'00000000000' --No hay codigo de barras en el layout

 drop table #listaProductos
 drop table #ExcepcionCodigos


/*
select	right(replicate('0', 9) + t1.codigo, 9) +
			left(t1.descripcion + replicate(' ', 31), 31) +
			left(replace(t1.clas_fis, ' ', '') + '  ', 2) +
			--right(replicate('0', 9) + convert(varchar(30), convert(int, convert(money, t1.prec_farm) * 100)), 9) +
			right(replicate('0', 9) + convert(varchar(30), convert(int, convert(money, isnull(isnull(t2.precio, t1.prec_farm), 0)) * 100)), 9) +
			right(replicate('0', 4) + left(t1.cod_lab, 4), 4) +
			left(t1.lab_largo + replicate(' ', 40), 40) + left(t1.cod_barras + replicate(' ', 13), 13) -- Adicion de código de barras 27/06/2016
from		maestro_productos_baan t1 left join precios_merck t2 on 
			t1.codigo = t2.codigo
where	t1.status <> 'B01' and 
			convert(bigint, t1.codigo) < 9999901 and
			substring(t1.codigo, 1, 2) <> '99' 
	and t1.codigo not between '9100000' and '9102241' -- Actualización de rangos 09/11/2015
	and t1.codigo not in ('9102246', '9102252') -- Actualización de rangos 09/11/2015
	and t1.codigo not between '9102257' and '9230740' -- Actualización de rangos 09/11/2015
	and t1.codigo not between '9230742' and '9231569' -- Actualización de rangos 09/11/2015
	and t1.codigo not between '9231572' and '9399999' -- Actualización de rangos 09/11/2015
	union
select right(replicate('0', 9) + pgprdc, 9) +
	left(pgdesc + replicate(' ', 31), 31) +
	left(replace(pgpca5, ' ', '') + '  ', 2) +
	right(replicate('0', 9) + convert(varchar(30), convert(int, convert(money, isnull(isnull(pssalp, pssalp), 0)) * 100)), 9) +
	right(replicate('0', 4) + left(pgpca1, 4), 4) +
	left(ctpct1 + replicate(' ', 40), 40) +
	left(pcxprc + replicate(' ', 13), 13)
from openquery(as400, 'select trim(pgprdc) as pgprdc, pgdesc, pgpca5, pssalp, pgpca1, ctpct1, pcxprc
from ma4620ef04.srbprg
inner join ma4620ef04.srbprs
on pgprdc = psprdc
and pspril = 2
and pgdsun = psunit
left join ma4620ef04.srbctlp1
on pgpca1 = ctpca1
left join ma4620ef04.srbpcr
on pgprdc = pciprc
and pcxrty = ''IA''
where pgprdc in (''9102275'', ''9102276'', ''9102277'', ''9102278'', ''9102279'', ''9102280'', ''9102281'', ''9102282'', ''9102283'', ''9102284'', ''9102286'', ''9102287'', ''9102288'', ''9102289'', ''9102290'', ''9102291'', ''9102292'',  ''9102293'', ''9102294'', ''9102295'', ''9230740'', ''9231121'', ''9231603'', ''9231604'', ''9231605'', ''9231606'', ''9231607'', ''9231611'', ''9235101'',''9200315'',''9232846'',''9236743'',''9236744'') with ur')
*/

GO

