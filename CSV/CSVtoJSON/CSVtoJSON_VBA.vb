
''''''''''''''''''''
'' MS ACCESS VBA
''''''''''''''''''''
Public Sub CSVtoJSON_ACC()
On Error GoTo ErrHandle
    Dim db As Database, rst As Recordset
    Dim jsonfile As String
    Dim csvdata As Collection, innerdata As Object
    Dim key As String, val As String
    
    Dim FileNum As Integer
    Dim DataLine As String, newstring As String, finalstring As String
    
    Set db = CurrentDb
    db.Execute "DELETE FROM Cldata", dbFailOnError
        
    ' IMPORT CSV
    DoCmd.TransferText acImportDelim, , "CLData", Application.CurrentProject.Path & "\CLData.csv", True
      
    Set rst = db.OpenRecordset("Cldata", dbOpenDynaset)
    
    If rst.RecordCount = 0 Then
        MsgBox "No data in table.", vbExclamation
        Exit Sub
    End If
   
    ' ITERATE DATA ROWS
    Set csvData = New Collection
    Do While Not rst.EOF
        Set innerdata = CreateObject("Scripting.Dictionary")
            
        key = "user": val = rst!User: innerdata.Add key, val
        key = "category": val = rst!Category: innerdata.Add key, val
        key = "city": val = rst!city: innerdata.Add key, val
        key = "post": val = rst!post: innerdata.Add key, val
        key = "time": val = rst!Time: innerdata.Add key, val
        key = "link": val = rst!link: innerdata.Add key, val

        csvdata.Add innerdata
        Set innerdata = Nothing
                      
        rst.MoveNext
    Loop

    ' SAVE JSON
    newstring = ConvertToJson(csvdata)
    finalstring = PrettyPrint(newstring)
    
    jsonfile = Application.CurrentProject.Path & "\CLData_ACC.json"

    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
    
    rst.Close

    MsgBox "Successfully migrated CSV data to JSON!", vbInformation

ExitHandle:
    Set innerdata = Nothing: Set csvData = Nothing
    Set rst = Nothing: Set db = Nothing
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
    prettyJSON = Replace(prettyJSON, Chr$(34) & ":", Chr$(34) & ": ")
    
    PrettyPrint = prettyJSON

End Function


''''''''''''''''''''
'' MS EXCEL VBA
''''''''''''''''''''
Public Sub CSVtoJSON_XL()
On Error GoTo ErrHandle
    Dim wb As Workbook
    Dim strpath As String, jsonfile As String
    Dim element As Variant, i As Integer
    
    Dim csvdata As New Collection, rawdata As Object, innerdata As Object
    Dim lastrow As Long, newstring As String, finalstring As String
    Dim key As String, val As String
    
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String
    
    strpath = ActiveWorkbook.Path

    ' READ CSV
    Set wb = Workbooks.OpenText Filename:=strpath & "\CLData.csv", DataType:=xlDelimited, Comma:=True
        
    With wb.Sheets(1)
        lastrow = .Cells(.Rows.Count, "A").End(xlUp).Row
    
        ' SAVE IMPORTED DATA TO DICTIONARY
        For i = 2 To lastrow
            Set innerdata = CreateObject("Scripting.Dictionary")
            key = "user": val = .Range("A" & i): innerdata.Add key, val
            key = "category": val = .Range("B" & i): innerdata.Add key, val
            key = "city": val = .Range("C" & i): innerdata.Add key, val
            key = "post": val = .Range("D" & i): innerdata.Add key, val
            key = "time": val = .Range("E" & i): innerdata.Add key, val
            key = "link": val = .Range("F" & i): innerdata.Add key, val

            csvdata.Add innerdata
            Set innerdata = Nothing
        Next i
    End With

    wb.Close False
    
    ' SAVE TO JSON WITH PRETTY PRINT
    newstring = ConvertToJson(csvdata)
    finalstring = PrettyPrint(newstring)
    
    jsonfile = strpath & "\CLData_XL.json"
    
    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
        
    MsgBox "Successfully migrated CSV data to JSON!", vbInformation

ExitHandle:
    Set wb = Nothing: Set element = Nothing    
    Set csvdata = Nothing: Set rawdata = Nothing: Set innerdata As Object
    Exit Sub

ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub


Public Function PrettyPrint(rawJSON As String) As String
    Dim i As Variant, prettyJSON As String
    
    prettyJSON = Replace(rawJSON, Chr$(34) & ",", Chr(34) & "," & vbNewLine & vbTab)
    prettyJSON = Replace(prettyJSON, "[", "[" & vbNewLine)
    prettyJSON = Replace(prettyJSON, "{", Space(3) & "{" & vbNewLine & vbTab)
    prettyJSON = Replace(prettyJSON, "},", vbNewLine & Space(3) & "}," & vbNewLine)
    prettyJSON = Replace(prettyJSON, "}]", vbNewLine & Space(3) & "}" & vbNewLine & "]")
    
    PrettyPrint = prettyJSON

End Function
