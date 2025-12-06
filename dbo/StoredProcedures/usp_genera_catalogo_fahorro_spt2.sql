
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE       procedure [dbo].[usp_genera_catalogo_fahorro_spt] @sucursal int, @cliente varchar(5)

as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @bodega as varchar(4)
declare @cantidad_minima as int
declare @descuento money

/*no tienen configurados los descuentos de padre por sucursal*/
select @descuento = convert(money, descuento) from clientes_baan where sucursal = @sucursal and cliente = '99007'
--select @descuento = '18.00'

   SELECT @bodega=[almacen_ibs] FROM [capa_ibs].[dbo].[sucursales]where [sistema]='ibs' and sucursal=@sucursal group by [ibs_letra],[almacen_ibs],[sucursal_traductor]
  
  select @cantidad_minima=6
  
  
  SELECT 
		left(convert(varchar(13), convert(bigint, t1.cod_barras)) + '             ', 13) + '|' +
            '    ' + right('000000000' + t1.codigo, 9) + '|' +
            left(t1.descripcion + '                                                            ', 60) + '|' +
            right('000000000000' + convert(varchar(6), t1.iva * 100), 15) + '|' +
            left(right('000000000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then precios.prec_farm + (precios.prec_farm * 0.5) else precios.prec_farm end), 18), 15) + '|' +
            left(right('000000000000' + convert(varchar(15), case t1.grupo_est when 'PC01A' then t1.prec_pub + (t1.prec_pub * 0.5) else t1.prec_pub end), 18), 15) + '|' +
            case 
            when t1.clas_fis = 'B'  then right('000000000000' + convert(varchar(16), isnull(@descuento,0)), 15)
            when t1.clas_fis = 'BA' then right('000000000000' + convert(varchar(16), isnull(@descuento,0)), 15)
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
            case LPLOQT when 0 then '000000' else '999999' end + '|' +
            '0' + '|' +
            '0' + '|' +
            right('000000000000' + convert(varchar(12), isnull(t3.porcentaje, 0) * 100), 15) + '|' +
            case 
            when t1.clas_fis = 'B' then '000000000004.88' 
            when t1.clas_fis = 'BA' then '000000000004.88' 
            else '000000000000.00' end + '|' +
            isnull(convert(varchar(8), t3.vigencia_final, 112), '00000000')
  FROM [capa_ibs].[dbo].[maestro_productos] as t1
  inner join   openquery(AS400,'
				select psprdc,COALESCE(PSSALP,0) as prec_farm,PSPRIL from  MA4620EF04.SR4PRS where PSPRIL=''05''
				AND psprdc in (select RDWHAT from MA4620EF04.SRBRSD where RDSRTY =''AHORRO FIL'' AND RDEXCT=''SI VENTA'')') as precios
               on precios.psprdc=t1.codigo
  inner join   openquery(AS400,'  select LPSROM,LPPRDC,SUM(integer(LPLOQT)) LPLOQT
 from MA4620EF04.WHOLOP
 WHERE TRIM(LPSROM)in (select distinct ADWHCD from MA4620EF04.SRBNAD where ADADNO=2
 and ADNUM in (select NANUM from MA4620EF04.SRONAM WHERE NANCA1=''99007''))
 and LPLZON in (SELECT distinct lolzon from MA4620EF04.WHOLOC where lostst = '''')
 GROUP BY LPSROM,LPPRDC
 ORDER BY LPPRDC
 WITH UR') on LPPRDC=t1.codigo
 left outer join dboferta t3 on t1.codigo = t3.codigo and t3.sucursal=@sucursal and (t3.bolsa = 'C1007' or (t3.bolsa = 'XXPAD' and t3.codigo = '2750402'))
  where LPSROM=@bodega and LPLOQT>@cantidad_minima

END
GO
