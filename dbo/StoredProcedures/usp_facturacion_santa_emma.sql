-- =============================================
-- Author:		mandrade
-- Create date: 19/10/2015
-- Description:	obtiene facturacion de santa emma sucursal medipac tijuana y tijuana marzam
-- [dbo].[usp_facturacion_santa_emma] 25
-- monkeyland.dbo.[usp_rutas_envio] 'santaEmma25'
-- =============================================
CREATE PROCEDURE [dbo].[usp_facturacion_santa_emma] @sucursal int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- [usp_facturacion_santa_emma] 6
	SET NOCOUNT ON;

   SELECT RIGHT('00' + CONVERT(varchar(2), t1.sucursal), 2) + t1.cliente + t1.digito_verificador + CASE WHEN t1.folio_fiscal IS NULL THEN t1.serie + LEFT(RIGHT(t1.factura, 7) 
       + '          ', 9) ELSE LEFT(t2.serie_cfd + CONVERT(varchar(8), CONVERT(bigint, t1.folio_fiscal)) + '          ', 10) END + CONVERT(varchar(8), t1.fecha_factura, 112) 
       + '00' + t1.codigo + LEFT(t1.descripcion + '                                        ', 40) + LEFT(t3.cod_barras_tandem + '             ', 13) + LEFT(t1.clas_fis + '  ', 2) 
       + RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_con_cargo), 7) + RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_sin_cargo), 7) 
       + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_farm_sin_imp), 10) + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_sin_imp), 10) 
       + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_con_imp), 10)+ --AS primera_parte
	   RIGHT('0000000000000' + CONVERT(varchar(13), t1.importe_bruto), 
       13) + RIGHT('000000' + CONVERT(varchar(10), t1.porcentaje_descto_oferta), 6) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.descto_oferta), 13) 
       + RIGHT('000000' + CONVERT(varchar(10), t1.porcentaje_descto_comercial), 6) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.descto_comercial), 13) 
       + RIGHT('0000000000000' + CONVERT(varchar(13), t1.ieps), 13) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.iva), 13) 
       + RIGHT('0000000000000' + CONVERT(varchar(13), t1.bonificacion_iva), 13) + RIGHT('00000' + CONVERT(varchar(5), 
       CASE WHEN t1.porcentaje_utilidad < 0 THEN 0 ELSE t1.porcentaje_utilidad END), 5) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.importe_neto), 13) 
       + RIGHT('000000000' + REPLACE(t1.orden, ' ', ''), 9) + RIGHT('000000' + CONVERT(varchar(6), t1.porcentaje_iva), 6) + t1.filler + 
	   RIGHT('00000' + CONVERT(varchar(5),t1.no_registro), 5)+
	   replicate(' ',15-len(isnull(f1.LTBATC,'')))+isnull(f1.LTBATC,'')+
	   replicate('0',8-len(cast(isnull(f1.LTUSBD,0) as varchar)))+cast(isnull(f1.LTUSBD,0) as varchar)  --AS segunda_parte,
--	   isnull(f1.LTTRAQ,0)as cantSurtidalote,isnull(f1.LTBATC,'')as Lote,isnull(f1.LTUSBD,0)as caducidad, 
--	   t1.segto, t1.ctepadre, t1.rfc, t1.fecha_factura, t1.cliente, t1.sucursal, t1.factura, t1.fecha_tandem, t1.clas_fis
FROM	dbo.facturacion_electronica_estandar AS t1 
		INNER JOIN dbo.sucursales AS t2 ON t1.sucursal = t2.sucursal 
		INNER JOIN dbo.maestro_productos AS t3 ON t1.codigo = t3.codigo 
		left join monkeyland..facturacion_lote_caducidad f1
		on t1.factura=f1.FACTURA and t1.ctepadre=substring(f1.NANCA1,3,3) AND t1.codigo=f1.IDPRDC
		and t1.cliente=substring(f1.IDCUNO,2,5) and t1.serie=f1.SERIE
where t1.ctepadre='843' and convert(varchar,t1.fecha_tandem ,112) >=convert(varchar,getdate(),112)
and t1.sucursal=@sucursal order by t1.serie,t1.folio_fiscal
END

GO

