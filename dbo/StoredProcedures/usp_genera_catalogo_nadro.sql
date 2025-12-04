


CREATE  procedure [dbo].[usp_genera_catalogo_nadro]
as
declare @descuento as money
select @descuento = descuento from clientes_baan where sucursal = 1 and cliente = '74590'


CREATE TABLE #nadrito(
	texto varchar(155) NULL,
	codigo varchar(7) NULL,
	fecha_hora datetime NULL
) 

insert into #nadrito 
select
'C' +
t1.codigo + ' ' +
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6)       THEN '1'
       WHEN t1.clas_ssa    IN(7,8,9)             THEN '2' 
       ELSE '2'  END +
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6)       THEN 'A'
       WHEN t1.clas_ssa    IN(7,8,9)             THEN 'M' 
       ELSE 'M'  END +
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6)       THEN 'A'
       WHEN t1.clas_ssa    IN(7,8,9)             THEN 'Z' 
       ELSE 'Z'  END + 
--' ' + --descuento a,b, c 1%, 2%, 3%...
+
case 
when t1.clas_fis in ('N', 'NA') then '0'
when t1.clas_fis in ('B', 'BA') then 
	case round(@descuento, 0) 
		when 0  then '0'
		when 1  then 'A'
		when 2  then 'B'
		when 3  then 'C'
		when 4  then 'D'
		when 5  then 'E'
		when 6  then 'F'
		when 7  then 'G'
		when 8  then 'H'
		when 9  then 'I'
		when 10 then 'J'
		when 11 then 'K'
		when 12 then 'L'
		when 13 then 'M'
		when 14 then 'N'
		when 15 then 'O'
		when 16 then 'P'
		when 17 then 'Q'
		when 18 then 'R'
		when 19 then 'S'
		when 20 then 'T'
		when 21 then 'U'
		when 22 then 'V'
		when 23 then 'W'
		when 24 then 'X'
		when 25 then 'Y'
		when 26 then 'Z'
	end
when t1.clas_fis in ('H', 'HA') then  
	case round(t1.descto_prod, 0)
		when 0  then '0'
		when 1  then 'A'
		when 2  then 'B'
		when 3  then 'C'
		when 4  then 'D'
		when 5  then 'E'
		when 6  then 'F'
		when 7  then 'G'
		when 8  then 'H'
		when 9  then 'I'
		when 10 then 'J'
		when 11 then 'K'
		when 12 then 'L'
		when 13 then 'M'
		when 14 then 'N'
		when 15 then 'O'
		when 16 then 'P'
		when 17 then 'Q'
		when 18 then 'R'
		when 19 then 'S'
		when 20 then 'T'
		when 21 then 'U'
		when 22 then 'V'
		when 23 then 'W'
		when 24 then 'X'
		when 25 then 'Y'
		when 26 then 'Z'
	end
end
+ 
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6,7)     THEN '1'
       WHEN t1.clas_ssa    IN(8,9)               THEN '0' 
       ELSE '0'  END + --caduca?
case t1.refrigerado when 'R' then 'S' else 'N' end  + 
convert(varchar(1), t1.clas_ssa) + 
case when t1.clas_fis in ('BA', 'NA', 'HA') then '2' else '4' end +
left(t1.descripcion + '                                   ', 35) +
left(t1.lab_corto + '          ', 10)  +
left(right('000000000000' + convert(varchar(12), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 13), 10)  +
left(right('000000000000' + convert(varchar(12), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 13), 10) +
right('00' + convert(varchar(10), convert(money, ((t1.prec_pub - t1.prec_farm) / t1.prec_pub) * 100)), 5) +
'00001' +
'00001' +
right('0000000000000' + t1.cod_barras, 13) +
'0000000000000'+
'00000' + 
'00000000000000' + 
'00000' + 
convert(varchar(8), current_timestamp, 3),
t1.codigo,
t2.fecha_hora
from maestro_productos_baan t1 inner join dbcataut t3 on t1.codigo = t3.codigo 
inner join cambios_precio_baan t2 on t1.codigo = t2.t_item
where
datediff(d, t2.fecha_hora, current_timestamp) < 10 and
isnumeric(t1.cod_barras) = 1 and 
t1.status not like 'B%' and 
convert(bigint, t1.codigo) < dbo.gobierno() and
t3.segmento = 'C1' and
t3.cadena = '868' and
t3.status = 'A'

union
select
'B' +
t1.codigo + ' ' +
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6)       THEN '1'
       WHEN t1.clas_ssa    IN(7,8,9)             THEN '2' 
       ELSE '2'  END +
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6)       THEN 'A'
       WHEN t1.clas_ssa    IN(7,8,9)             THEN 'M' 
       ELSE 'M'  END +
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6)       THEN 'A'
       WHEN t1.clas_ssa    IN(7,8,9)             THEN 'Z' 
       ELSE 'Z'  END + 
--' ' + --descuento a,b, c 1%, 2%, 3%...
+
case 
when t1.clas_fis in ('N', 'NA') then '0'
when t1.clas_fis in ('B', 'BA') then 
	case round(@descuento, 0) 
		when 0  then '0'
		when 1  then 'A'
		when 2  then 'B'
		when 3  then 'C'
		when 4  then 'D'
		when 5  then 'E'
		when 6  then 'F'
		when 7  then 'G'
		when 8  then 'H'
		when 9  then 'I'
		when 10 then 'J'
		when 11 then 'K'
		when 12 then 'L'
		when 13 then 'M'
		when 14 then 'N'
		when 15 then 'O'
		when 16 then 'P'
		when 17 then 'Q'
		when 18 then 'R'
		when 19 then 'S'
		when 20 then 'T'
		when 21 then 'U'
		when 22 then 'V'
		when 23 then 'W'
		when 24 then 'X'
		when 25 then 'Y'
		when 26 then 'Z'
	end
when t1.clas_fis in ('H', 'HA') then  
	case round(t1.descto_prod, 0)
		when 0  then '0'
		when 1  then 'A'
		when 2  then 'B'
		when 3  then 'C'
		when 4  then 'D'
		when 5  then 'E'
		when 6  then 'F'
		when 7  then 'G'
		when 8  then 'H'
		when 9  then 'I'
		when 10 then 'J'
		when 11 then 'K'
		when 12 then 'L'
		when 13 then 'M'
		when 14 then 'N'
		when 15 then 'O'
		when 16 then 'P'
		when 17 then 'Q'
		when 18 then 'R'
		when 19 then 'S'
		when 20 then 'T'
		when 21 then 'U'
		when 22 then 'V'
		when 23 then 'W'
		when 24 then 'X'
		when 25 then 'Y'
		when 26 then 'Z'
	end
end
+ 
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6,7)     THEN '1'
       WHEN t1.clas_ssa    IN(8,9)               THEN '0' 
       ELSE '0'  END + --caduca?
case t1.refrigerado when 'R' then 'S' else 'N' end  + 
convert(varchar(1), t1.clas_ssa) + 
case when t1.clas_fis in ('BA', 'NA', 'HA') then '2' else '4' end +
left(t1.descripcion + '                                   ', 35) +
left(t1.lab_corto + '          ', 10)  +
left(right('000000000000' + convert(varchar(12), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 13), 10)  +
left(right('000000000000' + convert(varchar(12), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 13), 10) +
right('00' + convert(varchar(10), convert(money, ((t1.prec_pub - t1.prec_farm) / t1.prec_pub) * 100)), 5) +
'00001' +
'00001' +
right('0000000000000' + t1.cod_barras, 13) +
'0000000000000'+
'00000' + 
'00000000000000' + 
'00000' + 
convert(varchar(8), current_timestamp, 3),
t1.codigo,
t1.fecha_baja
from maestro_productos_baan t1 inner join dbcataut t3 on t1.codigo = t3.codigo 
where
datediff(d, t1.fecha_baja, current_timestamp) < 10 and
isnumeric(t1.cod_barras) = 1 and 
/*t3.segmento = 'C1' and
t3.cadena = '868' and
t3.status = 'A' and*/
convert(bigint, t1.codigo) < dbo.gobierno() 

union

select
'A' +
t1.codigo + ' ' +
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6)       THEN '1'
       WHEN t1.clas_ssa    IN(7,8,9)             THEN '2' 
       ELSE '2'  END +
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6)       THEN 'A'
       WHEN t1.clas_ssa    IN(7,8,9)             THEN 'M' 
       ELSE 'M'  END +
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6)       THEN 'A'
       WHEN t1.clas_ssa    IN(7,8,9)             THEN 'Z' 
       ELSE 'Z'  END + 
--' ' + --descuento a,b, c 1%, 2%, 3%...
+
case 
when t1.clas_fis in ('N', 'NA') then '0'
when t1.clas_fis in ('B', 'BA') then 
	case round(@descuento, 0) 
		when 0  then '0'
		when 1  then 'A'
		when 2  then 'B'
		when 3  then 'C'
		when 4  then 'D'
		when 5  then 'E'
		when 6  then 'F'
		when 7  then 'G'
		when 8  then 'H'
		when 9  then 'I'
		when 10 then 'J'
		when 11 then 'K'
		when 12 then 'L'
		when 13 then 'M'
		when 14 then 'N'
		when 15 then 'O'
		when 16 then 'P'
		when 17 then 'Q'
		when 18 then 'R'
		when 19 then 'S'
		when 20 then 'T'
		when 21 then 'U'
		when 22 then 'V'
		when 23 then 'W'
		when 24 then 'X'
		when 25 then 'Y'
		when 26 then 'Z'
	end
when t1.clas_fis in ('H', 'HA') then  
	case round(t1.descto_prod, 0)
		when 0  then '0'
		when 1  then 'A'
		when 2  then 'B'
		when 3  then 'C'
		when 4  then 'D'
		when 5  then 'E'
		when 6  then 'F'
		when 7  then 'G'
		when 8  then 'H'
		when 9  then 'I'
		when 10 then 'J'
		when 11 then 'K'
		when 12 then 'L'
		when 13 then 'M'
		when 14 then 'N'
		when 15 then 'O'
		when 16 then 'P'
		when 17 then 'Q'
		when 18 then 'R'
		when 19 then 'S'
		when 20 then 'T'
		when 21 then 'U'
		when 22 then 'V'
		when 23 then 'W'
		when 24 then 'X'
		when 25 then 'Y'
		when 26 then 'Z'
	end
end
+ 
CASE   WHEN t1.clas_ssa    IN(1,2,3,4,5,6,7)     THEN '1'
       WHEN t1.clas_ssa    IN(8,9)               THEN '0' 
       ELSE '0'  END + --caduca?
case t1.refrigerado when 'R' then 'S' else 'N' end  + 
convert(varchar(1), t1.clas_ssa) + 
case when t1.clas_fis in ('BA', 'NA', 'HA') then '2' else '4' end +
left(t1.descripcion + '                                   ', 35) +
left(t1.lab_corto + '          ', 10)  +
left(right('000000000000' + convert(varchar(12), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 13), 10)  +
left(right('000000000000' + convert(varchar(12), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 13), 10) +
right('00' + convert(varchar(10), convert(money, ((t1.prec_pub - t1.prec_farm) / t1.prec_pub) * 100)), 5) +
'00001' +
'00001' +
right('0000000000000' + t1.cod_barras, 13) +
'0000000000000'+
'00000' + 
'00000000000000' + 
'00000' + 
convert(varchar(8), current_timestamp, 3),
t1.codigo,
t1.fecha_alta
from maestro_productos_baan t1 inner join dbcataut t3 on t1.codigo = t3.codigo 
where
datediff(d, t1.fecha_alta, current_timestamp) < 10 and
isnumeric(t1.cod_barras) = 1 and 
/*t3.segmento = 'C1' and
t3.cadena = '868' and
t3.status = 'A' and*/
convert(bigint, t1.codigo) < dbo.gobierno() 

select codigo, max(fecha_hora) fecha_hora into #recientes from #nadrito group by codigo

select t1.texto from #nadrito t1 inner join #recientes t2 on t1.codigo = t2.codigo and t1.fecha_hora = t2.fecha_hora

GO

