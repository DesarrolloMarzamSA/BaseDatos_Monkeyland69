--[usp_sanborns_cfd] '2018-05-01'
CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_sanborns_cfd]	@fecha VARCHAR(10)
AS
--	DECLARE @fecha VARCHAR(10)
--	SET @fecha = '2011-02-09'

/*
EXECUTE usp_sanborns_cfd '2018-07-19'; 
*/
begin
SELECT e.sucursal																	, 	
	e.cliente																		,
	--CASE WHEN e.fechaprog < s.fecha_ibs THEN s.serie_cfd_old ELSE	s.serie_cfd	END		serie_cfd,
	e.serie as serie_cfd,
	e.fechaprog																	,
	e.folio_fiscal															, 
	e.factura Remision																																	,	
	ISNULL(e.importe		, 0) importe_bruto			,
	ISNULL(b.confirmada	, 0) confirmada,
	e.filler as FacturaIBS,
	convert(varchar,e.fechaprog,111) as ruta--,	b.msg_error		
FROM Historica.dbo.encabezado e										WITH (NOLOCK)
LEFT OUTER JOIN bitacora_sanborns_cfd b WITH (NOLOCK) ON 
	b.sucursal = e.sucursal AND b.folio_fiscal = e.folio_fiscal 
WHERE 
	e.fechaprog	>= CONVERT(DATETIME,getdate()-60,121)	AND 
	e.ctepadre = '041' and (ISNULL(b.confirmada,0)=0 or isnull(b.msg_error,'') like '%9.- No Existe Archivo%')
ORDER BY e.fechaprog DESC
  end

GO

