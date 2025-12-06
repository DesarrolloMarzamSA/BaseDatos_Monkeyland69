
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_catalogo_klyns_llenado]
WITH ENCRYPTION
as
insert into catalogo_klyns (cod_barras, codigo, refklyns, xtimestamp)
(
select	distinct 
		t1.cod_barras, 
		t1.codigo, 
		t1.drefklyns,
		CURRENT_TIMESTAMP
from	pedidos_klyns_historia t1 left join catalogo_klyns t2 on 
		t1.cod_barras = t2.cod_barras and
		t1.codigo =  t2.codigo and
		t1.drefklyns = t2.refklyns
where	t2.cod_barras IS NULL
)
GO
