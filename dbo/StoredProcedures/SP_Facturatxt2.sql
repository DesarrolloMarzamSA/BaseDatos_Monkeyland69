
create procedure [dbo].[SP_Facturatxt2]
as
begin
select Tipo,
Numeroprove,
FolioalternoCosteo,
ImporteCosteo,
UUID,
Fecha,
Importesubfactura,
IEPS,
IVA,
Importetotalfac 
from  [monkeyland].[dbo].[superisste3] 
delete [monkeyland].[dbo].[superisste2]
end

GO

