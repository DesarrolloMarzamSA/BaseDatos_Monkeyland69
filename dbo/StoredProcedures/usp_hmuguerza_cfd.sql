
CREATE	--	CREATE
PROCEDURE	[dbo].[usp_hmuguerza_cfd] 
@fecha VARCHAR(10)
AS

/*
EXECUTE	usp_hmuguerza_cfd '2014-10-01'
*/

SELECT	e.sucursal,
		e.cliente,
		e.serie as serie_cfd,
		e.folio_fiscal,
		e.fechaprog,
		e.farmacia,
		e.orden	,				
		e.noalta as clienteIBS,
		ltrim(rtrim(c.NATREG))rfc,
		convert(varchar,e.fechaprog,111) as ruta,
		b.archivo_xml
FROM Historica.dbo.encabezado e WITH (NOLOCK)
inner join monkeyland.dbo.sronam c on e.noalta=ltrim(rtrim(c.NANUM))
left join monkeyland.dbo.bitacora_muguerza_cfdi b on ltrim(rtrim(b.serie_cfd))=e.serie and ltrim(rtrim(b.folio_fiscal))=e.folio_fiscal
WHERE 	e.ctepadre = '341' AND	e.fechaprog >= CONVERT(SMALLDATETIME,getdate()-30,121) and b.archivo_xml is null

GO

