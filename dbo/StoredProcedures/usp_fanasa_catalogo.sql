
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
--select * from clientes_baan where ctepadre=496 --farmacia like'%NAC%' and sucursal=1 ORDER BY farmacia
CREATE --create --drop
procedure [dbo].[usp_fanasa_catalogo]

as 
select 
	'0001'																		AS	zona,
	LEFT(CONVERT(varchar,convert(bigint,fc.codigo_barras)) + REPLICATE(' ',20),20)	as cod_barras,
	LEFT(isnull(pibs.descripcion,' ') + REPLICATE(' ',50) ,50)									as descripcion,
    RIGHT(REPLICATE('0',10) + CONVERT(varchar,convert(decimal(12,4),isnull(pibs.prec_farm,0))),10) as pre,
	RIGHT(REPLICATE('0',5) + CONVERT(varchar,convert(money,fc.desc_oferta)),5) as oferta,
	RIGHT(REPLICATE('0',5) + CONVERT(varchar,convert(money,fc.desc_financiero)),5)  as descto_prod,
	'00.00' as desc_especial,	
	case when pibs.existencias>0 then 1 else 0 end as existencia,
	case when pibs.iva>0 then 1 else 0 end as iva,	
   	REPLICATE(' ',10) as espacios
 from fanasa_catalogo_manual fc
inner join 
--openquery(as400,'
--SELECT PRG.PGPRDC codigo,PRG.PGDESC descripcion,
--case 
----SE MODIFICA PARA CLASIFICACION FISCAL NUEVA F,FA FEE FOR SERVICE
----when PRG.PGPCA5 not in(''BA'',''HA'',''NA'') THEN ''1''
--when PRG.PGPCA5 not in(''BA'',''HA'',''NA'',''FA'') THEN ''1''
--ELSE ''0''
--END iva,
--SUM(SRO.SRSTHQ) existencias,PRS.PSSALP prec_farm,
--(select CPRS.PSSALP from MA4620EF04.SR4PRS as CPRS where PRG.PGPRDC=CPRS.PSPRDC and CPRS.PSPRIL=''03'') prec_max
--from MA4620EF04.SROPRG AS PRG
--INNER JOIN MA4620EF04.SR4PRS AS PRS ON PRG.PGPRDC=PRS.PSPRDC
--INNER JOIN MA4620EF04.SRBSRO AS SRO ON PRG.PGPRDC=SRO.SRPRDC
--WHERE PRG.PGSTAT<> ''D'' and PRS.PSPRIL=''02'' GROUP BY PRG.PGPRDC,PRG.PGDESC,PRG.PGPCA5,PRS.PSSALP
--') pibs
openquery(as400,'
SELECT PRG.PGPRDC codigo,PRG.PGDESC descripcion,
case
when PRG.PGPCA5 not in(''BA'',''HA'',''NA'',''FA'') THEN ''1''
ELSE ''0''
END iva,
SUM(SRO.SRSTHQ) existencias,PRS.PSSALP prec_farm,
CPRS.PSSALP AS prec_max
from MA4620EF04.SROPRG AS PRG
INNER JOIN MA4620EF04.SR4PRS AS PRS ON PRG.PGPRDC=PRS.PSPRDC
INNER JOIN MA4620EF04.SRBSRO AS SRO ON PRG.PGPRDC=SRO.SRPRDC
INNER JOIN MA4620EF04.SR4PRS as CPRS ON PRG.PGPRDC=CPRS.PSPRDC and CPRS.PSPRIL=''03'' 
WHERE PRG.PGSTAT<> ''D'' and PRS.PSPRIL=''02'' GROUP BY PRG.PGPRDC,PRG.PGDESC,PRG.PGPCA5,PRS.PSSALP,CPRS.PSSALP
') pibs
on right(REPLICATE('0',7) + CONVERT(varchar,fc.codigo),7) = pibs.codigo

exec actualiza_cat_ean_prg

GO
