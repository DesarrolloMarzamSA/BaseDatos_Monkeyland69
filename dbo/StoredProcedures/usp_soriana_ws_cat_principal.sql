CREATE procedure [dbo].[usp_soriana_ws_cat_principal]
as

declare @descto money

select	@descto = descuento 
from		clientes_baan 
where	sucursal = 21 and cliente = '16880' 


select	--top 100
			123456 idArtificial,
			21329 Proveedor, --Proveedor
			--convert(BIGINT, t1.cod_barras) Codigo, --Codigo
			t1.cod_barras as Codigo,
			t1.descripcion Descripcion, --Descripcion
			case
				when t1.clas_ssa = '1' then  'true'
				when t1.clas_ssa = '2' then  'true'
				when t1.clas_ssa = '3' then  'true'
				else 'false'
			end Psicotropico, --Psicotropico
			case
				when t1.refrigerado = 'R' then  'true'
				else 'false'
			end ReqRefrigeracion, --ReqRefrigeracion
			case
					when t1.clas_ssa = 1 then 1
					when t1.clas_ssa = 2 then 2
					when t1.clas_ssa = 3 then 3
					when t1.clas_ssa = 4 then 4
					when t1.clas_ssa = 5 then 5
					when t1.clas_ssa = 6 then 6
					when t1.clas_ssa = 7 then 7
					else 0
			end FraccionFarm, --FraccionFarm 
			rtrim(t1.lab_rfc) Laboratorio, --Laboratorio
			'NO DISPONIBLE' ClaseTerapeutica,  --ClaseTerapeutica
			case
					when t1.clas_fis in ('NA', 'BA', 'HA','FA')  then 1
					else 2
			end PorcIVA,  --PorcIVA 
			6 PorcIEPS, --PorcIEPS
			convert(decimal(12, 2), t1.prec_farm) CostoBruto, --CostoBruto
			--t1.pzas_empaque_original CapEmpaque, --CapEmpaque
			1 CapEmpaque, --CapEmpaque 
			case t1.clas_fis
				when 'B' then @descto
				when 'BA' then @descto
				when 'N' then 0.00
				when 'NA' then 0.00
				when 'F' then 0.00
				when 'FA' then 0.00
				when 'H' then t1.descto_prod
				when 'HA' then t1.descto_prod
			end PorcDescuento, --PorcDescuento
			t1.prec_pub PrecioMaxPubl, --PrecioMaxPubl
			case
				when t1.grupo_est = 'ED06A' then 'true'
				else 'false'
			end EsAntibiotico, --EsAntibiotico
			'' 'SustanciasActivas',
			t2.marca Marca, --Marca
			t2.presentacion Presentacion --Presentacion

from		maestro_productos_baan t1 
INNER JOIN vi_catalogo_soriana t3 on t3.codigo = t1.codigo
inner join maestro_productos_baan_extras t2 on 
			t1.codigo = t2.codigo
where	--convert(bigint, t1.codigo) < dbo.gobierno() and 
	--len(rtrim(ltrim(t1.lab_rfc)))  > 0 and 
	--convert(bigint, t1.cod_barras) > 0 and  
	isnumeric(t1.cod_barras ) = 1	
	--and left(t1.status, 1) <> 'B'

--------and 			t3.cod_barras IN (
--------'7501037915112',								---	BISOLVONES
--------'7501034691538',
--------'7501034691415',
--------'7501034691620'
--------)


			
--			and t1.codigo NOT IN (
--'1501501',
--'0144702',
--'0066904',
--'0066905',
--'0279778',
--'0232515',
--'0232510',
--'0232513',
--'0232520',
--'1836088',
--'1836096',
--'1248532',
--'2138217',
--'0808014',
--'1253318',
--'0092004',
--'8407037',
--'2639913',
--'2639915'
--)		
			
			
			
order by 
			t1.cod_barras --desc

/*
select distinct m.cod_barras 
into #ean
from --maestro_productos_baan m
vi_catalogo_soriana m
order by cod_barras


DECLARE @renglones1 INT, @renglones2 INT
set @renglones1 = (SELECT COUNT(*) FROM #ean)

if(select count(*) from sys.sysobjects where name = 'catalogo_soriana')=0
create --	drop	--	truncate
table catalogo_soriana	(
	cod_barras		varchar(13),
	codigo				varchar(7),
	descripcion		varchar(35),
	prec_farm			money	,
	prec_pub			money ,
	clas_ssa			varchar(2),
	clas_fis			varchar(2),
	refrigerado		char(1),
	lab_rfc				varchar(16),
	grupo_est			char(6),
	descto_prod		money
	primary key (codigo )
	)
	;


set @renglones2 = (SELECT COUNT(*) FROM catalogo_soriana)

PRINT @renglones1 
PRINT @renglones2

if @renglones1 <> @renglones2
begin	
	truncate table catalogo_soriana;

	declare @ean VARCHAR(13)

	declare ean_cursor cursor for select cod_barras from #ean
	open ean_cursor
	fetch FROM ean_cursor INTO @ean
	while @@FETCH_STATUS = 0
	begin
		insert into catalogo_soriana
		select top 1 
			cod_barras		,
			codigo				,
			ltrim(rtrim(descripcion))		,
			prec_farm			,
			prec_pub			,
			clas_ssa			,
			clas_fis			,
			refrigerado		,
			lab_rfc				,
			grupo_est			,
			descto_prod		
		from maestro_productos_baan m
		where 
			cod_barras = @ean
			and ISNUMERIC(cod_barras) = 1
			and CONVERT(bigint, cod_barras) > 0
			and LEFT(status,1) <> 'B'
			and m.codigo < dbo.gobierno()
			
		fetch next FROM ean_cursor INTO @ean
	end
	--select * from #catalogo_soriana
	close ean_cursor
	deallocate ean_cursor
end

--drop table #catalogo_soriana
drop table #ean


declare @descto money

select	@descto = descuento 
from		clientes_baan 
where	sucursal = 1 and 
			cliente = '16880' 



select	--top 100
	123456                         AS idArtificial,
	21329                          AS Proveedor, --Proveedor
	convert(bigint, t1.cod_barras) AS Codigo, --Codigo
	t1.descripcion                 AS Descripcion, --Descripcion
	case
		when t1.clas_ssa = '1' then  'true'
		when t1.clas_ssa = '2' then  'true'
		when t1.clas_ssa = '3' then  'true'
		else 'false'
	end                            AS Psicotropico, --Psicotropico
	case
		when t1.refrigerado = 'R' then  'true'
		else 'false'
	end                            AS ReqRefrigeracion, --ReqRefrigeracion
	case
			when t1.clas_ssa = 1 then 1
			when t1.clas_ssa = 2 then 2
			when t1.clas_ssa = 3 then 3
			when t1.clas_ssa = 4 then 4
			when t1.clas_ssa = 5 then 5
			when t1.clas_ssa = 6 then 6
			when t1.clas_ssa = 7 then 7
			when t1.clas_ssa > 7 then 0
	end                           AS FraccionFarm, --FraccionFarm 
	rtrim(t1.lab_rfc) Laboratorio, --Laboratorio
	'NO DISPONIBLE' ClaseTerapeutica,  --ClaseTerapeutica
	case
			when t1.clas_fis in ('NA', 'BA', 'HA')  then 1
			else 2
	end                           AS PorcIVA,  --PorcIVA 
	6                             AS PorcIEPS, --PorcIEPS
	convert(decimal(12, 2), t1.prec_farm) CostoBruto, --CostoBruto
	--t1.pzas_empaque_original CapEmpaque, --CapEmpaque
	1 CapEmpaque, --CapEmpaque 
	case clas_fis
		when 'B' then @descto
		when 'BA' then @descto
		when 'N' then 0.00
		when 'NA' then 0.00
		when 'H' then descto_prod
		when 'HA' then descto_prod
	end PorcDescuento, --PorcDescuento
	t1.prec_pub PrecioMaxPubl, --PrecioMaxPubl
	case
		when t1.grupo_est = 'ED06A' then 'true'
		else 'false'
	end EsAntibiotico, --EsAntibiotico
	'' 'SustanciasActivas',
	t2.marca Marca, --Marca
	t2.presentacion Presentacion --Presentacion
from	catalogo_soriana t1 
inner join maestro_productos_baan_extras t2 on 
			t1.codigo = t2.codigo
*/			
			
/*
where	convert(bigint, t1.codigo) < dbo.gobierno() 
			and len(rtrim(ltrim(t1.lab_rfc)))  > 0
			and left(t1.status, 1) <> 'B'
			and convert(bigint, t1.cod_barras) > 0
*/

/*
order by 
			cod_barras --desc

*/

GO

