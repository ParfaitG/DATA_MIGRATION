
''''''''''''''''''''
'' MS ACCESS VBA
''''''''''''''''''''
Public Sub JSONtoCSV_ACC()
On Error GoTo ErrHandle
    Dim db As Database, qdef As QueryDef
    Dim FileNum As Integer
    Dim DataLine, jsonStr, strPath, strSQL As String
    Dim element, e, i As Variant
    Dim p As Object
    
    ' DATABASE SETUP
    Set db = CurrentDb
    strPath = Application.CurrentProject.Path

    For Each tbldef In db.TableDefs
        If tbldef.Name = "CLData" Then
            db.Execute "DROP TABLE " & tbldef.Name
        End If
    Next tbldef

    strSQL = "CREATE TABLE CLData (" _
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
        
    jsonStr = ""
    While Not EOF(FileNum)
        Line Input #FileNum, DataLine
        
        jsonStr = jsonStr & DataLine & vbNewLine
    Wend
    Close #FileNum
    Set p = ParseJson(jsonStr)
    
    ' APPEND TO TABLE
    For Each element In p
        strSQL = "PARAMETERS [User] Text(255), [Category] Text(255), [City] Text(255)," _
                  & "[Post] Text(255), [Time] Text(255), [Link] Text(255); " _
                  & "INSERT INTO CLData (user, category, city, post, [time], link) " _
                        & "VALUES([User],[Category], [City], [Post], [Time], [link])"
                      
        Set qdef = db.CreateQueryDef("", strSQL)
                
        qdef!User = element("user")
        qdef!Category = element("category")
        qdef!City = element("city")
        qdef!Post = element("post")
        qdef!Time = element("time")
        qdef!link = element("link")
        
        qdef.Execute
    Next element

    ' EXPORT CSV
    DoCmd.TransferText acExportDelim, , "CLData", Application.CurrentProject.Path & "\CLData_ACC.csv", True
    
    MsgBox "Successfully migrated JSON data to CSV!", vbInformation

ExitHandle:
    Set element = Nothing: Set p = Nothing
    Set qdef = Nothing: Set db = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle

End Sub


''''''''''''''''''''
'' MS EXCEL VBA
''''''''''''''''''''
Public Sub JSCONtoCSV_XL()
On Error GoTo ErrHandle
    Dim FileNum As Integer
    Dim DataLine, jsonStr, strPath As String
    Dim element As Variant, i As Integer
    Dim p As Object
    Dim wb As Workbook
        
    strPath = ActiveWorkbook.Path
    
    ' READ JSON
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

    ' HEADERS
    j = 1
    For Each varKey In p(0).element.Keys()
        wb.Sheets(1).Cells(1, j) = varKey
        j = j + 1
    Next varKey

    ' DATA ROWS
    i = 2
    For Each element In p
       j = 1
       For Each varKey In element.Keys()
          wb.Sheets(1).Cells(i, j) = element(varKey)
          j = j + 1
       Next varKey
       i = i + 1
    Next element
    
    ' SAVE CSV
    Application.DisplayAlerts = False
    wb.SaveAs strPath & "\CLData_XL.csv", xlCSV
    wb.Close

    MsgBox "Successfully migrated JSON data to CSV!", vbInformation

ExitHandle:
    Application.DisplayAlerts = True
    Set element = Nothing: Set p = Nothing
    Set wb = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle

End Sub

