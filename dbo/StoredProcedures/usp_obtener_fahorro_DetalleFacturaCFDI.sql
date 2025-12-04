-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- EXEC [dbo].[usp_obtener_fahorro_DetalleFacturaCFDI] 0
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_fahorro_DetalleFacturaCFDI]
@periodo int=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statement650240007736s.
	SET NOCOUNT ON; --drop table facturacion_cfd_spt_fahorrotemp
	SELECT 
	   --f.SUCURSAL
    --  ,f.SERIE
    --  ,f.IDCUNO
    --  ,f.IDINVN
    --  ,f.FACTURA
    --  ,f.IDLINE,
	  rtrim(f.IDPRDC)IDPRDC
      ,cast(rtrim(f.PCXPRC) as varchar(14))PCXPRC
	  ,isnull(c.Codigo_Sat,'00000000')as CODIGOSAT
      ,rtrim(f.IDDESC) as IDDESC
	  ,t3.lab_corto LABORATORIO
      ,sum(cast(f.IDQTY as numeric(12,0))) as IDQTY
      ,rtrim(f.CF) as CF
      ,cast(f.FARMACIA as decimal(20,2)) as FARMACIA
      ,cast(f.UNITARIO as decimal(20,2)) as UNITARIO
      ,cast(f.PUBLICO as decimal(20,2)) as PUBLICO
      ,sum(cast(f.PRECIO_CANTIDAD as decimal(20,2))) as PRECIO_CANTIDAD
      ,cast(f.NETO_UNITARIO as decimal(20,2)) as NETO_UNITARIO
      ,sum(cast(f.NETO_CANTIDAD as decimal(20,2))) as NETO_CANTIDAD
      ,cast((f.IVA/100) as decimal(20,2)) as IVA
      ,cast((f.IEPS/100) as decimal(20,2)) as IEPS
      ,convert(numeric(10,2),round(sum((f.NETO_CANTIDAD *f.IEPS)/100),2,1)) as IEPS_MONEDA
      ,sum(cast(f.TOTAL_IEPS as decimal(20,2))) as TOTAL_IEPS
      ,convert(numeric(10,2),round(sum((f.NETO_CANTIDAD *f.IVA)/100),2,1)) as IVA_MONEDA
      ,sum(cast(f.TOTAL_FINAL as decimal(20,2))) as TOTAL_FINAL
      ,f.DTDCPR
      ,sum(cast(f.DESCOFERTA as decimal(20,2)))as DESCOFERTA
      ,cast(isnull(f.DESCCOMERCIAL,'0')as decimal(20,2)) as DescComercial
      ,sum(cast(rtrim(f.DescComercialPesos) as decimal(20,2))) as DescComercialPesos
      --,f.IDGDSQ
      --,f.FECHAPROG
      --,f.IHOREF
      ,f.NATREG
	  into #detalleFacturas
  FROM monkeyland.dbo.detalle_fahorroFacturas f
 left join capa_ibs.dbo.maestro_productos t3 on f.IDPRDC = t3.codigo 
  left join dbo.catalogo_fahorroSAT c on f.IDPRDC=c.codigo 
  where f.[PERIODO]=@periodo  --and  
  --f.IDINVN=821009966731
  group by   rtrim(f.IDPRDC)
      ,cast(rtrim(f.PCXPRC) as varchar(14))
	  ,isnull(c.Codigo_Sat,'00000000')
      ,rtrim(f.IDDESC)
	  ,t3.lab_corto,rtrim(f.CF) 
      ,cast(f.FARMACIA as decimal(20,2))
      ,cast(f.UNITARIO as decimal(20,2))
      ,cast(f.PUBLICO as decimal(20,2))
	  ,cast(f.NETO_UNITARIO as decimal(20,2))
	  ,cast((f.IVA/100) as decimal(20,2)) 
      ,cast((f.IEPS/100) as decimal(20,2))
	  ,f.DTDCPR--,f.IDGDSQ
	  ,cast(isnull(f.DESCCOMERCIAL,'0')as decimal(20,2))
	  --,f.FECHAPROG--,f.IHOREF
	  ,f.NATREG
   order by iddesc



   update #detalleFacturas set  UNITARIO=convert(numeric(10,2),round((FARMACIA-((FARMACIA*DTDCPR)/100)),2,1))
   update #detalleFacturas set  PRECIO_CANTIDAD=convert(numeric(10,2),round((UNITARIO*IDQTY),2,1))
   update #detalleFacturas set  NETO_UNITARIO=convert(numeric(10,2),round((UNITARIO-(UNITARIO*DescComercial/100)),2,1)),NETO_CANTIDAD=convert(numeric(10,2),round((PRECIO_CANTIDAD-((PRECIO_CANTIDAD*DescComercial)/100)),2,1))
   update #detalleFacturas set IEPS_MONEDA=convert(numeric(10,2),round((NETO_CANTIDAD*(IEPS*100)/100),2,1)),IVA_MONEDA=convert(numeric(10,2),round((NETO_CANTIDAD*(IVA*100)/100),2,1))
   update #detalleFacturas set DESCOFERTA =convert(numeric(10,2),round(((FARMACIA*DTDCPR/100)*IDQTY),2,1))
   --[usp_obtener_fahorro_DetalleFacturaCFDI]

   select *
    from #detalleFacturas
   drop table #detalleFacturas

    --Ejemplo truncar a 2 digitos 
	--select convert(numeric(9,2),round(269.4272,2,1)) 
	--select convert(numeric(9,2),round(7.0512,2,1)) 
	--select convert(numeric(9,2),round(131.1456,2,1))
	--select convert(numeric(9,2),round(12.99,2,1)) 
	--select convert(numeric(9,2),round(12.999999,2,1)) 
END

GO

