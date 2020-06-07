
import java.sql.* ;
import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.OutputKeys;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class SQLtoXML_Java {       
    
    public static void main(String[] args) {    

            try {                
		String currentDir = new File("").getAbsolutePath();		
                String database = currentDir + "/CLData.db";
                            
                // Connect to database
                Connection conn = DriverManager.getConnection("jdbc:sqlite:"+database);
                conn.setAutoCommit(false);              

                // QUERY DATABASE
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM cldata");
                ResultSetMetaData rsmd = rs.getMetaData();
                int rs_column_count = rsmd.getColumnCount();
		                
                // INITIALIZE XML DOCUMENT
                DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();            
                DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
                Document doc = docBuilder.newDocument();

		Element rootElement = doc.createElement("CLData");
		doc.appendChild(rootElement);

                // BUILD NODES
                while (rs.next()) {
                       Element mcNode = doc.createElement("missedConnection");
                       rootElement.appendChild(mcNode); 
             
                       for(int i=1; i <= rs_column_count; i++) {
                             Element currNode = doc.createElement(rsmd.getColumnName(i));
                             currNode.appendChild(doc.createTextNode(rs.getString(i)));
                             mcNode.appendChild(currNode);  
                       }                                         
                }                    
                
                rs.close();
                stmt.close();
                conn.close();
                
                // OUTPUT XML
		TransformerFactory transformerFactory = TransformerFactory.newInstance();                
		Transformer transformer = transformerFactory.newTransformer();
                transformer.setOutputProperty(OutputKeys.INDENT, "yes");
                transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
                
		DOMSource source = new DOMSource(doc);
		StreamResult result = new StreamResult(new File(currentDir + "/CLData_Java.xml"));		
		transformer.transform(source, result);
                
                System.out.println("Successfully migrated SQL data to XML!");
                
            } catch (ParserConfigurationException pce) {
		System.out.println(pce.getMessage());            
            } catch (TransformerException tfe) {
		System.out.println(tfe.getMessage());            
            } catch (SQLException err) {            
                System.out.println(err.getMessage());
            } 
    
        
    }
}
