
CREATE procedure [dbo].[SP_LlenadoSuperisstefactura]-- '08694590'
@factura nvarchar(50)
as
begin
   -- select * from [monkeyland2].[dbo].[superisste2]
    insert into [monkeyland].[dbo].[superisste2]
--cambiamos el dato de la columna tipo por
--1 factura
--2 nota de credito 
select FACTURA,
           Tipo = 
			CASE 
			  WHEN  Tipo ='Factura' THEN 1
			   WHEN Tipo='Nota' then 2
				END,
				--sumamos el total de la factura
				--sumamos el subtotal de la factura
                  2134,
				  null,
				  null,
				  uuid,
				  cast(datepart(dd,cast(detalle.FECHAPROG as date))as nvarchar(10)) +Replace(str(datepart(mm,cast(detalle.FECHAPROG as date)),2),' ','0')+cast(datepart(yyyy,cast(detalle.FECHAPROG as date))as nvarchar(10)) as "fecha factura",
				  detalle.NETO_CANTIDAD,
				  detalle.IEPS,
				  detalle.IVA_MONEDA,
				  detalle.TOTAL_FINAL							  
                     FROM [192.168.90.18].[ETI_DatosCE].[dbo].[CFDIS_Emitidos]  f
                        inner join [monkeyland].[dbo].[detalle_superisste] detalle on f.Folio = detalle.FACTURA 	  
                            WHERE f.Folio = detalle.FACTURA and f.Folio =@factura
		--seleccionamos los campos que necesitamos que muestre al usuario					 	                  
		select  Factura,
		           Tipo,
		    Numeroprove,
	 FolioalternoCosteo,
		  ImporteCosteo,
		           UUID,
				  Fecha,
 sum(Importesubfactura),
				   IEPS,
			   sum(IVA),		 
    sum(Importetotalfac)	
		 		   from [monkeyland].[dbo].[superisste2]
	            	     where Factura = @factura
		                     group by Factura,Tipo,Numeroprove,FolioalternoCosteo,ImporteCosteo,UUID,Fecha,IEPS
							  

 end

GO

