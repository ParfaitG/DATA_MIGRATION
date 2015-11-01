Option Compare Database
Option Explicit

''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Private Sub CSVExport_Click()
On Error GoTo ErrHandle
    Dim strFile As String, todayDate As String
    
    todayDate = Format(Date, "YYYYMMDD")
        
    strFile = Application.CurrentProject.Path & "\CLData_" & todayDate & ".csv"
    DoCmd.TransferText acExportDelim, , "missedConnection", strFile, True
    
    MsgBox "Successfully converted XML data into CSV!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
End Sub

Private Sub XMLImport_Click()
On Error GoTo ErrHandle
    Dim xmlstr As String
    
    Dim db As Database
    Dim tbldef As TableDef
    
    Set db = CurrentDb
    
    ' REMOVE PRIOR TABLE
    For Each tbldef In db.TableDefs
        If tbldef.Name = "missedConnection" Then
            db.TableDefs.Delete ("missedConnection")
        End If
    Next tbldef
    
    ' IMPORT XML FILE TO TABLE
    xmlstr = Application.CurrentProject.Path & "\CLData.xml"
    Application.ImportXML xmlstr
    
    Set tbldef = Nothing
    Set db = Nothing
    
    MsgBox "Successfully imported XML data into Access!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub


''''''''''''''''''
''MS EXCEL VBA
''''''''''''''''''
Sub xmlExport()
On Error GoTo ErrHandle
    Dim wb As Workbook
    Dim strPath As String, todayDate As String
    
    strPath = Application.ActiveWorkbook.Path
    todayDate = Format(Date, "YYYYMMDD")
        
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    
    'OPENING XML FILE IN NEW WORKBOOK
    Set wb = Workbooks.OpenXML(Filename:=strPath & "\CLData.xml", LoadOption:=xlXmlLoadImportToList)
    
    ' SAVING WORKBOOK AS CSV FILE
    wb.SaveAs strPath & "\CLData_" & todayDate, FileFormat:=xlCSV
    wb.Close False
    
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
    
    MsgBox "Successfully imported XML data!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
    
End Sub

