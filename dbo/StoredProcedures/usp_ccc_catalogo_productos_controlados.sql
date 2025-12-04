
--exec [usp_ccc_catalogo_productos_normales] 1
CREATE  procedure [dbo].[usp_ccc_catalogo_productos_controlados] @sucursal tinyint
as

set nocount on
declare @contador int
select @contador = 1
declare @contador_hojas int
select @contador_hojas= 0
declare @total_hojas int
declare @total_lineas int

declare @contador_maestro int
select @contador_maestro = 0
declare @texto varchar(75)
declare @hoja int
select @hoja = 1
declare @fecha varchar(9)
select @fecha = upper(substring(convert(varchar(11), current_timestamp, 113), 1, 2) + '/' + substring(convert(varchar(11), current_timestamp, 113), 4, 3) + '/' + substring(convert(varchar(11), current_timestamp, 113), 10, 2) )
declare @encabezado1 varchar(100)
declare @encabezado2 varchar(100)
declare @encabezado3 varchar(100)
declare @encabezado4 varchar(100)
select @encabezado1 = '   PAG :' + right('   ' + convert(varchar(3), @hoja), 3) + '  CATALOGO CON PIEZAS POR CAJA ORIGINAL  ' + @fecha + '           '
select @encabezado2 = '                                         PZAS    P R E C I O S   CL TP  '
select @encabezado3 = '    Codigo    Producto  Descripcion      CAJA   Farmacia Publico FS R   '
select @encabezado4 = ' '

--56 por hoja
create table #resultados(texto varchar(75), linea int identity(1,1), primary key(linea))
create table #productos(texto varchar(75), linea int identity(1,1))
create table #productos_controlados(texto varchar(75), linea int identity(1,1))
insert into #productos(texto)
select
right('     ' + convert(varchar(5), convert(int, left(t1.codigo, 5))), 5) + '-' + right(t1.codigo, 2) + ' ' +
left(t1.descripcion + '                                 ', 30) + '  ' +
right('    ' + convert(varchar(4), t1.pzas_empaque_original), 4) + 
left(right('        ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_farm + (t1.prec_farm * 0.5) else t1.prec_farm end), 11), 8) + '  ' +
left(right('        ' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 11), 8) + '  ' +
--left(t1.clas_fis + '   ', 3) +
left(ltrim(rtrim(p.PGPCA5))+ '   ', 3) +
case clas_ssa 
when 1 then 'C'
when 2 then 'C'
when 3 then 'C'
when 4 then 'E'
when 5 then 'O'
when 6 then 'O'
when 7 then 'M'
when 8 then 'P'
when 9 then 'M'
else 'M' 
end
from 
maestro_productos_baan t1 inner join inventario_baan_sin_filtro t2 on t1.codigo = t2.codigo
--inner join AS400.S101FEBT.MA4620EF04.SROPRG p ON t1.codigo=rtrim(ltrim(p.PGPRDC))
inner join AS400.[S78E2DC0].MA4620EF04.SROPRG p ON t1.codigo=rtrim(ltrim(p.PGPRDC))
where
t2.sucursal = @sucursal and
substring(t2.status, 1, 1) <> 'B' and
t1.clas_ssa in (1,2,3)
-- Agregado al original by aacosta 28/06/2013 filtro para omitir clientes VIP
and t1.codigo not between 3200000 and 3799999
and t1.codigo not between 7500000 and 7900000
and t1.codigo not between 8000000 and 8999999
and t1.codigo not between 9000002 and 9000024
---------------------------------------------
order by
t1.descripcion asc

insert into #resultados(texto) values(@encabezado1)
insert into #resultados(texto) values(@encabezado2)
insert into #resultados(texto) values(@encabezado3)
insert into #resultados(texto) values(@encabezado4)

declare cursor_ccc cursor fast_forward for select texto from #productos order by linea asc
open cursor_ccc
fetch next from cursor_ccc into @texto
while @@fetch_status = 0
begin
	insert into #resultados(texto) values(@texto)
	select @contador= @contador + 1
	if(@contador = 57)
	begin
		select @hoja = @hoja + 1
		select @encabezado1 = '   PAG :' + right('   ' + convert(varchar(3), @hoja), 3) + '  CATALOGO CON PIEZAS POR CAJA ORIGINAL  ' + @fecha + '           '
		select @encabezado2 = '                                         PZAS    P R E C I O S   CL TP  '
		select @encabezado3 = '    Codigo    Producto  Descripcion      CAJA   Farmacia Publico FS R   '
		select @encabezado4 = ' '
		insert into #resultados(texto) values(' ')
		insert into #resultados(texto) values(@encabezado1)
		insert into #resultados(texto) values(@encabezado2)
		insert into #resultados(texto) values(@encabezado3)
		insert into #resultados(texto) values(@encabezado4)
		select @contador= 1
	end
	fetch next from cursor_ccc into @texto
end

close cursor_ccc
deallocate cursor_ccc


create table #resultados2(texto1 varchar(100), texto2 varchar(100), linea int)
select texto, linea, convert(int, linea / 122) + 1 pagina into #paginado from #resultados
select @total_hojas = max(pagina) from #paginado
select @hoja = 1


while @hoja <= @total_hojas
begin
	insert into #resultados2(texto1, linea) select texto, linea from #paginado where pagina = @hoja
	select @hoja = @hoja + 2
end

update #resultados2 set texto2 = t2.texto from #resultados2 t1 inner join #paginado t2 on t1.linea + 122 = t2.linea 

select right(replicate(69, ' ') + texto1, 69) + '       ' + right(replicate(69, ' ') + isnull(texto2, ' '), 69) from #resultados2

drop table #paginado
drop table #resultados
drop table #resultados2 
set nocount off

GO

