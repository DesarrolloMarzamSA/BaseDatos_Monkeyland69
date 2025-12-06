
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_pedidos_express_clientes_ofertas]

as
set nocount on
create table #clientes_ofertas(
sucursal tinyint NOT NULL,
cte_cod varchar(6) NOT NULL,
bolsa varchar(5) NOT NULL,
primary key(sucursal, cte_cod, bolsa))


declare @sucursal tinyint
declare @cte_cod varchar(6)
declare @bolsa varchar(5)


create table #clientes_baan(
	sucursal tinyint NOT NULL,
	cte_cod varchar(6) NOT NULL,
	agen_cod varchar(10) NULL,
	agen_nombre varchar(60) NULL,
	cte_nombre varchar(50) NULL,
	direccion varchar(50) NULL,
	colonia varchar(50) NULL,
	municipio varchar(50) NULL,
	estado varchar(50) NULL,
	cred_limite money NULL,
	cred_usado money NULL,
	tipo varchar(50) NULL,
	rfc varchar(50) NULL,
	status varchar(50) NULL/*,
	primary key(cte_cod)*/)  

create index idx_clientes_baan_temp1 on #clientes_baan(status)
create index idx_clientes_baan_temp2 on #clientes_baan(cte_cod)

insert into #clientes_baan select
t3.almacen sucursal,
convert(varchar(6), t3.letra_baan + t1.cliente)  cte_cod,
t1.agen_cod,
t1.agen_nombre,
t1.farmacia cte_nombre,
t1.direccion,
t1.colonia,
t1.poblacion municipio,
t2.descripcion estado,
t1.limite cred_limite,
t1.usado cred_usado,
t1.tipo,
t1.rfc,
t1.status
from
monkeyland.dbo.clientes_baan t1 inner join monkeyland.dbo.estados t2 on convert(tinyint, t1.cve_estado) = t2.cve_estado
inner join monkeyland.dbo.sucursales t3 on t1.sucursal = t3.sucursal


--delete from #clientes_baan where tipo not in('AGR','AUT','CAD','MAY','NOR','ES1','ES2','ESP','NAV')
--delete from #clientes_baan where((status like 'LEGAL%') or(status like 'COD (BAJ%') or (status like 'CREDITO (BAJA%') or(status like 'COD CHEQUE (BA%') or(status like 'COD (CHEQUE) B%'))
--delete from #clientes_baan where(tipo in('ES1','ES2','ESP')) and(status not in('CREDITO (FALTA','CREDITO (SUSPE','COD (NORMAL)','COD CHEQUE (NO','CREDITO','CREDITO (NORMA')) 
--delete from #clientes_baan where (tipo  = 'NAV' and cred_usado <= 0.01) 
--delete from #clientes_baan where agen_cod like '%BAJA%'
--delete from #clientes_baan where (convert(int, right(cte_cod, 5)) - (convert(int, right(cte_cod, 5))/100000)*100000)/1000 = 99

insert into #clientes_ofertas
select 
t2.almacen, 
t2.letra_baan + t1.cliente, 
case bandera_libre 
when 'L' then t3.segto + t3.ctepadre else 
'LIBRE' end
from monkeyland.dbo.clientes_ofertas t1 inner join monkeyland.dbo.sucursales t2 on t1.sucursal = t2.almacen 
inner join monkeyland.dbo.clientes_baan t3 on t1.sucursal = t3.sucursal and t1.cliente = t3.cliente
union
select 
t2.almacen, 
t2.letra_baan + t1.cliente, 
case bandera_plus 
when 'P1' then 'PLUS1'
when 'P2' then 'PLUS2'
when 'P3' then 'PLUS3'
when 'P4' then 'PLUS4'
when 'P5' then 'PLUS5'
when 'P6' then 'PLUS6'
when 'P7' then 'PLUS7'
when 'P8' then 'PLUS8'
when 'P9' then 'PLUS9'
else '     '
end
from monkeyland.dbo.clientes_ofertas t1 inner join monkeyland.dbo.sucursales t2 on t1.sucursal = t2.almacen 
inner join monkeyland.dbo.clientes_baan t3 on t1.sucursal = t3.sucursal and t1.cliente = t3.cliente
where left(bandera_plus, 1) = 'P'
union
select 
t2.almacen, 
t2.letra_baan + t1.cliente, 
t1.bandera_mega 
from monkeyland.dbo.clientes_ofertas t1 inner join monkeyland.dbo.sucursales t2 on t1.sucursal = t2.almacen 
inner join monkeyland.dbo.clientes_baan t3 on t1.sucursal = t3.sucursal and t1.cliente = t3.cliente
union
select 
t2.almacen, 
t2.letra_baan + t1.cliente, 
'MG'
from monkeyland.dbo.clientes_ofertas t1 inner join monkeyland.dbo.sucursales t2 on t1.sucursal = t2.almacen 
inner join monkeyland.dbo.clientes_baan t3 on t1.sucursal = t3.sucursal and t1.cliente = t3.cliente
where
t1.bandera_mega = 'MG'

--select * from #clientes_baan where cte_cod like '%50869'
--select * from #clientes_ofertas where cte_cod like '%50869'


insert into #clientes_ofertas select t1.sucursal, t1.cte_cod, 'LIBRE' from #clientes_baan t1 left outer join #clientes_ofertas t2 on t1.cte_cod = t2.cte_cod where t2.cte_cod is null

declare cursor_clientes_ofertas cursor fast_forward for select t1.sucursal, t1.cte_cod, t1.bolsa from #clientes_ofertas t1 inner join #clientes_baan t2 on t1.sucursal = t2.sucursal and t1.cte_cod = t2.cte_cod
open cursor_clientes_ofertas
fetch next from cursor_clientes_ofertas into @sucursal, @cte_cod, @bolsa

while @@fetch_status = 0
begin
	if not exists(select sucursal from pedidos_express.dbo.clientes_ofertas where sucursal = @sucursal and cte_cod = @cte_cod and bolsa = @bolsa)
	begin
		insert into pedidos_express.dbo.clientes_ofertas(sucursal, cte_cod, bolsa) values(@sucursal, @cte_cod, @bolsa)
	end
	fetch next from cursor_clientes_ofertas into @sucursal, @cte_cod, @bolsa
end

close cursor_clientes_ofertas
deallocate cursor_clientes_ofertas

select t1.sucursal, t1.cte_cod, t1.bolsa into #limpia_clientes_ofertas from #clientes_ofertas t1 inner join #clientes_baan t2 on t1.sucursal = t2.sucursal and t1.cte_cod = t2.cte_cod

declare @seguro int
select @seguro = count(t1.sucursal) from pedidos_express.dbo.clientes_ofertas t1 left outer join #limpia_clientes_ofertas t2 on t1.sucursal = t2.sucursal and t1.cte_cod = t2.cte_cod and t1.bolsa = t2.bolsa where t2.bolsa is null or t2.bolsa = ' '

if @seguro < 100000
begin

	declare cursor_limpia_clientes_ofertas cursor fast_forward for select t1.sucursal, t1.cte_cod, t1.bolsa from pedidos_express.dbo.clientes_ofertas t1 left outer join #limpia_clientes_ofertas t2 on t1.sucursal = t2.sucursal and t1.cte_cod = t2.cte_cod and t1.bolsa = t2.bolsa where t2.bolsa is null or t2.bolsa = ' '
	open cursor_limpia_clientes_ofertas
	fetch next from cursor_limpia_clientes_ofertas into @sucursal, @cte_cod, @bolsa
	while @@fetch_status = 0
	begin
		delete from pedidos_express.dbo.clientes_ofertas where sucursal = @sucursal and cte_cod = @cte_cod and bolsa = @bolsa
		fetch next from cursor_limpia_clientes_ofertas into @sucursal, @cte_cod, @bolsa
	end
	close cursor_limpia_clientes_ofertas
	deallocate cursor_limpia_clientes_ofertas

end

drop table #clientes_ofertas
drop table #clientes_baan
set nocount off
GO
