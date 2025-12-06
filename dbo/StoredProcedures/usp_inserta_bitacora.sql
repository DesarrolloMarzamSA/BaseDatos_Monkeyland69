
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_inserta_bitacora] @interfase varchar(100), @mensaje varchar(1500), @resultado int

as
insert into bitacora(interfase, mensaje, resultado, timestamp) values(@interfase, @mensaje, @resultado, current_timestamp)
GO
