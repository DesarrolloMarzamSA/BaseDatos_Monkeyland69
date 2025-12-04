
  CREATE procedure [dbo].[SP_sacarfacturacasaleyftp]
  @fecha nvarchar(30)
  as
  begin
  select 
         dc.SERIE, 
        count(dc.SERIE) as [numero facturas],		
		 dc.NATREG as carpeta
        ,cast(dc.FECHAPROG as date) as fecha		
           from detacasaley dc 
              where cast(FECHAPROG as date) = @fecha
	          group by dc.SERIE,dc.FECHAPROG,dc.NATREG 
	          order by SERIE asc
			  end

GO

