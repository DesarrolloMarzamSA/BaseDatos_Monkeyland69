
CREATE PROCEDURE [dbo].[usp_genera_ofertas_farmacias_torres] as
declare @sep varchar(1)
set @sep = '|'

/*
UPDATE cat_productos_torres SET cod_mar = mpb.codigo FROM cat_productos_torres tor
inner join maestro_productos_baan mpb on mpb.cod_barras = tor.cod_barras
*/

SELECT 
  'P00002'					Mayorista,									--		1
  'D'								Ident,											--		2
  tor.cod_barras,																--		3
  tor.cod_torres,																--		4
  cliente sucursal,      --	'19130'							--		5
  porcentaje				Porc_Ofert,									--		6
  (CASE mpb.grupo_est 
		WHEN 'PC01A' THEN mpb.prec_farm + (mpb.prec_farm * 0.5) 
		ELSE mpb.prec_farm END) prec_farm,					--		7
	mpb.descto				Descto,											--		8
  mpb.prec_farm		P_Costo,											--		9
  mpb.iva						IVA,												--		10
	tor.unidad				Unidad,											--		11
  piezas						Disponible,									--		12
  bolsa,																				--		13
	cliente
INTO #ofertas_torres
FROM dboferta ofe
INNER JOIN inventario_baan ib ON ib.sucursal = ofe.sucursal and ib.codigo = ofe.codigo and ib.piezas > 0
INNER JOIN cat_productos_torres   tor ON tor.cod_mar  = ofe.codigo
INNER JOIN maestro_productos_baan mpb ON mpb.codigo   = ofe.codigo
LEFT OUTER JOIN clientes_baan					cb	ON cb.sucursal	=	ofe.sucursal --	AND cb.segto = 'C2' AND cb.ctepadre = '424'
and cb.cliente in ('19130','04820'
,'19140','19150','19160','19170','19180','19190',
'19200','19760','20380','20870','20880','20890','28640','29380',
'34360','34930','35670','37730','38340','38350','40090','43340',
'46430','47060','47430','47860','49310','49320','63900','63910',
'65850','66270','66520','66630','66720')

WHERE ofe.bolsa = 'LIBRE' AND ofe.sucursal = 1 and
convert(int, mpb.codigo) < dbo.gobierno() and
 substring(mpb.status, 1, 1) <> 'B' 


ORDER by tor.cod_torres


set @sep = ''

SELECT
  LEFT (mayorista  + REPLICATE(' ',10),10) + @sep +																										  ident + @sep +																																					  LEFT (cod_barras + REPLICATE(' ',15),15) + @sep +																				  LEFT (cod_torres + REPLICATE(' ',20),20) + @sep +																				  LEFT (sucursal   + REPLICATE(' ',55),55) + @sep +																				  RIGHT(REPLICATE('0', 4) + CONVERT(varchar,convert(int,porc_ofert	* 100)),4) + @sep +		  RIGHT(REPLICATE(' ', 8) + CONVERT(varchar,convert(int,prec_farm		* 100)),8) + @sep +		  RIGHT(REPLICATE(' ', 8) + CONVERT(varchar,convert(int,descto			* 100)),8) + @sep +		  RIGHT(REPLICATE(' ', 8) + CONVERT(varchar,convert(int,p_costo			* 100)),8) + @sep +		  RIGHT(REPLICATE('0', 2) + CONVERT(varchar,convert(int,iva					* 100)),2) + @sep +		  unidad,																																									  disponible,																																							  bolsa,																																											cliente

FROM #ofertas_torres 

drop table #ofertas_torres

GO

