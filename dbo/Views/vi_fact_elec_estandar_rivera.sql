CREATE VIEW dbo.vi_fact_elec_estandar_rivera
AS
SELECT        RIGHT('00' + CONVERT(varchar(2), t1.sucursal), 2) + t1.cliente + t1.digito_verificador + CASE WHEN t1.folio_fiscal IS NULL THEN t1.serie + LEFT(RIGHT(t1.factura, 7) 
                         + '          ', 9) ELSE LEFT(t2.serie_cfd + CONVERT(varchar(8), CONVERT(bigint, t1.folio_fiscal)) + '          ', 10) END + CONVERT(varchar(8), t1.fecha_factura, 112) 
                         + '00' + t1.codigo + LEFT(t1.descripcion + '                                        ', 40) + LEFT(t3.cod_barras_tandem + '             ', 13) + LEFT(t1.clas_fis + '  ', 2) 
                         + RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_con_cargo), 7) + RIGHT('0000000' + CONVERT(varchar(7), t1.piezas_surtidas_sin_cargo), 7) 
                         + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_farm_sin_imp), 10) + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_sin_imp), 10) 
                         + RIGHT('0000000000' + CONVERT(varchar(10), t1.precio_pub_con_imp), 10) AS primera_parte, RIGHT('0000000000000' + CONVERT(varchar(13), t1.importe_bruto), 
                         13) + RIGHT('000000' + CONVERT(varchar(10), t1.porcentaje_descto_oferta), 6) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.descto_oferta), 13) 
                         + RIGHT('000000' + CONVERT(varchar(10), t1.porcentaje_descto_comercial), 6) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.descto_comercial), 13) 
                         + RIGHT('0000000000000' + CONVERT(varchar(13), t1.ieps), 13) + RIGHT('0000000000000' + CONVERT(varchar(13), t1.iva), 13) 
                         + RIGHT('0000000000000' + CONVERT(varchar(13), t1.bonificacion_iva), 13) + RIGHT('00000' + CONVERT(varchar(5), 
                         CASE WHEN t1.porcentaje_utilidad < 0 THEN 0 ELSE t1.porcentaje_utilidad END), 5) + RIGHT('0000000000000' + CONVERT(varchar(13), 
                         t1.importe_neto / t1.piezas_surtidas_con_cargo), 13) + RIGHT('000000000' + REPLACE(t1.orden, ' ', ''), 9) + RIGHT('000000' + CONVERT(varchar(6), 
                         t1.porcentaje_iva), 6) + t1.filler + RIGHT('00000' + CONVERT(varchar(5), t1.no_registro), 5) AS segunda_parte, t1.segto, t1.ctepadre, t1.rfc, t1.fecha_factura, t1.cliente, 
                         t1.sucursal, t1.factura, t1.fecha_tandem, t1.clas_fis
FROM            dbo.facturacion_electronica_estandar AS t1 INNER JOIN
                         dbo.sucursales AS t2 ON t1.sucursal = t2.sucursal INNER JOIN
                         dbo.maestro_productos AS t3 ON t1.codigo = t3.codigo

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vi_fact_elec_estandar_rivera';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[8] 4[21] 2[53] 3) )"
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
         Begin Table = "t1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 280
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t2"
            Begin Extent = 
               Top = 6
               Left = 318
               Bottom = 135
               Right = 491
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t3"
            Begin Extent = 
               Top = 6
               Left = 529
               Bottom = 135
               Right = 741
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vi_fact_elec_estandar_rivera';


GO

