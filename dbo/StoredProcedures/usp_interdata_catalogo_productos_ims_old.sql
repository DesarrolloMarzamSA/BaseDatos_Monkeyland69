CREATE procedure [dbo].[usp_interdata_catalogo_productos_ims_old]WITH RECOMPILE
as
select	right(replicate('0', 9) + t1.codigo, 9) +
			left(t1.descripcion + replicate(' ', 31), 31) +
			left(replace(t1.clas_fis, ' ', '') + '  ', 2) +
			right(replicate('0', 9) + convert(varchar(30), convert(int, convert(money, t1.prec_farm) * 100)), 9) +
			--right(replicate('0', 9) + convert(varchar(30), convert(int, convert(money, isnull(t2.precio, t1.prec_farm)) * 100)), 9) +
			right(replicate('0', 4) + left(t1.cod_lab, 4), 4) +
			left(t1.lab_largo + replicate(' ', 40), 40) +
			left(convert(varchar(13), convert(bigint, t1.cod_barras)) + replicate(' ', 13), 13)
			--convert(bigint, t1.cod_barras)
			--t1.codigo, t1.descripcion, t1.clas_fis, t2.precio, t1.prec_farm, t1.cod_lab, t1.lab_largo, t1.cod_barras
from		maestro_productos_baan t1 left outer join precios_merck t2 on 
			t1.codigo = t2.codigo
/* where t1.codigo not between '9100233' and '9100566'
and t1.codigo not between '9230000' and '9230500' */
where	substring(t1.codigo, 1, 2) <> '99' and
			t1.status <> 'B01'
			and convert(bigint, t1.codigo) < 9999901
	and prec_farm is not null
	and t1.codigo not between '9100000' and '9399999' -- Actualización de rangos 27/05/2015
	and PATINDEX('%[^0-9]%', t1.cod_barras) = 0 -- Algunos ean traen una "D"!! cambio 03/02/2015 y marca error en el convert
	union
select right(replicate('0', 9) + pgprdc, 9) +
	left(pgdesc + replicate(' ', 31), 31) +
	left(replace(pgpca5, ' ', '') + '  ', 2) +
	right(replicate('0', 9) + convert(varchar(30), convert(int, convert(money, isnull(isnull(pssalp, pssalp), 0)) * 100)), 9) +
	right(replicate('0', 4) + left(pgpca1, 4), 4) +
	left(ctpct1 + replicate(' ', 40), 40) +
	isnull(left(pcxprc + replicate(' ', 13), 13), '0000000000000')
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
where pgprdc in (''0525242'', ''0646254'', ''1401201'', ''1961001'', ''3400680'',''3400682'',''9200177'',''9200311'',''9201206'',''9201561'',''9202097'',''9231697'',''9231701'',''9231702'',''9231703'',''9231705'',''9231706'',''9231709'',''9231711'',''9231713'',''9231715'',''9231716'',''9231717'',''9231721'',''9231722'',''9231725'',''1253945'',''2451506'',''9235695'',''1416151'',''1459039'',''0862001'',''9235264'',''0172702'',''0724705'') with ur')

GO

