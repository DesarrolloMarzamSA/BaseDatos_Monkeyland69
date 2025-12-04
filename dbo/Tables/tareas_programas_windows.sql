CREATE TABLE [dbo].[tareas_programas_windows] (
    [HostName]                             VARCHAR (10)  NULL,
    [TaskName]                             VARCHAR (200) NULL,
    [Next_Run_Time]                        VARCHAR (200) NULL,
    [Status]                               VARCHAR (200) NULL,
    [Logon_Mode]                           VARCHAR (200) NULL,
    [Last_Run_Time]                        VARCHAR (200) NULL,
    [Last_Result]                          VARCHAR (200) NULL,
    [Creator]                              VARCHAR (200) NULL,
    [Schedule]                             VARCHAR (200) NULL,
    [Task_To_Run]                          VARCHAR (200) NULL,
    [Start_In]                             VARCHAR (200) NULL,
    [Comment]                              VARCHAR (200) NULL,
    [Scheduled_Task_State]                 VARCHAR (200) NULL,
    [Scheduled_Type]                       VARCHAR (200) NULL,
    [Start_Time]                           VARCHAR (200) NULL,
    [Start_Date]                           VARCHAR (200) NULL,
    [End_Date]                             VARCHAR (200) NULL,
    [Days]                                 VARCHAR (200) NULL,
    [Months]                               VARCHAR (200) NULL,
    [Run_As_User]                          VARCHAR (200) NULL,
    [Delete_Task_If_Not_Rescheduled]       VARCHAR (200) NULL,
    [Stop_Task_If_Runs_X_Hours_and_X_Mins] VARCHAR (200) NULL,
    [Repeat_Every]                         VARCHAR (200) NULL,
    [Repeat_Until_Time]                    VARCHAR (200) NULL,
    [Repeat_Until_Duration]                VARCHAR (200) NULL,
    [Repeat_Stop_If_Still_Running]         VARCHAR (200) NULL,
    [Idle_Time]                            VARCHAR (200) NULL,
    [Power_Management]                     VARCHAR (200) NULL,
    [arguments]                            VARCHAR (20)  NULL,
    [groupid]                              VARCHAR (50)  NULL,
    [DurationTrigger]                      VARCHAR (200) NULL
);


GO

