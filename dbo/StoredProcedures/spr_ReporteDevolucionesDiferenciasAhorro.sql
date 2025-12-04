-- =============================================
-- Author:Francisco Roberto Martínez Hernández
-- Create date: 14/06/2018
-- Description:	Reporte de diferencias entre devolcuiones y precios para farmacias del ahorro
-- Exec [dbo].[spr_ReporteDevolucionesDiferenciasAhorro] 280
-- =============================================
CREATE PROCEDURE [dbo].[spr_ReporteDevolucionesDiferenciasAhorro]
 @Periodo1 INT,
 @Iva1 DECIMAL(18,2) = 0.16,
 @DescuentoCom1 DECIMAL (18,2) = 0.18
AS
BEGIN

   DECLARE
    @Periodo INT = @Periodo1,
    @Iva DECIMAL (18,2)  = @Iva1,
    @DescuentoCom DECIMAL (18,2) = @DescuentoCom1
	 --DECLARE @Periodo INT=280, @Iva DECIMAL (18,2) = 0.16, @DescuentoCom DECIMAL(18,2)=0.18;					
    IF EXISTS(SELECT TOP 1 1 FROM ReportesDiferenciasAhorro (NOLOCK) WHERE periodo=@Periodo)
	BEGIN
	   --declare @Periodo int=280
	   SELECT Id,Periodo,Remision,FechaRemision,CuentaEstiloAhorro,Sucursal,Cuenta,CodigoMarzam,CodigoBarras,Producto
				 ,ClasificacionFiscal,Orden,PzasPedidasRemision,PzasDevueltas,DevBruta,IvaDev,DescComDev,IvaDescComDev
				 ,OfertaDev,MinRecalculo,MaxRecalculo,DiferenciaPrecio,/*ImporteMarzam,IvaMarzam,TotalMarzam,*/BrutoDocumento
	 			 ,IvaDocumento,TotalDocumento,ImporteDocumento,Recalculado
	   FROM ReportesDiferenciasAhorro (NOLOCK) WHERE periodo=@Periodo
	   AND Recalculado=1 AND MinRecalculo<>9
	END
	ELSE
	BEGIN

		BEGIN TRY 	 
		  --BEGIN TRAN PeriodoAhorro    
		   print 'Inicio #BaseAgrupado '+ cast( SYSDATETIME() as varchar)
		   --DECLARE @Periodo INT=280, @Iva DECIMAL (18,2) = 0.16, @DescuentoCom DECIMAL(18,2)=0.18;					   
		   SELECT
	           --columnas de agrupado	
	           A.[IDINVN] as Remision, A.[FECHAPROG] as FechaRemision, A.[Sucursal], LTRIM(RTRIM(A.[IDCUNO])) as Cuenta,  LTRIM(RTRIM(A.[IDPRDC])) as CodigoMarzam
	          ,A.[PCXPRC] as CodigoBarras, A.[IDDESC] as Producto, LTRIM(RTRIM(A.[CF])) as ClasificacionFiscal, A.[IHOREF] as Orden	 
	          --Columnas de devoluciones				 		 
	         ,(							
	            (SUM(CASE WHEN A.Accion ='C' AND A.RECALCULO=1 THEN A.IDQTY ELSE 0 END) - SUM(CASE WHEN A.Accion ='U' AND A.RECALCULO=1 THEN A.IDQTY ELSE 0 END) + SUM(CASE WHEN A.Accion ='D' AND A.RECALCULO=1 THEN A.IDQTY ELSE 0 END)) 										
	          ) as PzasDevueltas
	         --Columnas escalares de recalculos	
	         ,MIN(A.RECALCULO) MinRecalculo	
	         ,MAX(A.RECALCULO) MaxRecalculo				
	   	     --select a.*
	         INTO #BaseAgrupado
	       FROM [monkeyland].[dbo].[mov_detalle_fahorroFacturas] A			
	       WHERE A.PERIODO=@Periodo 					
	       GROUP BY 
	       A.SUCURSAL,A.[FECHAPROG], A.[IDINVN], A.[FACTURA], LTRIM(RTRIM(A.[IDCUNO])) ,  LTRIM(RTRIM(A.[IDPRDC])), A.[PCXPRC], A.[IDDESC], LTRIM(RTRIM(A.[CF])), A.[IHOREF]		
		   print 'Fin #BaseAgrupado '+ cast( SYSDATETIME() as varchar)
		   
		   print 'Inicio #PedidosAhorro '+  cast( SYSDATETIME() as varchar)   
		   SELECT CAST(P.orden AS BIGINT) AS orden, CAST(P.[cod_barras] AS BIGINT) AS cod_barras,P.sucursal,B.cuenta,P.fecha_procesado,B.FechaRemision,P.timestamp,P.cuenta_estilo_ahorro,P.precio_far,
	   		  ROW_NUMBER() OVER (PARTITION BY P.orden, P.cod_barras, P.sucursal,B.cuenta ORDER BY DATEDIFF(MINUTE, P.timestamp,DATEADD(DAY,1,B.FechaRemision)) asc) AS firstRow
	   		  INTO #PedidosAhorro
	       FROM [monkeyland].[dbo].[pedidos_spt_fahorro] P (NOLOCK)
	       JOIN #BaseAgrupado B ON CAST(P.orden AS BIGINT) = CAST(B.Orden AS BIGINT)
		   AND  CAST(P.[cod_barras] AS BIGINT)  = CAST(B.CodigoBarras AS BIGINT) AND P.sucursal = B.[Sucursal]	
		   AND LTRIM(RTRIM(P.cuenta)) = SUBSTRING(B.Cuenta,2,LEN(B.Cuenta)-1)
	       AND  P.timestamp< DATEADD(DAY,1,B.FechaRemision)	   
		   print 'Fin #PedidosAhorro '+ cast( SYSDATETIME() as varchar) 

		   --DECLARE @Periodo INT=280, @Iva DECIMAL (18,2) = 0.16, @DescuentoCom DECIMAL(18,2)=0.18;	
		   print 'Inicio INSERT INTO ReportesDiferenciasAhorro '+ cast( SYSDATETIME() as varchar)   	  
		   INSERT INTO ReportesDiferenciasAhorro 	
	        ([Periodo],[Remision],[FechaRemision],[CuentaEstiloAhorro],[Sucursal],[Cuenta],[CodigoMarzam],[CodigoBarras]
	        ,[Producto],[ClasificacionFiscal],[Orden],[PzasPedidasRemision],[PzasDevueltas],[DevBruta],[IvaDev],[DescComDev]
	        ,[IvaDescComDev],[OfertaDev],[MaxRecalculo],[MinRecalculo],[DiferenciaPrecio],[ImporteMarzam],[IvaMarzam],[TotalMarzam]
	        ,[BrutoDocumento],[IvaDocumento],[TotalDocumento],[ImporteDocumento],[Recalculado]) 
		   --DECLARE @Periodo INT=280, @Iva DECIMAL (18,2) = 0.16, @DescuentoCom DECIMAL(18,2)=0.18;	
	       SELECT  @Periodo,B.Remision,B.FechaRemision, P.cuenta_estilo_ahorro AS CuentaEstiloAhorro, B.Sucursal
		       ,B.Cuenta,B.CodigoMarzam, B.CodigoBarras,B.Producto,B.ClasificacionFiscal,B.Orden
			   ,(
				  SUM(CASE WHEN A.Accion IN ('C','D') AND A.RECALCULO=B.MinRecalculo THEN A.IDQTY END) 				      
				) AS PzasPedidasRemision	
			    --Columnas de devoluciones
				----------------------------------	
			   ,B.PzasDevueltas						 								
			    ----------------------------------
			   ,(					
                  B.PzasDevueltas								
				  * MAX(CASE WHEN A.RECALCULO=1 AND A.Accion IN ('C','D') THEN A.FARMACIA ELSE 0 END)					   
				) AS DevBruta
				----------------------------------
			   ,(
				  CASE WHEN SUBSTRING(LTRIM(RTRIM(A.CF)),2,1)='A' THEN
				  ( 
				    B.PzasDevueltas 
				    * MAX(CASE WHEN A.RECALCULO=1 AND A.Accion IN ('C','D') THEN A.FARMACIA ELSE 0 END)
					* @Iva
				  )
				  END	    
				) AS IvaDev
			    ----------------------------------
			   ,( 
				  CASE WHEN LTRIM(RTRIM(A.CF)) IN('B','BA','H','HA') THEN
				    CASE 
				  	WHEN LTRIM(RTRIM(A.CF))='B' THEN								
				  	  B.PzasDevueltas
				  	  * MAX(CASE WHEN A.RECALCULO=1 AND A.Accion IN ('C','D') THEN A.FARMACIA -(A.TOTAL_FINAL/A.IDQTY) ELSE 0 END)						
				    WHEN LTRIM(RTRIM(A.CF))='BA' THEN 						
				  	  B.PzasDevueltas
				  	  * MAX(CASE WHEN A.RECALCULO=1 AND A.Accion IN('C','D') THEN A.FARMACIA - ((A.TOTAL_FINAL-(A.TOTAL_FINAL * @Iva/(1 + @Iva))) /A.IDQTY)	ELSE 0 END)						
				  	WHEN LTRIM(RTRIM(A.CF))='H' THEN						
				  	  B.PzasDevueltas 
				  	  * MAX(CASE WHEN A.RECALCULO=1 AND A.Accion IN('C','D') THEN A.FARMACIA * @DescuentoCom ELSE 0 END)						
				  	WHEN LTRIM(RTRIM(A.CF))='HA' THEN						
				  	  B.PzasDevueltas
				  	  * MAX(CASE WHEN A.RECALCULO=1 AND A.Accion IN('C','D') THEN A.FARMACIA * @DescuentoCom ELSE 0 END)						
				    END
				  END	    
				) AS DescComDev
				--------------------------------
			   ,(
				  CASE WHEN LTRIM(RTRIM(A.CF)) IN('BA','HA') THEN		    
				  	B.PzasDevueltas
				  	* MAX(CASE WHEN A.RECALCULO=1 AND A.Accion IN('C','D') THEN A.FARMACIA - ((A.TOTAL_FINAL-(A.TOTAL_FINAL * @Iva/(1 + @Iva))) /A.IDQTY) ELSE 0 END)
				  	* @Iva 			
				  END	   
				) AS IvaDescComDev							
				------------------------------------
			   ,(				 
				  CASE 				   
				    WHEN LTRIM(RTRIM(A.CF)) IN('NA','FA','OA') THEN 					    
				    B.PzasDevueltas
				    * MAX(CASE WHEN A.RECALCULO=1 AND  A.Accion IN('C','D') THEN A.FARMACIA-(((A.TOTAL_FINAL-ISNULL(A.IEPS_MONEDA,0))-(((A.TOTAL_FINAL-ISNULL(A.IEPS_MONEDA,0))* @Iva)/(1 + @Iva))) /A.IDQTY) END)					    		    
                    WHEN LTRIM(RTRIM(A.CF)) IN('N','F','O') THEN							    
				    B.PzasDevueltas
				    * MAX(CASE WHEN A.RECALCULO=1 AND  A.Accion IN ('C','D') THEN A.FARMACIA-((A.TOTAL_FINAL-ISNULL(A.IEPS_MONEDA,0))/A.IDQTY)	END)							    
				  END				  	    
				) AS OfertaDev		 
			   ,B.MaxRecalculo,B.MinRecalculo 
			   ,( 			     
				  SUM(CASE WHEN A.RECALCULO=B.MaxRecalculo AND A.Accion ='U' THEN A.IDQTY ELSE 0 END)
				  *
				  (
				    MAX(CASE WHEN A.RECALCULO= B.MinRecalculo AND A.Accion IN('C','D') THEN A.FARMACIA ELSE 0 END)
				     -
				    MAX(ISNULL(P.precio_far,null))
				  )				 
				) AS DiferenciaPrecio
		        ,max(CASE WHEN A.Accion IN ('U','D') AND A.RECALCULO=B.MaxRecalculo THEN A.NETO_CANTIDAD END)as ImporteMarzam
	            ,max(CASE WHEN A.Accion IN ('U','D') AND A.RECALCULO=B.MaxRecalculo THEN A.IVA_MONEDA END)as IvaMarzam	
	            ,max(CASE WHEN A.Accion IN ('U','D') AND A.RECALCULO=B.MaxRecalculo THEN A.TOTAL_FINAL END)as TotalMarzam	 
	            ,max(CASE WHEN A.Accion IN ('C','D') AND A.RECALCULO=B.MinRecalculo THEN A.NETO_CANTIDAD END)as BrutoDocumento
	            ,max(CASE WHEN A.Accion IN ('C','D') AND A.RECALCULO=B.MinRecalculo THEN A.IVA_MONEDA END)as IvaDocumento	
	            ,max(CASE WHEN A.Accion IN ('C','D') AND A.RECALCULO=B.MinRecalculo THEN A.TOTAL_FINAL END)as TotalDocumento	 
	            ,max(CASE WHEN A.Accion IN ('C','D') AND A.RECALCULO=B.MinRecalculo THEN A.TOTAL_FINAL END)as ImporteDocumento	
				,1 as Recalculado								
		   FROM #BaseAgrupado B
		   -----------------------------
		   LEFT JOIN [monkeyland].[dbo].[mov_detalle_fahorroFacturas] A ON 	
		   A.SUCURSAL=B.SUCURSAL AND LTRIM(RTRIM(A.IDCUNO))=B.Cuenta AND A.[IDINVN] = B.Remision AND LTRIM(RTRIM(A.[IDPRDC]))=B.CodigoMarzam 
		   AND A.[PCXPRC] = B.CodigoBarras AND LTRIM(RTRIM(A.[CF]))=B.ClasificacionFiscal  AND A.[IHOREF]= B.Orden 				
		   -----------------------------------------------------------
		   LEFT JOIN #PedidosAhorro P ON P.orden = CAST(B.Orden AS BIGINT) AND P.[cod_barras] = CAST(B.CodigoBarras AS BIGINT) 
		   AND P.sucursal = B.[Sucursal] AND P.cuenta=B.Cuenta AND P.firstRow = 1	
		   GROUP BY 
			B.SUCURSAL,B.Remision			
		   ,B.Cuenta,B.CodigoMarzam,B.CodigoBarras,B.Producto,B.ClasificacionFiscal,B.Orden
		   ,B.FechaRemision,B.PzasDevueltas	
		   ,B.MaxRecalculo,B.MinRecalculo
		   ,A.SUCURSAL,A.[FECHAPROG], A.[IDINVN], A.[FACTURA], LTRIM(RTRIM(A.IDCUNO)), LTRIM(RTRIM(A.[IDPRDC])), A.[PCXPRC], A.[IDDESC], LTRIM(RTRIM(A.[CF])), A.[IHOREF]					
		   ,P.cuenta_estilo_ahorro
		   ORDER BY B.Remision,B.CodigoMarzam 							 
		   print 'Fin INSERT INTO ReportesDiferenciasAhorro ' + cast( SYSDATETIME() as varchar) 	
		    	
		   --DECLARE @Periodo INT=280, @Iva DECIMAL (18,2) = 0.16, @DescuentoCom DECIMAL(18,2)=0.18;	
		   print 'Inicio INSERT INTO #PedidosAhorro2 '+  cast( SYSDATETIME() as varchar) 	 		 		
		   SELECT CAST(P.orden AS BIGINT) AS orden, CAST(P.[cod_barras] AS BIGINT) AS cod_barras,P.sucursal,LTRIM(RTRIM(df.IDCUNO)) AS cuenta,P.fecha_procesado,df.FECHAPROG,P.timestamp,P.cuenta_estilo_ahorro,P.precio_far,
	   			ROW_NUMBER() OVER (PARTITION BY P.orden, P.cod_barras, P.sucursal,LTRIM(RTRIM(df.IDCUNO)) ORDER BY DATEDIFF(MINUTE, P.timestamp,DATEADD(DAY,1,df.FECHAPROG)) asc) AS firstRow	   		
           INTO #PedidosAhorro2
		   FROM [dbo].[detalle_fahorroFacturas] df (NOLOCK) 
		   JOIN [monkeyland].[dbo].[pedidos_spt_fahorro] P (NOLOCK) 
		   ON  ISNULL(df.RECALCULO,9)=9 
		   AND CAST(P.orden AS BIGINT) = CAST(df.[IHOREF] AS BIGINT) 
		   AND CAST(P.[cod_barras] AS BIGINT) = CAST(df.[PCXPRC] AS BIGINT) AND P.sucursal = df.[Sucursal]	
		   AND LTRIM(RTRIM(P.cuenta)) = SUBSTRING(LTRIM(RTRIM(df.IDCUNO)),2,LEN(LTRIM(RTRIM(df.IDCUNO)))-1)
		   AND  P.timestamp< DATEADD(DAY,1,df.FECHAPROG)	
		   WHERE df.PERIODO=@Periodo   
	       print 'Fin INSERT INTO #PedidosAhorro2 ' + cast( SYSDATETIME() as varchar)  
		 
		   --DECLARE @Periodo INT=280, @Iva DECIMAL (18,2) = 0.16, @DescuentoCom DECIMAL(18,2)=0.18;
		   print 'Inicio  MERGE INTO [dbo].[ReportesDiferenciasAhorro] ' + cast( SYSDATETIME() as varchar)  		  
		   MERGE INTO [dbo].[ReportesDiferenciasAhorro] T
		   USING 
		   (   				    
	   		  SELECT df.IDINVN,df.FECHAPROG,P.cuenta_estilo_ahorro,df.SUCURSAL, LTRIM(RTRIM(df.IDCUNO)) AS IDCUNO,LTRIM(RTRIM(df.IDPRDC)) AS IDPRDC,df.PCXPRC
				,df.IDDESC,df.DTDCPR,LTRIM(RTRIM(df.CF)) AS CF,df.IHOREF,df.IDQTY,df.NETO_CANTIDAD,df.IVA_MONEDA,df.TOTAL_FINAL,df.RECALCULO,
				CASE WHEN df.RECALCULO=9 THEN 1 ELSE 0 END AS RECALCULADO
			  FROM [dbo].[detalle_fahorroFacturas] df	
				 LEFT JOIN #PedidosAhorro2 P ON P.orden = CAST(df.IHOREF AS BIGINT) AND P.[cod_barras] = CAST(df.PCXPRC AS BIGINT) 
				 AND P.sucursal = df.Sucursal AND  P.cuenta=LTRIM(RTRIM(df.IDCUNO)) AND P.firstRow = 1			
			  WHERE df.PERIODO=@Periodo  	    
		   )S
		   ON 
		   (		
			 T.Periodo=@Periodo AND T.Remision = S.[IDINVN] AND T.SUCURSAL = S.SUCURSAL AND LTRIM(RTRIM(T.Cuenta)) = S.IDCUNO 
			AND LTRIM(RTRIM(T.CodigoMarzam)) =  LTRIM(RTRIM(S.[IDPRDC])) AND T.CodigoBarras = S.[PCXPRC] AND T.ClasificacionFiscal = S.[CF] AND T.Orden = S.[IHOREF]  				
		   )				
		   WHEN NOT MATCHED BY TARGET THEN --No existe en el destino
			INSERT  
			(
			   [Periodo],[Remision],[FechaRemision],[CuentaEstiloAhorro],[Sucursal],[Cuenta],[CodigoMarzam],[CodigoBarras]
			  ,[Producto],[ClasificacionFiscal],[Orden],[PzasPedidasRemision],[PzasDevueltas],[DevBruta],[IvaDev],[DescComDev]
			  ,[IvaDescComDev],[OfertaDev],[MaxRecalculo],[MinRecalculo],[DiferenciaPrecio],[ImporteMarzam],[IvaMarzam],[TotalMarzam]
			  ,[BrutoDocumento],[IvaDocumento],[TotalDocumento],[ImporteDocumento],[Recalculado]
			) 
			VALUES 
			(
			  @Periodo,S.IDINVN,S.FECHAPROG,S.cuenta_estilo_ahorro,S.SUCURSAL,S.IDCUNO,S.IDPRDC,S.PCXPRC
			  ,S.IDDESC,S.CF,S.IHOREF,S.IDQTY,NULL,NULL,NULL,NULL
			  ,NULL,NULL,S.RECALCULO,S.RECALCULO,NULL,S.NETO_CANTIDAD,S.IVA_MONEDA,S.TOTAL_FINAL
			  ,S.NETO_CANTIDAD,S.IVA_MONEDA,S.TOTAL_FINAL,S.TOTAL_FINAL,RECALCULADO
			);	      
		   print 'Fin  MERGE INTO [dbo].[ReportesDiferenciasAhorro] '+ cast( SYSDATETIME() as varchar)   

         --COMMIT TRAN PeriodoAhorro
		   --Se valida la columna [CuentaEstiloAhorro](Para evitar duplicados en agrupado)
		   IF EXISTS(SELECT TOP 1 1 FROM ReportesDiferenciasAhorro WHERE Periodo=@Periodo AND CuentaEstiloAhorro is null)
		   BEGIN
		       --DECLARE @Periodo INT=280, @Iva DECIMAL (18,2) = 0.16, @DescuentoCom DECIMAL(18,2)=0.18;
		       print 'Inicio   UPDATE B set B.CuentaEstiloAhorro=P.cuenta_estilo_ahorro'    
			   UPDATE B set B.CuentaEstiloAhorro=P.cuenta_estilo_ahorro
			   FROM [monkeyland].[dbo].[pedidos_spt_fahorro] P (NOLOCK)
				   JOIN ReportesDiferenciasAhorro B ON B.CuentaEstiloAhorro is null
				   AND CAST(P.orden AS BIGINT) = CAST(B.Orden AS BIGINT)
				   AND CAST(P.[codigo] AS BIGINT)  = CAST(B.CodigoMarzam AS BIGINT)
				   AND P.sucursal = B.[Sucursal]	
				   AND RTRIM(P.cuenta) = SUBSTRING(B.Cuenta,2,LEN(B.Cuenta)-1)
			   WHERE B.Periodo=@Periodo
			   print 'Inicio   UPDATE B set B.CuentaEstiloAhorro=P.cuenta_estilo_ahorro'    
           END

		   --DECLARE @Periodo INT=280, @Iva DECIMAL (18,2) = 0.16, @DescuentoCom DECIMAL(18,2)=0.18;
		   print 'Inicio   select * FROM ReportesDiferenciasAhorro (NOLOCK) WHERE periodo=@Periodo '+  cast( SYSDATETIME() as varchar)   
	       SELECT Id,Periodo,Remision,FechaRemision,CuentaEstiloAhorro,Sucursal,Cuenta,CodigoMarzam,CodigoBarras,Producto
				 ,ClasificacionFiscal,Orden,PzasPedidasRemision,PzasDevueltas,DevBruta,IvaDev,DescComDev,IvaDescComDev
				 ,OfertaDev,MinRecalculo,MaxRecalculo,DiferenciaPrecio,/*ImporteMarzam,IvaMarzam,TotalMarzam,*/BrutoDocumento
				 ,IvaDocumento,TotalDocumento,ImporteDocumento,Recalculado
		   FROM ReportesDiferenciasAhorro (NOLOCK) WHERE periodo=@Periodo
		   AND Recalculado=1 AND MinRecalculo<>9           
		   print 'Fin   select * FROM ReportesDiferenciasAhorro (NOLOCK) WHERE periodo=@Periodo '+ cast( SYSDATETIME() as varchar)
		   
		   DROP TABLE #BaseAgrupado	  
		   DROP TABLE #PedidosAhorro	
		   DROP TABLE #PedidosAhorro2	
		 
	    END TRY
	    BEGIN CATCH
           print 'Inicio    ROLLBACK TRAN PeriodoAhorro '  + cast( SYSDATETIME() as varchar)
		  -- ROLLBACK TRAN PeriodoAhorro 		
		   DECLARE @Msj varchar(4000) 
		   SELECT @Msj = ERROR_MESSAGE();
		   RAISERROR (@Msj, 16, 1)
		   RETURN;
	    END CATCH
	END	
END

GO

