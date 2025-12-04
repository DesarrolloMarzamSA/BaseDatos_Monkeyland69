CREATE PROCEDURE [dbo].[SP_ClienteFarmacon]
	
AS
BEGIN	
	SET NOCOUNT ON;
	--insertamos en la tabla cat farmacon 
insert into cat_farmacon

--para igualar los campos que se insertaran en la tabla cat_farmacon seleccionamos la sucursal,numero de cuenta y el ultimo campo que es nulo en cat_farmacon
select s.sucursal,SUBSTRING(nanum,2,5)as cuenta,getdate()

--seleccionamos los datos que queremos extraer de as400 el cual es el nanum del cliente padre farmacon 99599 y 99873
from openquery (AS400, 'Select ltrim(rtrim(NANUM)) NANUM 
								 from  MA4620EF04.SRONAM where NATYPP = 1 AND NANCA1 IN(''99599'',''99873'',''99965'',''99465'')
								 union
								 Select NANUM 
								 from  MA4620EF11.SRONAM where NATYPP = 1 AND NANCA1 IN(''99599'',''99873'',''99965'',''99465'')') as clienteAS400
--esta consulta le pondremos de nombre clienteas400 y nos traera el nanum de as400

--unimos la tabla sucursales para que nos traiga a que sucursal pertenece y descomponemos el nanum para obtener solo la letra
inner join sucursales s on s.ibs_letra=substring(nanum,1,1)

--unimos la tabla cat_farmacon  y con una subconsulta obtenemos la cuenta de la tabla cat_farmacon con letra con su sucursal
left join (select s.ibs_letra+cf.cuenta as cuenta,cf.sucursal
		   from cat_farmacon cf
		   
		   --unimos la tabla sucursales y donde este en sucursal este cat_farmacon
		   inner join sucursales s on s.sucursal=cf.sucursal) as clienteFarma
--el 1 left join es para formar la tabla clientefarma de monkeyland y compararlos con la cuenta de as400 con letra
on clienteFarma.cuenta = clienteAS400.nanum

--ponemos la condicion donde cuenta sea nulo y nanum sea menor de 6
where cuenta is null  and len(nanum)=6 and nanum not in('A33318')

--ordenamos de forma asendente la cuenta
order by cuenta asc  
END

GO

