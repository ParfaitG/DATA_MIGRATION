
'''''''''''''''''''
'' MS ACCESS VBA
'''''''''''''''''''
Private Sub JSONImport_Click()
On Error GoTo ErrHandle
    Dim db As Database, qdef As QueryDef
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String, strPath As String, strSQL As String
    Dim p As Object, element As Variant
    
    Set db = CurrentDb
    
    strPath = Application.CurrentProject.Path
    db.Execute "DELETE  FROM CLData;", dbFailOnError
        
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

Private Sub XMLExport_Click()
On Error GoTo ErrHandle
    Dim rawDoc As Object, xslDoc As Object, newDoc As Object
    Dim xmlstr As String, xslstr As String, todayDate As String
    
    xmlstr = Application.CurrentProject.Path & "\CLData_ACC.xml"
        
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
    
    MsgBox "Successfully migrated JSON data to XML data!", vbInformation
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Exit Sub
    
End Sub


'''''''''''''''''''
'' MS EXCEL VBA
'''''''''''''''''''
Sub XMLExport()
On Error GoTo ErrHandle
    Dim FileNum As Integer
    Dim DataLine As String, jsonStr As String, strPath As String
    Dim element As Variant, i As Integer
    Dim p As Object
    
    Dim doc As New MSXML2.DOMDocument, xslDoc As New MSXML2.DOMDocument, newDoc As New MSXML2.DOMDocument
    Dim root As IXMLDOMElement, MCNode As IXMLDOMElement
    Dim userNode As IXMLDOMElement, categoryNode As IXMLDOMElement, cityNode As IXMLDOMElement
    Dim postNode As IXMLDOMElement, timeNode As IXMLDOMElement, linkNode As IXMLDOMElement
            
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
    
    ' DECLARE XML DOC OBJECT
    Set root = doc.createElement("CLData")
    doc.appendChild root
    
    ' ITERATE DATA ROWS
    For Each element In p
        
        Set MCNode = doc.createElement("missedConnection")
        root.appendChild MCNode

        Set userNode = doc.createElement("user")
        userNode.Text = element("user")
        MCNode.appendChild userNode

        Set categoryNode = doc.createElement("category")
        categoryNode.Text = element("category")
        MCNode.appendChild categoryNode

        Set cityNode = doc.createElement("city")
        cityNode.Text = element("city")
        MCNode.appendChild cityNode

        Set postNode = doc.createElement("post")
        postNode.Text = element("post")
        MCNode.appendChild postNode

        Set timeNode = doc.createElement("time")
        timeNode.Text = element("time")
        MCNode.appendChild timeNode

        Set linkNode = doc.createElement("link")
        linkNode.Text = element("link")
        MCNode.appendChild linkNode
        
    Next element
    
    ' PRETTY PRINT RAW OUTPUT WITH XSLT
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
    newDoc.Save strPath & "\CLData_XL.xml"
    
    MsgBox "Successfully converted json data to xml!", vbInformation
        
    Set element = Nothing
    Set p = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description
    Exit Sub
End Sub