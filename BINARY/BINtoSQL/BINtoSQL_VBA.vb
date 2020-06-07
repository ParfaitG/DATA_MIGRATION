
''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Public Sub BINtoSQL_ACC()
On Error GoTo ErrHandle
    Dim db As Database
    Dim tbldef As TableDef
    
    Set db = CurrentDb
    
    ' REMOVE PRIOR TABLE
    For Each tbldef In db.TableDefs
        If tbldef.Name = "CLData_linked" Then
            db.TableDefs.Delete (tbldef.Name)
        End If
    Next tbldef

    ' RE-LINK EXTERNAL TABLE
    DoCmd.TransferDatabase acLink, "ODBC Database", _
          "ODBC;"DRIVER=SQLite3 ODBC Driver;Database=" & CurrentProject.Path & "\CLData.db;", _
                  acTable, "CLData", "CLData_linked"
    
    ' RUN APPEND QUERY
    db.Execute "INSERT INTO CLData_linked SELECT * FROM CLData", dbFailOnError
        
    MsgBox "Successfully migrated CSV data into SQL database!", vbInformation
    Exit Sub
    
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
Public Sub BINtoSQL_XL()
On Error GoTo ErrHandle
    Dim strPath As String, constr As String
    Dim conn As Object, cmd As Object
    Dim r As Long, c As Long
    
    strPath = Application.ActiveWorkbook.Path
    
    ' OPEN DB CONNECTION
    Set conn = CreateObject("ADODB.Connection")
    constr = "DRIVER=SQLite3 ODBC Driver;Database=" & strPath & "\CLData.db;"
    conn.Open constr
    
    ' APPEND TO DB
    sql = "INSERT INTO CLData (user, category, city, post, time, link) " _
           & "VALUES(?, ?, ?, ?, ?, ?)"

    For r = 2 To ThisWorkbook.Sheets(1).UsedRange.Rows.Count
        Set cmd = CreateObject("ADODB.Command")
        With cmd
            .ActiveConnection = conn
            .CommandText = sql
            .CommandType = adCmdText
            
            For c = 1 to ThisWorkbook.Sheets(1).UsedRange.Columns.Count
               .Parameters.Append .CreateParameter("prm" & c, adVarChar, adParamInput, , ThisWorkbook.Sheets(1).Cells(r, c))
            Next c

            .Execute
        End With
    Next r
    
    cmd.Close: conn.Close
    
    MsgBox "Successfully migrated CSV data into SQL database!", vbInformation
    Exit Sub
    
ExitHandle:
    Set cmd = Nothing: Set conn = Nothing
    Exit Sub

ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle

End Sub




