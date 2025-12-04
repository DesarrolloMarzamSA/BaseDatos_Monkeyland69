USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_fanasa_insert_facturas]
@archivo_embarque as varchar(20),
@fecha_creacion as datetime,
@buffer varchar(max)
WITH ENCRYPTION
as
declare

@factura_ibs as varchar(20),
@factura as varchar(20),
@cuenta as varchar(20),
@fecha as datetime,
@codigo_barras as varchar(20),
@prec_farmacia as varchar(20),
@cantidad_surtida as varchar(20),
@constante as varchar(20),
@iva as varchar(20),
@oferta as varchar(20),
@descuento as varchar(20),
@referencia as varchar(20),
@nfac as varchar(15)


select @factura= SUBSTRING(@buffer,1,9)

set @nfac = (select distinct max(ibs)+RIGHT(REPLICATE('0',9) + SUBSTRING(@factura,3,12),9) 
from capa_ibs.dbo.sucursales where ibs_letra=SUBSTRING(@factura,2,1))
declare @sqlQuery as varchar(max)

SET @sqlQuery = 'select IHINVN from MA4620EF04.SRBISH WHERE IHINVN= ' + '''' + '''' + @nfac + '''' + ''''
DECLARE @cache TABLE (fac varchar(20) NOT NULL)
INSERT @cache execute('select * from openquery(AS400, ''' + @sqlQuery + ''')')
SELECT @factura_ibs = fac FROM @cache
--if (@factura_ibs<>'')
--begin
select @cuenta= SUBSTRING(@buffer,22,5)

select @fecha= SUBSTRING(@buffer,28,8)

select @codigo_barras= SUBSTRING(@buffer,39,13)

select @prec_farmacia= SUBSTRING(@buffer,64,10)

select @cantidad_surtida= SUBSTRING(@buffer,75,7)

select @constante= SUBSTRING(@buffer,83,4)

select @iva= SUBSTRING(@buffer,88,4)

select @oferta= SUBSTRING(@buffer,93,5)

select @descuento= SUBSTRING(@buffer,102,5)

select @referencia= SUBSTRING(@buffer,113,12)


insert into fanasa_fact_proc
values
(
@archivo_embarque,
@fecha_creacion,
@factura_ibs,
@factura,
@cuenta,
@fecha,
@codigo_barras,
@prec_farmacia,
@cantidad_surtida,
@constante,
@iva,
@oferta,
@descuento,
@referencia
)
--end
GO
