CREATE procedure [dbo].[usp_farmacon_pedidos_update_ofertasv2]
	@hash_md5 varchar(50)
as
	declare @primer_bolsa  as varchar(5)
	declare @segunda_bolsa as varchar(5)
	set @primer_bolsa = 'C2599'
	set @segunda_bolsa = 'LIBRE'
update t1 set t1.sucursal = t2.sucursal ,enviado_ftp = 0
--select t1.*,t2.sucursal 
from pedidos_farmacon t1 inner join cat_farmacon t2 on substring(t1.cuenta,3,5) = t2.cuenta
where substring(t1.cuenta,1,2)='00' and t1.hash_md5=@hash_md5--'689167f33075494c22305b20cb36fd10'

update t1 set t1.sucursal = t2.sucursal ,enviado_ftp = 0
--select t1.*,t2.sucursal 
from pedidos_farmacon t1 inner join cat_farmacon t2 on substring(t1.cuenta,3,5) = t2.cuenta and 
substring(t1.cuenta,1,2)=t2.sucursal
where substring(t1.cuenta,1,2)<>'00' and t1.hash_md5=@hash_md5--'689167f33075494c22305b20cb36fd10'

select	t2.sucursal sucursal,
			t1.cod_barras cod_barras,
			case
				when cant_base = 0 and cant_oferta = 0 then porcentaje * 100 
				when cant_base > 0 and cant_oferta > 0 then (convert(money, cant_oferta) / (convert(money, cant_base) + convert(money, cant_oferta))) * 100
				else porcentaje * 100
			end porcentaje_oferta
into		#x_tabla1
from		maestro_productos_baan t1 inner join dboferta t2 on 
			t1.codigo = t2.codigo and 
			t2.bolsa = @primer_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
			t2.sucursal in (6, 16, 17, 18, 25)
select	t2.sucursal sucursal,
			t1.cod_barras cod_barras,
			case
				when cant_base = 0 and cant_oferta = 0 then porcentaje * 100 
				when cant_base > 0 and cant_oferta > 0 then (convert(money, cant_oferta) /( convert(money, cant_base) + convert(money, cant_oferta))) * 100
				else porcentaje * 100
			end porcentaje_oferta
into		#x_tabla2
from		maestro_productos_baan t1 inner join  dboferta t2 on 
			t1.codigo = t2.codigo and 
			t2.bolsa = @segunda_bolsa
where	convert(int, t1.codigo) < dbo.gobierno() and
			t2.sucursal in (6, 16, 17, 18, 25)
--select	*
--into		#inventario_farmacon_actual
--from		inventario_farmacon

--create index idx_x_tabla1_temp on #x_tabla1(sucursal, cod_barras)
			
update	pedidos_farmacon 
set		porcentaje_oferta_dboferta = t2.porcentaje_oferta
from		pedidos_farmacon t1 inner join #x_tabla1 t2 on
			t1.sucursal = t2.sucursal and
			t1.cod_barras = t2.cod_barras and
			t1.hash_md5 = @hash_md5
			
--create index idx_x_tabla2_temp on #x_tabla2(sucursal, cod_barras, porcentaje_oferta_dboferta)
			
update	pedidos_farmacon 
set		porcentaje_oferta_dboferta = t2.porcentaje_oferta
from		pedidos_farmacon t1 inner join #x_tabla2 t2 on
			t1.sucursal = t2.sucursal and
			t1.cod_barras = t2.cod_barras and
			t1.poferta <> t1.porcentaje_oferta_dboferta and
			t1.hash_md5 = @hash_md5

update	pedidos_farmacon 
set		enviado_ftp = 1 
where	poferta <> porcentaje_oferta_dboferta and
			hash_md5 = @hash_md5

update	pedidos_farmacon 
set		enviado_ftp = 1
from		pedidos_farmacon t1 inner join maestro_productos_baan t2 on
			convert(bigint, t1.cod_barras) = convert(bigint, t2.cod_barras)
where	t1.hash_md5 = @hash_md5 and 
			t2.grupo_est = 'PF01D'
--update	pedidos_farmacon
--set		enviado_ftp = 1, 
--			motivo_no_surtido = 7
--from		pedidos_farmacon t1 inner join #inventario_farmacon_actual t2 on
--			t1.sucursal = t2.sucursal and
--			convert(bigint, t1.cod_barras) = convert(bigint, t2.cod_barras)
--where	t2.piezas = 0
--update	pedidos_farmacon 
--set		codigo = t2.codigo 
--from		pedidos_farmacon t1 inner join maestro_productos_baan t2 on 
--			right('0000000000000' + replace(t1.cod_barras, ' ', ''), 13) = t2.cod_barras 
--where	t1.cod_barras <> '0000000000000' and 
--			tftp is null and 
--			convert(bigint, t2.codigo) < dbo.gobierno()
--update	pedidos_farmacon
--set		motivo_no_surtido = 7,
--			enviado_ftp = 1
--where	codigo is null

GO

