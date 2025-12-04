-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_genera_catalogo_fahorro_spt_1] @sucursal int, @cliente varchar(5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @sucursal_st as int

--consulta para forzar el cambio de sucrusal 1 (metro sur) a 21 Ecatepec
select @sucursal_st=case when @sucursal=1 OR @sucursal=4 then 21 else @sucursal end
--select @sucursal_st=case when @sucursal=1 then 21 else @sucursal end

declare @descuento money
select @descuento = convert(money, descuento) from clientes_baan where sucursal = @sucursal_st and cliente = '99007'--@cliente
declare @piezas int
if @sucursal_st = 11 or @sucursal_st = 13
      begin
            select @piezas = 1
      end
else
      begin
            select @piezas = 2
      end

            select 
            left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + '|' +
            '    ' + right('000000000' + t1.codigo, 9) + '|' +
            left(t1.descripcion + '                                                            ', 60) + '|' +
            right('000000000000' + convert(varchar(6), t1.iva * 100), 15) + '|' +
            left(right('000000000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then precios.prec_farm + (precios.prec_farm * 0.5) else precios.prec_farm end), 18), 15) + '|' +
            left(right('000000000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 18), 15) + '|' +
            case 
            when t1.clas_fis = 'B'  then right('000000000000' + convert(varchar(16), @descuento), 15)
            when t1.clas_fis = 'BA' then right('000000000000' + convert(varchar(16), @descuento), 15)
            when t1.clas_fis = 'N'  then '000000000000.00' 
            when t1.clas_fis = 'NA' then '000000000000.00' 
            when t1.clas_fis = 'H'  then right('000000000000' + convert(varchar(16), t1.descto_prod), 15) 
            when t1.clas_fis = 'HA' then right('000000000000' + convert(varchar(16), t1.descto_prod), 15)  end + '|' +
            case t1.clas_ssa 
            when '1' then '1' 
            when '2' then '1' 
            when '3' then '1' 
            when '4' then '1' 
            when '5' then '1' 
            when '6' then '1' 
            when '7' then '0' 
            when '8' then '0' 
            when '9' then '0' 
            else '0' end + '|' +
            left(t1.lab_largo + '                                                            ', 60) + '|' +
            case t1.refrigerado when 'R' then '1' else '0' end  + '|' +
            case t1.clas_ssa 
            when '1' then '1' 
            when '2' then '3' 
            when '3' then '3' 
            else '0' end + '|' ,
            '1  ' + '|00000000000000|000000000000.00|000000000000.00|' +
            case t2.piezas when 0 then '000000' else '999999' end + '|' +
            --'999999' + '|' +
            '0' + '|' +
            '0' + '|' +
            right('000000000000' + convert(varchar(12), isnull(t3.porcentaje, 0) * 100), 15) + '|' +
            case 
            when t1.clas_fis = 'B' then '000000000004.88' 
            when t1.clas_fis = 'BA' then '000000000004.88' 
            else '000000000000.00' end + '|' +
            isnull(convert(varchar(8), t3.vigencia_final, 112), '00000000')
            from
            cat_fahorro_fijo t5 inner join 
            maestro_productos_baan t1 on t5.codigo = t1.codigo 
            inner join openquery(AS400,'select psprdc,COALESCE(PSSALP,0) as prec_farm,PSPRIL from  MA4620EF04.SR4PRS where PSPRIL=''05''') as precios
            on precios.psprdc=t1.codigo
            inner join inventario_baan_sin_filtro t2 on t1.codigo = t2.codigo
            inner join dbcataut t4 on t1.codigo = t4.codigo and t4.segmento = 'C1' and t4.cadena = '007'
            left outer join dboferta t3 on t2.codigo = t3.codigo and t2.sucursal = t3.sucursal and (t3.bolsa = 'C1007' or (t3.bolsa = 'XXPAD' and t3.codigo = '2750402'))
            --inner join filtro_catalogo_spt_fahorro t5 on t1.codigo = t5.codigo and t5.sucursal = @sucursal_st
            where
            --t5.sucursal=@sucursal_st and--habilitar solo para la nueva version del catalogo del 09/10/2012
            --t1.codigo = '2375101' and
            (substring(t2.status, 1, 1) in ('C','D','S','T','A', ' ') and
            --t1.fecha_baja is null and
            t2.sucursal = @sucursal_st and
            isnumeric(t1.cod_barras) = 1 and 
            convert(int, t1.codigo) < dbo.gobierno() and
            t4.status = 'A' and
            --t2.piezas > @piezas ) or t2.codigo = '9000701' and t2.sucursal = @sucursal_st
            t2.piezas >= 8  and t2.sucursal = @sucursal_st) or t2.codigo = '9000701'
            order by 
            t1.descripcion

END

GO

