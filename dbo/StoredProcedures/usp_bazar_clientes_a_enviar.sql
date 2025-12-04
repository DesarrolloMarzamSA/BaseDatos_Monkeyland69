

CREATE procedure [dbo].[usp_bazar_clientes_a_enviar]
as
select distinct 
t2.sucursal, 
t2.cliente,
t2.correo
from 
encabezado  t1 inner join bazar_direcciones_correo t2 on t1.sucursal = t2.sucursal and t1.cliente = t2.cliente
where 
t1.fecha_tandem = convert(datetime, convert(varchar(10), current_timestamp, 121), 121) and 
--t1.fecha_tandem = convert(datetime, '2011-07-05', 121) and 
t1.segto = 'C2' and 
t1.ctepadre = '468'

GO

