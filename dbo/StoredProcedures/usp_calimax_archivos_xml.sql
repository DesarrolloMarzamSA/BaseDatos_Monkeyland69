
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_calimax_archivos_xml]  
	@sucursal tinyint,  
	@fecha datetime  

as  
--declare @sucursal tinyint  
--declare @fecha datetime  
--set @sucursal = 6  
--set @fecha = '02-09-2010' 
select	distinct 'Factura' +  
			convert(varchar(8), convert(bigint, t1.folio_fiscal)) +  
			case  
				when t1.sucursal = 6 then 'FJ'  
				when t1.sucursal = 25 then 'FY'    
			end,  
			case   
				when t1.sucursal = 6 then '190.1.32.3'  
				when t1.sucursal = 25 then '190.1.4.169'    
			end as ip,  
			case  
				when t1.sucursal = 6 then 'faeMARZFJ' + convert(varchar(8), convert(bigint, t1.folio_fiscal)) + '.xml'  
				when t1.sucursal = 25 then 'faeMARZFY' + convert(varchar(8), convert(bigint, t1.folio_fiscal)) + '.xml'  
			end  
from		facturacion_electronica_estandar t1 inner join rutas_tandem t2 on
			t1.sucursal =  t2.sucursal  
where	t1.fecha_factura = @fecha and  
			t1.sucursal = @sucursal and 
			t1.segto = 'E2' and   
			t1.ctepadre = '728' and
			t1.rfc = 'CDE8401046V6'		
group by
			t1.sucursal,   
			t1.folio_fiscal,   
			t2.ip
GO
