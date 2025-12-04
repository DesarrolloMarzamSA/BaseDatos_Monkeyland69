
CREATE procedure [dbo].[SP_Facturatxt]

as
begin
select Tipo,
Numeroprove,
FolioalternoCosteo,
ImporteCosteo,
UUID,
cast(datepart(dd,cast(fecha as date))as nvarchar(10)) +Replace(str(datepart(mm,cast(fecha as date)),2),' ','0')+cast(datepart(yyyy,cast(fecha as date))as nvarchar(10)) as "Fecha",
Importesubfactura,
IEPS,
IVA,
Importetotalfac 
from  [monkeyland].[dbo].[superisste3] 
delete [monkeyland].[dbo].[superisste2]
end

GO

