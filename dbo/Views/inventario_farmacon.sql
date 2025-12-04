CREATE VIEW dbo.inventario_farmacon
AS
SELECT        SUCURSAL, CODIGO, COD_BARRAS, PIEZAS
FROM            OPENQUERY([as400], 
                         '
SELECT 
T2.SUCURSAL, 
CAST(T1.srprdc as char(7)) codigo, 
RIGHT(''0000000000000'' || REPLACE(LEFT(LTRIM(IFNULL(CASE T5.PJEANP WHEN ''             '' THEN NULL ELSE T5.PJEANP END, IFNULL(T6.PCXPRC, ''0000000000000''))), 13), '' '', ''''), 13) cod_barras,
CAST(CASE WHEN T1.SRSTHQ - T1.SRPICQ - T1.SRCUSQ - IFNULL(t4.LPLOQT, 0) < 0 THEN 0 ELSE T1.SRSTHQ - T1.SRPICQ - T1.SRCUSQ - IFNULL(t4.LPLOQT, 0) end as int) piezas
from 
MA4620EF04.SRBSRO T1 INNER JOIN PASO.SC_SUCURSALES T2 ON SUBSTRING(T1.SRSROM, 3, 1) = T2.IBS_LETRA
INNER JOIN MA4620EF04.SRBPRG t3 on T1.SRPRDC = t3.PGPRDC
LEFT OUTER JOIN MA4620EF04.WHOLOP t4 on T1.SRSROM = T4.LPSROM AND T1.SRPRDC = t4.LPPRDC AND LPLZON IN (''AA'', ''ME'', ''DP'', ''DC'', ''50'', ''51'')
LEFT OUTER JOIN MA4620EF04.SROEAN t5 on T3.PGPRDC = T5.PJPRDC AND PASO.FN_ISNUMERIC(T3.PGPRDC) = 1 
LEFT OUTER JOIN MA4620EF04.SROPCR T6 ON T3.PGPRDC = T6.PCIPRC
where
PASO.FN_ISNUMERIC(T1.SRPRDC) = 1 and
T3.PGSTAT <> ''D'' AND
substring(T1.SRSROM, 1, 2) = ''01'' and PASO.FN_ISNUMERIC(T1.SRPRDC) = 1 and
(SUBSTRING(T1.SRHSTC, 1, 1) in ('' '', ''C'', ''A'', ''S'', ''D'') or (SUBSTRING(T1.SRHSTC, 1, 1) in (''B'', ''N'') AND CAST(CASE WHEN T1.SRSTHQ - T1.SRPICQ - T1.SRCUSQ - IFNULL(t4.LPLOQT, 0) < 0 THEN 0 ELSE T1.SRSTHQ - T1.SRPICQ - T1.SRCUSQ - IFNULL(t4.LPLOQT, 0) end as int) > 0)) 
union
SELECT 
25 SUCURSAL, 
CAST(T1.srprdc as char(7)) codigo, 
RIGHT(''0000000000000'' || REPLACE(LEFT(LTRIM(IFNULL(CASE T5.PJEANP WHEN ''             '' THEN NULL ELSE T5.PJEANP END, IFNULL(T6.PCXPRC, ''0000000000000''))), 13), '' '', ''''), 13) cod_barras,
CAST(CASE WHEN T1.SRSTHQ - T1.SRPICQ - T1.SRCUSQ - IFNULL(t4.LPLOQT, 0) < 0 THEN 0 ELSE T1.SRSTHQ - T1.SRPICQ - T1.SRCUSQ - IFNULL(t4.LPLOQT, 0) end as int) piezas
from 
MA4620EF04.SRBSRO T1 INNER JOIN PASO.SC_SUCURSALES T2 ON SUBSTRING(T1.SRSROM, 3, 1) = T2.IBS_LETRA
INNER JOIN MA4620EF04.SRBPRG t3 on T1.SRPRDC = t3.PGPRDC
LEFT OUTER JOIN MA4620EF04.WHOLOP t4 on T1.SRSROM = T4.LPSROM AND T1.SRPRDC = t4.LPPRDC AND LPLZON IN (''AA'', ''ME'', ''DP'', ''DC'', ''50'', ''51'')
LEFT OUTER JOIN MA4620EF04.SROEAN t5 on T3.PGPRDC = T5.PJPRDC AND PASO.FN_ISNUMERIC(T3.PGPRDC) = 1 
LEFT OUTER JOIN MA4620EF04.SROPCR T6 ON T3.PGPRDC = T6.PCIPRC
where
PASO.FN_ISNUMERIC(T1.SRPRDC) = 1 and
T3.PGSTAT <> ''D'' AND
substring(T1.SRSROM, 1, 2) = ''01'' and PASO.FN_ISNUMERIC(T1.SRPRDC) = 1 and
(SUBSTRING(T1.SRHSTC, 1, 1) in ('' '', ''C'', ''A'', ''S'', ''D'') or (SUBSTRING(T1.SRHSTC, 1, 1) in (''B'', ''N'') AND CAST(CASE WHEN T1.SRSTHQ - T1.SRPICQ - T1.SRCUSQ - IFNULL(t4.LPLOQT, 0) < 0 THEN 0 ELSE T1.SRSTHQ - T1.SRPICQ - T1.SRCUSQ - IFNULL(t4.LPLOQT, 0) end as int) > 0)) 
FOR FETCH ONLY WITH UR
')
                          AS derivedtbl_1

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'inventario_farmacon';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[6] 4[12] 2[63] 3) )"
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'inventario_farmacon';


GO

