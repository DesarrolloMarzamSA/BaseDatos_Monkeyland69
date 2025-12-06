
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_farmacon_reporte]   
 @fechaini datetime,  
 @fechafin datetime  

as  
  
--declare @fechaini datetime  
--declare @fechafin datetime  
--set @fechaini = '02-03-2011'  
--set @fechafin = '04-03-2011'  
  
select t1.arch_cliente,  
   t2.fecha,  
   max(t1.hora_resp_tandem) 'Fecha Termino Trae Respuestas',  
   convert(varchar, datediff(mi, min(t2.fecha), max(t1.hora_resp_tandem))) + ' Minutos' 'Diferencia General'  
from   pedidos_farmacon_historia t1 inner join farmacon_lotes t2 on  
   t1.arch_cliente = t2.arch_cliente and   
   t1.hash_md5 = t2.hash_md5  
where t2.fecha between convert(datetime, convert(varchar(10), @fechaini, 121), 121) and convert(datetime, convert(varchar(10), @fechafin, 121), 121)  
group by   
   t1.arch_cliente,   
   t2.fecha  
order by   
   min(t2.fecha)  
select distinct  
   sum (t1.cantidad_pedida),  
   t2.descripcion 'Sucursal',   
   t1.tamano_archivo_respuesta,  
   t1.cuenta 'Cliente',   
   t3.ip 'IP Servidor',   
   t3.volumen + '.' + t1.arch_tandem 'Ruta Archivo Tandem',  
   t1.arch_tandem,  
   '''' + t1.arch_tandem + '''' + ',',
   t1.arch_cliente,  
   min(t1.fechahistoria) 'Fecha Pedido'  
from  pedidos_farmacon_historia t1 inner join sucursales t2 on   
   t1.sucursal = t2.sucursal inner join  rutas_tandem t3 on   
   t1.sucursal = t3.sucursal inner join farmacon_lotes t4 on  
   t1.arch_cliente = t4.arch_cliente  
where (t1.tamano_archivo_respuesta = 0 or t1.tamano_archivo_respuesta is null) and    
   t1.arch_tandem is not null and   
   t4.fecha between convert(datetime, convert(varchar(10), @fechaini, 121), 121) and convert(datetime, convert(varchar(10), @fechafin, 121), 121)  
group by  
   t1.fechahistoria,  
   t2.descripcion,  
   t1.tamano_archivo_respuesta,  
   t1.cuenta,   
   t3.ip,   
   t3.volumen,  
   t1.arch_tandem,
   t1.arch_cliente 
order by    
   9,
   7 

GO
