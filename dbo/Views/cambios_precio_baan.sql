create view cambios_precio_baan 
as
select 
t1.codigo t_item,
t2.cod_lab t_suno,
t1.p_costo t_prcn,
t1.prec_farm t_prfn,
t1.prec_pub t_prpn,
t2.descto t_marc,
0 t_marf,
0 t_prca,
0 t_prfa,
0 t_prpa,
'         ' t_user,
0 t_prli,
0 t_prma,
0 t_marp,
t1.timestamp fecha_hora
from
capa_ibs.dbo.cambios_precio t1 inner join maestro_productos t2 on t1.codigo = t2.codigo

GO

