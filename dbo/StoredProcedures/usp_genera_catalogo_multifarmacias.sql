-- =============================================
-- Author:		mandrade
-- Create date: 10062014
-- Description:	catalogo Multifarmacias
-- =============================================
CREATE PROCEDURE [dbo].[usp_genera_catalogo_multifarmacias] 
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    select	t1.cod_barras+'	'+
	'00'+
	t1.codigo+'	'+
			 t1.clas_fis+'	'+
			--cast(case
			--	when t1.clas_fis = 'N'  then '0.00'
			--	when t1.clas_fis = 'NA' then '0.00'
			--	when t1.clas_fis = 'B'  then '18.00'
			--	when t1.clas_fis = 'BA' then '18.00'
			--	when t1.clas_fis = 'H'  then cast(round(t1.descto_prod,2,1) as varchar)
			--	when t1.clas_fis = 'HA' then cast(round(t1.descto_prod,2,1) as varchar)
			--end as varchar)+'	'+
			--cast(round(t2.descuento*100,2,1) as varchar)
			
			cast(case
				when t1.clas_fis = 'N'  then '0.0000'
				when t1.clas_fis = 'NA' then '0.0000'
				when t1.clas_fis = 'B'  then '0.1800'
				when t1.clas_fis = 'BA' then '0.1800'
				when t1.clas_fis = 'H'  then cast(cast((cast(t1.descto_prod as float)/100)as decimal(4,4)) as varchar)
				when t1.clas_fis = 'HA' then cast(cast((cast(t1.descto_prod as float)/100)as decimal(4,4)) as varchar)
			end as varchar)+'	'+
			cast((cast(t2.descuento as decimal(4,4))) as varchar)
		--	select *
from	monkeyland.dbo.maestro_productos_baan t1 inner join monkeyland.[dbo].[decuentos_confidenciales] t2 on 
			t1.codigo = t2.codigo 
where	t2.cliente='MULTIFARMACIA' and  
			isnumeric(t1.cod_barras) = 1 and
			substring(t1.status, 1, 1) <> 'B' 
order by t1.descripcion
  
END

GO

