
''''''''''''''''''''
'' MS ACCESS VBA
''''''''''''''''''''
Private Sub CSVImport_Click()
On Error GoTo ErrHandle
    Dim db As Database
    Dim xlFile As String
    
    Set db = CurrentDb
    db.Execute "DELETE FROM Cldata", dbFailOnError
        
    DoCmd.TransferText acImportDelim, , "CLData", Application.CurrentProject.Path & "\Cldata.csv", True
    
    MsgBox "Successfully imported CSV data!", vbInformation
    
    Set db = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub

Private Sub JSONExport_Click()
On Error GoTo ErrHandle
    Dim db As Database, rst As Recordset
    Dim jsonfile As String
    Dim csvdata As New Collection, innerdata As Object
    Dim key As String, val As String
    
    Dim FileNum As Integer
    Dim DataLine As String, newstring As String, finalstring As String
    
    Set db = CurrentDb
        
    Set rst = db.OpenRecordset("Cldata", dbOpenDynaset)
    
    If rst.RecordCount = 0 Then
        MsgBox "No data in table.", vbExclamation
        Exit Sub
    End If
   
    ' ITERATE DATA ROWS
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

    ' SAVE TO JSON WITH PRETTY PRINT
    newstring = ConvertToJson(csvdata)
    finalstring = PrettyPrint(newstring)
    
    jsonfile = Application.CurrentProject.Path & "\Cldata_ACC.json"

    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
    
    rst.Close
    Set rst = Nothing
    Set db = Nothing
    
    MsgBox "Successfully migrated csv data to json!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
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
Public Sub JSONExport()
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
    Workbooks.OpenText Filename:=strpath & "\CLData.csv", DataType:=xlDelimited, Comma:=True
    Set wb = ActiveWorkbook
        
    lastrow = wb.Sheets(1).Cells(wb.Sheets(1).rows.Count, "A").End(xlUp).Row
    
    ' SAVE IMPORTED DATA TO DICTIONARY
    For i = 2 To lastrow
        Set innerdata = CreateObject("Scripting.Dictionary")
        key = "user": val = wb.Sheets(1).Range("A" & i): innerdata.Add key, val
        key = "category": val = wb.Sheets(1).Range("B" & i): innerdata.Add key, val
        key = "city": val = wb.Sheets(1).Range("C" & i): innerdata.Add key, val
        key = "post": val = wb.Sheets(1).Range("D" & i): innerdata.Add key, val
        key = "time": val = wb.Sheets(1).Range("E" & i): innerdata.Add key, val
        key = "link": val = wb.Sheets(1).Range("F" & i): innerdata.Add key, val

        csvdata.Add innerdata
        Set innerdata = Nothing
    Next i
    
    wb.Close False
    
    ' SAVE TO JSON WITH PRETTY PRINT
    newstring = ConvertToJson(csvdata)
    finalstring = PrettyPrint(newstring)
    
    jsonfile = strpath & "\Cldata_XL.json"
    
    FileNum = FreeFile()
    Open jsonfile For Output As #FileNum
        Print #FileNum, finalstring
    Close #FileNum
        
    MsgBox "Successfully migrated csv data to json!", vbInformation
    
    Set wb = Nothing
    Exit Sub

ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
    
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
