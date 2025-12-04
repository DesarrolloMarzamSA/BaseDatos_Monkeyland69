
CREATE PROCEDURE [cat].[ExtraccionCodigoEAN]  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#cat_ean_prg') IS NOT NULL
				DROP TABLE #cat_ean_prg

	CREATE TABLE #cat_ean_prg(
		[codigo] [varchar](35) NOT NULL,
		[codigo_barras] [varchar](35) NOT NULL,
		[descripcion] [varchar](100) NOT NULL,
		[estatus] [varchar](1) NOT NULL
	)

	insert into #cat_ean_prg
		SELECT PGPRDC,PCXPRC,PGDESC,PGSTAT from openquery(AS400,'
	Select p.PGPRDC , coalesce(trim(PJEANP),trim(PCXPRC),'''') as PCXPRC, left(PGDESC,30) PGDESC,trim(PGSTAT) PGSTAT
	From MA4620EF04.SRBPRG as p
	Left outer join  MA4620EF04.SRBEAN  as e1 on p.PGPRDC = e1.PJPRDC
	Left outer join MA4620EF04.SRBPCR  as e2 on e2.PCXRTY = ''IA'' and e2.PCIPRC = p.PGPRDC   
	Where PGFICC <> ''Y'' AND p.PGPRDC >= ''0000000'' AND p.PGPRDC <= ''3999999''
	and coalesce(trim(PJEANP),trim(PCXPRC),'''') <>'''' ')

	 ;WITH CTE AS 
	 (
		select ROW_NUMBER() OVER(PARTITION by [codigo] ORDER BY [codigo] ASC) AS Fila,[codigo],[codigo_barras],[descripcion],[estatus]
		from #cat_ean_prg
	)
	--select [codigo],[codigo_barras],[descripcion],[estatus] from cte where Fila=1

	MERGE INTO [dbo].[cat_ean_prg] T 
	USING(
		select [codigo],[codigo_barras],[descripcion],[estatus] from cte where Fila=1 ) S
		ON (T.[codigo]= S.[codigo] AND T.[codigo_barras]= S.[codigo_barras])			
	WHEN MATCHED THEN
	UPDATE 
		SET T.[codigo]= S.[codigo],T.[codigo_barras]= S.[codigo_barras],T.[descripcion]=S.[descripcion],T.[estatus]=S.[estatus]
	WHEN NOT MATCHED BY TARGET THEN --No existe en el destino
	INSERT ([codigo],[codigo_barras],[descripcion],[estatus])
	values([codigo],[codigo_barras],[descripcion],[estatus]);

	IF((SELECT COUNT(1) FROM #cat_ean_prg) > 0)
	BEGIN
	DELETE p from [dbo].[cat_ean_prg] p
	left join #cat_ean_prg pe on pe.[codigo]=p.[codigo] and pe.[codigo_barras]=p.[codigo_barras]
	where pe.[codigo] is null
	END

END

GO

