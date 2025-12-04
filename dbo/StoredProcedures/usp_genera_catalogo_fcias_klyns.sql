CREATE PROCEDURE usp_genera_catalogo_fcias_klyns 

	@sucursal TINYINT,
	@primer_bolsa  as varchar(5),
	@segunda_bolsa  as varchar(5)    
as

--declare @sucursal tinyint
--declare @primer_bolsa  as varchar(5)  
--declare @segunda_bolsa  as varchar(5)  
--set @sucursal = 7
--set @primer_bolsa = 'LIBRE'
--set @segunda_bolsa = 'XXXXX'

declare @x_dummy money
set @x_dummy = 0.82

select	t2.codigo
into	#codigos
from	maestro_productos_baan t1 inner join dboferta t2 on
		t1.codigo =  t2.codigo and
		t2.bolsa =  @primer_bolsa
where	convert(int, t1.codigo) < dbo.gobierno() and
		isnumeric(t1.cod_barras) = 1 and
		substring(t1.status, 1, 1) <> 'B' and 
		t2.sucursal = @sucursal
		
select	'A' +
		right(replicate('0', 16) + convert(varchar(16), convert(bigint, t1.cod_barras)), 16) +
		right(replicate('0', 16) + convert(varchar(16), convert(bigint, t1.codigo)), 16) +
		left(t1.descripcion + replicate(' ', 50), 50) + 
		left(t1.lab_largo + replicate(' ', 20), 20) + 
		'1' + 
		case
				when t1.refrigerado = 'R' then '1'
				else '0'
		end +
		case
			when t1.clas_ssa in (1, 2, 3) then '1'
			else '0'
		end +
		'PZA       ' + 
		'001' + 
		case
			when clas_ssa in ('1', '2', '3', '4', '5', '6') then '1'
			else '0'
		end + 
		'0' + 
		case t1.grupo_est 
			when 'PC01A' then right(replicate('0', 9) + convert(varchar(9), t1.prec_farm + (t1.prec_farm * 0.5)), 9)
			else right(replicate('0', 9) + convert(varchar(9), t1.prec_farm), 9)
		end +
		right(replicate('0', 9) + convert(varchar, t1.prec_pub), 9) + 
		case
			when t1.iva = 0.00 then '0'
			else '1'
		end +
		right(replicate('0', 5) + convert(varchar(5), t1.iva * 100), 5) INICIO, 
		case
			when t1.clas_fis in ('N', 'NA') and t1.clas_ssa in (1, 2, 3) then 15.00
			when t1.clas_fis in ('N', 'NA') and t1.clas_ssa not in (1, 2, 3) then 0.00
			when t1.clas_fis in ('B', 'BA') then 22.10
			when t1.clas_fis in ('H', 'HA') and t1.codigo in (select codigo from cat_lacteos) then 15.00
			when t1.clas_fis in ('H', 'HA') and t1.codigo not in (select codigo from cat_lacteos) then 18.00
		end VALOR1,
		t1.clas_fis clas_fis,
		t1.clas_ssa clas_ssa,
		t1.cod_barras,
		'001' + 
		case
			when t2.cant_base = 0 and t2.cant_oferta = 0 then right(replicate('0', 5) + convert(varchar(5), convert(money, t2.porcentaje * 100)), 5)
			when t2.cant_base > 0 and t2.cant_oferta > 0 then right(replicate('0', 5) + convert(varchar(5), (convert(money, t2.cant_oferta) / (convert(money, t2.cant_base) + convert(money, t2.cant_oferta))) * 100), 5)
			else right(replicate('0', 5) + convert(varchar(5), convert(money, t2.porcentaje * 100)), 5)
		end +
		'00.00' + 
		'00.00' + 
		convert(varchar, getdate(), 112) FIN
		into   #tabla1
from	maestro_productos_baan t1 inner join dboferta t2 on
		t1.codigo =  t2.codigo and
		t2.bolsa =  @primer_bolsa 
where	convert(int, t1.codigo) < dbo.gobierno() and
		isnumeric(t1.cod_barras) = 1 and
		t2.sucursal = @sucursal and
		t1.codigo not in (select codigo from Capa_ibs.dbo.maestro_bajas)
insert into	#tabla1 (inicio, valor1, clas_fis, clas_ssa, cod_barras,fin)  (
select	'A' +
		right(replicate('0', 16) + convert(varchar(16), convert(bigint, t1.cod_barras)), 16) +
		right(replicate('0', 16) + convert(varchar(16), convert(bigint, t1.codigo)), 16) +
		left(t1.descripcion + replicate(' ', 50), 50) + 
		left(t1.lab_largo + replicate(' ', 20), 20) + 
		'1' + 
		case
				when t1.refrigerado = 'R' then '1'
				else '0'
		end +
		case
			when t1.clas_ssa in (1, 2, 3) then '1'
			else '0'
		end +
		'PZA       ' + 
		'001' + 
		case
			when clas_ssa in ('1', '2', '3', '4', '5', '6') then '1'
			else '0'
		end + 
		'0' + 
		case t1.grupo_est 
			when 'PC01A' then right(replicate('0', 9) + convert(varchar(9), t1.prec_farm + (t1.prec_farm * 0.5)), 9)
			else right(replicate('0', 9) + convert(varchar(9), t1.prec_farm), 9)
		end +
		right(replicate('0', 9) + convert(varchar, t1.prec_pub), 9) + 
		case
			when t1.iva = 0.00 then '0'
			else '1'
		end +
		right(replicate('0', 5) + convert(varchar(5), t1.iva * 100), 5) INICIO,
		case
			when t1.clas_fis in ('N', 'NA') and t1.clas_ssa in (1, 2, 3) then 15.00
			when t1.clas_fis in ('N', 'NA') and t1.clas_ssa not in (1, 2, 3) then 0.00
			when t1.clas_fis in ('B', 'BA') then 22.10
			when t1.clas_fis in ('H', 'HA') and t1.codigo in (select codigo from cat_lacteos) then 15.00
			when t1.clas_fis in ('H', 'HA') and t1.codigo not in (select codigo from cat_lacteos) then 18.00
		end VALOR1, 
		t1.clas_fis,
		t1.clas_ssa, 
		t1.cod_barras,
		'001' + 
		'00.00' +
		'00.00' + 
		'00.00' + 
		convert(varchar, getdate(), 112) FIN
from	maestro_productos_baan t1 
where	convert(int, t1.codigo) < dbo.gobierno() and
		isnumeric(t1.cod_barras) = 1 and
		substring(t1.status, 1, 1) <> 'B' and
		t1.codigo not in (select codigo from #codigos) and
		t1.codigo not in (select codigo from Capa_ibs.dbo.maestro_bajas)
		)
select	inicio + 
		right(replicate('0', 5) + convert(varchar(5), convert(money, valor1)), 5) + 
		'00.00' + 
		'00.00' +
		fin
from	#tabla1
drop table #codigos
drop table #tabla1

GO

