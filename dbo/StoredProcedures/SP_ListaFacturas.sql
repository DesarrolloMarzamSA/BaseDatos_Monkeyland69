
	CREATE procedure [dbo].[SP_ListaFacturas] 
	@fechainicio nvarchar(30),
    @fechafin nvarchar(30)
     as
       begin
	   insert into [monkeyland].[dbo].[superisste3]
	    exec  SP_LlenadoSuperisste @fechainicio,@fechafin
		select * from  [monkeyland].[dbo].[superisste3] where Fecha between @fechainicio and @fechafin  
		delete [monkeyland].[dbo].[superisste2] 
		end

GO

