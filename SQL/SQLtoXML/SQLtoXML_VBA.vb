
''''''''''''''''''
''MS ACCESS VBA
''''''''''''''''''
Public Sub SQLtoXML_ACC()
On Error GoTo ErrHandle

    Dim db As Database, tbldef As TableDef
    Dim rawDoc, xslDoc, newDoc As MSXML2.DOMDocument
    Dim strPath, xmlstr, xslstr As String
    
    Set db = CurrentDb
    
    strPath = Application.CurrentProject.Path

    ' REMOVE PRIOR LINKED MYSQL TABLE
    For Each tbldef In db.TableDefs
        If tbldef.Name = "CLData" Then
            db.TableDefs.Delete ("CLData")
        End If
    Next tbldef
    
    ' CREATE LINKED TABLE
    DoCmd.TransferDatabase acLink, "ODBC Database", _
          "ODBC;DRIVER=SQLite3 ODBC Driver;Database=" & strPath & "\CLData.db;", _
          acTable, "CLData", "CLData_linked"
        
    xmlstr = strPath & "\CLData_ACC.xml"
    
    ' EXPORT RAW XML
    Application.ExportXML acExportTable, "CLData", xmlstr
    
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

    ' TRANSFORM XML
    Set rawDoc = New MSXML2.DOMDocument
    Set xslDoc = New MSXML2.DOMDocument
    Set newDoc = New MSXML2.DOMDocument
    
    rawDoc.async = False
    rawDoc.Load xmlstr
        
    xslDoc.async = False
    xslDoc.LoadXML xslstr
    
    ' SAVE XML
    rawDoc.transformNodeToObject xslDoc, newDoc
    newDoc.Save xmlstr
    
    MsgBox "Successfully migrated SQL data into XML!", vbInformation

ExitHandle:
    Set tbldef = Nothing: Set db = Nothing
    Set rawDoc = Nothing: Set xslDoc = Nothing: Set newDoc = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub


''''''''''''''''''
''MS EXCEL VBA
''''''''''''''''''
Public Sub SQLtoXML_XL()
On Error GoTo ErrHandle
    Dim doc, xslDoc, newDoc As New MSXML2.DOMDocument
    Dim root, MCNode, childNode As IXMLDOMElement

    Dim CN, RS As Object
    Dim constr, strPath As String
    Dim i As Long
    
    strPath = Application.ActiveWorkbook.Path

    ' INITIALIZE XML
    Set root = doc.createElement("CLData")
    doc.appendChild root

    ' CONNECT TO DATABASE
    Set CN = CreateObject("ADODB.Connection")
    Set RS = CreateObject("ADODB.Recordset")

    constr = "DRIVER=SQLite3 ODBC Driver;Database=" & strPath & "\CLData.db;"
   
    CN.Open constr
    RS.Open "SELECT * FROM cldata", CN
    RS.moveFirst
    
    ' BUILD XML NODES
    Do While Not RS.EOF    
        Set MCNode = doc.createElement("missedConnection")
        root.appendChild MCNode
        
        For i = 1 to RS.Fields.Count
            Set childNode = doc.createElement(RS.Fields(i - 1).Name)
            userNode.Text = RS.Fields(i - 1).Value
            MCNode.appendChild childNode
        Next i
            
        RS.moveNext
    Loop
        
    ' CLOSE RECORDSET AND DATABASE
    RS.Close: CN.Close
        
    ' IDENTITY TRANSFORM
    xslDoc.LoadXML "<?xml version=" & Chr(34) & "1.0" & Chr(34) & "?>" _
            & "<xsl:stylesheet version=" & Chr(34) & "1.0" & Chr(34) _
            & "                xmlns:xsl=" & Chr(34) & "http://www.w3.org/1999/XSL/Transform" & Chr(34) & ">" _
            & "<xsl:strip-space elements=" & Chr(34) & "*" & Chr(34) & " />" _
            & "<xsl:output method=" & Chr(34) & "xml" & Chr(34) & " indent=" & Chr(34) & "yes" & Chr(34) & " />" _
            & " <xsl:template match=" & Chr(34) & "node() | @*" & Chr(34) & ">" _
            & "  <xsl:copy>" _
            & "   <xsl:apply-templates select=" & Chr(34) & "node() | @*" & Chr(34) & " />" _
            & "  </xsl:copy>" _
            & " </xsl:template>" _
            & "</xsl:stylesheet>"
        
    xslDoc.async = False
    doc.transformNodeToObject xslDoc, newDoc

    ' SAVE XML
    newDoc.Save strPath & "\CLData_XL.xml"
            
    MsgBox "Successfully migrated SQL data to XML!", vbInformation

ExitHandle:
    Set doc = Nothing: Set xslDoc = Nothing: Set newDoc = Nothing
    Set root = Nothing: Set MCNode = Nothing: Set childNode = Nothing
    Set RS = Nothing: Set CN = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub



