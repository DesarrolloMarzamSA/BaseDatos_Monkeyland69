
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_genera_catalogo_walmart]
WITH ENCRYPTION
as
set nocount on
declare @codean varchar(20)
declare @codmarzam varchar(20)
declare @precio money
declare @precio_checa money
declare @codean_checa varchar(20)

create table #cat_productos_ibs(
	codean varchar(20),
	codmarzam varchar(11),
	precio money)

	declare @cadena_sql varchar(5000)
			insert into #cat_productos_ibs(codean, codmarzam, precio)
			SELECT CODEAN, CODMARZAM, PRECIO FROM OPENQUERY(AS400,'select trim(e.pjeanp)as CODEAN,trim(e.pjprdc) as CODMARZAM ,trim(p.pssalp)as PRECIO 
                from ma4620ef04.SR4PRS p inner join ma4620ef04.SR1EAN e ON p.psprdc=e.pjprdc and p.pspril=''03'' order by  e.pjeanp')

create index idx_tmp_cat_productos_ibs on #cat_productos_ibs(codean, codmarzam)
declare cursor_tmp_precios cursor fast_forward for select codean, codmarzam, precio from #cat_productos_ibs 
open cursor_tmp_precios
fetch next from cursor_tmp_precios into @codean, @codmarzam, @precio
while @@fetch_status = 0
begin
	select @codean_checa = [codigo_ean] from [catalogo_productos_walmart] where [codigo_ean] like '%'+@codean+'%'
	if(@@rowcount = 1)
		begin
			if(@codean_checa <> @codean)
			begin
				update [catalogo_productos_walmart] set [precio_farmacia] = @precio,[fecha_regsitro]=GETDATE() where [codigo_ean] like '%'+@codean+'%'
			end
		end
	--else
	--	begin
	--		insert into [catalogo_productos_walmart]([codigo_ean],[precio_farmacia],[fecha_regsitro]) values(@codean,@precio,GETDATE())
	--	end
	fetch next from cursor_tmp_precios into @codean, @codmarzam, @precio
end
close cursor_tmp_precios
deallocate cursor_tmp_precios

drop table #cat_productos_ibs

set nocount off

GO
