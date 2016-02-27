
''''''''''''''''''
'' MS ACCESS VBA
''''''''''''''''''
Private Sub CSVImport_Click()
On Error GoTo ErrHandle
    Dim db As Database, qdef As QueryDef
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String, strPath As String, strSQL As String
    Dim p As Object, element As Variant
    
    Set db = CurrentDb
    
    strPath = Application.CurrentProject.Path
    db.Execute "DELETE  FROM CLData;", dbFailOnError
        
    ' READ FROM EXTERNAL FILE
    FileNum = FreeFile()
    Open strPath & "\Cldata.json" For Input As #FileNum
        
    ' PARSE FILE STRING
    jsonStr = ""
    While Not EOF(FileNum)
        Line Input #FileNum, DataLine
        
        jsonStr = jsonStr & DataLine & vbNewLine
    Wend
    Close #FileNum
    Set p = ParseJson(jsonStr)
    
    ' ITERATE DATA ROWS
    For Each element In p
        strSQL = "PARAMETERS [User] Text(255), [Category] Text(255), [City] Text(255)," _
                  & "[Post] Text(255), [Time] Text(255), [Link] Text(255); " _
                  & "INSERT INTO CLData (user, category, city, post, [time], link) " _
                        & "VALUES([User],[Category], [City]," _
                        & " [Post], [Time], [link])"
                      
        Set qdef = db.CreateQueryDef("", strSQL)
                
        qdef!User = element("user")
        qdef!Category = element("category")
        qdef!City = element("city")
        qdef!Post = element("post")
        qdef!Time = element("time")
        qdef!link = element("link")
        
        qdef.Execute
    Next element
    
    Set element = Nothing
    Set p = Nothing
    Set db = Nothing
    
    MsgBox "Successfully imported JSON data!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub

Private Sub SQLExport_Click()
On Error GoTo ErrHandle
    Dim db As Database, tbldef As TableDef
    DoCmd.SetWarnings False
    
    ' RUN APPEND QUERY
    Set db = CurrentDb
    
    ' REMOVE LINKED TABLE
    For Each tbldef In db.TableDefs
        If tbldef.Name = "MyCLData" Then
            db.Execute "DROP TABLE MyCLData"
        End If
    Next tbldef
    
    ' LINK MYSQL TABLE
    DoCmd.TransferDatabase acLink, "ODBC Database", _
          "ODBC;DRIVER={MySQL ODBC 5.3 Unicode Driver};server=localhost;database=****;" _
           & "UID=****;PWD=****;", acTable, "CLData", "MyCLData"

    db.Execute "INSERT INTO MyCLData SELECT * FROM CLData", dbFailOnError
    
    DoCmd.SetWarnings True
    MsgBox "Successfully migrated JSON data to CSV data!", vbInformation
    Exit Sub
    
ErrHandle:
    Dim dbeError As Error
    For Each dbeError In DBEngine.Errors
        MsgBox dbeError.Number & ": " & dbeError.Description
    Next dbeError
    Exit Sub
End Sub


''''''''''''''''''
'' MS EXCEL VBA
''''''''''''''''''
Sub SQLImport()
On Error GoTo ErrHandle
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String
    Dim conn As Object, cmd As Object
    Dim strPath As String, constr As String, strSQL As String
    Dim p As Object, element As Variant
            
    strPath = ActiveWorkbook.Path
    
    ' READ FROM EXTERNAL FILE
    FileNum = FreeFile()
    Open strPath & "\Cldata.json" For Input As #FileNum
        
    ' PARSE FILE STRING
    jsonStr = ""
    While Not EOF(FileNum)
        Line Input #FileNum, DataLine
        
        jsonStr = jsonStr & DataLine & vbNewLine
    Wend
    Close #FileNum
    
    Set p = ParseJson(jsonStr)
    
    ' OPEN DB CONNECTION
    Set conn = CreateObject("ADODB.Connection")
    constr = "DRIVER={MySQL ODBC 5.3 Unicode Driver};server=localhost;database=****;UID=****;PWD=****"
    conn.Open constr
    
    ' PREPARING SQL STATEMENT AND SETTINGS
    strSQL = "INSERT INTO cldata (user, category, city, post, time, link) " _
                    & "VALUES (?, ?, ?, ?, ?, ?)"
    
    ' APPEND TO DATABASE
    For Each element In p
        Set cmd = New ADODB.Command
        
        With cmd
            .ActiveConnection = conn
            .CommandText = strSQL
            .CommandType = adCmdText
            .CommandTimeout = 15
        End With
        
        ' BINDING PARAMETERS
        cmd.Parameters.Append cmd.CreateParameter("userparam", adVarChar, adParamInput, 255)
        cmd.Parameters(0).Value = element("user")
        cmd.Parameters.Append cmd.CreateParameter("categparam", adVarChar, adParamInput, 255)
        cmd.Parameters(1).Value = element("category")
        cmd.Parameters.Append cmd.CreateParameter("cityparam", adVarChar, adParamInput, 255)
        cmd.Parameters(2).Value = element("city")
        cmd.Parameters.Append cmd.CreateParameter("postparam", adVarChar, adParamInput, 255)
        cmd.Parameters(3).Value = element("post")
        cmd.Parameters.Append cmd.CreateParameter("timparam", adVarChar, adParamInput, 255)
        cmd.Parameters(4).Value = element("time")
        cmd.Parameters.Append cmd.CreateParameter("linkparam", adVarChar, adParamInput, 255)
        cmd.Parameters(5).Value = element("link")
        
        cmd.Execute
    Next element

    conn.Close
        
    Set element = Nothing
    Set p = Nothing
    Set conn = Nothing
    
    MsgBox "Successfully converted json data to sql!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub

