
import javax.xml.parsers.*;

import java.io.File;
import java.io.FileWriter;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.xml.sax.*;
import org.w3c.dom.*;

import com.google.gson.*;

public class XMLtoJSON_Java {       

    public static void main(String[] args) {

	    // JSON OBJECTS
	    JsonArray jsondata = new JsonArray();
            JsonObject jo = new JsonObject();
	    
	    // XML OBJECTS
            Document dom = null;       
            DocumentBuilder db = null;   
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	    	    
            try {
                String currentDir = new File("").getAbsolutePath();

                // PARSE XML
                db = dbf.newDocumentBuilder();                
                dom = db.parse(currentDir + "/CLData.xml");
    
                Element doc = dom.getDocumentElement();
                NodeList mcNodes = doc.getElementsByTagName("missedConnection");

                // EXTRACT BY NODE
                for (int i=1; i < mcNodes.getLength(); i++) {
                    NodeList childNodes = mcNodes.item(i).getChildNodes();

                    jo = new JsonObject();

                    for (int n=0; n < childNodes.getLength(); n++) {
                       if(childNodes.item(n).getNodeType() == Node.ELEMENT_NODE){
                          Element cElem = (Element) childNodes.item(n);

                          jo.addProperty(childNodes.item(n).getNodeName(), cElem.getTextContent());
                       }
                    }

                    jsondata.add(jo);
                }

		// SAVE JSON
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		String prettyJsonString = gson.toJson(jsondata);
		
		FileWriter file = new FileWriter(currentDir + "/CLData_Java.json");
		file.write(prettyJsonString);
		file.flush();
		file.close();
	
                System.out.println("Successfully migrated XML data to JSON!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (ParserConfigurationException pce) {
                System.out.println(pce.getMessage());
            } catch (SAXException se) {
                System.out.println(se.getMessage());
            } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } 
    }
}
