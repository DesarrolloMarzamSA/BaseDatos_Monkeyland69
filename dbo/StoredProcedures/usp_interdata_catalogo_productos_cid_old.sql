
CREATE procedure [dbo].[usp_interdata_catalogo_productos_cid_old] 
as
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

GO

