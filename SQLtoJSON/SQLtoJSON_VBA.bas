
''''''''''''''''''
'' MS ACCESS VBA
''''''''''''''''''
Private Sub JSONExport_Click()
On Error GoTo ErrHandle
    Dim db As Database, rst As Recordset
    Dim strpath As String, jsonfile As String
    Dim element As Variant, e As Variant, i As Variant
    
    Dim xmldata As New Collection, rawdata As Object, innerdata As Object
    Dim lastrow As Long, newstring As String, finalstring As String
    Dim key As String, val As String
    
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String
    
    strpath = Application.CurrentProject.Path
   
    Set db = CurrentDb
    Set rst = db.OpenRecordset("CLData", dbOpenDynaset)
    
    If rst.RecordCount = 0 Then
        MsgBox "No record in table.", vbExclamation
        Exit Sub
    End If
    
    ' SAVE IMPORTED DATA TO DICTIONARY
    Do While Not rst.EOF
        Set innerdata = CreateObject("Scripting.Dictionary")
        
        key = "user": val = rst!User: innerdata.Add key, val
        key = "category": val = rst!Category: innerdata.Add key, val
        key = "city": val = rst!city: innerdata.Add key, val
        key = "post": val = rst!post: innerdata.Add key, val
        key = "time": val = rst!Time: innerdata.Add key, val
        key = "link": val = rst!link: innerdata.Add key, val

        xmldata.Add innerdata
        Set innerdata = Nothing
        rst.MoveNext
    Loop
    
    ' SAVE TO JSON WITH PRETTY PRINT
    newstring = ConvertToJson(xmldata)
    finalstring = PrettyPrint(newstring)

    jsonfile = strpath & "\Cldata_ACC.json"

    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
        
    MsgBox "Successfully migrated sql data to json!", vbInformation
    
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub

Private Sub SQLImport_Click()
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

    db.Execute "DELETE FROM CLData", dbFailOnError
    db.Execute "INSERT INTO CLData ([user], [category], [city], [time], [post], [link])" _
                & " SELECT [user], [category], [city], [time], [post], [link] FROM MyCLData", dbFailOnError
    
    DoCmd.SetWarnings True
    MsgBox "Successfully imported SQL data!", vbInformation
    Exit Sub
    
ErrHandle:
    Dim dbeError As Error
    For Each dbeError In DBEngine.Errors
        MsgBox dbeError.Number & ": " & dbeError.Description
    Next dbeError
    Exit Sub
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
Public Sub JSONExport()
On Error GoTo ErrHandle
    Dim conn As Object, rst As Object
    Dim strpath As String, jsonfile As String, constr As String
        
    Dim sqldata As New Collection, innerdata As Object
    Dim key As String, val As String
    Dim newstring As String, finalstring As String
        
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String
    
    strpath = ActiveWorkbook.Path

    ' OPEN DB CONNECTION AND RECORDSET
    Set conn = CreateObject("ADODB.Connection")
    constr = "DRIVER={MySQL ODBC 5.3 Unicode Driver};server=localhost;database=****;UID=****;PWD=****"
    conn.Open constr
    
    ' APPEND DB DATA TO RECORDSET
    Set rst = CreateObject("ADODB.Recordset")
    rst.Open "SELECT * FROM cldata", conn
    
    If rst.RecordCount = 0 Then
        MsgBox "No data in table.", vbExclamation
        Exit Sub
    End If
    
    ' EXTRACT DATA ROW BY ROW
    Do While Not rst.EOF
    
        Set innerdata = CreateObject("Scripting.Dictionary")
        key = "user": val = rst!user: innerdata.Add key, val
        key = "category": val = rst!Category: innerdata.Add key, val
        key = "city": val = rst!city: innerdata.Add key, val
        key = "post": val = rst!Post: innerdata.Add key, val
        key = "time": val = rst!Time: innerdata.Add key, val
        key = "link": val = rst!link: innerdata.Add key, val

        sqldata.Add innerdata
        Set innerdata = Nothing
        
        rst.MoveNext
    Loop
    
    ' SAVE TO JSON WITH PRETTY PRINT
    newstring = ConvertToJson(sqldata)
    finalstring = PrettyPrint(newstring)
    
    jsonfile = strpath & "\Cldata_XL.json"
    
    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
        
    MsgBox "Successfully migrated sql data to json!", vbInformation
    
    rst.Close
    conn.Close
    
    Set rst = Nothing
    Set conn = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
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

