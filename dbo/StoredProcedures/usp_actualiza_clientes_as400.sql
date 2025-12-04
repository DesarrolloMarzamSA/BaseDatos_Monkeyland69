
-- =============================================
-- Author:		mandrade
-- Create date: 16-06-2014
-- Description:	obtiene los clientes actualizados del SRONAM
-- =============================================
CREATE PROCEDURE [dbo].[usp_actualiza_clientes_as400]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

CREATE TABLE #sronamAux(
	[NAOPNO] [numeric](2, 0) NOT NULL,
	[NADEID] [char](8) NOT NULL,
	[NASTAT] [char](1) NOT NULL,
	[NANUM] [char](11) NOT NULL,
	[NANSNO] [char](11) NOT NULL,
	[NATYPP] [numeric](1, 0) NOT NULL,
	[NANAME] [char](30) NOT NULL,
	[NAADR1] [char](35) NOT NULL,
	[NAADR2] [char](35) NOT NULL,
	[NAADR3] [char](35) NOT NULL,
	[NAADR4] [char](35) NOT NULL,
	[NAPOCD] [char](16) NOT NULL,
	[NANSNA] [char](20) NOT NULL,
	[NACREG] [char](16) NOT NULL,
	[NATREG] [char](16) NOT NULL,
	[NADUMM] [char](1) NOT NULL,
	[NACOUN] [char](4) NOT NULL,
	[NAAREA] [char](3) NOT NULL,
	[NALANG] [char](3) NOT NULL,
	[NANCA1] [char](6) NOT NULL,
	[NANCA2] [char](6) NOT NULL,
	[NANCA3] [char](6) NOT NULL,
	[NACRDT] [numeric](8, 0) NOT NULL,
	[NAIORD] [char](1) NOT NULL,
	[NAPROD] [char](1) NOT NULL,
	[NAINNF] [numeric](17, 3) NOT NULL,
	[NACNTY] [char](5) NOT NULL,
	[NASPCD] [char](2) NOT NULL,
	[NATAXJ] [char](12) NOT NULL,
	[NANANN] [numeric](11, 0) NOT NULL,
	[NAMDCN] [char](1) NOT NULL,
	[NAPCDE] [char](1) NOT NULL,
	[NACTNB] [numeric](19, 4) NOT NULL,
	[NAPROP] [numeric](5, 2) NOT NULL,
	[NACTNP] [numeric](5, 2) NOT NULL,
	[NAARHA] [char](10) NOT NULL,
	[NAAPHA] [char](10) NOT NULL,
	[NAISVC] [char](1) NOT NULL,
	[NANCA4] [char](6) NOT NULL,
	[NANCA5] [char](6) NOT NULL,
	[NANCA6] [char](6) NOT NULL
) ON [PRIMARY]
 
		insert into #sronamAux
		select * from openquery(AS400,'
		select *		
		from MA4620EF04.SRONAM WHERE NANCA1 IN(''99341'')')

		insert into monkeyland.[dbo].[sronam]
		select c.NAOPNO,c.NADEID,c.NASTAT,c.NANUM,c.NANSNO,c.NATYPP,c.NANAME,c.NAADR1,c.NAADR2,c.NAADR3,c.NAADR4,c.NAPOCD,c.NANSNA,c.NACREG,c.NATREG,c.NADUMM,c.NACOUN,c.NAAREA,c.NALANG,c.NANCA1,c.NANCA2,c.NANCA3,c.NACRDT,c.NAIORD,c.NAPROD,c.NAINNF,c.NACNTY,c.NASPCD,c.NATAXJ,c.NANANN,c.NAMDCN,c.NAPCDE,c.NACTNB,c.NAPROP,c.NACTNP,c.NAARHA,c.NAAPHA,c.NAISVC,c.NANCA4,c.NANCA5,c.NANCA6,getdate()--,c1.NANUM
		 from #sronamAux c
		 left join monkeyland.[dbo].[sronam] c1 on c.NANUM=c1.NANUM
		 where c1.NANUM is null
		 drop table #sronamAux

		 
END

GO

