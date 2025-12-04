
CREATE procedure [dbo].[SP_pedidosempatados]
@fechainicio date
as
begin
SELECT COUNT(sucursal)as "total"  
      ,sucursal  
      ,[cuenta]
      ,[arch_tandem]
	  ,sum(cant_ped) as "cantidad"	  
	 --  ,cast([timestamp]as date) as "Fecha"
	   --,cast(DATEPART(YEAR,[timestamp]) as nvarchar(30))+'-'+cast(datepart(mm,[timestamp]) as nvarchar(30))+'-'+cast(DATEPART(dd,[timestamp]) as nvarchar(30))+' '+cast(datepart(hh,[timestamp])as nvarchar(30))+':'+cast(datepart(mi,[timestamp])as nvarchar(30)) as "Fecha"
	    ,substring(cast([timestamp]as nvarchar(30)),1,19) as "Fecha" 
		FROM pedidos_spt_fahorro
		 where  procesado_traductor = 1 and cast([timestamp] as date) Between @fechainicio and  DATEADD(day,+1,@fechainicio) 
		  group by sucursal,cuenta,substring(cast([timestamp]as nvarchar(30)),1,19),arch_tandem
		   order by arch_tandem desc,  substring(cast([timestamp]as nvarchar(30)),1,19) asc
end

GO

