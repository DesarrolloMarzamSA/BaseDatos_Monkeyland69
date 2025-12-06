
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE	--	CREATE	--	DROP
PROCEDURE [dbo].[usp_lab_sanofi_poblar_fe]
	--@sucursal INT,	
	@fecha VARCHAR(10)

AS

/*
execute usp_lab_sanofi_poblar_fe '2011-11-01'
*/

IF(SELECT COUNT(*) FROM lab_sanofi_fes WHERE fecha_factura = CONVERT(date, @fecha, 121) )= 0

BEGIN
	INSERT INTO lab_sanofi_fes 	(
		sucursal,
		cliente,
		--digito_verificador,
		--serie,
		factura,
		fecha_factura,
		codigo,
		descripcion,
		cod_barras,
		--clas_fis,
		piezas_surtidas_con_cargo,
		piezas_surtidas_sin_cargo,
		precio_farm_sin_imp,
		--precio_pub_sin_imp,
		--precio_pub_con_imp,
		importe_bruto,
		--porcentaje_descto_oferta,
		--descto_oferta,
		--porcentaje_descto_comercial,
		descto_comercial,
		--ieps,
		iva,
		bonificacion_iva,
		porcentaje_utilidad,
		importe_neto,
		orden,
		--porcentaje_iva,
		--filler,
		no_registro,
		desc_comerc_prod,
		--porcentaje_iva2,
		--iva2,
		--bonificacion_iva2,
		--porcentaje_ieps,
		--desc_comerc_ieps,
		--iva_del_iesps,
		--bonificacion_iva_del_iesps,
		TIMESTAMP,
		segto,
		ctepadre,
		rfc,
		--tipo_documento,
		folio_fiscal 
	)
	SELECT 
		fe.sucursal,
		fe.cliente,
		--fe.digito_verificador,
		--fe.serie,
		fe.factura,
		fe.fecha_factura,
		fe.codigo,
		fe.descripcion,
		fe.cod_barras,
		--fe.clas_fis,
		fe.piezas_surtidas_con_cargo,
		fe.piezas_surtidas_sin_cargo,
		fe.precio_farm_sin_imp,
		--fe.precio_pub_sin_imp,
		--fe.precio_pub_con_imp,
		fe.importe_bruto,
		--fe.porcentaje_descto_oferta,
		--fe.descto_oferta,
		--fe.porcentaje_descto_comercial,
		fe.descto_comercial,
		--fe.ieps,
		fe.iva,
		fe.bonificacion_iva,
		fe.porcentaje_utilidad,
		fe.importe_neto,
		fe.orden,
		--fe.porcentaje_iva,
		--fe.filler,
		fe.no_registro,
		fe.desc_comerc_prod,
		--fe.porcentaje_iva2,
		--fe.iva2,
		--fe.bonificacion_iva2,
		--fe.porcentaje_ieps,
		--fe.desc_comerc_ieps,
		--fe.iva_del_iesps,
		--fe.bonificacion_iva_del_iesps,
		fe.TIMESTAMP,
		fe.segto,
		fe.ctepadre,
		fe.rfc,
		--fe.tipo_documento,
		fe.folio_fiscal 
	FROM facturacion_electronica_estandar fe WITH (NOLOCK)
	INNER JOIN lab_sanofi_cat_productos ps WITH (NOLOCK) ON ps.codigo = fe.codigo
	WHERE fe.fecha_factura = CONVERT(DATE, @fecha, 121)
END

--SELECT TOP 10 * FROM facturacion_electronica_estandar

--SELECT * FROM fes_sanofi

/*
SELECT fecha_factura, COUNT(*) 
FROM fes_sanofi with (nolock)
GROUP BY fecha_factura 
ORDER BY fecha_factura 
*/

SELECT CONVERT(VARCHAR, 
(SELECT COUNT(*) FROM fes_sanofi WHERE fecha_factura = CONVERT(date, @fecha, 121))
) + ' LINEAS INSERTADAS DEL DIA '+ @fecha
GO
