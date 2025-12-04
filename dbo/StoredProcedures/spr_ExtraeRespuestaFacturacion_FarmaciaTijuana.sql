-- =============================================
-- Author:		<Author,,Name>
-- Create date: <12-08-2019>
-- Description:	<Realiza la extraccion del layout de respuestas para farmacias tijuana
-- =============================================
--select * from parametros_fact_elec_estandar where cliente like '%tijuana%'
--[spr_ExtraeRespuestaFacturacion_FarmaciaTijuana] 25
CREATE PROCEDURE [dbo].[spr_ExtraeRespuestaFacturacion_FarmaciaTijuana] 
	@sucursal int=0,@fechaFactura date = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
     

IF( @fechaFactura is not null )
BEGIN

SELECT        RIGHT('00' + CONVERT(varchar(2), t1.sucursal), 2) + t1.cliente + t1.digito_verificador + CASE WHEN t1.folio_fiscal IS NULL THEN t1.serie + LEFT(RIGHT(t1.factura, 7) + '          ', 9) ELSE LEFT(t2.serie_cfd + CONVERT(varchar(8), 
                         CONVERT(bigint, t1.folio_fiscal)) + '          ', 10) END + CONVERT(varchar(8), t1.fecha_factura, 112) + '00' + t1.codigo + LEFT(t1.descripcion + '                                        ', 40) + LEFT(t3.cod_barras_tandem + '             ', 13) 
                         + LEFT(t1.clas_fis + '  ', 2) + RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_con_cargo), 7) + RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_sin_cargo), 7) 
                         + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_farm_sin_imp), 10) + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_sin_imp), 10) + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_con_imp), 
                         10) AS primera_parte
						 ,RIGHT('0000000000000' + CONVERT(varchar(13), t1.importe_bruto), 13) + RIGHT('000000' + CONVERT(varchar(10), t1.porcentaje_descto_oferta), 6) + RIGHT('0000000000000' + CONVERT(varchar(13), 
                         t1.descto_oferta), 13) + RIGHT('000000' + CONVERT(varchar(10), t1.porcentaje_descto_comercial), 6) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.descto_comercial), 13) 
                         + RIGHT('0000000000000' + CONVERT(varchar(13), t1.ieps), 13) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.iva), 13) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.bonificacion_iva), 13) 
                         + RIGHT('00000' + CONVERT(varchar(5), CASE WHEN t1.porcentaje_utilidad < 0 THEN 0 ELSE t1.porcentaje_utilidad END), 5) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.importe_neto), 13) 
                         + RIGHT('000000000' + REPLACE(t1.orden, ' ', ''), 9) + RIGHT('000000' + CONVERT(varchar(6), t1.porcentaje_iva), 6) + RIGHT('0000000000' + CONVERT(varchar(10), t1.importe_neto / t1.piezas_surtidas_con_cargo), 10)+isnull(t4.CEUUID,'') 
                         AS segunda_parte						 
FROM            dbo.facturacion_electronica_estandar AS t1 INNER JOIN
                         dbo.sucursales AS t2 ON t1.sucursal = t2.sucursal INNER JOIN
                         dbo.maestro_productos AS t3 ON t1.codigo = t3.codigo left join 
[dbo].[uuid_facturacion] as t4 on t1.folio_fiscal=RIGHT('00000000' + CONVERT(varchar(8), CEINVN), 8) and t1.serie=rtrim(t4.CESERI)
where t1.ctepadre='586'and t1.fecha_factura = @fechaFactura 

END

ELSE
BEGIN
SELECT   t1.sucursal,t1.cliente,     RIGHT('00' + CONVERT(varchar(2), t1.sucursal), 2) + t1.cliente + t1.digito_verificador + CASE WHEN t1.folio_fiscal IS NULL THEN t1.serie + LEFT(RIGHT(t1.factura, 7) + '          ', 9) ELSE LEFT(t2.serie_cfd + CONVERT(varchar(8), 
                         CONVERT(bigint, t1.folio_fiscal)) + '          ', 10) END + CONVERT(varchar(8), t1.fecha_factura, 112) + '00' + t1.codigo + LEFT(t1.descripcion + '                                        ', 40) + LEFT(t3.cod_barras_tandem + '             ', 13) 
                         + LEFT(t1.clas_fis + '  ', 2) + RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_con_cargo), 7) + RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_sin_cargo), 7) 
                         + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_farm_sin_imp), 10) + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_sin_imp), 10) + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_con_imp), 
                         10) +
						 RIGHT('0000000000000' + CONVERT(varchar(13), t1.importe_bruto), 13) + RIGHT('000000' + CONVERT(varchar(10), t1.porcentaje_descto_oferta), 6) + RIGHT('0000000000000' + CONVERT(varchar(13), 
                         t1.descto_oferta), 13) + RIGHT('000000' + CONVERT(varchar(10), t1.porcentaje_descto_comercial), 6) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.descto_comercial), 13) 
                         + RIGHT('0000000000000' + CONVERT(varchar(13), t1.ieps), 13) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.iva), 13) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.bonificacion_iva), 13) 
                         + RIGHT('00000' + CONVERT(varchar(5), CASE WHEN t1.porcentaje_utilidad < 0 THEN 0 ELSE t1.porcentaje_utilidad END), 5) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.importe_neto), 13) 
                         + RIGHT('000000000' + REPLACE(t1.orden, ' ', ''), 9) + RIGHT('000000' + CONVERT(varchar(6), t1.porcentaje_iva), 6) + RIGHT('0000000000' + CONVERT(varchar(10), t1.importe_neto / t1.piezas_surtidas_con_cargo), 10)+isnull(t4.CEUUID,'') 
                         AS factura						 
FROM            dbo.facturacion_electronica_estandar AS t1 INNER JOIN
                         dbo.sucursales AS t2 ON t1.sucursal = t2.sucursal INNER JOIN
                         dbo.maestro_productos AS t3 ON t1.codigo = t3.codigo left join 
[dbo].[uuid_facturacion] as t4 on t1.folio_fiscal=RIGHT('00000000' + CONVERT(varchar(8), CEINVN), 8) and t1.serie=rtrim(t4.CESERI)
where t1.ctepadre='586' and convert(varchar(12),t1.fecha_factura,112) >=convert(varchar(12),getdate()-1,112) and t1.sucursal=@sucursal

END

END

GO

