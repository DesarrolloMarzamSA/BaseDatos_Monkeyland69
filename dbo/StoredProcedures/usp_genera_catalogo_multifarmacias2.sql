
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		mandrade
-- Create date: 10062014
-- Description:	catalogo Multifarmacias
-- =============================================
CREATE PROCEDURE [dbo].[usp_genera_catalogo_multifarmacias] 
WITH ENCRYPTION
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    select	 t1.cod_barras+' '+
	t1.codigo+' '+
			 t1.clas_fis+' '+
			cast(cast(case
				when t1.clas_fis = 'N' then '0'
				when t1.clas_fis = 'NA' then '0'
				when t1.clas_fis = 'B' then '9.99'
				when t1.clas_fis = 'BA' then '9.99'
				when t1.clas_fis = 'H' then  t1.descto_prod
				when t1.clas_fis = 'HA' then t1.descto_prod
			end as money)as varchar)+' '+cast(cast(t2.descuento as float) as varchar)
from	monkeyland.dbo.maestro_productos_baan t1 inner join monkeyland.[dbo].[decuentos_confidenciales] t2 on 
			t1.codigo = t2.codigo and t2.cliente='MULTIFARMACIA' 
where	convert(int, t1.codigo) < dbo.gobierno() and 
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1, 1) <> 'B' 
order by t1.descripcion
END
GO
