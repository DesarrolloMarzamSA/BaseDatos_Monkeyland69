
CREATE procedure [dbo].[SP_pedidosnoempatados]
@fechainicio date
as
begin
SELECT COUNT(cod_barras)as "total"  
      ,sucursal  
      ,[cuenta],
	  case
	    when [arch_tandem] IS NULL
	 then 'Sin archivo para ftp sembrado'
		else [arch_tandem]
      end  as  sembrado     
	  ,sum(cant_ped) as "cantidad"
	  ,cod_barras 
	  --,cast(DATEPART(YEAR,[timestamp]) as nvarchar(30))+'-'+cast(datepart(mm,[timestamp]) as nvarchar(30))+'-'+cast(DATEPART(dd,[timestamp]) as nvarchar(30))+' '+cast(datepart(hh,[timestamp])as nvarchar(30))+':'+cast(datepart(MINUTE,[timestamp])as nvarchar(30)) as "Fecha"
	  --,CONVERT(varchar,[timestamp],110) as "Fecha"	  
		,substring(cast([timestamp]as nvarchar(30)),1,19) as "Fecha" 
		FROM pedidos_spt_fahorro
		 where  procesado_traductor != 1 and cast([timestamp] as date) Between @fechainicio and  DATEADD(day,+1,@fechainicio) --and cod_barras='7503003738404'
		  group by sucursal,cuenta,substring(cast([timestamp]as nvarchar(30)),1,19),arch_tandem,cant_ped,cod_barras
		   order by arch_tandem desc,substring(cast([timestamp]as nvarchar(30)),1,19)  asc
		    end

GO

