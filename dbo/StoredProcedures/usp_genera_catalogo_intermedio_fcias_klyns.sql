CREATE PROCEDURE usp_genera_catalogo_intermedio_fcias_klyns
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

--declare @x_dummy money
--set @x_dummy = 0.82

select	t2.codigo
into	#codigos
from	maestro_productos_baan t1 inner join dboferta t2 on
		t1.codigo =  t2.codigo and
		t2.bolsa =  @primer_bolsa
where	convert(int, t1.codigo) < dbo.gobierno() and
		isnumeric(t1.cod_barras) = 1 and
		substring(t1.status, 1, 1) <> 'B' and 
		t2.sucursal = @sucursal

select	LPSROM, 
		LPPRDC, 
		existencia
into	#existencia
from	openquery	([as400], 
'SELECT	LPSROM, 
		LPPRDC, 
		SUM(LPLOQT) AS "Existencia" 
FROM    MA4620EF04.WHOLOP AS WHOLOP 
WHERE   WHOLOP.LPLZON NOT IN (''AA'',''DC'',''DP'',''ME'',''50'',''51'') AND 
		WHOLOP.LPSROM = ''01G''
GROUP BY 
		LPSROM, 
		LPPRDC')
		
select	t1.cod_barras,
		t1.codigo,
		t1.clas_fis, 
		case t1.grupo_est 
			when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5)
			else t1.prec_farm
		end precio,
				case
			when t1.iva = 0.00 then 1
			else 1.16
		end iva,
		case
			when t1.clas_fis in ('N', 'NA') and t1.clas_ssa in (1, 2, 3) then 0.85
			when t1.clas_fis in ('N', 'NA') and t1.clas_ssa not in (1, 2, 3) then 1.00
			when t1.clas_fis in ('B', 'BA') then 0.7790
			when t1.clas_fis in ('H', 'HA') and t1.codigo in (select codigo from cat_lacteos) then 0.85
			when t1.clas_fis in ('H', 'HA') and t1.codigo not in (select codigo from cat_lacteos) then 0.82
		end VALOR1,
		case
			when t2.cant_base = 0 and t2.cant_oferta = 0 then 1 - convert(money, t2.porcentaje)
			when t2.cant_base > 0 and t2.cant_oferta > 0 then 1 - (convert(money, t2.cant_oferta) / (convert(money, t2.cant_base) + convert(money, t2.cant_oferta)))
			else 1 - convert(money, t2.porcentaje * 100)
		end oferta
into	#tabla1
from	maestro_productos_baan t1 inner join dboferta t2 on
		t1.codigo =  t2.codigo and
		t2.bolsa =  @primer_bolsa
where	convert(int, t1.codigo) < dbo.gobierno() and
		isnumeric(t1.cod_barras) = 1 and
		substring(t1.status, 1, 1) <> 'B' and 
		t2.sucursal = @sucursal
insert into	#tabla1 
			(cod_barras, 
			codigo, 
			t1.clas_fis, 
			precio, 
			iva, 
			valor1, 
			oferta)(
select	t1.cod_barras,
		t1.codigo,
		t1.clas_fis, 
		case t1.grupo_est 
			when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5)
			else t1.prec_farm
		end precio,
				case
			when t1.iva = 0.00 then 1
			else 1.16
		end iva, 
		case
			when t1.clas_fis in ('N', 'NA') and t1.clas_ssa in (1, 2, 3) then 0.85
			when t1.clas_fis in ('N', 'NA') and t1.clas_ssa not in (1, 2, 3) then 1.00
			when t1.clas_fis in ('B', 'BA') then 0.7790
			when t1.clas_fis in ('H', 'HA') and t1.codigo in (select codigo from cat_lacteos) then 0.85
			when t1.clas_fis in ('H', 'HA') and t1.codigo not in (select codigo from cat_lacteos) then 0.82
		end VALOR1,
		1.00 oferta
from	maestro_productos_baan t1 
where	convert(int, t1.codigo) < dbo.gobierno() and
		isnumeric(t1.cod_barras) = 1 and
		substring(t1.status, 1, 1) <> 'B' and
		t1.codigo not in (	select	codigo 
							from	#codigos)
		)
		
--select cod_barras, codigo, clas_fis, precio, iva, valor1, oferta, (precio * iva * valor1 * oferta) preciofinal from	#tabla1

update	pedidos_solicitud_klyns
set		preciofactmarzam = convert(money, cast(round(t2.precio * t1.cant_ped, 2, 1) as decimal(18, 2))),
		preciofinalmarzam = convert(money, cast(round(t2.precio * t2.iva * t2.valor1 * t2.oferta * t1.cant_ped, 2, 1) as decimal(18, 2)))
from 	pedidos_solicitud_klyns t1 inner join #tabla1 t2 on
		t1.codigo = t2.codigo inner join #existencia t3 on
		t1.codigo = t3.LPPRDC
		
drop table #codigos
drop table #tabla1
drop table #existencia

GO

