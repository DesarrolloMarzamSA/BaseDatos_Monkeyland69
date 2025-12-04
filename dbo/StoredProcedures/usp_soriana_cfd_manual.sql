CREATE
--CREATE
PROCEDURE [dbo].[usp_soriana_cfd_manual]
--	[usp_soriana_cfd_manual] '2013-01-25','2013-01-25','FM','' 
@fecha VARCHAR(10),@fechaFin VARCHAR(10),@serie varchar(2)='',@mensaje varchar(100)='' 
AS

SELECT distinct fecha							,
	e.IATA						,
	b.sucursal				, 
	case when b.serie_cfd='FD' THEN 'FU' ELSE b.serie_cfd end	as serie_cfd,
	b.folio_fiscal		,
	b.remision				,
	b.cliente					,
	e.rfc							,
	ISNULL(a.folio_acuse, b.folio_entrada)			folio_acuse				,	
	ISNULL(b.tienda, 0)	numTienda,
	mostrador	farmacia				,
	ISNULL(pedido,0)	orden,	
	0																					porc_iva					,
	0																					porc_ieps					,
	0																					piezas						,
	ISNULL(b.importe,0)												importe_bruto			,
	0																					iva								,
	0																					ieps							,
	importe																		importe_neto			,
	confirmada,
	confirmacion,
	archivo,
	b.msg_error,
	a.usr			,
	b.intento	,
	a.documento_soriana
		
FROM bitacora_soriana_cfd b		WITH (NOLOCK)
INNER JOIN encabezado_soriana e		WITH (NOLOCK)
	ON e.sucursal = b.sucursal AND e.folio_fiscal = b.folio_fiscal
LEFT OUTER JOIN 
cfd_soriana_acuses_de_recibo a	WITH (NOLOCK) 
	ON  a.folio_fiscal = b.folio_fiscal
WHERE
	(confirmada = 0 
	OR confirmada IS NULL 
	OR a.usr = 'OHB' 
	)	and b.fecha between  @fecha and @fechaFin 
	and b.msg_error not in ('ACCEPTED')
		and
	( ( folio_acuse > 0 OR folio_acuse IS NOT NULL )
	OR (folio_entrada > 1 AND folio_entrada IS NOT NULL ) ) 
	and b.serie_cfd like '%'+@serie+'%' and b.msg_error like '%'+@mensaje+'%' ORDER BY folio_acuse DESC

GO

