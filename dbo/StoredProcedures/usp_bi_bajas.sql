USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_bi_bajas] 
WITH ENCRYPTION
as
select codigo from maestro_productos_baan where datediff(dd, fecha_baja, current_timestamp) < 5 --	and prec_farm < 9999.99 
GO
