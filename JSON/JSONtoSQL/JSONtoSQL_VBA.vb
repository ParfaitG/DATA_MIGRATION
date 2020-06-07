
''''''''''''''''''
'' MS ACCESS VBA
''''''''''''''''''
Public Sub JSONtoSQL_ACC()
On Error GoTo ErrHandle
    Dim db As Database, tbldef As TableDef, qdef As QueryDef
    Dim dbeError As Error
    Dim FileNum As Integer
    Dim DataLine, jsonStr, strPath, strSQL As String
    Dim p As Object, element As Variant
    
    ' DATABASE SETUP
    Set db = CurrentDb
    strPath = Application.CurrentProject.Path

    For Each tbldef In db.TableDefs
        If tbldef.Name = "CLData_Local" Or tbldef.Name = CLData_Linked" Then
            db.Execute "DROP TABLE " & tbldef.Name
        End If
    Next tbldef

    strSQL = "CREATE TABLE CLData_Local (  " _
              & "    [User]     Text(255), " _
              & "    [Category] Text(255), " _
              & "    [City]     Text(255), " _
              & "    [Post]     Text(255), " _
              & "    [Time]     Text(255), " _
              & "    [Link]     Text(255)  " _
              & ");"
    db.Execute strSQL

    ' READ JSON
    FileNum = FreeFile()
    Open strPath & "\CLData.json" For Input As #FileNum
        
    ' PARSE FILE STRING
    jsonStr = ""
    While Not EOF(FileNum)
        Line Input #FileNum, DataLine
        
        jsonStr = jsonStr & DataLine & vbNewLine
    Wend
    Close #FileNum
    Set p = ParseJson(jsonStr)
    
    ' ITERATE DATA ROWS
    strSQL = "PARAMETERS [User] Text(255), [Category] Text(255), [City] Text(255)," _
              & "[Post] Text(255), [Time] Text(255), [Link] Text(255); " _
              & "INSERT INTO CLData_Local (user, category, city, post, [time], link) " _
              & " VALUES([User],[Category], [City], [Post], [Time], [link])"

    For Each element In p                      
        Set qdef = db.CreateQueryDef("", strSQL)
                
        qdef!User = element("user")
        qdef!Category = element("category")
        qdef!City = element("city")
        qdef!Post = element("post")
        qdef!Time = element("time")
        qdef!link = element("link")
        
        qdef.Execute
    Next element
    
    DoCmd.SetWarnings False
    
    ' LINK EXTERNAL TABLE
    DoCmd.TransferDatabase acLink, "ODBC Database", _
          "ODBC;"DRIVER=SQLite3 ODBC Driver;Database=" & CurrentProject.Path & "\CLData.db;", _
                  acTable, "CLData", "CLData_linked"

    ' RUN APPEND QUERY
    db.Execute "INSERT INTO CLData_linked SELECT * FROM CLData", dbFailOnError

    MsgBox "Successfully migrated JSON data to SQL database!", vbInformation

ExitHandle:
    DoCmd.SetWarnings True
    Set element = Nothing: Set p = Nothing
    Set qdef = Nothing: Set db = Nothing  

    Set tbldef = Nothing: Set db = Nothing
    Set dbeError = Nothing
    Exit Sub
    
ErrHandle:
    For Each dbeError In DBEngine.Errors
        MsgBox dbeError.Number & ": " & dbeError.Description, vbCritical
    Next dbeError
    Resume ExitHandle

End Sub


''''''''''''''''''
'' MS EXCEL VBA
''''''''''''''''''
Public Sub JSONtoSQL_XL()
On Error GoTo ErrHandle
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String
    Dim conn As Object, cmd As Object
    Dim strPath As String, constr As String, strSQL As String
    Dim p As Object, element As Variant, varKey As Variant
            
    strPath = ActiveWorkbook.Path
    
    ' READ FROM EXTERNAL FILE
    FileNum = FreeFile()
    Open strPath & "\CLData.json" For Input As #FileNum
        
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
    constr = "DRIVER=SQLite3 ODBC Driver;Database=" & strPath & "\CLData.db;"
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
        For Each varKey In element.Keys()
            cmd.Parameters.Append cmd.CreateParameter(varKey, adVarChar, adParamInput, 255)
            cmd.Parameters(0).Value = element(varKey)
        Next varKay
        
        cmd.Execute
    Next element

    conn.Close

    MsgBox "Successfully migrated JSON data to SQL database!", vbInformation

ExitHandle:
    Set element = Nothing: Set varKey = Nothing: Set p = Nothing
    Set cmd = Nothing: conn = Nothing    
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle

End Sub

