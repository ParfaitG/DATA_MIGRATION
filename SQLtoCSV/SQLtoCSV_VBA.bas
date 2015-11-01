Option Compare Database
Option Explicit

''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Private Sub SQLImport_Click()
On Error GoTo ErrHandle

    Dim db As Database
    Dim tbldef As TableDef
    
    Set db = CurrentDb
    
    ' REMOVE PRIOR LINKED MYSQL TABLE
    For Each tbldef In db.TableDefs
        If tbldef.Name = "CLData" Then
            db.TableDefs.Delete ("CLData")
        End If
    Next tbldef
    
    ' RE-LINK MYSQL TABLE
    DoCmd.TransferDatabase acLink, "ODBC Database", _
          "ODBC;DRIVER={MySQL ODBC 5.3 Unicode Driver};server=hostname;database=database;" _
           & "UID=username;PWD=password;", acTable, "CLData", "CLData"
   
    Set tbldef = Nothing
    Set db = Nothing
        
    MsgBox "Successfully uploaded SQL data into Access!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub

Private Sub CSVExport_Click()
On Error GoTo ErrHandle
    Dim strFile As String, todayDate As String
    
    todayDate = Format(Date, "YYYYMMDD")
    strFile = Application.CurrentProject.Path & "\CLData_" & todayDate & ".csv"
        
    DoCmd.TransferText acExportDelim, , "CLData", strFile, True
    
    MsgBox "Successfully exported SQL data into CSV!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub


''''''''''''''''''
''MS EXCEL VBA
''''''''''''''''''
Sub xmlExport()
On Error GoTo ErrHandle
    Dim wb As Workbook
    Dim doc As New MSXML2.DOMDocument, xslDoc As New MSXML2.DOMDocument, newDoc As New MSXML2.DOMDocument
    Dim root As IXMLDOMElement, MCNode As IXMLDOMElement
    Dim userNode As IXMLDOMElement, categoryNode As IXMLDOMElement, cityNode As IXMLDOMElement
    Dim postNode As IXMLDOMElement, timeNode As IXMLDOMElement, linkNode As IXMLDOMElement
    Dim strPath As String, xslFile As String
    Dim i As Long
    
    ' DECLARE XML DOC OBJECT
    Set root = doc.createElement("CLData")
    doc.appendChild root
    
    strPath = Application.ActiveWorkbook.Path
    
    ' READ CSV
    Workbooks.OpenText Filename:=strPath & "\CLData.csv", DataType:=xlDelimited, Comma:=True
    Set wb = ActiveWorkbook
    
    ' WRITE TO XML
    For i = 2 To wb.Sheets(1).UsedRange.Rows.Count

        Set MCNode = doc.createElement("missedConnection")
        root.appendChild MCNode

        Set userNode = doc.createElement("user")
        userNode.Text = wb.Sheets(1).Cells(i, 1)
        MCNode.appendChild userNode

        Set categoryNode = doc.createElement("category")
        categoryNode.Text = wb.Sheets(1).Cells(i, 2)
        MCNode.appendChild categoryNode

        Set cityNode = doc.createElement("city")
        cityNode.Text = wb.Sheets(1).Cells(i, 3)
        MCNode.appendChild cityNode

        Set postNode = doc.createElement("post")
        postNode.Text = wb.Sheets(1).Cells(i, 4)
        MCNode.appendChild postNode

        Set timeNode = doc.createElement("time")
        timeNode.Text = wb.Sheets(1).Cells(i, 5)
        MCNode.appendChild timeNode

        Set linkNode = doc.createElement("link")
        linkNode.Text = wb.Sheets(1).Cells(i, 6)
        MCNode.appendChild linkNode

    Next i
    
    wb.Close False

    ' STYLE RAW OUTPUT FOR INDENTATION AND LINE BREAKS
    xslDoc.LoadXML "<?xml version=" & Chr(34) & "1.0" & Chr(34) & "?>" _
            & "<xsl:stylesheet version=" & Chr(34) & "1.0" & Chr(34) _
            & "                xmlns:xsl=" & Chr(34) & "http://www.w3.org/1999/XSL/Transform" & Chr(34) & ">" _
            & "<xsl:strip-space elements=" & Chr(34) & "*" & Chr(34) & " />" _
            & "<xsl:output method=" & Chr(34) & "xml" & Chr(34) & " indent=" & Chr(34) & "yes" & Chr(34) & "" _
            & "            encoding=" & Chr(34) & "UTF-8" & Chr(34) & "/>" _
            & " <xsl:template match=" & Chr(34) & "node() | @*" & Chr(34) & ">" _
            & "  <xsl:copy>" _
            & "   <xsl:apply-templates select=" & Chr(34) & "node() | @*" & Chr(34) & " />" _
            & "  </xsl:copy>" _
            & " </xsl:template>" _
            & "</xsl:stylesheet>"

    xslDoc.async = False
    doc.transformNodeToObject xslDoc, newDoc
    newDoc.Save strPath & "\CLData_XLOutput.xml"
            
    MsgBox "Successfully migrated CSV data into XML!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub


