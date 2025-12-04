SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_actualiza_cambios_baan]
as
--begin
--declare @t_item varchar(16), @t_suno varchar(6), @t_prcn money, @t_prfn money, @t_prpn money, @t_marc money, @t_marf money, @t_prca money, @t_prfa money, @t_prpa money, @t_user varchar(16), @t_prli float, @t_prma smallint, @t_marp money, @fecha_hora datetime
--declare @producto varchar(16)
--	declare mi_cursor cursor fast_forward for
--	select 
--	t_item, 
--	t_suno, 
--	convert(money, t_prcn) t_prcn, 
--	convert(money, t_prfn) t_prfn, 
--	convert(money, t_prpn) t_prpn, 
--	convert(money, t_marc) t_marc, 
--	convert(money, t_marf) t_marf, 
--	convert(money, t_prca) t_prca, 
--	convert(money, t_prfa) t_prfa, 
--	convert(money, t_prpa) t_prpa, 
--	t_user, 
--	convert(money, t_prli) t_prli, 
--	t_prma, 
--	convert(money, t_marp) t_marp, 
--	convert(datetime, convert(varchar(10), t_date, 121) + ' ' + monkeyland.dbo.ufn_numero_a_hora(t_hhra), 121) fecha_hora 
--	from openquery([baan], 'select t_date,t_suno,t_item,t_hhra,t_itsu,t_prcn,t_prfn,t_prpn,t_marc,t_marf,t_prca,t_prfa,t_prpa,t_user,t_prli,t_prma,t_marp from ttdpur903080')
--	open mi_cursor
--		fetch next from mi_cursor into @t_item, @t_suno, @t_prcn, @t_prfn, @t_prpn, @t_marc, @t_marf, @t_prca, @t_prfa, @t_prpa, @t_user, @t_prli, @t_prma, @t_marp, @fecha_hora
--		while  @@fetch_status = 0
--			begin
--				select @producto = t_item from cambios_precio_baan where t_item = @t_item and t_suno = @t_suno and fecha_hora = @fecha_hora and t_user = @t_user
--				if @@rowcount = 0
--				begin
--					insert into cambios_precio_baan(t_item, t_suno, t_prcn, t_prfn, t_prpn, t_marc, t_marf, t_prca, t_prfa, t_prpa, t_user, t_prli, t_prma, t_marp, fecha_hora) values(@t_item, @t_suno, @t_prcn, @t_prfn, @t_prpn, @t_marc, @t_marf, @t_prca, @t_prfa, @t_prpa, @t_user, @t_prli, @t_prma, @t_marp, @fecha_hora)
--				end
--				fetch next from mi_cursor into @t_item, @t_suno, @t_prcn, @t_prfn, @t_prpn, @t_marc, @t_marf, @t_prca, @t_prfa, @t_prpa, @t_user, @t_prli, @t_prma, @t_marp, @fecha_hora
--			end
--	close mi_cursor
--	deallocate mi_cursor
--end


GO
