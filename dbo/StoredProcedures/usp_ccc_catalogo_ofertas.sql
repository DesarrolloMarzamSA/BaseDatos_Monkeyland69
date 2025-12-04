


--exec usp_ccc_catalogo_ofertas 24
CREATE procedure [dbo].[usp_ccc_catalogo_ofertas] @sucursal tinyint
as


--encabezado cada 66 líneas
create table #resultados(texto varchar(100), linea int identity(1,1), primary key(linea))
create table #ofertas(texto varchar(100), lab_largo char(100))

declare @descripcion_sucursal varchar(24)
select @descripcion_sucursal = left(' SUC. ' + upper(descripcion) + '                        ', 24) from sucursales where sucursal = @sucursal
declare @contador int
select @contador = 0
declare @lab_largo char(100)
declare @lab_descripcion char(100)
declare @texto char(100)
declare @hoja int
select @hoja = 1
declare @hora varchar(8)
select @hora = substring(convert(varchar(20), current_timestamp, 121), 12, 8)
declare @fecha varchar(11)
select @fecha = upper(substring(convert(varchar(11), current_timestamp, 113), 1, 2) + '/' + substring(convert(varchar(11), current_timestamp, 113), 4, 3) + '/' + substring(convert(varchar(11), current_timestamp, 113), 8, 4) )
declare @encabezado1 varchar(100)
declare @encabezado2 varchar(100)
declare @encabezado3 varchar(100)
declare @encabezado4 varchar(100)
declare @encabezado5 varchar(100)
declare @encabezado6 varchar(100)
declare @encabezado7 varchar(100)

select @encabezado1 = @fecha + '     CASA MARZAM, S.A. DE C.V.   SUC:  **' + @descripcion_sucursal + '**     HOJA:  ' + right('   ' + convert(varchar(3), @hoja), 3)
select @encabezado2 = '                  CATALOGO DE OFERTAS VIGENTES CLASIF. POR PROVEEDOR   (ETICO)       ' + @hora
select @encabezado3 = 'PROG: SBOFE421         PARA USO EXCLUSIVO DE LOS AGENTES DE VENTAS MARZAM'
select @encabezado4 = '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
select @encabezado5 = '  CODIGO                                           P  R  E  C  I  O    CANT   PZAS         CL'
select @encabezado6 = ' PRODUCTO    D  E  S  C  R  I  P  C  I  O  N      FARMACIA    PUBLICO  BASE   S/C    %     FI'
select @encabezado7 = ' ~~~~~~~~   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     ~~~~~~~~    ~~~~~~~  ~~~~   ~~~~  ~~~~~  ~~'


insert into #resultados(texto) values(@encabezado1)
insert into #resultados(texto) values(@encabezado2)
insert into #resultados(texto) values(@encabezado3)
insert into #resultados(texto) values(@encabezado4)
insert into #resultados(texto) values(@encabezado5)
insert into #resultados(texto) values(@encabezado6)
insert into #resultados(texto) values(@encabezado7)

insert into #ofertas
select
'  ' +
left(t1.codigo, 5) + '-' + right(t1.codigo, 2) + '  ' +
left(t2.descripcion + '                                 ', 33) + '     ' +
left(right('        ' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_farm + (t2.prec_farm * 0.5) else t2.prec_farm end), 11), 8) + '   ' +
left(right('        ' + convert(varchar(15), case t2.grupo_est when 'PC01A' then t2.prec_pub + (t2.prec_pub * 0.5) else t2.prec_pub end), 11), 8) + '  ' +
case cant_base when 0 then '   1' else right('    ' + convert(varchar(4), t1.cant_base), 4) end + '   ' +
case t1.cant_oferta when 0 then '    ' else right('    ' + convert(varchar(4), t1.cant_oferta), 4) end + '  ' +
right('     ' + convert(varchar(5), t1.porcentaje * 100), 5) + '  ' +
right('  ' + t2.clas_fis, 2),
' ' + t2.cod_lab + ' ' + t2.lab_largo laboratorio
from 
dboferta t1 inner join maestro_productos_baan t2 on t1.codigo = t2.codigo
where
t1.sucursal = 1 and
t1.bolsa = 'LIBRE'
-- Agregado al original by aacosta 28/06/2013 filtro para omitir clientes VIP
and t1.codigo not between 3200000 and 3799999
and t1.codigo not between 7500000 and 7900000
and t1.codigo not between 8000000 and 8999999
and t1.codigo not between 9000002 and 9000024
---------------------------------------------
order by
' ' + t2.cod_lab + ' ' + t2.lab_largo asc

declare cursor_laboratorios cursor fast_forward for select distinct lab_largo, right(lab_largo, 94) lab_descripcion from #ofertas order by right(lab_largo, 94) asc
open cursor_laboratorios 
fetch next from cursor_laboratorios into @lab_largo, @lab_descripcion
while @@fetch_status = 0
begin
	insert into #resultados(texto) values(@lab_largo)
	select @contador = @contador + 1
	declare cursor_productos cursor fast_forward for select texto from #ofertas where lab_largo = @lab_largo
	open cursor_productos
	fetch next from cursor_productos into @texto
	while @@fetch_status = 0
	begin
		insert into #resultados(texto) values(@texto)
		select @contador = @contador + 1
		if(@contador >= 66)
		begin
			select @contador = 0
			select @hoja = @hoja + 1
			insert into #resultados(texto) values(replicate(100, ' '))
			select @encabezado1 = @fecha + '     CASA MARZAM, S.A. DE C.V.   SUC:  **' + @descripcion_sucursal + '**     HOJA:  ' + right('   ' + convert(varchar(3), @hoja), 3)
			insert into #resultados(texto) values(@encabezado1)
			insert into #resultados(texto) values(@encabezado2)
			insert into #resultados(texto) values(@encabezado3)
			insert into #resultados(texto) values(@encabezado4)
			insert into #resultados(texto) values(@encabezado5)
			insert into #resultados(texto) values(@encabezado6)
			insert into #resultados(texto) values(@encabezado7)
		end
		fetch next from cursor_productos into @texto
	end
	close cursor_productos
	deallocate cursor_productos
	select @contador = @contador + 1
	insert into #resultados(texto) values(replicate(100, ' '))
	if(@contador >= 66)
	begin
		select @contador = 0
		select @hoja = @hoja + 1
		insert into #resultados(texto) values(replicate(100, ' '))
		select @encabezado1 = @fecha + '     CASA MARZAM, S.A. DE C.V.   SUC:  **' + @descripcion_sucursal + '**     HOJA:  ' + right('   ' + convert(varchar(3), @hoja), 3)
		insert into #resultados(texto) values(@encabezado1)
		insert into #resultados(texto) values(@encabezado2)
		insert into #resultados(texto) values(@encabezado3)
		insert into #resultados(texto) values(@encabezado4)
		insert into #resultados(texto) values(@encabezado5)
		insert into #resultados(texto) values(@encabezado6)
		insert into #resultados(texto) values(@encabezado7)
	end
	fetch next from cursor_laboratorios into @lab_largo, @lab_descripcion
end

close cursor_laboratorios
deallocate cursor_laboratorios

select * from #resultados
drop table #resultados
drop table #ofertas

GO

