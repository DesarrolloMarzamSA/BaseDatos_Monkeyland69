
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_soriana_ws_cat_sustancias_activas01]
WITH ENCRYPTION
as
select	top 2570 1 orden, 
			convert(bigint, Ltrim(Rtrim(cod_barras))) Codigo,
			case
				when len(rtrim(desc_sus_act1)) > 0 then desc_sus_act1
				else desc_sus_act2
			end,
			0.00 Concentracion,
			'' UnidadConcentracion
from		maestro_productos_baan 
where cod_barras not like '%E%'
GO
