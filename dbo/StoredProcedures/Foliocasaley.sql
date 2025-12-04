create procedure [dbo].[Foliocasaley]
@folio int
as
begin
select folio from Casaleyxml where folio = @folio
end

GO

