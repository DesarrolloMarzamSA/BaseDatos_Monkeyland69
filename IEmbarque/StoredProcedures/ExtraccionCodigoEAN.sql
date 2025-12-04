-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [IEmbarque].[ExtraccionCodigoEAN]  as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#producto_EAN') IS NOT NULL
				DROP TABLE #producto_EAN

CREATE table #producto_EAN(    
	[PCIPRC] [varchar](35) NOT NULL,
	[PCXPRC] [varchar](35) NOT NULL,
	PGDESC [varchar](35) NOT NULL,
	PGSTAT [varchar](35) NOT NULL
) 
insert into #producto_EAN
	SELECT PGPRDC,PCXPRC,PGDESC,PGSTAT from openquery(AS400,'
Select p.PGPRDC , coalesce(trim(PJEANP),trim(PCXPRC),'''') as PCXPRC, left(PGDESC,30) PGDESC,trim(PGSTAT) PGSTAT
From MA4620EF04.SRBPRG as p
Left outer join  MA4620EF04.SRBEAN  as e1 on p.PGPRDC = e1.PJPRDC
Left outer join MA4620EF04.SRBPCR  as e2 on e2.PCXRTY = ''IA'' and e2.PCIPRC = p.PGPRDC   
Where PGFICC <> ''Y'' and coalesce(trim(PJEANP),trim(PCXPRC),'''') <>'''' ')

 ;WITH CTE
	AS 
	(
select  ROW_NUMBER() OVER(PARTITION by PCIPRC ORDER BY PCIPRC ASC) AS Fila,PCIPRC,PCXPRC,[PGDESC],[PGSTAT]
from #producto_EAN
)
--select * from cte where Fila=1
 MERGE INTO [IEmbarque].[producto_EAN] T
		USING 
		( select * from cte where Fila=1 ) S
		ON (T.PCIPRC= S.PCIPRC AND T.PCXPRC= S.PCXPRC)			
		WHEN MATCHED THEN
		UPDATE 
			  SET T.PCIPRC= S.PCIPRC,T.PCXPRC= S.PCXPRC,T.[PGDESC]=S.[PGDESC],T.[PGSTAT]=S.[PGSTAT],[FECHA_ACTUALIZACION]=getdate()
			   WHEN NOT MATCHED BY TARGET THEN --No existe en el destino
	       INSERT  (PCIPRC,PCXPRC,[PGDESC],[PGSTAT],FECHA_REGISTRO)
		   values(PCIPRC,PCXPRC,[PGDESC],[PGSTAT],getdate());

		   	IF((SELECT COUNT(1) FROM #producto_EAN) > 0)
			 BEGIN
			 DELETE p from [IEmbarque].[producto_EAN]  p
			 left join  #producto_EAN pe on pe.PCIPRC=p.PCIPRC and pe.PCXPRC=p.PCXPRC
			 where pe.PCIPRC is null
			  END

		    IF OBJECT_ID('tempdb..#producto_EAN') IS NOT NULL
				DROP TABLE #producto_EAN

END

GO

