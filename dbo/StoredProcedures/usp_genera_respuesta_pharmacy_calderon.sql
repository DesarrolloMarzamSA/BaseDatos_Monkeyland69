
CREATE procedure [dbo].[usp_genera_respuesta_pharmacy_calderon]
	@arch_cliente varchar(50),  
	@hash_md5 varchar(50)
as
select distinct rtrim(cod_barras)+ replicate(' ', 13-len(rtrim(cod_barras)))+
cast(cant_ped as varchar)+replicate(' ', 7-len(cast(cant_ped as varchar))) +
cast(cant_ped-isnull(cant_surt,0) as varchar)+replicate(' ', 7-len(cast(cant_ped-isnull(cant_surt,0) as varchar)))+
replicate(' ', 10-len(orden))+orden+
cliente+replicate(' ', 12-len(cliente))+
replicate(' ', 2-len(convert(varchar,sucursal)))+convert(varchar,sucursal)
from pedidos_pharmacy_calderon_historia
where arch_cliente=@arch_cliente and hash_md5=@hash_md5 and cant_ped-isnull(cant_surt,0)>0
--select * from  pedidos_pharmacy_calderon_historia

GO

