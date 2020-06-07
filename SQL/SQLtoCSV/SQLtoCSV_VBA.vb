
''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Public Sub SQLtoCSV_ACC()
On Error GoTo ErrHandle
    Dim db As Database
    Dim tbldef As TableDef
    
    Set db = CurrentDb
    
    ' REMOVE PRIOR LINKED TABLE
    For Each tbldef In db.TableDefs
        If tbldef.Name = "CLData_linked" Then
            db.TableDefs.Delete ("CLData_linked")
        End If
    Next tbldef
    
    ' CREATE LINK TABLE
    DoCmd.TransferDatabase acLink, "ODBC Database", _
          "ODBC;DRIVER=SQLite3 ODBC Driver;Database=" & CurrentProject.Path & "\CLData.db;", _
          acTable, "CLData", "CLData_linked"

    ' EXPORT CSV
    DoCmd.TransferText acExportDelim, , "CLData_linked", CurrentProject.Path & "\CLData.csv", True
        
    MsgBox "Successfully migrated SQL data to CSV!", vbInformation

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
Public Sub SQLtoCSV_XL()
On Error GoTo ErrHandle
    Dim wb As Workbook
    Dim strPath, constr, sql As String
    Dim rs, cmd As Object
    Dim r, c As Long
    
    strPath = Application.ActiveWorkbook.Path
    
    ' OPEN DB CONNECTION
    Set conn = CreateObject("ADODB.Connection")
    constr = "DRIVER=SQLite3 ODBC Driver;Database=" & strPath & "\CLData.db;"
    conn.Open constr
            
    ' QUERY DATABASE
    Set rs = CreateObject("ADODB.Recordset")
    rs.Open "SELECT * FROM cldata", conn

    ' INTIALIZE CSV
    Set wb = Workbooks.Add()
        
    ' WRITE ROWS
    With wb.Sheets(1)
        ' HEADERS
        For c = 1 To rs.Fields.Count
            .Cells(1, c) = rs.Fields(c-1).Name
        Next c

        r = 2
        ' DATA ROWS
        Do While Not rs.EOF
           For c = 1 To rs.Fields.Count
               .Cells(r, c) = rs.Fields(c-1).Value
           Next c

           r = r + 1
           rs.MoveNext
        Loop

       .Name = "DATA"
    End With

    ' SAVE CSV
    wb.SaveAS strPath & "\CLData_XL.csv", xlCSV
    wb.Close True
    rs.Close: conn.Close
    
    MsgBox "Successfully migrated SQL data to CSV!", vbInformation

ExitHandle:
    Set rs = Nothing: Set conn = Nothing
    Set wb = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub



