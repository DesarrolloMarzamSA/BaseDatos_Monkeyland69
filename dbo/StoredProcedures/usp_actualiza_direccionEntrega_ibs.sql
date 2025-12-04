SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_actualiza_direccionEntrega_ibs]
-- =============================================
-- Author:		Marco Andrade
-- Create date: 11-10-2012
-- Description:	Procedimiento para obtener las direcciones de los clientes de entrega
-- =============================================SET ANSI_NULLS ON
as
set nocount on
declare	@decliente_ibs varchar(9)
declare	@detipo_dir int
declare	@defarmacia varchar(250)
declare	@deaddir1 varchar(250)
declare	@deaddir2 varchar(250)
declare	@deaddir3 varchar(250)
declare	@demxbndc varchar(250)
declare	@demxbond varchar(250)
declare	@demxneib varchar(250)
declare	@demxcity varchar(250)
declare	@demxint1 varchar(250)
declare	@demxint2 varchar(250)
declare	@demxext1 varchar(250)
declare	@demxext2 varchar(250)
declare	@demxal35 varchar(250)
declare	@demxglnc varchar(250)
declare	@demxstte varchar(250)
declare	@decrdt	int
declare @decliente_ibs_checa varchar(9)
declare	@decrdt_checa int

create table #direccion_entrega(decliente_ibs varchar(9),detipo_dir int,defarmacia varchar(250),deaddir1 varchar(250),deaddir2 varchar(250),deaddir3 varchar(250),demxbndc varchar(250),demxbond varchar(250),demxneib varchar(250),demxcity varchar(250),demxint1 varchar(250),demxint2 varchar(250),demxext1 varchar(250),demxext2 varchar(250),demxal35 varchar(250),demxglnc varchar(250),demxstte varchar(250),decrdt int)

insert into #direccion_entrega select ltrim(rtrim(ADNUM)),ltrim(rtrim(ADADNO)),ltrim(rtrim(ADMXNAME)),ltrim(rtrim(ADMXADR1)),ltrim(rtrim(ADMXADR2)),
ltrim(rtrim(ADMXADR3)),ltrim(rtrim(ADMXBNDC)),ltrim(rtrim(ADMXBOND)),ltrim(rtrim(ADMXNEIB)),ltrim(rtrim(ADMXCITY)),ltrim(rtrim(ADMXINT1)),
ltrim(rtrim(ADMXINT2)),ltrim(rtrim(ADMXEXT1)),ltrim(rtrim(ADMXEXT2)),ltrim(rtrim(ADMXAL35)),ltrim(rtrim(ADMXGLNC)),ltrim(rtrim(ADMXSTTE)),
ltrim(rtrim(ADCRDT))
from 
openquery(as400, '
select de.ADNUM,de.ADADNO,de.ADMXNAME,de.ADMXADR1,de.ADMXADR2,de.ADMXADR3,de.ADMXBNDC,de.ADMXBOND,de.ADMXNEIB
,de.ADMXCITY,de.ADMXINT1,de.ADMXINT2,de.ADMXEXT1,de.ADMXEXT2,de.ADMXAL35,de.ADMXGLNC,de.ADMXSTTE,de.ADCRDT
from MA4620EF04.MXONAD de
where de.ADADNO=2
UNION
select de.ADNUM,de.ADADNO,de.ADMXNAME,de.ADMXADR1,de.ADMXADR2,de.ADMXADR3,de.ADMXBNDC,de.ADMXBOND,de.ADMXNEIB
,de.ADMXCITY,de.ADMXINT1,de.ADMXINT2,de.ADMXEXT1,de.ADMXEXT2,de.ADMXAL35,de.ADMXGLNC,de.ADMXSTTE,de.ADCRDT
from MA4620EF11.MXONAD de
where de.ADADNO=2')

declare cursor_direcc_entregaibs cursor fast_forward for select decliente_ibs,detipo_dir,defarmacia,deaddir1,deaddir2,deaddir3,demxbndc,demxbond,demxneib,demxcity,demxint1,demxint2,demxext1,demxext2,demxal35,demxglnc,demxstte,decrdt from #direccion_entrega
open cursor_direcc_entregaibs
fetch next from cursor_direcc_entregaibs into @decliente_ibs,@detipo_dir,@defarmacia,@deaddir1,@deaddir2,@deaddir3,@demxbndc,@demxbond,@demxneib,@demxcity,@demxint1,@demxint2,@demxext1,@demxext2,@demxal35,@demxglnc,@demxstte,@decrdt
while @@fetch_status = 0
begin
	select  @decliente_ibs_checa =  decliente_ibs from direccion_entrega_clientes_ibs where  decliente_ibs =  @decliente_ibs
	select  @decrdt_checa =  decrdt from direccion_entrega_clientes_ibs where  decliente_ibs =  @decliente_ibs
	if @@rowcount > 0
		begin
			if(@decliente_ibs <> @decliente_ibs_checa and @decrdt <> @decrdt_checa)
			begin
				update direccion_entrega_clientes_ibs set decliente_ibs=@decliente_ibs,	detipo_dir=@detipo_dir,	defarmacia=@defarmacia,	deaddir1=@deaddir1,	deaddir2=@deaddir2,	deaddir3=@deaddir3,	demxbndc=@demxbndc,	demxbond=@demxbond,	demxneib=@demxneib,	demxcity=@demxcity,	demxint1=@demxint1,	demxint2=@demxint2,	demxext1=@demxext1,	demxext2=@demxext2,	demxal35=@demxal35,	demxglnc=@demxglnc,	demxstte=@demxstte,	decrdt=@decrdt where decliente_ibs=@decliente_ibs			
			end
		end
	else
		begin
			insert into direccion_entrega_clientes_ibs(decliente_ibs,detipo_dir,defarmacia,deaddir1,deaddir2,deaddir3,demxbndc,demxbond,demxneib,demxcity,demxint1,demxint2,demxext1,demxext2,demxal35,demxglnc,demxstte,decrdt) values(@decliente_ibs,@detipo_dir,@defarmacia,@deaddir1,@deaddir2,@deaddir3,@demxbndc,@demxbond,@demxneib,@demxcity,@demxint1,@demxint2,@demxext1,@demxext2,@demxal35,@demxglnc,@demxstte,@decrdt)
		end	

	fetch next from cursor_direcc_entregaibs into @decliente_ibs,@detipo_dir,@defarmacia,@deaddir1,@deaddir2,@deaddir3,@demxbndc,@demxbond,@demxneib,@demxcity,@demxint1,@demxint2,@demxext1,@demxext2,@demxal35,@demxglnc,@demxstte,@decrdt
end

close cursor_direcc_entregaibs
deallocate cursor_direcc_entregaibs

drop table #direccion_entrega
set nocount off

GO
