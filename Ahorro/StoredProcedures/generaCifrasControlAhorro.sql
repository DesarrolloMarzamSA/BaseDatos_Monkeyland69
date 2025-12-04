
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Ahorro].[generaCifrasControlAhorro]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 declare @tableroAhorroTmp TABLE
  (
  cuentaEstiloAhorro varchar(10),
  ordenCliente varchar(20),
  sucursal varchar(3),
  cuenta varchar(6),
  nombreArchivo varchar(30),
  numeroLineas int,
  year int,
  mes int,
  dia int,
  fecha datetime
  )

  DECLARE @fecha as datetime

  select @fecha=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

  --insert into @tableroAhorroTmp (cuentaEstiloAhorro,ordenCliente,sucursal,cuenta,nombreArchivo,numeroLineas,year,mes,dia,fecha)
  --select [cuentaEstiloAhorro]
  --    ,[orden]
  --    ,[sucursal]
  --    ,[cuenta]
  --    ,[archivoTandem]
	 -- ,COUNT(1) as lineas
	 -- ,YEAR(timestamp)
	 -- ,MONTH(timestamp)
	 -- ,DAY(timestamp)
	 -- ,DATEADD(dd, 0, DATEDIFF(dd, 0, timestamp))
  --FROM [Ahorro].[pedidosFiliales] with (nolock)
  --where timestamp>@fecha
  --group by  [cuentaEstiloAhorro]
  --    ,[orden]
  --    ,[sucursal]
  --    ,[cuenta]
  --    ,[archivoTandem]
	 -- ,YEAR(timestamp)
	 -- ,MONTH(timestamp)
	 -- ,DAY(timestamp)
	 -- ,DATEADD(dd, 0, DATEDIFF(dd, 0, timestamp))

	insert into @tableroAhorroTmp (cuentaEstiloAhorro,ordenCliente,sucursal,cuenta,nombreArchivo,numeroLineas,year,mes,dia,fecha)
	select b.[cuentaEstiloAhorro]
      ,b.[orden]
      ,a.[sucursal]
      ,a.[cuenta]
      ,b.[nombreHandHeld] as [archivoTandem]
	  ,COUNT(1) as lineas
	  ,YEAR(timestamp)
	  ,MONTH(timestamp)
	  ,DAY(timestamp)
	  ,DATEADD(dd, 0, DATEDIFF(dd, 0, timestamp))
  FROM [Ahorro].[pedidosFiliales] as a with (nolock)
  left join [Ahorro].[encabezadoPedidosFiliales] as b with (nolock) on a.hashMd5=b.[hashMd5]
  where timestamp>@fecha
  group by  b.[cuentaEstiloAhorro]
      ,b.[orden]
      ,a.[sucursal]
      ,a.[cuenta]
      ,b.[nombreHandHeld]
	  ,YEAR(timestamp)
	  ,MONTH(timestamp)
	  ,DAY(timestamp)
	  ,DATEADD(dd, 0, DATEDIFF(dd, 0, timestamp))
 
merge [Ahorro].[resumenPedidos] as destino
using (select year,
  mes,
  dia,
  sum(a.numeroLineas) as totalLineas,
  sum(case when b.nombreArchivo is null then 0 else numeroLineas end ) as LineasEnviadas,
  sum(case when b.nombreArchivo is null then numeroLineas else 0 end ) as LineasFaltantes,
  COUNT(b.nombreArchivo) as pedidosTotales,
  SUM(case when b.nombreArchivo is null then 0 else 1 end) as procesadoTraductor,
  SUM(case when b.nombreArchivo is null then 1 else 0 end) as sinProcesar,
  DATEPART(weekday,  min(fecha)) as diaSemana
from @tableroAhorroTmp as a
left join [Ahorro].[datosTraductor] as b with (nolock) on b.nombreArchivo=a.nombreArchivo
--where a.nombreArchivo is not null 
group by  year,mes,dia) as origen
on destino.year=origen.year and destino.mes=origen.mes and destino.dia=origen.dia
when matched
	then update set [totalLineas]=origen.[totalLineas],
					[lineasEnviadas]=origen.[lineasEnviadas],
					[lineasFaltantes]=origen.[lineasFaltantes],
					[pedidosTotales]=origen.[pedidosTotales],
					[pedidosTraductor]=origen.[procesadoTraductor],
					[pedidosFaltantes]=origen.[sinProcesar],
					diaSemana=origen.diaSemana
when not matched 
	then insert ([year],[mes],[dia],[totalLineas],[lineasEnviadas],[lineasFaltantes]
				,[pedidosTotales],[pedidosTraductor],[pedidosFaltantes],diaSemana)
		values (origen.year,origen.mes,origen.dia,origen.[totalLineas],origen.[lineasEnviadas],
				origen.[lineasFaltantes],origen.[pedidosTotales],origen.[procesadoTraductor],origen.[sinProcesar],
				origen.diaSemana);

END

GO

