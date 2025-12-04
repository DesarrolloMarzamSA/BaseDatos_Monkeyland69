USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_compras_astra_zeneca]
WITH ENCRYPTION
as
/*
declare @miquery as varchar(8000)
declare @finalquery as varchar(8000)
declare @contaras as int


CREATE TABLE #debaan(
	[t_cwar] [int] NULL,
	[t_odat] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
	[t_orno] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
	[t_suno] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
	[t_item] [varchar](7) COLLATE Modern_Spanish_CI_AS NULL,
	[t_dsca] [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
	[t_dqua] [int] NULL,
	[t_srnb] [int] NULL,
	[t_date] [varchar](10) COLLATE Modern_Spanish_CI_AS NULL
) 


set @miquery = 'select 
cast(substr(t1.t_cwar, 1, 2) as int) t_cwar, 
cast(t1.t_odat as varchar(10))  t_odat, 
cast(t1.t_orno as varchar(10))  t_orno, 
cast(t5.t_suno as varchar(10))  t_suno, 
cast(t2.t_item as varchar(7))   t_item, 
cast(t4.t_dsca as varchar(100)) t_dsca, 
cast(t2.t_dqua as int)          t_dqua, 
cast(t3.t_srnb as int)          t_srnb, 
cast(t3.t_date as varchar(10))  t_date
from 
ttdpur040080 t1 inner join ttdpur041080 t2 on t1.t_orno = t2.t_orno and t1.t_cwar = t2.t_cwar
inner join ttdpur045080 t3 on t2.t_orno = t3.t_orno and t2.t_pono = t3.t_pono
inner join ttiitm001080 t4 on t2.t_item = t4.t_item
inner join ttccom020080 t5 on t4.t_suno = t5.t_suno
where 
substr(t1.t_cwar, 3, 1) in (''''P'''', ''''N'''') and
t5.t_seak = ''''ASTRAZ'''' and
t1.t_odat > ' + '''' + '''' + replace(convert(varchar(10), dateadd(mm, -1, current_timestamp), 101), '/', '-') + '''' + '''' + ' and
t3.t_srnb = 1'

SET @finalQuery = 'insert into #debaan SELECT * FROM OPENQUERY(baan,' + '''' + @miquery + '''' + ')' 

exec (@finalquery)

set @miquery = 'select 
cast(substr(t1.t_cwar, 1, 2) as int) t_cwar, 
cast(t1.t_odat as varchar(10))  t_odat, 
cast(t1.t_orno as varchar(10))  t_orno, 
cast(t5.t_suno as varchar(10))  t_suno, 
cast(t2.t_item as varchar(7))   t_item, 
cast(t4.t_dsca as varchar(100)) t_dsca, 
cast(t2.t_dqua as int)          t_dqua, 
cast(t3.t_srnb as int)          t_srnb, 
cast(t3.t_date as varchar(10))  t_date
from 
ttdpur040090 t1 inner join ttdpur041090 t2 on t1.t_orno = t2.t_orno and t1.t_cwar = t2.t_cwar
inner join ttdpur045090 t3 on t2.t_orno = t3.t_orno and t2.t_pono = t3.t_pono
inner join ttiitm001080 t4 on t2.t_item = t4.t_item
inner join ttccom020080 t5 on t4.t_suno = t5.t_suno
where 
substr(t1.t_cwar, 3, 1) in (''''P'''', ''''N'''') and
t5.t_seak = ''''ASTRAZ'''' and
t1.t_odat > ' + '''' + '''' + replace(convert(varchar(10), dateadd(mm, -1, current_timestamp), 101), '/', '-') + '''' + '''' + ' and
t3.t_srnb = 1'

SET @finalQuery = 'insert into #debaan SELECT * FROM OPENQUERY(baan,' + '''' + @miquery + '''' + ')' 

exec (@finalquery)



set @miquery = 'select 
cast(substr(t1.t_cwar, 1, 2) as int) t_cwar, 
cast(t1.t_odat as varchar(10))  t_odat, 
cast(t1.t_orno as varchar(10))  t_orno, 
cast(t5.t_suno as varchar(10))  t_suno, 
cast(t2.t_item as varchar(7))   t_item, 
cast(t4.t_dsca as varchar(100)) t_dsca, 
cast(t2.t_dqua as int)          t_dqua, 
cast(t3.t_srnb as int)          t_srnb, 
cast(t3.t_date as varchar(10))  t_date
from 
ttdpur040091 t1 inner join ttdpur041091 t2 on t1.t_orno = t2.t_orno and t1.t_cwar = t2.t_cwar
inner join ttdpur045091 t3 on t2.t_orno = t3.t_orno and t2.t_pono = t3.t_pono
inner join ttiitm001080 t4 on t2.t_item = t4.t_item
inner join ttccom020080 t5 on t4.t_suno = t5.t_suno
where 
substr(t1.t_cwar, 3, 1) in (''''P'''', ''''N'''') and
t5.t_seak = ''''ASTRAZ'''' and
t1.t_odat > ' + '''' + '''' + replace(convert(varchar(10), dateadd(mm, -1, current_timestamp), 101), '/', '-') + '''' + '''' + ' and
t3.t_srnb = 1'

SET @finalQuery = 'insert into #debaan SELECT * FROM OPENQUERY(baan,' + '''' + @miquery + '''' + ')' 

exec (@finalquery)


set @miquery = 'select 
cast(substr(t1.t_cwar, 1, 2) as int) t_cwar, 
cast(t1.t_odat as varchar(10))  t_odat, 
cast(t1.t_orno as varchar(10))  t_orno, 
cast(t5.t_suno as varchar(10))  t_suno, 
cast(t2.t_item as varchar(7))   t_item, 
cast(t4.t_dsca as varchar(100)) t_dsca, 
cast(t2.t_dqua as int)          t_dqua, 
cast(t3.t_srnb as int)          t_srnb, 
cast(t3.t_date as varchar(10))  t_date
from 
ttdpur040092 t1 inner join ttdpur041092 t2 on t1.t_orno = t2.t_orno and t1.t_cwar = t2.t_cwar
inner join ttdpur045092 t3 on t2.t_orno = t3.t_orno and t2.t_pono = t3.t_pono
inner join ttiitm001080 t4 on t2.t_item = t4.t_item
inner join ttccom020080 t5 on t4.t_suno = t5.t_suno
where 
substr(t1.t_cwar, 3, 1) in (''''P'''', ''''N'''') and
t5.t_seak = ''''ASTRAZ'''' and
t1.t_odat > ' + '''' + '''' + replace(convert(varchar(10), dateadd(mm, -1, current_timestamp), 101), '/', '-') + '''' + '''' + ' and
t3.t_srnb = 1'

SET @finalQuery = 'insert into #debaan SELECT * FROM OPENQUERY(baan,' + '''' + @miquery + '''' + ')' 

exec (@finalquery)


select @contaras = count(*) from  #debaan

if(@contaras > 10)
begin
	truncate table astra_compras_ingresadas

	insert into astra_compras_ingresadas
	select 
	'MARZAM' ClaveDist,
	convert(varchar(2), t1.t_cwar) ClaveSucDist,
	convert(varchar(10), convert(datetime, replace(t1.t_date, '/', '-'), 101), 104) FechaMovimiento,
	'00:00:00' HoraMovimiento,
	t1.t_item CodigoMat,
	t2.cod_barras CodigoEAN,
	'IN' ClaseMovimiento,
	'GR' MotivoMovimiento,
	'AZM' OrigenMovimiento,
	'ATP' StatusInventario,
	sum(t1.t_dqua) Cantidad,
	'PZA' UnidadMedida,
	'' NumeroLote,
	'' Texto1,
	'' Texto2,
	'' Texto3
	from 
	#debaan t1 inner join maestro_productos_baan t2 on t1.t_item = t2.codigo
	where t1.t_cwar > 0
	group by
	convert(varchar(2), t1.t_cwar),
	convert(varchar(10), convert(datetime, replace(t1.t_date, '/', '-'), 101), 104),
	t1.t_item,
	t2.cod_barras
end




drop table #debaan

--select * into monkeyland.dbo.astra_compras_ingresadas from astra_compras_ingresadas

*/
GO
