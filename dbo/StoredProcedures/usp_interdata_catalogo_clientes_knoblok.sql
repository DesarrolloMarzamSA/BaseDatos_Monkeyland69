create PROCEDURE [dbo].[usp_interdata_catalogo_clientes_knoblok]
as
select *from openquery(AS400,'select * from (
      SELECT NOWHCD AS ADWHCD, NANUM, NANAME, ADMXNAME,
      case when length(trim(ADMXADR2)) > 0 then trim(ADMXADR2) concat('' '') end
      concat(case when length(trim(ADMXEXT1)) > 0 then trim(ADMXEXT1) concat('' '') else '''' end)
      concat(case when length(trim(ADMXEXT2)) > 0 then trim(ADMXEXT2) concat('' '') else '''' end)
      concat(case when length(trim(ADMXINT1)) > 0 then trim(ADMXINT1) concat('' '') else '''' end)
      concat(case when length(trim(ADMXINT2)) > 0 then trim(ADMXINT2) else '''' end) Direccion,
      ADMXNEIB, ADMXCITY, ADMXSTTE, ADPOCD,NATREG
      FROM MA4620EF04.SRONAM T1
      INNER JOIN MA4620EF04.SRONAD T3
      ON T1.NANUM = T3.ADNUM
      INNER JOIN MA4620EF04.MXBNAD T2
      ON T2.ADNUM = T3.ADNUM
 INNER JOIN MA4620EF04.SRONOI T4
 ON T1.NANUM = T4.NONUM
      WHERE NANUM >= ''A00000''
      and NANUM not in (''A98840'')
      and adwhcd not in (''99C'',''99E'',''Y01'',''Y02'',''Y03'',''Z01'',''UFM'',''U10'')
      AND length(TRIM(NANUM)) = 6
      and trim(translate(substring(nanum, 1, 1), ''          '', ''0123456789'')) <> ''''
      AND T1.NASTAT <> ''D''
      AND T2.ADADNO = 2
      AND T3.ADADNO = 2
      union
      SELECT ADWHCD, NANUM, NANAME, ADMXNAME,
      case when length(trim(ADMXADR2)) > 0 then trim(ADMXADR2) concat('' '') end
      concat(case when length(trim(ADMXEXT1)) > 0 then trim(ADMXEXT1) concat('' '') else '''' end)
      concat(case when length(trim(ADMXEXT2)) > 0 then trim(ADMXEXT2) concat('' '') else '''' end)
      concat(case when length(trim(ADMXINT1)) > 0 then trim(ADMXINT1) concat('' '') else '''' end)
      concat(case when length(trim(ADMXINT2)) > 0 then trim(ADMXINT2) else '''' end) Direccion,
      ADMXNEIB, ADMXCITY, ADMXSTTE, ADPOCD,NATREG
      FROM MA4620EF11.SRONAM T1
      INNER JOIN MA4620EF11.SRONAD T3
      ON T1.NANUM = T3.ADNUM
      INNER JOIN MA4620EF11.MXBNAD T2
      ON T2.ADNUM = T3.ADNUM
      WHERE NANUM >= ''A00000''
      and NANUM not in (''A98840'')
      and adwhcd not in (''99C'',''99E'',''Y01'',''Y02'',''Y03'',''Z01'',''UFM'',''U10'')
      AND length(TRIM(NANUM)) = 6
      and trim(translate(substring(nanum, 1, 1), ''          '', ''0123456789'')) <> ''''
      AND T1.NASTAT <> ''D''
      AND T2.ADADNO = 2
      AND T3.ADADNO = 2) t1 order by NANUM');

GO

