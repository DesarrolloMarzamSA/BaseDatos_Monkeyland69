-- =============================================
-- Author:		<Author,,Name> 
-- Create date: <Create Date,,>
-- Updated date: <29-11-2018>
-- Description:	<Description,,>
/* 
 EXEC [dbo].[usp_obtener_totalesTrama03]  741

 */
-- =============================================
CREATE PROCEDURE [dbo].[usp_obtener_totalesTrama03] 
   @periodo int=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--declare @idfactura varchar(20)
	-- set @idfactura='803006523696'
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
      ,convert(numeric(9,2),round(sum((f.NETO_CANTIDAD *f.IEPS)/100),2,1)) as IEPS_MONEDA
      ,sum(cast(f.TOTAL_IEPS as decimal(20,2))) as TOTAL_IEPS
      ,convert(numeric(9,2),round(sum((f.NETO_CANTIDAD *f.IVA)/100),2,1)) as IVA_MONEDA
      ,sum(cast(f.TOTAL_FINAL as decimal(20,2))) as TOTAL_FINAL
      ,f.DTDCPR
      ,sum(cast(f.DESCOFERTA as decimal(20,2)))as DESCOFERTA
      ,cast(isnull(f.DESCCOMERCIAL,'0')as decimal(20,2)) as DescComercial
      ,sum(cast(rtrim(f.DescComercialPesos) as decimal(20,2))) as DescComercialPesos
	  ,sum(convert(numeric(10,2),round(f.IVA_MONEDA*convert(numeric(10,2),round(isnull(f.DESCCOMERCIAL,'0'),2,1))/100,2,1))) as DescIVA
	  ,sum(convert(numeric(10,2),round(f.IEPS_MONEDA*convert(numeric(10,2),round(isnull(f.DESCCOMERCIAL,'0'),2,1))/100,2,1))) as DescIEPS
      --,f.IDGDSQ
      --,f.FECHAPROG
      --,f.IHOREF
      ,f.NATREG
	   into #facturaPerfecta
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

   update #facturaPerfecta set  UNITARIO=convert(numeric(10,2),round((FARMACIA-((FARMACIA*DTDCPR)/100)),2,1))
   update #facturaPerfecta set  PRECIO_CANTIDAD=convert(numeric(10,2),round((UNITARIO*IDQTY),2,1))
   update #facturaPerfecta set  NETO_UNITARIO=convert(numeric(10,2),round((UNITARIO-(UNITARIO*DescComercial/100)),2,1))
                               ,NETO_CANTIDAD=convert(numeric(10,2),round((PRECIO_CANTIDAD-((PRECIO_CANTIDAD*DescComercial)/100)),2,1))
   update #facturaPerfecta set  IEPS_MONEDA=convert(numeric(10,2),round((NETO_CANTIDAD*(IEPS*100)/100),2,1)),IVA_MONEDA=convert(numeric(10,2),round((NETO_CANTIDAD*(IVA*100)/100),2,1))
   update #facturaPerfecta set  DESCOFERTA =convert(numeric(10,2),round(((FARMACIA*DTDCPR/100)*IDQTY),2,1))

  BEGIN
    declare @totalBrutoExento  decimal(20,2)
    declare @totalBrutoGravado decimal(20,2)
    declare @totalPiezas       numeric(20,0)
    declare @totalBruto        decimal(20,2)
    declare @totalNeto         decimal(20,2)
    declare @totalDescuento    decimal(20,2)
    declare @totalDescuentoAux decimal(20,2)
    declare @totalImpuesto     decimal(20,2)
    declare @baseTrasladoIVA   decimal(20,2)
    declare @tasaIVA           decimal(20,2)
    declare @brutoIVA          decimal(20,2)
    declare @descIVA           decimal(20,2)
    declare @netoIVA           decimal(20,2)
    declare @baseTrasladoIEPS  decimal(20,2)
    declare @tasaIEPS          decimal(20,2)
    declare @brutoIEPS         decimal(20,2)
    declare @descIEPS          decimal(20,2)
    declare @netoIEPS          decimal(20,2)
    declare @totalNetoSIVA     decimal(20,2)
    declare @totalDescuento2   decimal(20,2)
    declare @totalAlcohol      decimal(20,2)
    declare @totalLineas       numeric(20,0)
    declare @descExento        decimal(20,2)
    declare @netoExento        decimal(20,2)
    declare @descGravado       decimal(20,2)
    declare @netoGravado       decimal(20,2)
    declare @totalAjuste       decimal(20,2)
    declare @totalPrecioPublic decimal(20,2)
    declare @totalOfer         decimal(20,2)
    declare @totalOferProctj   decimal(20,2)
    declare @totalOferPz       decimal(20,2)
    declare @totalBasicSIVA    decimal(20,2)
    declare @totalNetoCIVA     decimal(20,2)
    declare @totalBruto2       decimal(20,2)
    declare @subtotal          decimal(20,2)
    declare @tasaIEPS1         decimal(20,2)
    declare @importeIEPS1      decimal(20,2)
    declare @baseIEPS1         decimal(20,2)
    declare @tasaIEPS2         decimal(20,2)
    declare @importeIEPS2      decimal(20,2)
    declare @baseIEPS2         decimal(20,2)
    declare @tasaIEPS3         decimal(20,2)
    declare @importeIEPS3      decimal(20,2)
    declare @baseIEPS3         decimal(20,2)
    declare @importeNeto       decimal(20,2)
    declare @totalLimitado     decimal(20,2)
 END

 SET @totalBrutoExento  = (select convert(numeric(20,2),round(sum(precio_cantidad),2,1)) from #facturaPerfecta where iva<=0)
 SET @totalBrutoGravado = (select convert(numeric(20,2),round(sum(precio_cantidad),2,1)) from #facturaPerfecta where iva>0)
 SET @totalPiezas       = (select sum(idqty) from #facturaPerfecta )            
 SET @totalDescuentoAux = (select convert(numeric(20,2),round(sum(desccomercialpesos),2,1)) from #facturaPerfecta )      
 SET @baseTrasladoIVA   = (select convert(numeric(20,2),round(sum(precio_cantidad),2,1)) from #facturaPerfecta where iva>0)
 SET @tasaIVA           = (select top 1  iva from #facturaPerfecta where iva>0)       
 SET @brutoIVA          = (select convert(numeric(20,2),round(sum(iva_moneda),2,1)) from #facturaPerfecta where iva>0)           
 SET @descIVA           = 0-----(select convert(numeric(20,2),round(sum(DescIVA),2,1)) from #facturaPerfecta)       
 SET @netoIVA           = (select convert(numeric(20,2),round(sum(iva_moneda),2,1)) from #facturaPerfecta)
 SET @baseTrasladoIEPS  = (select isnull(convert(numeric(20,2),round(sum(precio_cantidad),2,1)),0) from #facturaPerfecta where ieps=0.25)
 SET @tasaIEPS          = (select top 1 case when ieps>0 then 0 else ieps end from #facturaPerfecta where ieps=0.25)
 ----SET @brutoIEPS         = (select isnull(convert(numeric(20,2),round(sum(ieps_moneda),2,1)),0) from #facturaPerfecta where ieps>0)
 ----SET @descIEPS          = (select isnull(sum(DescIEPS),0) from #facturaPerfecta)
 ----SET @netoIEPS          = (select isnull(@brutoIEPS-@descIEPS,0))
 SET @descIEPS          = 0-----(select isnull(sum(DescIEPS),0) from #facturaPerfecta)
 SET @netoIEPS          =  (select isnull(convert(numeric(20,2),round(sum(ieps_moneda),2,1)),0) from #facturaPerfecta where ieps>0)
 SET @brutoIEPS         =(select isnull( @netoIEPS + @descIEPS,0))
 BEGIN
 SET @totalNetoSIVA     = 0
 SET @totalDescuento2   = (select convert(numeric(20,2),round(sum(desccomercialpesos),2,1)) from #facturaPerfecta ) 
 SET @totalAlcohol      = (select isnull(convert(numeric(20,2),round(sum(ieps_moneda),2,1)),0) from #facturaPerfecta where ieps=0.25)
 SET @totalLineas       = (select count(1) from #facturaPerfecta )
 --SET @descExento        = (select convert(numeric(20,2),round(sum(desccomercialpesos),2,1))from #facturaPerfecta ) 
 SET @descExento        = (select convert(numeric(20,2),round(sum(desccomercialpesos),2,1))from #facturaPerfecta where iva<=0) 
 SET @descGravado       = (select convert(numeric(20,2),round(sum(desccomercialpesos),2,1)) from #facturaPerfecta where iva>0)
 SET @netoGravado       = (select convert(numeric(20,2),round(sum(neto_cantidad),2,1)) from #facturaPerfecta where iva>0)
 SET @totalAjuste       = 0
 SET @totalPrecioPublic = (select convert(numeric(20,2),round(sum(publico*idqty),2,1)) from #facturaPerfecta)
 SET @totalOfer         = (select sum(cast(descoferta as decimal(20,2))) from #facturaPerfecta)
 SET @totalOferProctj   = (select top 1 dtdcpr from #facturaPerfecta where dtdcpr>0)
 SET @totalOferPz       = (select isnull(count(1),0) from #facturaPerfecta where dtdcpr>0)
 SET @totalBasicSIVA    = (select convert(numeric(20,2),round(sum(precio_cantidad),2,1)) from #facturaPerfecta where cf='B' and iva<=0)
 SET @totalNetoCIVA     = (select convert(numeric(20,2),round(sum(neto_cantidad),2,1)) from #facturaPerfecta where cf='NA' )
 SET @totalBruto2       = (select convert(numeric(20,2),round(sum(precio_cantidad),2,1)) from #facturaPerfecta)
 SET @subtotal          = (select convert(numeric(20,2),round(sum(neto_cantidad),2,1)) from #facturaPerfecta)
 SET @tasaIEPS1         = (select top 1 isnull(ieps,0) from #facturaPerfecta where ieps=0.08)
 SET @importeIEPS1      = (select isnull(convert(numeric(20,2),round(sum(ieps_moneda),2,1)),0) from #facturaPerfecta where ieps=0.08)
 --SET @baseIEPS1         = (select isnull(convert(numeric(20,2),round(sum(precio_cantidad),2,1)),0) from #facturaPerfecta where ieps=0.08)
 SET @baseIEPS1         = (select isnull(convert(numeric(20,2),round(sum(neto_cantidad),2,1)),0) from #facturaPerfecta where ieps=0.08)
 SET @tasaIEPS2         = (select top 1 isnull(ieps,0) from #facturaPerfecta where ieps=0.25)
 SET @importeIEPS2      = (select isnull(convert(numeric(20,2),round(sum(ieps_moneda),2,1)),0) from #facturaPerfecta where ieps=0.25)
 --SET @baseIEPS2         = (select isnull(convert(numeric(20,2),round(sum(precio_cantidad),2,1)),0) from #facturaPerfecta where ieps=0.25)
 SET @baseIEPS2         = (select isnull(convert(numeric(20,2),round(sum(neto_cantidad),2,1)),0) from #facturaPerfecta where ieps=0.25)
 SET @importeNeto       = (select convert(numeric(20,2),round(sum(neto_cantidad),2,1)) from #facturaPerfecta)
 END
 SET @totalImpuesto     = (select @netoIVA+ @netoIEPS )
 SET @totalDescuento    = (select @totalDescuentoAux)
 --SET @totalBruto        = (select @totalBrutoExento+@totalBrutoGravado+@totalImpuesto)--(select @totalBrutoExento+@totalBrutoGravado+@brutoIVA+@brutoIEPS)     
 --SET @totalNeto         = (select (@totalBrutoExento+@totalBrutoGravado+@totalImpuesto)-@totalDescuento)--(select @importeNeto+@netoIVA+@netoIEPS) 
 -- SET @totalBruto        = (select @totalBrutoExento+@totalBrutoGravado+@totalImpuesto)--(select @totalBrutoExento+@totalBrutoGravado+@brutoIVA+@brutoIEPS)    
 --SET @totalNeto         = (select (@totalBrutoExento+@totalBrutoGravado+@totalImpuesto)-@totalDescuento)--(select @importeNeto+@netoIVA+@netoIEPS)

 SET @totalBruto        = (select ISNULL(@totalBrutoExento,0)+ISNULL(@totalBrutoGravado,0)+ISNULL(@totalImpuesto,0))--(select @totalBrutoExento+@totalBrutoGravado+@brutoIVA+@brutoIEPS)    
 SET @totalNeto         = (select (ISNULL(@totalBrutoExento,0)+ISNULL(@totalBrutoGravado,0)+ISNULL(@totalImpuesto,0))-ISNULL(@totalDescuento,0))--(select @importeNeto+@netoIVA+@netoIEPS)

 SET @netoExento        = (select convert(numeric(20,2),round(sum(neto_cantidad),2,1)) from #facturaPerfecta where iva<=0)
 SET @totalLimitado     = (select convert(numeric(20,2),round(sum(precio_cantidad),2,1)) from #facturaPerfecta where cf='H' )

 DECLARE @C29_netoExento  decimal(20,2) = ( isnull(@totalBrutoExento,0)-isnull(@descExento,0))
 --DECLARE @C30_descGravado decimal(20,2)=0.00
 DECLARE @C30_descGravado decimal(20,2)=ISNULL(@descGravado,0)
 DECLARE @C31_netoGravado decimal(20,2)=(isnull(@totalBrutoGravado,0)-isnull(@C30_descGravado,0))
--DECLARE @C31_netoGravado decimal(20,2)=(isnull(@totalBrutoGravado,0)-isnull(@descGravado,0))

 BEGIN /*(FRMH: 20230220) RECALCULOS CFDI 4.0*/
      IF OBJECT_ID('tempdb..#DetalleFacturasRecalculos40') IS NOT NULL
	    DROP TABLE #DetalleFacturasRecalculos40	 
      CREATE TABLE #DetalleFacturasRecalculos40(
            IDPRDC        VARCHAR(50),
            PCXPRC		  VARCHAR(15),
            CODIGOSAT	  VARCHAR(20),
            IDDESC		  VARCHAR(50),
            LABORATORIO	  VARCHAR(50),
            IDQTY		  NUMERIC(12,0),
            CF			  VARCHAR(50),
            FARMACIA	  DECIMAL(20,2),
            UNITARIO	  DECIMAL(20,2),
            PUBLICO		  DECIMAL(20,2),
            PRECIO_CANTIDAD	   DECIMAL(20,2),
            NETO_UNITARIO  DECIMAL(20,2),
            NETO_CANTIDAD  DECIMAL(20,2),
            IVA			  DECIMAL(20,2),
            IEPS		  DECIMAL(20,2),
            IEPS_MONEDA	  NUMERIC(20,2),
            TOTAL_IEPS	  DECIMAL(20,2),
            IVA_MONEDA	  NUMERIC(20,2),
            TOTAL_FINAL	  DECIMAL(20,2),
            DTDCPR		  DECIMAL(20,2),
            DESCOFERTA		DECIMAL(20,2),
            DescComercial	DECIMAL(20,2),
            DescComercialPesos DECIMAL(20,2),	
            NATREG   VARCHAR(20)
      )

      INSERT INTO #DetalleFacturasRecalculos40
      EXEC [dbo].[usp_obtener_fahorro_DetalleFacturaCFDI] @periodo

	  --Recaulculos de IVA
      SELECT 
	       @baseTrasladoIVA = ISNULL(SUM(NETO_CANTIDAD),0),
	       @brutoIVA=         ISNULL(SUM(IVA_MONEDA)   ,0)
	  FROM #DetalleFacturasRecalculos40 WHERE IVA>0

      DECLARE @C69_Base decimal(20,2)
	  DECLARE @C66_IMPORTE_TASA0 decimal(20,2)
	  SELECT 
	       @C69_Base =         ISNULL(SUM(NETO_CANTIDAD),0),
	       @C66_IMPORTE_TASA0= ISNULL(SUM(IVA_MONEDA)	,0)
	  FROM #DetalleFacturasRecalculos40 WHERE IVA=0

	  --Recaulculos de IEPS
      SELECT 
	       @baseIEPS1 =    ISNULL(SUM(NETO_CANTIDAD),0),
	       @importeIEPS1 = ISNULL(SUM(IEPS_MONEDA)  ,0)
	  FROM #DetalleFacturasRecalculos40 WHERE IEPS=0.08
	
      SELECT 
	       @baseIEPS2 =    ISNULL(SUM(NETO_CANTIDAD),0),
	       @importeIEPS2 = ISNULL(SUM(IEPS_MONEDA)	,0)	  
	  FROM #DetalleFacturasRecalculos40 WHERE IEPS=0.25

 END


 --select * from #facturaPerfecta
  select ISNULL(@totalBrutoExento,0)  as totalBrutoExento , ISNULL(@totalBrutoGravado,0) as totalBrutoGravado , ISNULL(@totalPiezas,0) as totalPiezas ,@totalBruto as totalBruto  ,@totalNeto as totalNeto ,ISNULL(@totalDescuento,0) as totalDescuento ,ISNULL(@totalImpuesto,0) as totalImpuesto ,ISNULL(@baseTrasladoIVA,0) as baseTrasladoIVA ,ISNULL(@tasaIVA,0) as tasaIVA ,ISNULL(@brutoIVA,0) as brutoIVA ,
         @descIVA as descIVA ,ISNULL(@netoIVA,0)  as netoIVA ,@baseTrasladoIEPS  as baseTrasladoIEPS ,isnull(@tasaIEPS,0) as tasaIEPS  ,@brutoIEPS as brutoIEPS ,@descIEPS as descIEPS ,@netoIEPS as netoIEPS  ,@totalNetoSIVA as  totalNetoSIVA,ISNULL(@totalDescuento2,0) as totalDescuento2,@totalAlcohol as totalAlcohol ,@totalLineas as  totalLineas,ISNULL(@descExento,0) as descExento ,ISNULL(@netoExento,0) as netoExento,ISNULL(@descGravado,0) as descGravado ,      
	     ISNULL(@netoGravado,0) as netoGravado ,@totalAjuste as totalAjuste ,ISNULL(@totalPrecioPublic,0) as totalPrecioPublic ,ISNULL(@totalOfer,0) as totalOfer ,isnull(@totalOferProctj,0) as totalOferProctj ,isnull(@totalOferPz,0) as totalOferPz ,ISNULL(@totalBasicSIVA,0) as totalBasicSIVA ,isnull(@totalNetoCIVA,0) as totalNetoCIVA,ISNULL(@totalBruto2,0) as totalBruto2 ,ISNULL(@subtotal,0) as subtotal ,
		 isnull(@tasaIEPS1,0) as tasaIEPS1 , @importeIEPS1 as  importeIEPS1,@baseIEPS1 as baseIEPS1 ,isnull(@tasaIEPS2,0) as tasaIEPS2 ,@importeIEPS2 as importeIEPS2 ,@baseIEPS2 as baseIEPS2 
		 ,@C29_netoExento as C29_netoExento, @C30_descGravado as C30_descGravado, @C31_netoGravado as C31_netoGravado     
		 ,@C66_IMPORTE_TASA0 as C66_IMPORTE_TASA0, @C69_Base as C69_Base
  drop table #facturaPerfecta

END

GO

