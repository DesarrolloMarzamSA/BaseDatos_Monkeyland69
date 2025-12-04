-- =============================================
-- Author:		mandrade
-- Create date: 04-01-2016
-- Description:	depura facturacion de benavides
-- =============================================
CREATE PROCEDURE [dbo].[usp_fbenavides_depura_facturacion] as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

      insert into monkeyland..detalle_benavides_historico
	  SELECT distinct d.SUCURSAL,d.SERIE,d.IDCUNO,d.IDINVN,d.FACTURA,d.IDLINE,d.IDPRDC,d.PCXPRC,d.IDDESC,d.IDQTY,d.CF,d.FARMACIA,d.UNITARIO,d.PRECIO_CANTIDAD,d.NETO_UNITARIO,d.NETO_CANTIDAD,d.IVA,d.IEPS,d.IEPS_MONEDA,d.TOTAL_IEPS,d.IVA_MONEDA,d.TOTAL_FINAL,d.FECHAPROG,d.DESCUENTOPROD,d.FECHA_ACTUALIZACION,d.NOPEDIDO,d.ESTATUSH,d.ESTATUSD,d.FECHAESTATUS
	  FROM [monkeyland].[dbo].[detalle_benavides] d
	  left join monkeyland..detalle_benavides_historico d1 on d.IDINVN=d1.IDINVN AND d.IDCUNO=d1.IDCUNO
	  and d.IDPRDC=d1.IDPRDC
	  where d1.IDINVN is null
	  and convert(varchar,d.fechaprog,112)<=convert(varchar,getdate()-3,112)
	  

	  --delete FROM [monkeyland].[dbo].[detalle_benavides] 
	  --where convert(varchar,fechaprog,112)<=convert(varchar,getdate()-3,112)
END

GO

