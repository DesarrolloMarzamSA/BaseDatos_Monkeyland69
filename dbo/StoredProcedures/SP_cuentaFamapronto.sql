CREATE procedure [dbo].[SP_cuentaFamapronto] 
as
begin

----insertamos en la tabla cat_farmapronto
--insert into cat_farmapronto
----seleccionamos los datos de sucursal y cuenta que se van a registrar
--select s.sucursal,SUBSTRING(nanum,2,5)as cuenta

----seleccionamos los datos que queremos extraer de as400 el cual es el nanum del cliente padre farmapronto 99676
--from openquery (AS400, 'Select ltrim(rtrim(NANUM)) NANUM 
--								 from  MA4620EF04.SRONAM where NATYPP = 1 AND NANCA1 IN(''99676'')
--								 union
--								 Select NANUM 
--								 from  MA4620EF11.SRONAM where NATYPP = 1 AND NANCA1 IN(''99676'')') as clienteAS400
----esta consulta le pondremos de nombre clienteas400 y nos traera el nanum de as400

----unimos la tabla sucursales para que nos traiga a que sucursal pertenece y descomponemos el nanum para obtener solo la letra
--inner join sucursales s on s.ibs_letra=substring(nanum,1,1) and fisica=1

----unimos la tabla cat_farmacon  y con una subconsulta obtenemos la cuenta de la tabla cat_farmacon con letra con su sucursal
--left join (select s.ibs_letra+cf.cliente as cuenta
--		   from cat_farmapronto cf
		   
--		   --unimos la tabla sucursales y donde este en sucursal este cat_farmacon
--		   inner join sucursales s on s.sucursal=cf.sucursal) as clienteFarma
----el 1 left join es para formar la tabla clientefarma de monkeyland y compararlos con la cuenta de as400 con letra
--on clienteFarma.cuenta = clienteAS400.nanum

----ponemos la condicion donde cuenta sea nulo y nanum sea menor de 6
--where cuenta is null  and len(nanum)=6

----ordenamos de forma asendente la cuenta
--order by cuenta asc  

insert into [monkeyland].[dbo].[cat_farmapronto]
select case 
	   when SUBSTRING(nanum,1,1)='A' then 1
	   when SUBSTRING(nanum,1,1)='C' then 3
	   when SUBSTRING(nanum,1,1)='D' then 4
	   when SUBSTRING(nanum,1,1)='E' then 5
	   when SUBSTRING(nanum,1,1)='G' then 7
	   when SUBSTRING(nanum,1,1)='J' then 6
	   when SUBSTRING(nanum,1,1)='M' then 13
	   when SUBSTRING(nanum,1,1)='P' then 16
	   when SUBSTRING(nanum,1,1)='Q' then 17
	   when SUBSTRING(nanum,1,1)='R' then 18
	   when SUBSTRING(nanum,1,1)='X' then 24
	   when SUBSTRING(nanum,1,1)='Y' then 25
	   when SUBSTRING(nanum,1,1)='V' then 26
	   end as sucursal,
	   SUBSTRING(nanum,2,5)as cuenta
	   --,nanum
from openquery (AS400, 'Select nanum
from  MA4620EF04.SRONAM where NATYPP = 1 AND NANCA1 IN(''99292'') and NASTAT='''' and nanum not in (''C22560'')
union
Select nanum
from  MA4620EF11.SRONAM where NATYPP = 1 AND NANCA1 IN(''99292'') and NASTAT='''' ')
where len(nanum)=6 and SUBSTRING(nanum,2,5) not in (select [cliente] from [monkeyland].[dbo].[cat_farmapronto])
order by sucursal,cuenta

end

GO

