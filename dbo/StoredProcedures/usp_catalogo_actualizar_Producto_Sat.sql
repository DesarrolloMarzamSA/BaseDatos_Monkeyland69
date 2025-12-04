-- =============================================
-- Author:		frmartinez	
-- Create date: 09/05/2019
-- Description:	catalogo actualizar Producto Sat
-- =============================================
CREATE PROCEDURE [dbo].[usp_catalogo_actualizar_Producto_Sat]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


CREATE TABLE #catalogoSat(
	[Idioma] [varchar](5) NOT NULL,
	[Codigo] [varchar](10) NOT NULL,
	[Codigo_Sat] [varchar](200) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Estatus] [varchar](1) NOT NULL,
	[HashCode] bigint)

	insert into #catalogoSat ([Idioma],[Codigo],[Codigo_Sat],[Fecha],[Estatus])
  select Idioma,CODIGO,rtrim(Codigo_Sat),getdate() as fecha,'A' as estatus
 from openquery(as400, 'SELECT TRIM(PXLANG) IDIOMA,TRIM(PXPRDC) CODIGO,  
TRIM(PXTX50) CODIGO_SAT FROM MA4620EF04.SROPRX 
WHERE PXLANG = ''SAT'' and  trim(PXPRDC)<>'''' and TRIM(PXTX50) not in(''H87'')
and PXTLIN=''1'' ') 
where ISNUMERIC(CODIGO)=1
GROUP BY   idioma, codigo, CODIGO_SAT

update #catalogoSat set [HashCode] =CHECKSUM(CAST([Codigo] as varchar(20) )+cast([Codigo_Sat] as varchar(50)))


--select c.*
delete c
from [catalogo_fahorroSAT] c
left join #catalogoSat c1 on c.[HashCode] =c1.[HashCode]

where  isnumeric(c1.Codigo)=1 and c1.codigo is null 

 MERGE [dbo].[catalogo_fahorroSAT] P2
	USING (SELECT * FROM #catalogoSat) P1
	ON (P1.[HashCode] = P2.[HashCode])
	
	WHEN NOT MATCHED THEN
       INSERT ([Idioma],[Codigo],[Codigo_Sat],[Fecha],[Estatus],[HashCode])
       VALUES (P1.[Idioma],P1.[Codigo],P1.[Codigo_Sat],P1.[Fecha],P1.[Estatus],P1.[HashCode]);
	    
	drop table #catalogoSat


END

GO

