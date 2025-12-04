create procedure [dbo].[usp_limpia_bitacora]
as
insert into historica.dbo.bitacora(interfase, mensaje, resultado, timestamp) select interfase, mensaje, resultado, timestamp from monkeyland.dbo.bitacora where timestamp <= dateadd(d, -3, current_timestamp)
delete from monkeyland.dbo.bitacora where timestamp <= dateadd(d, -3, current_timestamp)

GO

