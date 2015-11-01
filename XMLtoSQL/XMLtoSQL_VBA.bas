Option Compare Database
Option Explicit

''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Private Sub SQLUpload_Click()
On Error GoTo ErrHandle

    Dim db As Database
    Dim tbldef As TableDef
    
    Set db = CurrentDb
    
    ' REMOVE PRIOR LINKED MYSQL TABLE
    For Each tbldef In db.TableDefs
        If tbldef.Name = "CLData" Then
            db.TableDefs.Delete ("CLData")
        End If
    Next tbldef
    
    ' RE-LINK MYSQL TABLE
    DoCmd.TransferDatabase acLink, "ODBC Database", _
          "ODBC;DRIVER={MySQL ODBC 5.3 Unicode Driver};server=hostname;database=database;" _
           & "UID=username;PWD=password;", acTable, "CLData", "CLData"
    
    ' RUN APPEND QUERY
    db.Execute "INSERT INTO CLData SELECT * FROM missedConnection", dbFailOnError
    
    Set tbldef = Nothing
    Set db = Nothing
        
    MsgBox "Successfully migrated XML data to SQL!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
    
End Sub

Private Sub XMLImport_Click()
On Error GoTo ErrHandle
    Dim xmlstr As String
    
    Dim db As Database
    Dim tbldef As TableDef
    
    Set db = CurrentDb
    
    ' REMOVE PRIOR LINKED MYSQL TABLE
    For Each tbldef In db.TableDefs
        If tbldef.Name = "missedConnection" Then
            db.TableDefs.Delete ("missedConnection")
        End If
    Next tbldef
    
    xmlstr = Application.CurrentProject.Path & "\CLData.xml"
    Application.ImportXML xmlstr
    
    Set tbldef = Nothing
    Set db = Nothing
    
    MsgBox "Successfully imported XML data into Access!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
    
End Sub


''''''''''''''''''
''MS EXCEL VBA
''''''''''''''''''
Sub xmlUpload()
On Error GoTo ErrHandle
    Dim CN As Object
    Dim constr As String, strPath As String, sql As String
    Dim wb As Workbook
    Dim r As Long, counter As Long
    
    strPath = ActiveWorkbook.Path
      
    ' IMPORT XML FILE TO EXTERNAL WORKBOOK
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    Set wb = Workbooks.OpenXML(Filename:=strPath & "\CLData.xml", LoadOption:=xlXmlLoadImportToList)
    
    ' CONNECTING TO DATABASE
    constr = "DRIVER=MySQL ODBC 5.3 Unicode Driver;server=hostname;database=database;UID=username;PWD=password;"
    
    Set CN = CreateObject("ADODB.Connection")
    CN.Open constr

    ' APPEND XML DATA ROWS
    counter = 0
    For r = 2 To wb.Sheets(1).UsedRange.Rows.Count
        CN.BeginTrans
        sql = "INSERT INTO CLData (user, category, city, post, time, link) " _
                 & "VALUES(" & wb.Sheets(1).Cells(r, 1) & ", " & Chr(39) & wb.Sheets(1).Cells(r, 2) & Chr(39) & ", " _
                         & Chr(39) & wb.Sheets(1).Cells(r, 3) & Chr(39) & ", " & Chr(39) & Replace(wb.Sheets(1).Cells(r, 4), "'", "''") & Chr(39) & ", " _
                         & Chr(39) & wb.Sheets(1).Cells(r, 5) & Chr(39) & ", " & Chr(39) & wb.Sheets(1).Cells(r, 6) & Chr(39) & ")"

        CN.Execute sql
        CN.CommitTrans
        counter = counter + 1
    Next r

    wb.Close False
    
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
    
    ' CLOSE DATABASE
    CN.Close
        
    MsgBox "Successfully migrated " & counter & " rows of XML data into SQL!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
    
End Sub
