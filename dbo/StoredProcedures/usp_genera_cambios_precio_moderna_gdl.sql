


CREATE  procedure [dbo].[usp_genera_cambios_precio_moderna_gdl]
as
--PROCEDIMIENTO PARA  CAMBIOS FCIAS. MODERNA DE GDL
begin
select 
left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) +
left(t1.descripcion + '                              ', 30) +
right('      ' + convert(varchar(10), t2.t_prpn), 9) +
right('      ' + convert(varchar(10), t2.t_prfn), 9)
from maestro_productos_baan t1 inner join cambios_precio_baan t2 on t1.codigo = t2.t_item
where t2.fecha_hora > dateadd(dd, -5, current_timestamp) and
convert(int, t1.codigo) < dbo.gobierno() and
isnumeric(t1.cod_barras) = 1
end

GO

