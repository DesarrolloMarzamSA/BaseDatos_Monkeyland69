
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_genera_facturacion_electronica_fenix_reducido] @fecha varchar(10)

as
/*
exec usp_genera_facturacion_electronica_fenix_reducido '2011-02-08'
*/

declare @total_del_registro int
SELECT @total_del_registro = count(*) 
FROM facturacion_electronica_estandar fe 
INNER JOIN sucursales s								ON s.sucursal = s.sucursal
INNER JOIN maestro_productos mp	ON mp.codigo = fe.codigo 
INNER JOIN CatTiendasFenix cf					ON cf.sucursal = fe.sucursal AND cf.cliente = fe.cliente
WHERE fe.segto = 'C1' 
AND fe.ctepadre = '010' 
--AND fe.fecha_factura = CONVERT(datetime, @fecha, 121) 
AND fe.fecha_tandem = CONVERT(datetime, @fecha, 121) 


SELECT
	--LEFT(s.serie_cfd + CONVERT(varchar, CONVERT(int, fe.folio_fiscal)) + REPLICATE(' ',12), 12) +
		case 
		--la fecha esta asi por que hay facturas fiscales entregadas con FD por lo que
		--las entregas de esos dias tiene que ir con FD y no FU
		when convert(datetime, @fecha, 121)>=convert(datetime,'20130107',121)
		then left(case when s.serie_cfd='FD' then 'FU' else s.serie_cfd end + right(cast(cast(fe.folio_fiscal as int)as char(8)),8),10)
		else left(s.serie_cfd + right(cast(cast(fe.folio_fiscal as int)as char(8)),8),10)
		end	+	
	LEFT(cf.numtienda + '            ', 12) +
	CONVERT(varchar(8), fe.fecha_factura, 112) + 
	RIGHT(REPLICATE('0',13) + RTRIM(fe.cod_barras                            ),13) +
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, fe.precio_farm_sin_imp        ), 9) +
	RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, fe.piezas_surtidas_con_cargo  ), 7) + 
	RIGHT(REPLICATE(' ', 7) + CONVERT(VARCHAR, fe.piezas_surtidas_sin_cargo  ), 7) + 
	RIGHT(REPLICATE(' ', 9) + CONVERT(VARCHAR, fe.porcentaje_iva             ), 9) +
	RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, fe.porcentaje_descto_oferta   ), 6) +
	RIGHT(REPLICATE(' ', 6) + CONVERT(VARCHAR, fe.porcentaje_descto_comercial), 6) 
FROM facturacion_electronica_estandar fe	WITH (NOLOCK)
INNER JOIN sucursales s	WITH (NOLOCK)	ON s.sucursal = fe.sucursal
INNER JOIN maestro_productos mp			WITH (NOLOCK)	ON mp.codigo = fe.codigo 
INNER JOIN CatTiendasFenix cf							WITH (NOLOCK)	ON cf.sucursal = fe.sucursal AND cf.cliente = fe.cliente
WHERE fe.segto = 'C1' 
AND fe.ctepadre = '010' 
AND --fe.fecha_factura >= CONVERT(datetime, CONVERT(varchar(10), current_timestamp, 121), 121) 
fe.fecha_tandem = CONVERT(datetime, @fecha, 121)
ORDER BY cf.numtienda,fe.folio_fiscal
GO
