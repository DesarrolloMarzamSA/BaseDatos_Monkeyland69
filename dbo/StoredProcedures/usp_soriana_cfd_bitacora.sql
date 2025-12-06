
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE --CREATE
PROCEDURE [dbo].[usp_soriana_cfd_bitacora]
--@sucursal INT, 
@fecha VARCHAR(10), @confirmadas INT 
WITH ENCRYPTION
AS
/*
usp_soriana_cfd_bitacora '2010-12-09', 0--	1, 
*/
SELECT
--	b.fecha							,
	--b.sucursal					,
	b.serie_cfd					,
	b.folio_fiscal			,
	b.remision					,
	s.letra							,
	b.cliente						,
	b.importe						,
	b.tienda						,
	b.mostrador					,
	b.folio_entrada			,
	CASE WHEN b.confirmada = 1 THEN 'Enviada' ELSE 'Pendiente' END confirmada				,
	b.confirmacion			,
	b.registro					,
	b.intento						,
	b.msg_error					
FROM bitacora_soriana_cfd b with(nolock) 
INNER JOIN sucursales s with(nolock) ON s.sucursal  = b.sucursal
--LEFT OUTER JOIN CatTiendasSoriana s ON s.sucursal = cb.sucursal AND s.cliente = cb.cliente
WHERE
--	b.sucursal = @sucursal	AND
	b.fecha = CONVERT(DATETIME,@fecha,121)
	AND b.confirmada = @confirmadas

ORDER BY b.serie_cfd, folio_fiscal

--CREATE INDEX idx_bitacora_soriana_cfd_fecha ON bitacora_soriana_cfd (fecha)
GO
