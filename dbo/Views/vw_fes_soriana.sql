CREATE
VIEW vw_fes_soriana
AS
SELECT 
	f.sucursal,
	s.serie_cfd,
	CONVERT(VARCHAR(10),f.fecha_factura,121) fecha,
	f.folio_fiscal cfd,
	f.factura remision,
	f.cliente,
	f.codigo,
	f.descripcion,
	f.piezas_surtidas_con_cargo cant_c,
	f.piezas_surtidas_sin_cargo cant_s,
	f.precio_farm_sin_imp p_farmac,
	f.iva,
	f.importe_bruto,
	f.segto,
	f.ctepadre

FROM historica.dbo.facturacion_electronica_estandar f
INNER JOIN sucursales s ON s.sucursal = f.sucursal
WHERE segto = 'E1' AND ctepadre IN ('044','032')

GO

