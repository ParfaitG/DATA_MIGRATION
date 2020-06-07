
''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Private Sub CSVtoXML_ACC()
On Error GoTo ErrHandle
    Dim strFile, xmlPath, xslstr As String
    Dim rawDoc, xslDoc, newDoc As New MSXML2.DOMDocument

    strFile = Application.CurrentProject.Path

    ' IMPORT CSV
    DoCmd.TransferText acImportDelim, , "CLData", strFile & "\CLData.csv", True
      
    ' EXPORT RAW XML
    xmlPath = Application.CurrentProject.Path & "\CLData_ACC.xml"
    Application.ExportXML acExportTable, "CLData", xmlPath
    
    ' IDENTITY TRANSFORM XSLT
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

    Set rawDoc = New MSXML2.DOMDocument
    Set xslDoc = New MSXML2.DOMDocument
    Set newDoc = New MSXML2.DOMDocument
    
    rawDoc.async = False
    rawDoc.Load xmlstr
        
    xslDoc.async = False
    xslDoc.LoadXML xslstr
    
    ' PRETTY PRINT RAW XML
    rawDoc.transformNodeToObject xslDoc, newDoc
    newDoc.Save xmlstr
    
    MsgBox "Successfully migrated CSV data to XML!", vbInformation
    
ExitHandle:
    Set rawDoc = Nothing: Set xslDoc = Nothing: Set newDoc = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub


''''''''''''''''''
''MS EXCEL VBA
''''''''''''''''''
Public Sub CSVtoXML_XL()
On Error GoTo ErrHandle
    Dim wb As Workbook
    Dim doc, xslDoc, newDoc As MSXML2.DOMDocument
    Dim root, MCNode, childNode As IXMLDOMElement
    Dim strPath, xslFile As String
    Dim lastRow, lastCol, i, j As Long
    
    ' DECLARE XML DOC OBJECT
    Set doc = New MSXML2.DOMDocument
    Set root = doc.createElement("CLData")
    doc.appendChild root
    
    strPath = Application.ActiveWorkbook.Path
    
    ' READ CSV
    Workbooks.OpenText Filename:=strPath & "\CLData.csv", DataType:=xlDelimited, Comma:=True
    Set wb = ActiveWorkbook
    
    ' WRITE RAW XML
    lastRow = wb.Sheets(1).UsedRange.Rows.Count
    lastCol = wb.Sheets(1).UsedRange.Columns.Count

    For i = 2 To lastRow
        Set MCNode = doc.createElement("missedConnection")
        root.appendChild MCNode

        For j = 1 to lastCol
            Set childNode = doc.createElement(Cells(1, j))
            childNode.Text = wb.Sheets(1).Cells(i, j)
            MCNode.appendChild childNode
        Next j
    Next i
    
    wb.Close False

    ' IDENTITY TRANSFORM XSLT
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

    Set xslDoc = New MSXML2.DOMDocument
    Set newDoc = New MSXML2.DOMDocument

    ' PRETTY PRINT RAW XML
    xslDoc.async = False
    doc.transformNodeToObject xslDoc, newDoc
    newDoc.Save strPath & "\CLData_XL.xml"
            
    MsgBox "Successfully migrated CSV data to XML!", vbInformation

ExitHandle:
    Set wb = Nothing
    Set root = Nothing: Set childNode = Nothing: Set MCNode = Nothing
    Set doc = Nothing: Set xslDoc = Nothing: Set newDoc = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub
