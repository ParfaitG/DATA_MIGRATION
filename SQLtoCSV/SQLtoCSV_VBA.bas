Option Compare Database
Option Explicit

''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Private Sub SQLImport_Click()
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
   
    Set tbldef = Nothing
    Set db = Nothing
        
    MsgBox "Successfully uploaded SQL data into Access!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub

Private Sub CSVExport_Click()
On Error GoTo ErrHandle
    Dim strFile As String, todayDate As String
    
    todayDate = Format(Date, "YYYYMMDD")
    strFile = Application.CurrentProject.Path & "\CLData_" & todayDate & ".csv"
        
    DoCmd.TransferText acExportDelim, , "CLData", strFile, True
    
    MsgBox "Successfully exported SQL data into CSV!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub


''''''''''''''''''
''MS EXCEL VBA
''''''''''''''''''
Sub sqlImport()
On Error GoTo ErrHandle
    Dim wb As Workbook
    Dim strPath As String, constr As String
    Dim conn As Object
    Dim i As Long
    
    strPath = Application.ActiveWorkbook.Path
    
    ' OPEN DB CONNECTION
    Set conn = CreateObject("ADODB.Connection")
    constr = "DRIVER={MySQL ODBC 5.3 Unicode Driver};server=hostname;database=database;UID=username;PWD=password"
    conn.Open constr
            
    ' READ CSV
    Workbooks.OpenText Filename:=strPath & "\CLData.csv", DataType:=xlDelimited, Comma:=True
    Set wb = ActiveWorkbook
    
    ' APPEND TO DATABASE
    For i = 2 To wb.Sheets(1).UsedRange.Rows.Count
        conn.Execute "INSERT INTO cldata (user, category, city, post, time, link)" _
                        & "VALUES (" & wb.Sheets(1).Cells(i, 1) & ", '" & wb.Sheets(1).Cells(i, 2) & "', " _
                        & "'" & wb.Sheets(1).Cells(i, 3) & "', '" & Replace(wb.Sheets(1).Cells(i, 4), "'", "''") & "', " _
                        & "'" & wb.Sheets(1).Cells(i, 5) & "', '" & wb.Sheets(1).Cells(i, 6) & "')"
    Next i
        
    wb.Close False
    conn.Close
    
    MsgBox "Successfully migrated CSV data into SQL!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub



