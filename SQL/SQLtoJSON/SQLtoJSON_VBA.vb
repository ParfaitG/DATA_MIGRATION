
''''''''''''''''''
'' MS ACCESS VBA
''''''''''''''''''
Public Sub SQLtoJSON_ACC()
On Error GoTo ErrHandle
    Dim db As Database, tbldef As TableDef, rst As Recordset
    Dim strpath, jsonfile, jsonstring As String

    Dim xmldata As Collection, innerdata As Object
    Dim i, FileNum As Integer
    Dim key As String, val As String

    strpath = Application.CurrentProject.Path

    Set db = CurrentDb
    
    ' REMOVE LINKED TABLE
    For Each tbldef In db.TableDefs
        If tbldef.Name = "MyCLData" Then
            db.Execute "DROP TABLE CLData_Linked"
        End If
    Next tbldef
    
    ' CREATE LINKED TABLE
    DoCmd.TransferDatabase acLink, "ODBC Database", _
          "ODBC;DRIVER=SQLite3 ODBC Driver;Database=" & strPath & "\CLData.db;", _
          acTable, "CLData", "CLData_linked"

    ' QUERY DATABASE
    Set rst = db.OpenRecordset("CLData_Linked", dbOpenDynaset)
        
    ' CONVERT DATA TO DICTIONARY
    Set xmldata = New Collection
    Do While Not rst.EOF
        Set innerdata = CreateObject("Scripting.Dictionary")
        
        For i = 1 to rst.Fields.Count
            key = rst.Fields(i - 0).Name: val = rst.Fields(i - 0).Value
            innerdata.Add key, val
        Next i
        xmldata.Add innerdata
        Set innerdata = Nothing
        rst.MoveNext
    Loop

    rst.Close

    ' WRITE JSON
    jsonstring = ConvertToJson(xmldata)
    jsonstring = PrettyPrint(jsonstring)

    jsonfile = strpath & "\CLData_ACC.json"

    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
        
    MsgBox "Successfully migrated SQL data to JSON!", vbInformation

ExitHandle:
    Set innerdata = Nothing: Set xmldata = Nothing
    Set tbldef = Nothing: Set rst = Nothing: Set db = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub


Public Function PrettyPrint(rawJson As String) As String
    Dim prettyJSON As String

    prettyJSON = Replace(rawJson, Chr$(34) & ",", Chr(34) & "," & vbNewLine & vbTab)
    prettyJSON = Replace(prettyJSON, "[", "[" & vbNewLine)
    prettyJSON = Replace(prettyJSON, "{", Space(3) & "{" & vbNewLine & vbTab)
    prettyJSON = Replace(prettyJSON, "},", vbNewLine & Space(3) & "}," & vbNewLine)
    prettyJSON = Replace(prettyJSON, "}]", vbNewLine & Space(3) & "}" & vbNewLine & "]")
    prettyJSON = Replace(prettyJSON, Chr$(34) & ":", Chr(34) & ": ")
    
    PrettyPrint = prettyJSON

End Function


''''''''''''''''''
'' MS EXCEL VBA
''''''''''''''''''
Public Sub SQLtoJSON_XL()
On Error GoTo ErrHandle
    Dim conn, rst As Object
    Dim strpath, jsonfile, constr As String
        
    Dim sqldata As Collection, innerdata As Object
    Dim i As Long, jsonstring As String
    Dim key, val As String
        
    Dim FileNum As Integer
    
    strpath = ActiveWorkbook.Path

    ' OPEN DB CONNECTION
    Set conn = CreateObject("ADODB.Connection")
    constr = "DRIVER=SQLite3 ODBC Driver;Database=" & strPath & "\CLData.db;"
    conn.Open constr
    
    ' QUERY DATABASE
    Set rst = CreateObject("ADODB.Recordset")
    rst.Open "SELECT * FROM cldata", conn
    
    ' CONVERT TO DICTIONARY
    Set sqldata = New Collection
    Do While Not rst.EOF      
        Set innerdata = CreateObject("Scripting.Dictionary")

        For i = 1 to rst.Fields.Count
            key = rst.Fields(i - 1).Name: val = rst.Fields(i - 1).Value
            innerdata.Add key, val
        Next i

        sqldata.Add innerdata
        Set innerdata = Nothing
        
        rst.MoveNext
    Loop
    
    ' SAVE JSON
    jsonstring = ConvertToJson(sqldata)
    jsonstring = PrettyPrint(jsonstring)
    
    jsonfile = strpath & "\CLData_XL.json"
    
    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
        
    MsgBox "Successfully migrated SQL data to JSON!", vbInformation
    
    rst.Close: conn.Close

ExitHandle:    
    Set sqldata = Nothing: Set xmldata = Nothing
    Set rst = Nothing: Set conn = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle

End Sub


Public Function PrettyPrint(rawJson As String) As String
    Dim prettyJSON As String

    prettyJSON = Replace(rawJson, Chr$(34) & ",", Chr(34) & "," & vbNewLine & vbTab)
    prettyJSON = Replace(prettyJSON, "[", "[" & vbNewLine)
    prettyJSON = Replace(prettyJSON, "{", Space(3) & "{" & vbNewLine & vbTab)
    prettyJSON = Replace(prettyJSON, "},", vbNewLine & Space(3) & "}," & vbNewLine)
    prettyJSON = Replace(prettyJSON, "}]", vbNewLine & Space(3) & "}" & vbNewLine & "]")
    prettyJSON = Replace(prettyJSON, Chr$(34) & ":", Chr(34) & ": ")
    
    PrettyPrint = prettyJSON

End Function

