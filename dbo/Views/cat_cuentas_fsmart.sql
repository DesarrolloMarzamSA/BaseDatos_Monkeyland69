

/*select 
	sucursal, 
	letra, 
	cliente, 
	farmacia, 
	poblacion, 
	case 
		when status NOT LIKE '%BAJA%' then 1 
		ELSE 0 end as activo, 
	cliente_ibs, 
	timestamp, 
	ctepadre
from clientes_baan
where ctepadre IN ( '715', '338')*/
CREATE VIEW [dbo].[cat_cuentas_fsmart]
AS
SELECT        SUCURSAL, 
CASE WHEN SUCURSAL=7 THEN '07'
WHEN SUCURSAL=8 THEN '08'
WHEN SUCURSAL=24 THEN '0X'
WHEN SUCURSAL=23 THEN '0X'
END
 AS LETRA, CLIENTE, FARMACIA, POBLACION, ACTIVO, CLIENTE_IBS, TIMESTAMP, CTEPADRE
FROM            OPENQUERY(AS400, 
                         '
SELECT 
CASE WHEN NOI.noz3lent=''821'' AND SUBSTRING(T2.NANUM,1,1)=''A'' THEN CAST(''01'' AS INT) 
WHEN NOI.noz3lent=''821'' AND SUBSTRING(T2.NANUM,1,1)=''D'' THEN CAST(''04'' AS INT) 
WHEN NOI.noz3lent=''807'' AND SUBSTRING(T2.NANUM,1,1)=''X'' AND TRIM(SR.CMCSTS)=''075'' THEN CAST(''24'' AS INT) 
WHEN NOI.noz3lent=''807'' AND SUBSTRING(T2.NANUM,1,1)=''X'' THEN CAST(''23'' AS INT) 
WHEN NOI.noz3lent=''808'' AND SUBSTRING(T2.NANUM,1,1)=''X'' THEN CAST(''24'' AS INT) 
WHEN NOI.noz3lent=''855'' THEN CAST(''09'' AS INT) 
ELSE CAST(SUBSTRING(NOI.noz3lent,2,3)AS INT) 
END SUCURSAL,
SUBSTRING(T2.NANUM,1,1) letra1,SUBSTRING(T2.NANUM,2,6) AS cliente
,t2.naname AS farmacia,t2.NAADR4 AS poblacion,''1'' as ACTIVO,T2.NANUM AS cliente_ibs,
TIMESTAMP(INSERT(INSERT(DIGITS(t2.NACRDT),5,0,''-''),8,0,''-'') || '' 00:00:00.000'') as timestamp,
SUBSTRING(t2.NANCA1,3,6) AS ctepadre
FROM MA4620EF04.SRBNAM T2 
INNER JOIN MA4620EF04.Z3BNOI NOI ON T2.NANUM=NOI.NONUM
INNER JOIN MA4620EF04.SRBCMA SR ON T2.NANUM=SR.CMCUNO 
WHERE t2.nanca1 in(''99715'', ''99338'',''99724'') and t2.NANUM not in(''G99338'',''X99338'',''X99715'',''G51925'') and t2.NATYPP=1 and t2.NASTAT='' ''')
                          AS derivedtbl_1

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'cat_cuentas_fsmart';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[33] 4[5] 2[45] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "derivedtbl_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'cat_cuentas_fsmart';


GO

