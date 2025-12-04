-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[altaCuentaFarmatodoCofar]
@cuentaMarzam as varchar(10),@codigoFarmacia as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @sucursal as int
declare @cliente as varchar(5)
declare @letraSucursal as varchar(2)

select @cliente=SUBSTRING(@cuentaMarzam,2,5)
select @letraSucursal=SUBSTRING(@cuentaMarzam,1,1)

select @sucursal= case when @letraSucursal='A' then 1
					   when @letraSucursal='C' then 3
					   when @letraSucursal='D' then 4
					   when @letraSucursal='E' then 5
					   when @letraSucursal='J' then 6
					   when @letraSucursal='G' then 7
					   when @letraSucursal='M' then 13
					   when @letraSucursal='P' then 16
					   when @letraSucursal='Q' then 17
					   when @letraSucursal='R' then 18
					   when @letraSucursal='U' then 21
					   when @letraSucursal='W' then 23
					   when @letraSucursal='X' then 24
					   when @letraSucursal='Y' then 25
				  end

INSERT INTO [monkeyland].[dbo].[cat_farmatodo_cofar] ([sucursal],[cliente],[codigo_farmacia])
 VALUES (@sucursal,@cliente,@codigoFarmacia)

   INSERT INTO [AvisosEmbarque].[dbo].[relacion_codigos_clientes]
  ( [id_cliente_ibs],[id_cliente_propietario],[data0])
  VALUES (@cuentaMarzam,@codigoFarmacia,@cliente)

END

GO

