
''''''''''''''''''''
'' MS ACCESS VBA
''''''''''''''''''''
Public Sub BuildBIN_ACC()
On Error GoTo ErrHandle
    Dim db As Database

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

    ' IMPORT CSV
    DoCmd.TransferText acImportDelim, , "CLData", strPath & "\..\..\CSV\CSVtoMXL\CLData.csv", True
      
    MsgBox "Successfully created binary data!", vbInformation

ExitHandle:
    Set db = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle

End Sub


''''''''''''''''''''
'' MS EXCEL VBA
''''''''''''''''''''
Public Sub BuildBIN_XL()
On Error GoTo ErrHandle
    Dim csvFile As String
       
    csvFile = ThiseWorkbook.Path & "\..\..\CSV\CSVtoMXL\CLData.csv"

    ' IMPORT CSV
    With ThisWorkbook.Sheets(1).QueryTables.Add(Connection:="TEXT;" & csvFile, _
       Destination:=Cells(1, 1))
        .TextFileStartRow = 1
        .TextFileParseType = xlDelimited
        .TextFileConsecutiveDelimiter = False
        .TextFileTabDelimiter = False
        .TextFileSemicolonDelimiter = False
        .TextFileCommaDelimiter = True
        .TextFileSpaceDelimiter = False
        .Refresh BackgroundQuery:=False
    End With

    For Each qt In ThisWorkbook.Sheets(1).QueryTables
       qt.Delete
    Next qt
 
    ThisWorkbook.Save
    
    MsgBox "Successfully created binary data!", vbInformation

ExitHandle:
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle

End Sub

