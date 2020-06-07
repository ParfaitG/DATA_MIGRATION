
''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Public Sub XMLtoCSV_ACC()
On Error GoTo ErrHandle
    Dim strPath, xmlstr As String
    
    Dim db As Database, tbldef As TableDef
    
    strPath = Application.CurrentProject.Path

    ' REMOVE PRIOR TABLE
    Set db = CurrentDb
    For Each tbldef In db.TableDefs
        If tbldef.Name = "missedConnection" Then
            db.TableDefs.Delete ("missedConnection")
        End If
    Next tbldef
    
    ' IMPORT XML
    xmlstr = strPath & "\CLData.xml"
    Application.ImportXML xmlstr

    ' EXPORT CSV
    DoCmd.TransferText acExportDelim, , "missedConnection", strPath & "\CLData_ACC.csv", True
    
    MsgBox "Successfully migrated XML data to CSV!", vbInformation

ExitHandle:    
    Set tbldef = Nothing: Set db = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub


''''''''''''''''''
''MS EXCEL VBA
''''''''''''''''''
Public Sub XMLtoCSV_XL()
On Error GoTo ErrHandle
    Dim wb As Workbook
    Dim strPath As String
    
    strPath = Application.ActiveWorkbook.Path
        
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    
    'OPENING XML
    Set wb = Workbooks.OpenXML(Filename:=strPath & "\CLData.xml", LoadOption:=xlXmlLoadImportToList)
    
    ' SAVE CSV
    wb.SaveAs strPath & "\CLData_XL.csv", FileFormat:=xlCSV
    wb.Close False
    
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
    
    MsgBox "Successfully migrated XML data to CSV!", vbInformation

ExitHandle:
    Set wb = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub

