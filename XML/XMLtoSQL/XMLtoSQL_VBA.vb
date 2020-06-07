

''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Public Sub XMLtoSQL_ACC()
On Error GoTo ErrHandle

    Dim db As Database, tbldef As TableDef
    
    Set db = CurrentDb
    
    ' REMOVE PRIOR TABLES
    For Each tbldef In db.TableDefs
        If tbldef.Name = "missedConnection"  Or tbldef.Name = "CLData" Then
            db.TableDefs.Delete ("CLData")
        End If
    Next tbldef

    ' IMPORT XML
    xmlstr = strPath & "\CLData.xml"
    Application.ImportXML xmlstr

    ' RE-LINK TABLE
    DoCmd.TransferDatabase acLink, "ODBC Database", _
          "ODBC;DRIVER=SQLite3 ODBC Driver;Database=" & CurrentProject.Path & "\CLData.db;", _
           acTable, "CLData", "CLData_Linked"
    
    ' RUN APPEND QUERY
    db.Execute "INSERT INTO CLData_Linked SELECT * FROM missedConnection", dbFailOnError
        
    MsgBox "Successfully migrated XML data into SQL database!", vbInformation
    
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
Public Sub XMLtoSQL_XL()
On Error GoTo ErrHandle
    Dim conn As Object, cmd As Object
    Dim constr As String, strPath As String, sql As String
    Dim wb As Workbook
    Dim r As Long, c As Long, counter As Long
    
    strPath = ThisWorkbook.Path
      
    ' IMPORT XML
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    Set wb = Workbooks.OpenXML(Filename:=strPath & "\CLData.xml", LoadOption:=xlXmlLoadImportToList)
    
    ' CONNECTING TO DATABASE
    constr = "DRIVER=SQLite3 ODBC Driver;Database=" & strPath & "\CLData.db;"
    
    Set conn = CreateObject("ADODB.Connection")
    conn.Open constr

    ' APPEND DATA
    sql = "INSERT INTO CLData (user, category, city, post, time, link) " _
           & "VALUES(?, ?, ?, ?, ?, ?)"

    conn.BeginTrans
    For r = 2 To wb.Sheets(1).UsedRange.Rows.Count
        Set cmd = CreateObject("ADODB.Command")
        With cmd
            .ActiveConnection = conn
            .CommandText = sql
            .CommandType = adCmdText
            
            For c = 1 to wb.Sheets(1).UsedRange.Columns.Count
               .Parameters.Append .CreateParameter("prm" & c, adVarChar, adParamInput, , wb.Sheets(1).Cells(r, c))
            Next c

            .Execute
        End With
    Next r
    conn.CommitTrans

    wb.Close False        
    conn.Close
        
    MsgBox "Successfully migrated XML data into SQL database!", vbInformation

ExitHandle:
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True

    Set wb = Nothing
    Set cmd = Nothing: Set conn = Nothing
    Exit Sub

ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle   
 
End Sub
