
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE 		--	CREATE
PROCEDURE [dbo].[usp_tareas_windows_25_pordia]
WITH ENCRYPTION
AS


/*
EXECUTE usp_tareas_windows_25_pordia
*/

--	HostName																		,
SELECT DISTINCT 
--TOP 1
--	RegistrationInfo

	'2012-09-12T12:00:00.000'										AS RegDate							,
	Creator																			AS RegAuthor						,
	TaskName																		as Regdesc							,
--	Triggers
--		Repetition
	CASE WHEN Repeat_Every = 'Disabled' THEN '' ELSE 
	'PT'+RTRIM(LTRIM(LEFT(Repeat_Every,2)))+'M'	END	as Interval					,
	'PT5M'																					as DurationTrigger	,
	'false'																			as StopAtDurationEnd,

	'2012-09-12T12:00:00.000'										AS StartBoundary		,
	'false'																			as EnabledRepetition,
--	--	ScheduredByDay
	'1'																					as DayInteval				,
--	Principals
--		Principal
	Creator																			AS Author2					,
	Run_As_User																	as userID						,
	'InteractiveToken'													as LogonType				,
	'LeastPrivilege'														as RunLevel					,
--	Settings	
--	IdleSettings

	CASE 
	WHEN Repeat_Until_Duration LIKE '10' 	THEN Repeat_Until_Duration	
	ELSE 'PT10M'														END AS DurationSettings	,	
	'PT1H'																			AS WaitTimeout			,
	'false'																			AS StopOnIdleEnd		,
	'false'																			AS RestartOnIdle		,
	
	'IgnoreNew'																	AS MultipleInstancesPolicy	,
	'true'																			AS DisallowStartIfOnBatteries,
	'true'																			AS StopIfGoingOnBatteries,
	'true'																			AS AllowHardTerminate,
	'false'																			AS StartWhenAvailable,
	'false'																			AS RunOnlyIfNetworkAvailable,
	'true'																			AS AllowStartOnDemand	,
	'false'																			AS EnabledSettings		,
	'false'																			AS Hidden							,
	'false'																			AS RunOnlyIfIdle			,
	'false'																			AS WakeToRun					,
	'P3D'																				AS ExecutionTimeLimit	,
	'7'																					AS Priority						,
--	Actions
	--	Exec
	Task_To_Run																	AS Command						,
	arguments																		AS Arguments					,
	Start_In																		AS WorkingDirectory		--,
	




----------------------------------------------------------------
/*

	Repeat_Until_Duration																,
	Repeat_Until_Time																		,
	Repeat_Stop_If_Still_Running												,
	Next_Run_Time																		,
	Status																		,
	Logon_Mode																		,
	Last_Run_Time																		,
	Last_Result																		,
	Schedule																		,
	Comment																		,
	Scheduled_Task_State																		,
	Scheduled_Type																		,
	Start_Time																		,
	Start_Date																		,
	End_Date																		,
	Days																		,
	Months																		,
	Delete_Task_If_Not_Rescheduled																		,
	Stop_Task_If_Runs_X_Hours_and_X_Mins																		,
	Idle_Time																		,
	Power_Management 																		
	
	*/
	
	
FROM tareas_programas_windows
WHERE --Scheduled_Type = 'Daily'
--	TaskName LIKE '%Acarreador%'
--TaskName LIKE 'IBS%'
groupid = 'TRADUCTOR'

--Repeat_Every <> 'Disabled'


-- SELECT * FROM tareas_programas_windows


/*
UPDATE tareas_programas_windows SET groupid = 'DB' where TaskName LIKE 'CORP_DB%'
UPDATE tareas_programas_windows SET groupid = 'FACTURACION ELECTRONICA' where TaskName LIKE '%Pedidos%'
UPDATE tareas_programas_windows SET groupid = 'PEDIDOS ELECTRONICOS' where TaskName LIKE '%Pedidos%' OR TaskName LIKE '%Respuestas%' 
UPDATE tareas_programas_windows SET groupid = 'TRADUCTOR' where TaskName LIKE 'acarreadorPedidos%'
UPDATE tareas_programas_windows SET groupid = 'TRADUCTOR' where TaskName LIKE 'acarreadorRespuestas%'
UPDATE tareas_programas_windows SET groupid = 'TRADUCTOR' where TaskName LIKE 'acarreadorPedidos%'
*/




/*
---alter table tareas_programas_windows ADD arguments VARCHAR(20)

--UPDATE tareas_programas_windows SET arguments = SUBSTRING(Task_To_Run,  CHARINDEX(' ',Task_To_Run,  1) + 1 , 20)
--WHERE CHARINDEX(' ',Task_To_Run,  1) > 0

SELECT Task_To_Run, SUBSTRING(Task_To_Run,  CHARINDEX(' ',Task_To_Run,  1) + 1 , 20) --, arguments 

FROM tareas_programas_windows
--WHERE CHARINDEX(' ',Task_To_Run,  1) > 0
*/
GO
