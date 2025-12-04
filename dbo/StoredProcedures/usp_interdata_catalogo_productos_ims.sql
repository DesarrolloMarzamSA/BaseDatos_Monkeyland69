CREATE procedure [dbo].[usp_interdata_catalogo_productos_ims] WITH RECOMPILE
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
	   ('1416151'),
	   ('1459039'),
	   ('0862001'),
	   ('9235264'),
	   ('0172702'),
	   ('0724705'),
	   ('9200315'),
	   ('1687046'),
	   ('3500183'),
	   ('9235390'),
	   ('9237268'),
	   ('0422210'),
	   ('2670311'),
	   ('2606009'),
	   ('4000061'),
	   ('0607808'),
	   ('1648543'),
	   ('9238567'),
	   ('8702036'),
	   ('2979103'),
	   ('4100011'),
	   ('1963079'),
	   ('9240241'),
	   ('9240250'),
	   ('9241435'),
	   ('9241436'),
	   ('9241628'),
	   ('9240245'),
	   ('9240253'),
	   ('9240251'),
	   ('9240252'),
	   ('9241682'),
	   ('9241438'),
	   ('9241663'),
	   ('9240243'),
	   ('9241681'),
	   ('9241664'),
	   --cambio realizado por marodriguez
('9800002'),
('9800003'),
('9800006'),
('9800013'),
('9800017'),
('9800024'),
('9800025'),
('9800027'),
('9800028'),
('9800030'),
('9800031'),
('9800032'),
('9800034'),
('9800035'),
('9800044'),
('9800045'),
('9800047'),
('9800048'),
('9800049'),
('9800052'),
('9800053'),
('9800062'),
('9800491'),
('9800502'),
('9800507'),
('9800508'),
('9800509'),
('9800516'),
('9800525'),
('9800527'),
('9800534'),
('9800540'),
('8300001'),
('8300002'),
('8300003'),
('8300004'),
('8300005'),
('8300006'),
('8300007'),
('8300008'),
('8300009'),
('8300010'),
('8300011'),
('8300012'),
('8300013'),
('8300014'),
('8300015'),
('8300016'),
('8300017'),
('8300018'),
('8300019'),
('8300020'),
('8300021'),
('8300022'),
('8300023'),
('8300024'),
('8300025'),
('8300026'),
('8300027'),
('8300028'),
('8300029'),
('8300030'),
('8300031'),
('8300032'),
('8300033'),
('8300034'),
('8300035'),
('8300036'),
('8300037'),
('8300038'),
('8300039'),
('8300040'),
('8300041'),
('8300042'),
('8300043'),
('8300044'),
('8300045'),
('8300046'),
('8300047'),
('8300048'),
('8300049'),
('8300050'),
('8300051'),
('8300052'),
('8300053'),
('8300054'),
('8300055'),
('8300056'),
('8300057'),
('8300058'),
('8300059'),
('8300060'),
('8300061'),
('8300062'),
('8300063'),
('8300064'),
('8300065'),
('8300066'),
('8300067'),
('8300068'),
('8300069'),
('8300070'),
('8300071'),
('8300072'),
('8300073'),
('8300074'),
('8300075'),
('8300076'),
('8300077'),
('8300078'),
('8300079'),
('8300080'),
('8300081'),
('8300082'),
('8300083'),
('8300084'),
('8300085'),
('8300086'),
('8300087'),
('8300088'),
('8300089'),
('8300090'),
('8300091'),
('8300092'),
('8300093'),
('8300094'),
('8300095'),
('8300096'),
('8300097'),
('8300098'),
('8300099'),
('8300100'),
('8300101'),
('8300102'),
('8300103'),
('8300104'),
('8300105'),
('8300106'),
('8300107'),
('8300108'),
('8300109'),
('8300110'),
('8300111'),
('8300112'),
('8300113'),
('8300114'),
('8300115'),
('8300116'),
('8300117'),
('8300118'),
('8300119'),
('8300120'),
('8300121'),
('8300122'),
('8300123'),
('8300124'),
('8300125'),
('8300126'),
('8300127'),
('8300128'),
('8300129'),
('8300130'),
('8300131'),
('8300132'),
('8300133'),
('8300134'),
('8300135'),
('8300136'),
('9236743'),
('2182703'),
('0280987'),
('0280988'),
('0280989'),
('0280990'),
('0280992'),
('0280993'),
('0280995'),
('0280996'),
('0280997'),
('9236744'),
--ESaldivar  05/06/2019
('1525515'),
('4000053')
--ESaldivar 14/08/2019
,('9000035')
,('9800015')
,('9800069')
,('9800113')
,('9800114')
,('0084015')
--Esaldivar 10/09/2019
,('0931809')
,('1254301')
,('9240247')

insert into #listaProductos (codigoMarzam,descripcionProducto,clasificacionFiscal,codigoProveedor,nombreProveedor,codigoBarras,estatus,precioFarmacia,precioProveedor)
select RTRIM(pgprdc) as codigoMarzam,
	   RTRIM(pgdesc) as descripcionProducto,
	   RTRIM(pgpca5) as clasificacionFiscal,
	   RTRIM(pgpca1) as codigoProveedor,
	   RTRIM(ctpct1) as nombreProveedor,
	   RTRIM(isnull(pcxprc,'00000000000')) as codigoBarras,
	   RTRIM(PGHSTC) as estatus,
	   isnull(precioFarmacia,0) as precioFarmacia,
	   isnull(precioProveedor,0) as precioProveedor
from openquery(as400, 'select trim(pgprdc) as pgprdc, pgdesc, pgpca5, case when pgpca1='''' then PGMSUP else pgpca1 end as pgpca1, ctpct1, pcxprc,PGHSTC, PF.pssalp AS precioFarmacia, PP.pssalp as precioProveedor
from ma4620ef04.srbprg
left join ma4620ef04.srbpcr on pgprdc = pciprc and pcxrty = ''IA''
left join ma4620ef04.srbctlp1 on case when pgpca1='''' then PGMSUP else pgpca1 end = ctpca1
left join ma4620ef04.srbprs as PF on pgprdc = PF.psprdc and PF.pspril = 2 and pgdsun = PF.psunit
left join ma4620ef04.srbprs as PP on pgprdc = PP.psprdc and PP.pspril = 4 and pgdsun = PP.psunit
where pgprdc<>''.'' and pgstat<>''D'' AND PGHSTC<>''B01''
 with ur')
 where isnumeric(pgprdc)=1 AND ISNUMERIC(rtrim(ltrim(isnull(pcxprc,'00000000000'))))=1
 and substring(RTRIM(pgprdc), 1, 2) <> '99' and convert(bigint,RTRIM(pgprdc)) < 9999901
 and RTRIM(pgprdc) not between '9100000' and '9399999'

insert into #listaProductos (codigoMarzam,descripcionProducto,clasificacionFiscal,codigoProveedor,nombreProveedor,codigoBarras,estatus,precioFarmacia,precioProveedor) 
 select RTRIM(pgprdc) as codigoMarzam,
	   RTRIM(pgdesc) as descripcionProducto,
	   RTRIM(pgpca5) as clasificacionFiscal,
	   RTRIM(pgpca1) as codigoProveedor,
	   RTRIM(ctpct1) as nombreProveedor,
	   RTRIM(isnull(pcxprc,'00000000000')) as codigoBarras,
	   RTRIM(PGHSTC) as estatus,
	   isnull(precioFarmacia,0) as precioFarmacia,
	   isnull(precioProveedor,0) as precioProveedor
from openquery(as400, 'select trim(pgprdc) as pgprdc, pgdesc, pgpca5, case when pgpca1='''' then PGMSUP else pgpca1 end as pgpca1, ctpct1, pcxprc,PGHSTC, PF.pssalp AS precioFarmacia, PP.pssalp as precioProveedor
from ma4620ef04.srbprg
left join ma4620ef04.srbpcr on pgprdc = pciprc and pcxrty = ''IA''
left join ma4620ef04.srbctlp1 on case when pgpca1='''' then PGMSUP else pgpca1 end = ctpca1
left join ma4620ef04.srbprs as PF on pgprdc = PF.psprdc and PF.pspril = 2 and pgdsun = PF.psunit
left join ma4620ef04.srbprs as PP on pgprdc = PP.psprdc and PP.pspril = 4 and pgdsun = PP.psunit
 with ur') AS x
 INNER JOIN #ExcepcionCodigos as y ON x.pgprdc=y.codigoMarzam
  where isnumeric(pgprdc)=1
 
 --SELECT * FROM #listaProductos

 
 select RIGHT(REPLICATE('0',9)+ SUBSTRING(codigoMarzam,1,9) ,9)+
		LEFT(descripcionProducto+REPLICATE(' ',31),31)+
		LEFT(REPLACE (clasificacionFiscal,' ','')+ ' ',2)+
				--ISNULL(precioProveedor,precioFarmacia)
		RIGHT(REPLICATE('0',9)+CONVERT(varchar(30),CONVERT(int,CONVERT(money,
		case when precioProveedor is null then precioFarmacia
			 when precioProveedor=0 then precioFarmacia
			 else precioProveedor
		end
		*100))),9)+
		RIGHT(REPLICATE('0',4)+LEFT(isnull(codigoProveedor,''),4),4)+
		LEFT(isnull(nombreProveedor,'')+REPLICATE(' ',40),40)+
		LEFT(CONVERT(varchar(13), CONVERT(bigint,SUBSTRING(rtrim(ltrim(case when codigoBarras like '%E+%' then '00000000000' else codigoBarras end )),1,13))) + REPLICATE(' ',13),13)
 from #listaProductos
 

 -- select codigoMarzam,
	--	descripcionProducto,
	--	clasificacionFiscal,
	--	 precioProveedor,
	--	 precioFarmacia,
	--	codigoProveedor,
	--	nombreProveedor,
	--	SUBSTRING(rtrim(ltrim(codigoBarras)),1,13)
	--	--CONVERT(bigint,SUBSTRING(rtrim(ltrim(codigoBarras)),1,13))
 --from #listaProductos
-- where codigoBarras =''
 --where ISNUMERIC(codigoBarras)=0

-- Actualización de rangos 27/05/2015
--select * from #listaProductos

 drop table #listaProductos
 drop table #ExcepcionCodigos

GO

