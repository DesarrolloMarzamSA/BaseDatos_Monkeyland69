
CREATE	--CREATE
VIEW [dbo].[vw_encabezado_soriana]
AS
SELECT --TOP 1000
	e.sucursal,
	s.serie_cfd,
	CONVERT(VARCHAR(10),e.fechaprog,121) fecha,
	e.folio_fiscal cfd,
	e.factura remision,
	e.cliente,
	e.farmacia,
	b.tienda,
	b.folio_entrada,
	e.orden,
	b.confirmada,
	b.intento,
--	f.codigo,
--	f.descripcion,
	--f.piezas_surtidas_con_cargo cant_c,
	--f.piezas_surtidas_sin_cargo cant_s,
	--f.precio_farm_sin_imp p_farmac,
	--f.iva,
--	SUM(f.importe_bruto),
--	e.segto,
	e.ctepadre,	--b.archivo
	CASE 
		WHEN b.msg_error like '%El Folio NE No ha sido Recibido%'				THEN 'NE No Recibida'
		WHEN b.msg_error like '%La fecha de la remisión no es válida%'	THEN 'Fecha Remisión'
		--ELSE ''
	END problema

FROM historica.dbo.encabezado e
--historica.dbo.facturacion_electronica_estandar f
INNER JOIN sucursales s ON s.sucursal = e.sucursal
LEFT OUTER JOIN bitacora_soriana_cfd b ON b.sucursal = e.sucursal AND b.folio_fiscal = CONVERT(INT,e.folio_fiscal)
LEFT OUTER JOIN cfd_soriana_acuses_de_recibo a ON a.serie_cfd = s.serie_cfd AND a.folio_fiscal = CONVERT(INT,e.folio_fiscal)
WHERE 
	e.segto = 'E1' AND e.ctepadre IN ('044','032') 
	AND	e.fechaprog >= CONVERT(DATETIME,'2010-04-01',121) 
--	AND b.intento = 0

GO

