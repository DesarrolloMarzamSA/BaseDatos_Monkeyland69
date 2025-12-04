CREATE VIEW dbo.vw_facturacion_benavides_fes
AS
SELECT DISTINCT 
                      t1.sucursal, t1.cliente, t1.digito_verificador, t1.serie, t1.factura, t1.fecha_factura, t1.codigo, t1.descripcion, 
                      RIGHT('0000000000000' + LTRIM(RTRIM(ISNULL(t2.cod_barras, '0000000000000'))), 13) AS cod_barras, t1.clas_fis, t1.piezas_surtidas_con_cargo, 
                      t1.piezas_surtidas_sin_cargo, ROUND(t1.precio_farm_sin_imp, 2) AS precio_farm_sin_imp, ROUND(t1.precio_pub_sin_imp, 2) AS precio_pub_sin_imp, 
                      ROUND(t1.precio_pub_con_imp, 2) AS precio_pub_con_imp, ROUND(t1.importe_bruto, 2) AS importe_bruto, ROUND(t1.porcentaje_descto_oferta, 2) 
                      AS porcentaje_descto_oferta, ROUND(t1.descto_oferta, 2) AS descto_oferta, ROUND(t1.porcentaje_descto_comercial, 2) AS porcentaje_descto_comercial, 
                      ROUND(t1.descto_comercial, 2) AS descto_comercial, ROUND(t1.ieps, 2) AS ieps, ROUND(t1.iva, 2) AS iva, ROUND(t1.bonificacion_iva, 2) AS bonificacion_iva, 
                      ROUND(t1.porcentaje_utilidad, 2) AS porcentaje_utilidad, ROUND(t1.importe_neto, 2) AS importe_neto, t1.orden, ROUND(t1.porcentaje_iva, 2) AS porcentaje_iva, 
                      t1.filler, t1.no_registro, t1.desc_comerc_prod, t1.porcentaje_iva2, t1.iva2, t1.bonificacion_iva2, t1.porcentaje_ieps, t1.desc_comerc_ieps, t1.iva_del_iesps, 
                      t1.bonificacion_iva_del_iesps, t1.timestamp, t1.segto, t1.ctepadre, t1.rfc, t1.tipo_documento, t1.folio_fiscal, t1.fecha_tandem
FROM         Historica.dbo.fes2 AS t1 WITH (nolock) LEFT OUTER JOIN
                      capa_ibs.dbo.maestro_productos AS t2 WITH (nolock) ON t1.codigo = t2.codigo

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_facturacion_benavides_fes';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "t2"
            Begin Extent = 
               Top = 6
               Left = 305
               Bottom = 125
               Right = 506
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 267
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_facturacion_benavides_fes';


GO

