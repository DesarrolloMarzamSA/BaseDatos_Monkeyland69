
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE --create 
procedure [dbo].[usp_busca_ean] @codigo varchar(7)

as

/*
execute usp_busca_ean '1660905'
*/

select cod_barras from maestro_productos where codigo = @codigo
GO
