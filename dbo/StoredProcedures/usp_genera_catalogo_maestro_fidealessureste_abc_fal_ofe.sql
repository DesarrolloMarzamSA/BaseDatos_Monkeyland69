USE monkeyland
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_genera_catalogo_maestro_fidealessureste_abc_fal_ofe] (@sucursal int)	WITH ENCRYPTION
as


/*
EXECUTE usp_genera_catalogo_maestro_fidealessureste_abc_fal_ofe 5
*/


--  CATALOGO MAESTRO CON ALTAS BAJAS Y CAMBIOS PARA
--  FARMACIAS IDEALESSURESTE


--	FECHA				DESCRIPCION												PROGRAMADOR				SOLICITO
--	----------	----------------------------			----------------	----------
--	2009-08-03	CREACION													MIGUEL SAMAYOA		ERICKA
--	2009-09-17	SE AGREGO CODIGO 9000605					MIGUEL SAMAYOA		PALMA
--	2011-07-07	SE AGREGARON BOLSAS DE OFERTAS		MIGUEL SAMAYOA		MOISES

/*
declare @sucursal int
set @sucursal = 5        
*/


declare @sucursal_final int
select @sucursal_final=case when @sucursal=1 then 21 else @sucursal end

declare @sep varchar(1) 
set @sep = '|'

--declare @bolsa varchar(5)
--set @bolsa = 'C2571'

DECLARE @bolsa1 VARCHAR(5), @bolsa2 VARCHAR(5), @bolsa3 VARCHAR(5)
set @bolsa1 = 'XXPAD'
set @bolsa2 = 'LIBRE'
set @bolsa3 = 'ZFHYB'
declare @dias int
set @dias = 5

declare @descto DECIMAL(10,2)
SET @descto = 18
--	(SELECT descuento FROM clientes_baan WHERE sucursal = @sucursal and cliente = '99571')

DECLARE @excepciones VARCHAR(50)

SET @excepciones = '9000605'

IF (SELECT COUNT(*) FROM sys.sysobjects WHERE name = 'catalogo_maestro_farmacias_idealessureste') = 0
create --	drop	--	truncate
table catalogo_maestro_farmacias_idealessureste (
	sucursal					int	,
  tipo_movimiento   varchar(1),           
  cod_barras        varchar(20),          
  clave_proveedor   varchar(7)	,          
  descripcion       varchar(100),         
  desc_corta        varchar(20),          
  familia						varchar(2),           
  laboratorio       varchar(40),					
  presentacion			varchar(2),				    
  pcio_farmacia		  money,				        
  pcio_max_pub      money,						    
  porc_iva          decimal(5,2),					
  porc_ieps         decimal(5,2),			    
  porc_oferta       decimal(5,2),				  
  escala_oferta     int,								  
  porc_oferta_2     decimal(5,2),				  
  escala_oferta_2   int,								  
  porc_financiero   decimal(5,2),					
  unid_c_cargo      decimal(7,2),								  
  unid_s_cargo      decimal(7,2),								  
  Caduca            varchar(1),				    
  Refrigeracion     varchar(1),			      
  Devolucion        varchar(1),				    
  c_ssa             varchar(1),					  
  clas_fis          varchar(10),					
  grupo_est         varchar(10),					
	timestamp					smalldatetime					,
	metodo						varchar(5)						,
	vigencia_inicial		date							,
	vigencia_final		date,
	descuento_final float,
	precio_final	float
PRIMARY KEY (sucursal, clave_proveedor )
)

declare @descto_vol decimal (6,2)
declare @descto_neto decimal (6,2)
set @descto_vol = 3.5
set @descto_neto = 10

--	TRUNCATE TABLE catalogo_maestro_farmacias_idealessureste
DELETE FROM catalogo_maestro_farmacias_idealessureste WHERE sucursal = @sucursal_final

-----------------------------------  CATALOGO ACTUALIZADO  -----------------------------

delete FROM [capa_ibs].[dbo].[tbl_metodos_ofertas]
  where cast(codigo as int )in (
  SELECT cast(codigo as int)
			FROM [capa_ibs].[dbo].[tbl_metodos_ofertas]
			where sucursal=@sucursal_final and metodo in ('ZF571','ZG571','ZFHYB','ZGMG2')
			GROUP BY  codigo
			having COUNT(*)>1
  ) and metodo <>'ZGMG2'

insert into catalogo_maestro_farmacias_idealessureste   
  SELECT 
		@sucursal_final, CASE 
			WHEN i.piezas > 0  THEN  ' ' 
			WHEN i.piezas = 0 THEN 'F' 
			WHEN LEFT(mpb.status,1) = 'B' THEN 'B' 
			end tipo_movimiento,				
    cod_barras_tandem,																																
    mpb.codigo AS clave_proveedor,																						
    descripcion,																															
    desc_corta,																																
    CASE WHEN clas_ssa IN ('1','2','3') THEN ' 2'	--	CONTROLADOS
         WHEN clas_ssa IN ('4','5'    ) THEN ' 1'	--	PATENTE
         WHEN clas_ssa IN ('6','9'    ) THEN ' 4'	--	VARIOS
         WHEN clas_ssa IN ('8'        ) THEN ' 5'	--	PERFUMERIA
         WHEN clas_ssa IN ('7'        ) THEN '13' --	MATERIAL DE CURACION
																				ELSE ' 0' END familia,								
    LEFT(lab_largo+REPLICATE(' ',20),20) laboratorio,													
    '00' presentacion,																												
    CASE WHEN mpb.grupo_est = 'PC01A'		THEN mpb.prec_farm + (mpb.prec_farm * 0.5)  
																				ELSE mpb.prec_farm	END prec_farm,		
    CASE WHEN mpb.grupo_est = 'PC1A'		THEN mpb.prec_pub  + (mpb.prec_pub  * 0.5)   
																				ELSE mpb.prec_pub		END prec_pub,			
    iva porc_iva,																															
    CASE WHEN mpb.grupo_est = 'PC01A'		THEN 50 ELSE 0 END porc_ieps,					
    --0 porc_oferta,													
    isnull(metodo_oferta.ofer,0) as porc_oferta,
    0 escala_oferta,																													
    0 porc_oferta_2,																													
    0 escala_oferta_2,																												
    CASE  WHEN clas_fis IN ('B','BA') THEN @descto
          WHEN clas_fis IN ('N','NA') THEN 0
          WHEN clas_fis IN ('H','HA') THEN descto_prod END porc_financiero,		
    1 unid_c_cargo,																														
    0 unid_s_cargo,																														
    CASE WHEN clas_ssa IN ('1','2','3','4','5') THEN 1 ELSE 0 END caduca,			
    left(refrigerado,1) refrigeracion,																				
    '0' devolucion,																														
    clas_ssa c_ssa,																														
    clas_fis,																																	
    grupo_est,																																
		mpb.timestamp			,
		null metodo																												
		,	null,null,
		0,0,isnull(metodo_oferta.ofer,0)/100,
		CASE  WHEN clas_fis IN ('B','BA') THEN isnull(@descto,0)
          WHEN clas_fis IN ('N','NA') THEN 0
          WHEN clas_fis IN ('H','HA') THEN isnull(descto_prod,0) END/100,
          isnull(descu.descuento_volumen,0),isnull(descu.descuento_netos,0),0
		--ISNULL(
		--1-( (1-descu.descuento_volumen) * (1-descu.descuento_netos)* (1-(isnull(metodo_oferta.ofer,0)/100))*
		--     (1- ( 
		--  CASE  WHEN clas_fis IN ('B','BA') THEN isnull(@descto,0)
  --        WHEN clas_fis IN ('N','NA') THEN 0
  --        WHEN clas_fis IN ('H','HA') THEN isnull(descto_prod,0) END/100
  --        ))
		--),0),
		--round(mpb.prec_farm-(mpb.prec_farm* isnull((
		--1-( (1-descu.descuento_volumen) * (1-descu.descuento_netos)* (1-(isnull(metodo_oferta.ofer,0)/100))*
		--     (1- ( 
		--  CASE  WHEN clas_fis IN ('B','BA') THEN isnull(@descto,0)
  --        WHEN clas_fis IN ('N','NA') THEN 0
  --        WHEN clas_fis IN ('H','HA') THEN isnull(descto_prod,0) END/100
  --        ))
		--)),0)),2)
  FROM maestro_productos_baan mpb
  INNER JOIN inventario_baan i ON --i.piezas > 0 AND 
		mpb.codigo = i.codigo AND i.sucursal = @sucursal_final
  left join (
			SELECT codigo,porcentaje*100 as ofer
			FROM [capa_ibs].[dbo].[tbl_metodos_ofertas]
			where sucursal=@sucursal_final and metodo in ('ZF571','ZG571','ZFHYB','ZGMG2')
			GROUP BY  codigo,porcentaje*100 ) as metodo_oferta
  on metodo_oferta.codigo=mpb.codigo
    left join catalogo_descuentos_farmacias_idealessureste descu on
		cast(mpb.codigo as bigint)=descu.codigo_marzam
  WHERE 
     mpb.codigo NOT IN (
			SELECT clave_proveedor 
			FROM catalogo_maestro_farmacias_idealessureste 
			WHERE sucursal = @sucursal_final)
    AND ISNUMERIC(mpb.cod_barras_tandem) = 1 
    AND (CONVERT(bigINT, mpb.codigo) < dbo.gobierno() OR mpb.codigo IN (@excepciones))
    /*modificacion para omitir laboratorios 2013/03/05
    Abraham AMrcelino ramirez vega
    */
    and cod_lab not in ('0120','2237','2239','0135','0147','0158',
	'0132','0133','2709','2713','2714','2885','2329','2334','2335','2336','2337','2338','2339','2341',
	'0301','3006','3012','3215','115','2441','2442','2941','2943','2944','2946','2947','2948','2949')
	and mpb.codigo not in (
'0087025',
'0087034',
'0087035',
'0087201',
'0087202',
'0087203',
'0087204',
'0090301',
'0090302',
'0090303',
'1660905',
'0009001',
'0009002',
'0009003',
'0090801',
'0425102',
'0425103',
'0425104',
'0425105',
'0425106',
'0613816',
'0676203',
'0676204',
'0715303',
'0715305',
'0715306',
'0856005',
'0856006',
'0868007',
'0951001',
'0959103',
'1012103',
'1012104',
'1012107',
'1401008',
'1401009',
'1401010',
'1487013',
'1507303',
'1507305',
'1507307',
'1507309',
'1507312',
'1507313',
'1609801',
'1647901',
'1654103',
'1938205',
'1992002',
'1992003',
'1992004',
'1992005',
'2456503',
'2456505',
'2456506',
'2470203',
'2631101',
'2640501',
'2689302',
'2689303',
'2689304',
'2518901'
	)
    and i.piezas>0


update catalogo_maestro_farmacias_idealessureste set descuento_final=1-((1-descuento1)*(1-descuento2)*(1-descuento3)*(1-descuento4)*(1-descuento5))
where sucursal=@sucursal_final

update catalogo_maestro_farmacias_idealessureste set precio_final=pcio_farmacia-(pcio_farmacia*descuento_final)
where sucursal=@sucursal_final

------------------------------------------------------------------------------------------------

--DECLARE @bolsa1 VARCHAR(5), @bolsa2 VARCHAR(5), @bolsa3 VARCHAR(5)
--set @bolsa1 = 'XXPAD'
--set @bolsa2 = 'LIBRE'
--set @bolsa3 = 'ZFHYB'


CREATE TABLE #fidealessureste_ofertas (
--	fecha							smalldatetime,
	sucursal					int					,
	bolsa							varchar( 5)	,
	codigo						varchar( 7)	,
	cant_base					money				,
	cant_oferta				money				,
	porcentaje				money				,
	vigencia_inicial		DATE			,
	vigencia_final			DATE			,
	disponible					INT								,
	timestamp						DATETIME
	primary key (sucursal, bolsa, codigo) )
	
	/*esta parte actualizal as ofertas y es la que parece estar fallando*/
	--INSERT INTO #fidealessureste_ofertas
	--EXECUTE usp_constructor_metodos_ofertas 'FIDEALESSURESTE', @sucursal_final
	
-----------------------------------------------------------------------------------------------

--UPDATE catalogo_maestro_farmacias_idealessureste SET 
--	porc_oferta = ofe.porcentaje * 100,
--	metodo = ofe.bolsa,
--	vigencia_inicial = ofe.vigencia_inicial,
--	vigencia_final = ofe.vigencia_final
--FROM catalogo_maestro_farmacias_idealessureste cat
--INNER JOIN #fidealessureste_ofertas ofe ON 
--	ofe.sucursal = @SUCURSAL AND 
--	cast(ofe.codigo as bigint) = cast(cat.clave_proveedor as bigint)
--WHERE --tipo_movimiento <> 'F' AND
--	  cat.sucursal = case when @sucursal=1 then 21 else @sucursal end  

--AND porc_oferta <> 0
--and metodo is null

-------------------- BLOQUE PARA REVISAR CON EXCEL ---------------------------------
/*
select 
  tipo_movimiento ,										
  cod_barras as codigo     ,										
  clave_proveedor ,										
  descripcion     ,										
  desc_corta      ,										
	familia					,										
  laboratorio     ,										
	presentacion		,										
  pcio_farmacia		,
  pcio_max_pub	  ,
  porc_iva        ,
  porc_ieps       ,
  porc_oferta     ,
  escala_oferta   ,
  porc_oferta_2   ,
  escala_oferta_2 ,
  porc_financiero ,
  unid_c_cargo    ,
  unid_s_cargo    ,
  caduca          ,
  refrigeracion   ,
  devolucion      ,
  c_ssa           ,
  clas_fis        ,
  grupo_est				,
	timestamp
from catalogo_maestro_farmacias_idealessureste
--where clave_proveedor = '0247002'
--where convert(int,clave_proveedor) in 
--(1116802,1116801,1116803,1116804,1485002,1485001,2320001,2530401,2530402,2530405,2530403,2530404,551202,551201,702501,702502,2689201,2689202)
order by clave_proveedor  --  descripcion			--	tipo_movimiento,


*/
-------------------------------------------------------------------------------------------------

set @sep = ''
-------------------------------------------  RESULTADO FINAL	---------------------------------------


SELECT 
  tipo_movimiento                                + @sep +																		          
  LEFT(cod_BARRAS																									+ REPLICATE(' ', 20), 20) + @sep +	
  LEFT(clave_proveedor																						+ REPLICATE(' ', 10), 10) + @sep +	
  LEFT(descripcion																								+ REPLICATE(' ',100),100) + @sep +	
  LEFT(desc_corta																									+ REPLICATE(' ', 20), 20) + @sep +	
  LEFT(familia																										+ REPLICATE(' ',  2),  2) + @sep +	
  LEFT(laboratorio																								+ REPLICATE(' ', 20), 20)	+ @sep +	
  presentacion																																							+ @sep +	
  --LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),pcio_farmacia  )) + REPLICATE(' ', 12), 12) + @sep +	
  LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),precio_final  )) + REPLICATE(' ', 12), 12) + @sep +	
  LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),pcio_max_pub   )) + REPLICATE(' ', 12), 12) + @sep +	
  LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),porc_iva * 100 )) + REPLICATE(' ',  6),  6) + @sep + 
  LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),porc_ieps      )) + REPLICATE(' ',  6),  6) + @sep + 
  LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),0.0    )) + REPLICATE(' ',  6),  6) + @sep + 
  LEFT ( CONVERT(VARCHAR, CONVERT(INT          ,escala_oferta  )) + REPLICATE(' ',  4),  4) + @sep +	
  LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),porc_oferta_2  )) + REPLICATE(' ',  6),  6) + @sep +	
  LEFT ( CONVERT(VARCHAR, CONVERT(INT          ,escala_oferta_2)) + REPLICATE(' ',  4),  4) + @sep +	
  --LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),porc_financiero)) + REPLICATE(' ',  6),  6) + @sep + 
  LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),0.0)) + REPLICATE(' ',  6),  6) + @sep + 
  LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),unid_c_cargo   )) + REPLICATE(' ',  7),  7) + @sep + 
  LEFT ( CONVERT(VARCHAR, CONVERT(DECIMAL(12,2),unid_s_cargo   )) + REPLICATE(' ',  7),  7) + @sep +	
  coalesce (nullif (caduca, ''), '0') + @sep +
  CASE WHEN LEFT(refrigeracion,1) = 'R' THEN '1' ELSE '0' END																+ @sep + 
  coalesce (nullif (devolucion, ''), '0')+ @sep +
  coalesce (nullif (c_ssa, ''), '0')+ @sep +	
  CASE                                                                                  
    WHEN @sucursal =  5 THEN '1' 
    WHEN @sucursal = 13 THEN '2'
    WHEN @sucursal =  1 THEN '3'
    WHEN @sucursal =  4 THEN '4'
    WHEN @sucursal =  3 THEN '5'
    ELSE '0' END
    --+@sep + LEFT ( CONVERT(VARCHAR,precio_final) + REPLICATE(' ', 12), 12)
FROM catalogo_maestro_farmacias_idealessureste U
INNER JOIN inventario_baan i ON 
	u.clave_proveedor = i.codigo AND i.sucursal =@sucursal_final 
WHERE U.sucursal = @sucursal_final
AND (pcio_farmacia IS NOT NULL OR pcio_max_pub IS NOT NULL)
ORDER BY clave_proveedor


drop table #fidealessureste_ofertas


--drop table catalogo_maestro_farmacias_idealessureste

GO
