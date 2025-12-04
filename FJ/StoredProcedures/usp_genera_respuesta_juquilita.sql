CREATE PROCEDURE [FJ].[usp_genera_respuesta_juquilita]
	@arch_cliente varchar(50),  
	@hash_md5 varchar(50)
AS
SELECT DISTINCT 
	rtrim(cod_barras)+ replicate(' ', 13-len(rtrim(cod_barras)))+
	cast(cant_ped as varchar)+replicate(' ', 7-len(cast(cant_ped as varchar))) +
	cast(cant_ped-isnull(cant_surt,0) as varchar)+replicate(' ', 7-len(cast(cant_ped-isnull(cant_surt,0) as varchar)))+
	replicate(' ', 10-len(orden))+orden+
	cliente+replicate(' ', 12-len(cliente))+
	replicate(' ', 2-len(convert(varchar,sucursal)))+convert(varchar,sucursal)
FROM FJ.pedidos_Juquilita
WHERE arch_cliente=@arch_cliente AND hash_md5=@hash_md5 AND cant_ped-isnull(cant_surt,0)>0

GO

