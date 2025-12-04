-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_fahorro_actualizaSAT] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
select REGCONSI,'Z99007' as NANUM,'99007'AS NANCA1
into #temp1
from openquery(AS400,'SELECT TRIM(SLPIDE) AS REGCONSI FROM MA4620ES.SR1SCL  where SLACOM = ''CZ''')

select INGRESO,USOCFDI,'Z99007' as NANUM,'99007'AS NANCA1
into #temp2
from openquery(AS400,'SELECT TRIM(CTPLHD)AS INGRESO,TRIM(SUBSTRING(CTTNHD,1,3)) AS USOCFDI from MA4620EF04.SRBCTLD1 WHERE CTOTYP=''FD''')

select FORMPAGO,NANUM,NANCA1
into #temp3
from openquery(AS400,
'SELECT TRIM(FP.UKPAMT) AS FORMPAGO,CL.NANUM,CL.NANCA1
FROM MA4620EF04.SRONAM CL 
INNER JOIN MA4620EF04.SR2SUK FP ON CL.NANUM=FP.UKNUM WHERE UKNUM=''Z99007''')

SELECT METODOPAGO,NANUM, NANCA1
into #temp4
from openquery(AS400,'
select TRIM(DRPACD)AS METODOPAGO,TRIM(CL.NANUM) NANUM,TRIM(CL.NANCA1) NANCA1 from MA4620EF04.SRBCMP
INNER JOIN MA4620EF04.SRONAM CL ON DRNUM=CL.NANUM
 WHERE DRNUM=''Z99007''')


truncate table [complementoSATFahorro]

INSERT INTO [dbo].[complementoSATFahorro]
           ([cliente]
           ,[clientePadre]
           ,[ingreso]
           ,[formaPago]
           ,[regimenConsolidacion]
           ,[metodoPago]
           ,[usoCFDI])
select a.NANUM,a.NANCA1,b.INGRESO,c.FORMPAGO,a.REGCONSI,d.METODOPAGO,b.USOCFDI
 from #temp1 a 
left join #temp2 b on a.NANUM=b.NANUM and a.NANCA1=b.NANCA1
left join #temp3 c on b.NANUM=c.NANUM and b.NANCA1=c.NANCA1
LEFT JOIN #temp4 d on c.NANUM=d.NANUM and c.NANCA1=d.NANCA1

drop table #temp1
drop table #temp2
drop table #temp3
drop table #temp4
END

GO

