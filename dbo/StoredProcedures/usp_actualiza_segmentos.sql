

CREATE procedure [dbo].[usp_actualiza_segmentos] 
as


/*
select * from clientes_baan where sucursal = 1 and segto = 'C1' and ctepadre = '008'

select * from segmentos where segto = 'MQ'
select distinct segto, ctepadre, farmacia descripcion from clientes_baan where cliente like '99%' and ctepadre <> '' and segto <> '' and farmacia not like '%LIBRE%' and agen_NOMBRE like '%CLIENTES PADRE%' order by segto, ctepadre

*/
declare @lineas as int

declare @segto varchar(2)
declare @ctepadre varchar(3)
declare @descripcion varchar(100)

declare @segto_checa varchar(2)
declare @ctepadre_checa varchar(3)
declare @descripcion_checa varchar(100)

select distinct segto, ctepadre, farmacia into #segmentos from clientes_baan where cliente like '99%' and ctepadre <> '' and segto <> '' and farmacia not like '%LIBRE%' and agen_NOMBRE like '%CLIENTES PADRE%' order by segto, ctepadre

select @lineas = count(*) from #segmentos

if(@lineas > 500)
begin

	declare mi_cursor cursor fast_forward for select segto, ctepadre, farmacia from #segmentos
	open mi_cursor
	fetch next from mi_cursor into @segto, @ctepadre, @descripcion
	while @@fetch_status = 0
	begin
		select @segto_checa = segto, @ctepadre_checa = ctepadre, @descripcion_checa = descripcion from segmentos where segto = @segto and ctepadre = @ctepadre
		if @@rowcount > 0
		begin
			if(@descripcion_checa <> @descripcion)
			begin
				update segmentos set descripcion = @descripcion where segto = @segto and ctepadre = @ctepadre
			end --if(@farmacia_checa <> @farmacia)
		end --if @@rowcount > 0
		else
		begin
				insert into segmentos(segto, ctepadre, descripcion) values(@segto, @ctepadre, @descripcion)
		end -- else
		fetch next from mi_cursor into @segto, @ctepadre, @descripcion
	end
	close mi_cursor
	deallocate mi_cursor

	delete segmentos from segmentos t1 left outer join #segmentos t2 on t1.segto = t2.segto and t1.ctepadre = t2.ctepadre where t2.segto is null
end
--insert into segmentos(segto, ctepadre, descripcion) values('MQ', '666', 'prueba chacal')

GO

