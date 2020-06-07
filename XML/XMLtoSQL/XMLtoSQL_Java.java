
import javax.xml.parsers.*;

import java.sql.* ;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.xml.sax.*;
import org.w3c.dom.*;

public class XMLtoSQL_Java {       
    
    public static void main(String[] args) {
                
            String currentDir = new File("").getAbsolutePath();
            String database = currentDir + "/CLData.db";

            // XML OBJECTS
	    Document dom;            
	    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		
            try { 
                // CONNECT TO DB
                Connection conn = DriverManager.getConnection("jdbc:sqlite:"+database);
                conn.setAutoCommit(false);

                Statement stmt = conn.createStatement();
                stmt.executeUpdate("DELETE FROM cldata");

                String insertSQL = "INSERT INTO cldata (`user`, `city`, `category`, `post`, `link`, `time`)"
		                    + "VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(insertSQL);

		// PARSE XML
                DocumentBuilder db = dbf.newDocumentBuilder();                
                dom = db.parse(currentDir + "/CLData.xml");
    	    
                Element doc = dom.getDocumentElement();
                NodeList mcNodes = doc.getElementsByTagName("missedConnection");

                // EXTRACT BY NODE
                for (int i=0; i < mcNodes.getLength(); i++) {
                    NodeList childNodes = mcNodes.item(i).getChildNodes();

                    int j = 1;
                    for (int n=0; n < childNodes.getLength(); n++) {
                       if(childNodes.item(n).getNodeType() == Node.ELEMENT_NODE){
                          Element cElem = (Element) childNodes.item(n);

                          pstmt.setString(j, cElem.getTextContent());
                          j = j + 1;
                       }
                    }

                    // APPEND DATA    
                    pstmt.executeUpdate();                 
                }

                conn.commit();
                pstmt.close();
                conn.close();

                System.out.println("Successfully migrated XML data into SQL database!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (ParserConfigurationException pce) {
                System.out.println(pce.getMessage());
            } catch (SAXException se) {
                System.out.println(se.getMessage());
            } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (SQLException err) {            
                System.out.println(err.getMessage());
            } 
    }
}
