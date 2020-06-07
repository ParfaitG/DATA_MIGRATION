
'''''''''''''''''''
'' MS ACCESS VBA
'''''''''''''''''''
Public Sub XMLtoJSON_ACC()
On Error GoTo ErrHandle
    Dim db As Database, tbldef As TableDef, rst As Recordset
    Dim strpath As String, jsonfile As String
    Dim element As Variant, i As Integer
    
    Dim xmldata As Collection, innerdata As Object
    Dim lastrow As Long, newstring As String, finalstring As String
    Dim key As String, val As String
    
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String
    
    strpath = Application.CurrentProject.Path

    ' REMOVE LINKED TABLE
    Set db = CurrentDb
    
    For Each tbldef In db.TableDefs
        If tbldef.Name = "missedConnection" Then
            db.Execute "DROP TABLE missedConnection", dbFailOnError
        End If
    Next tbldef

    ' IMPORT XML
    xmlstr = strPath & "\CLData.xml"
    Application.ImportXML xmlstr

    ' QUERY DATABASE
    Set rst = db.OpenRecordset("missedConnection", dbOpenDynaset)
    
    If rst.RecordCount = 0 Then
        MsgBox "No record in table.", vbExclamation
        Exit Sub
    End If
    
    ' CONVERT TO DICTIONARY
    Set xmldata = New Collection
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
    
    rst.Close

    ' SAVE JSON
    newstring = ConvertToJson(xmldata)
    finalstring = PrettyPrint(newstring)

    jsonfile = strpath & "\CLData_ACC.json"

    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
        
    MsgBox "Successfully migrated XML data to JSON!", vbInformation
    
ExitHandle:
    Set tblDef = Nothing: Set rst = Nothing: Set db = Nothing
    Set innerData = Nothing: Set xmldata = Nothing
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


'''''''''''''''''''
'' MS EXCEL VBA
'''''''''''''''''''
Public Sub XMLtoJSON_XL()
On Error GoTo ErrHandle
    Dim wb As Workbook
    Dim strpath As String, jsonfile As String
    Dim element As Variant, i As Integer
    
    Dim xmldata As Collection, innerdata As Object
    Dim lastrow As Long, newstring As String, finalstring As String
    Dim key As String, val As String
    
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String
    
    strpath = ActiveWorkbook.Path

    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    
    ' READ XML
    Set wb = Workbooks.OpenXML(Filename:=strpath & "\CLData.xml", LoadOption:=xlXmlLoadImportToList)
    
    ' CONVERT DATA TO DICTIONARY
    With wb.Sheets(1)
        lastrow = .Cells(.rows.Count, "A").End(xlUp).Row
    
        Set xmldata = New Collection
        For i = 2 To lastrow
            Set innerdata = CreateObject("Scripting.Dictionary")
            key = "user": val = .Range("A" & i): innerdata.Add key, val
            key = "category": val = .Range("B" & i): innerdata.Add key, val
            key = "city": val = .Range("C" & i): innerdata.Add key, val
            key = "post": val = .Range("D" & i): innerdata.Add key, val
            key = "time": val = .Range("E" & i): innerdata.Add key, val
            key = "link": val = .Range("F" & i): innerdata.Add key, val

            xmldata.Add innerdata
            Set innerdata = Nothing
        Next i
    End With

    wb.Close False
    
    ' SAVE JSON
    newstring = ConvertToJson(xmldata)
    finalstring = PrettyPrint(newstring)
    
    jsonfile = strpath & "\Cldata_XL.json"
    
    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
    
    MsgBox "Successfully migrated XML data to JSON!", vbInformation

ExitHandle:
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
    Set wb = Nothing
    Set innerData = Nothing: Set xmldata = Nothing
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
