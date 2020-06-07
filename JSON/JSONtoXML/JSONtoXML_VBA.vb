
'''''''''''''''''''
'' MS ACCESS VBA
'''''''''''''''''''
Public Sub JSONtoXML_ACC()
On Error GoTo ErrHandle
    Dim db As Database, qdef As QueryDef
    Dim FileNum As Integer
    Dim DataLine, jsonStr, strPath, strSQL As String
    Dim p As Object, element As Variant
    
    Dim rawDoc, xslDoc, newDoc As MSXML2.DOMDocument
    Dim xmlstr, xslstr As String
    
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
                  & " VALUES ([User],[Category], [City], [Post], [Time], [link])"
                      
        Set qdef = db.CreateQueryDef("", strSQL)
                
        qdef!User = element("user")
        qdef!Category = element("category")
        qdef!City = element("city")
        qdef!Post = element("post")
        qdef!Time = element("time")
        qdef!link = element("link")
        
        qdef.Execute
    Next element
        
    ' EXPORT RAW XML
    xmlstr = Application.CurrentProject.Path & "\CLData_ACC.xml"
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

    ' PRETTY PRINT RAW XML
    Set rawDoc = New MSXML2.DOMDocument
    Set xslDoc = New MSXML2.DOMDocument
    Set newDoc = New MSXML2.DOMDocument
    
    rawDoc.async = False
    rawDoc.Load xmlstr
        
    xslDoc.async = False
    xslDoc.LoadXML xslstr
    
    rawDoc.transformNodeToObject xslDoc, newDoc
    newDoc.Save xmlstr
    
    MsgBox "Successfully migrated JSON data to XML!", vbInformation

ExitHandle:
    Set element = Nothing: Set p = Nothing
    Set qdef = Nothing: Set db = Nothing
    Set rawDoc = Nothing: Set xslDoc = Nothing: Set newDoc = Nothing
    Exit Sub

ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
    
End Sub


'''''''''''''''''''
'' MS EXCEL VBA
'''''''''''''''''''
Public Sub JSONtoXML_XL()
On Error GoTo ErrHandle
    Dim FileNum As Integer
    Dim DataLine, jsonStr, strPath As String
    Dim element, varKey As Variant
    Dim i As Integer
    Dim p As Object
    
    Dim doc, xslDoc, newDoc As MSXML2.DOMDocument
    Dim root, MCNode, chilNode As IXMLDOMElement
            
    strPath = ActiveWorkbook.Path
    
    ' READ JSON
    FileNum = FreeFile()
    Open strPath & "\CLData.json" For Input As #FileNum
        
    ' PARSE FILE STRING
    jsonStr = ""
    While Not EOF(FileNum)
        Line Input #FileNum, DataLine
        
        jsonStr = jsonStr & DataLine & vbNewLine
    Wend
    Close #FileNum
    Set p = ParseJson(jsonStr)
    
    ' INITIALIZE XML
    Set doc = New MSXML2.DOMDocument
    Set root = doc.createElement("CLData")
    doc.appendChild root
    
    ' ITERATE DATA ROWS
    For Each element In p
        Set MCNode = doc.createElement("missedConnection")
        root.appendChild MCNode

        For Each varKey In element.Keys()
            Set childNode = doc.createElement(varKey)
            childNode.Text = element(varKey)
            MCNode.appendChild childNode
        Next varKey
    Next element
    
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

    ' PRETTY PRINT RAW XML
    Set xslDoc = New MSXML2.DOMDocument
    Set newDoc = New MSXML2.DOMDocument

    xslDoc.async = False
    doc.transformNodeToObject xslDoc, newDoc
    newDoc.Save strPath & "\CLData_XL.xml"
    
    MsgBox "Successfully migrated JSON data to XML!", vbInformation
        
ExitHandle:
    Set element = Nothing: Set varKey = Nothing: Set p = Nothing
    Set root = Nothing: Set childNode = Nothing: Set MCNode = Nothing
    Set doc = Nothing: Set xslDoc = Nothing: Set newDoc = Nothing
    Exit Sub
    
ErrHandle:
    MsgBox Err.Number & " - " & Err.Description, vbCritical
    Resume ExitHandle
End Sub

