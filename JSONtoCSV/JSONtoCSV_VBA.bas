
''''''''''''''''''''
'' MS ACCESS VBA
''''''''''''''''''''
Private Sub JSONImport_Click()
On Error GoTo ErrHandle
    Dim db As Database, qdef As QueryDef
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String, strPath As String, strSQL As String
    Dim element As Variant, e As Variant, i As Variant
    Dim p As Object, jsondict As Object
    
    Set db = CurrentDb
    
    strPath = Application.CurrentProject.Path
    db.Execute "DELETE FROM CLData;", dbFailOnError
        
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
    
    MsgBox "Successfully imported JSON data!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub

Private Sub CSVExport_Click()
On Error GoTo ErrHandle
    Dim xlFile As String
    
    DoCmd.TransferText acExportDelim, , "CLData", Application.CurrentProject.Path & "\CLData_ACC.csv", True
    
    MsgBox "Successfully migrated JSON data to CSV data!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub


''''''''''''''''''''
'' MS EXCEL VBA
''''''''''''''''''''
Sub CSVExport()
On Error GoTo ErrHandle
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String, strPath As String
    Dim element As Variant, i As Integer
    Dim p As Object, jsondict As Object
    Dim wb As Workbook
    Dim jsondata As New Collection
        
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
    
    ' OPEN EXTERNAL WORKBOOK
    Set wb = Workbooks.Add
    wb.Activate

    ' ADD COLUMN HEADERS
    wb.Sheets(1).Cells(1, 1) = "user"
    wb.Sheets(1).Cells(1, 2) = "category"
    wb.Sheets(1).Cells(1, 3) = "city"
    wb.Sheets(1).Cells(1, 4) = "time"
    wb.Sheets(1).Cells(1, 5) = "post"
    wb.Sheets(1).Cells(1, 6) = "link"

    ' ITERATE DATA ROWS
    i = 2
    For Each element In p
        wb.Sheets(1).Cells(i, 1) = element("user")
        wb.Sheets(1).Cells(i, 2) = element("category")
        wb.Sheets(1).Cells(i, 3) = element("city")
        wb.Sheets(1).Cells(i, 4) = element("time")
        wb.Sheets(1).Cells(i, 5) = element("post")
        wb.Sheets(1).Cells(i, 6) = element("link")
        
        i = i + 1
    Next element
    
    Application.DisplayAlerts = False
    wb.SaveAs strPath & "\Cldata_XL.csv", xlCSV
    wb.Close
    Application.DisplayAlerts = True
    
    MsgBox "Successfully converted json data to csv!", vbInformation
        
    Set element = Nothing
    Set p = Nothing
    Set wb = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub

