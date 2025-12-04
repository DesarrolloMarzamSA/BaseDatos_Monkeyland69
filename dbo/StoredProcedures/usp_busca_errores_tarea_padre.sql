USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_busca_errores_tarea_padre]
@partime varchar(4)
WITH ENCRYPTION
as
declare @dw tinyint
declare @mm tinyint

--declare @partime varchar(4)
--set @partime= '1020'

select 	@dw =	datepart(dw, getdate() - 1)
select 	@mm =	 datepart(mm, getdate())
select	rtrim(path), 
			rtrim(ejecutable), 
			parametros,
			id_tarea_programada 
from		tareas_programadas
where	substring(dias,@dw,1) = '1' and
			substring(meses,@mm,1) = '1' and
			habilitado = '1' and
			datediff(mi, hora_ultima_ejecucion, getdate()) > 1440 + 5 and
			cast(hora_ejecucion as int) < cast(@partime as int)

GO
