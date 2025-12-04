-- =============================================
-- Author:		<Abraham Marcelino Ramirez Vega>
-- Create date: <2019/02/25>
-- Description:	<Obtener datos de facturacion farmacias ahorro filiales>
-- =============================================
CREATE PROCEDURE spr_ObtenerDatosFacturasAhorroFiliales 
@fechaInicio as datetime,
@fechaFin as datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select sucursal
,cliente
,digito_verificador
,serie
,factura
,fecha_factura
,codigo
,descripcion
,cod_barras
,clas_fis
,piezas_surtidas_con_cargo
,piezas_surtidas_sin_cargo
,precio_farm_sin_imp
,precio_pub_sin_imp
,precio_pub_con_imp
,importe_bruto
,porcentaje_descto_oferta
,descto_oferta
,porcentaje_descto_comercial
,descto_comercial
,ieps
,iva
,bonificacion_iva
,porcentaje_utilidad
,importe_neto
,orden
,porcentaje_iva
,filler
,no_registro
,desc_comerc_prod
,porcentaje_iva2
,iva2
,bonificacion_iva2
,porcentaje_ieps
,desc_comerc_ieps
,iva_del_iesps
,bonificacion_iva_del_iesps
,timestamp
,segto
,ctepadre
,rfc
,tipo_documento
,folio_fiscal
,fecha_tandem
 from facturacion_electronica_estandar
 where ctepadre = '008' and timestamp between @fechaInicio and @fechaFin

END

GO

