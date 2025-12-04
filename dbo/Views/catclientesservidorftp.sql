
CREATE view [dbo].[catclientesservidorftp]
as
select 
f.sucursal, 
f.nombre, 
f.email, 
f.ip, 
f.usuario,
f.password,
f.ruta, 
f.hora_inicio, 
f.hora_fin , 
f.activo, 
f.filtro_monto, 
f.limite_filtro_min, 
f.limite_filtro_max, 
f.timestamp,
f.selex

from cat_clientes_estandar_ftp f

GO

