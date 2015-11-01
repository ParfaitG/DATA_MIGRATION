Option Compare Database
Option Explicit

''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Private Sub CSVImport_Click()
On Error GoTo ErrHandle
    Dim strFile As String
    
    strFile = Application.CurrentProject.Path
    DoCmd.TransferText acImportDelim, , "CLData", strFile & "\CLData.csv", True
        
    MsgBox "Successfully imported CSV data!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub

Private Sub XMLExport_Click()
On Error GoTo ErrHandle
    Dim rawDoc As Object, xslDoc As Object, newDoc As Object
    Dim xmlstr As String, xslstr As String, todayDate As String
    
    xmlstr = Application.CurrentProject.Path & "\CLData_ACCOutput.xml"
        
    ' EXPORT TABLE TO XML FORMAT
    Application.ExportXML acExportTable, "CLData", xmlstr
    
    ' STYLE RAW OUTPUT WITH XSLT
    xslstr = "<?xml version=" & Chr(34) & "1.0" & Chr(34) & "?>" _
              & "<xsl:stylesheet version=" & Chr(34) & "1.0" & Chr(34) & "" _
              & "                xmlns:xsl=" & Chr(34) & "http://www.w3.org/1999/XSL/Transform" & Chr(34) & "" _
              & "                xmlns:od=" & Chr(34) & "urn:schemas-microsoft-com:officedata" & Chr(34) & "" _
              & "                exclude-result-prefixes=" & Chr(34) & "od" & Chr(34) & ">" _
              & " <xsl:strip-space elements=" & Chr(34) & "*" & Chr(34) & " />" _
              & "  <xsl:output method=" & Chr(34) & "xml" & Chr(34) & " indent=" & Chr(34) & "yes" & Chr(34) & "" _
              & "              encoding=" & Chr(34) & "UTF-8" & Chr(34) & "/>" _
              & " <xsl:template match=" & Chr(34) & "dataroot" & Chr(34) & ">" _
              & "    <xsl:element name=" & Chr(34) & "CLData" & Chr(34) & ">" _
              & "     <xsl:for-each select=" & Chr(34) & "CLData" & Chr(34) & ">" _
              & "       <xsl:element name=" & Chr(34) & "missedConnection" & Chr(34) & ">" _
              & "         <user><xsl:value-of select=" & Chr(34) & "user" & Chr(34) & "/></user>" _
              & "         <category><xsl:value-of select=" & Chr(34) & "category" & Chr(34) & "/></category>" _
              & "         <city><xsl:value-of select=" & Chr(34) & "city" & Chr(34) & "/></city>" _
              & "         <post><xsl:value-of select=" & Chr(34) & "post" & Chr(34) & "/></post>" _
              & "         <time><xsl:value-of select=" & Chr(34) & "time" & Chr(34) & "/></time>" _
              & "         <link><xsl:value-of select=" & Chr(34) & "link" & Chr(34) & "/></link>" _
              & "       </xsl:element>" _
              & "     </xsl:for-each>" _
              & "    </xsl:element>" _
              & "  </xsl:template>" _
              & "</xsl:stylesheet>"

    Set rawDoc = CreateObject("MSXML2.DOMDocument")
    Set xslDoc = CreateObject("MSXML2.DOMDocument")
    Set newDoc = CreateObject("MSXML2.DOMDocument")
    
    rawDoc.async = False
    rawDoc.Load xmlstr
        
    xslDoc.async = False
    xslDoc.LoadXML xslstr
    
    rawDoc.transformNodeToObject xslDoc, newDoc
    newDoc.Save xmlstr
    
    MsgBox "Successfully migrated CSV data to XML data!", vbInformation
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
