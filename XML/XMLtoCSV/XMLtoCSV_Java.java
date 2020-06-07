
import javax.xml.parsers.*;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import org.xml.sax.*;
import org.w3c.dom.*;

public class XMLtoCSV_Java {    

        public static void main(String [] args){

            String currentDir = new File("").getAbsolutePath();
            String COLUMN_HEADERS = "";
            String CSV_QUOTE = "\"";
            String COMMA_DELIMITER = ",";
            String NEW_LINE_SEPARATOR = "\n";               

            Document dom = null;       
            DocumentBuilder db = null;   
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            
            try {

                // PARSE XML
                db = dbf.newDocumentBuilder();                
                dom = db.parse(currentDir + "/CLData.xml");
    
                Element doc = dom.getDocumentElement();
                NodeList mcNodes = doc.getElementsByTagName("missedConnection");
                     
                // WRITE CSV
                FileWriter writer = new FileWriter(currentDir + "/CLData_Java.csv");

                NodeList childNodes = mcNodes.item(0).getChildNodes(); 

                for (int n=0; n < childNodes.getLength(); n++) {
                    if(childNodes.item(n).getNodeType() == Node.ELEMENT_NODE){
                        COLUMN_HEADERS = COLUMN_HEADERS + childNodes.item(n).getNodeName();
                       
                        if(n < (childNodes.getLength()-2)) {
                           COLUMN_HEADERS = COLUMN_HEADERS + COMMA_DELIMITER;
                        }
                    }
                }
                writer.append(COLUMN_HEADERS);
                writer.append(NEW_LINE_SEPARATOR);

                // EXTRACT BY NODE
                for (int i=1; i < mcNodes.getLength(); i++) {
                    childNodes = mcNodes.item(i).getChildNodes();
                    
                    for (int j=0; j < childNodes.getLength(); j++) {
                       if(childNodes.item(j).getNodeType() == Node.ELEMENT_NODE){
                          Element cElem = (Element) childNodes.item(j);
                          writer.append(CSV_QUOTE + cElem.getTextContent().replace("\"", "\"\"") + CSV_QUOTE);
                       
                          if(j < (childNodes.getLength()-2)) {
                             writer.append(COMMA_DELIMITER);
                          }
                       } 
                    }
                    writer.append(NEW_LINE_SEPARATOR);
                }
                
                writer.flush();
                writer.close();
                
                System.out.println("Successfully migrated XML data to CSV!");            
                
            } catch (ParserConfigurationException pce) {
                System.out.println(pce.getMessage());
            } catch (SAXException se) {
                System.out.println(se.getMessage());
            } catch (IOException ioe) {
                System.err.println(ioe.getMessage());
            }
        }
    
}
