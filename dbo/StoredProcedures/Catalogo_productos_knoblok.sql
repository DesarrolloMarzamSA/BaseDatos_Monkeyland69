create PROCEDURE [dbo].[Catalogo_productos_knoblok]
AS


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
select *
from openquery(as400, 'select trim(pgprdc) as pgprdc, pgdesc, pgpca5, pgpca1, ctpct1, pcxprc,PGHSTC, PF.pssalp AS precioFarmacia, PP.pssalp as precioProveedor
from ma4620ef04.srbprg
left join ma4620ef04.srbpcr on pgprdc = pciprc and pcxrty = ''IA''
left join ma4620ef04.srbctlp1 on pgpca1 = ctpca1
left join ma4620ef04.srbprs as PF on pgprdc = PF.psprdc and PF.pspril = 2 and pgdsun = PF.psunit
left join ma4620ef04.srbprs as PP on pgprdc = PP.psprdc and PP.pspril = 4 and pgdsun = PP.psunit
where pgprdc<>''.'' and pgstat<>''D''
 with ur')
 
 select *
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

GO

