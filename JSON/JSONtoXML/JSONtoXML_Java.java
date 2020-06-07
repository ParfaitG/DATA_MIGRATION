
import java.util.*;
import java.lang.reflect.Type;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.OutputKeys;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.google.gson.*;
import com.google.gson.reflect.TypeToken;

public class JSONtoXML_Java {       
        
    public static void main(String[] args) {
	
	    String currentDir = new File("").getAbsolutePath();
            String JSON_FILE = currentDir + "/CLData.json";

            try {
                // READ JSON
                Type type = new TypeToken<List<Map<String, String>>>(){}.getType();
                List<Map<String, String>> cldata = new Gson().fromJson(new FileReader(JSON_FILE), type);

		// INITIALIZE XML
                DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();            
                DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.newDocument();

		Element rootElement = doc.createElement("CLData");
		doc.appendChild(rootElement);

                // WRITE NODES
                for(int i=0; i < cldata.size(); i++) {
                   Element mcNode = doc.createElement("missedConnection");
                   rootElement.appendChild(mcNode); 

                   Map<String, String> mcdata = cldata.get(i);
                   for (Map.Entry<String,String> entry : mcdata.entrySet()) {
                      Element currNode = doc.createElement(entry.getKey());
                      currNode.appendChild(doc.createTextNode(entry.getValue()));
                      mcNode.appendChild(currNode);   
	           }
                }

		// TRANSFORM AND SAVE XML
		TransformerFactory transformerFactory = TransformerFactory.newInstance();                
		Transformer transformer = transformerFactory.newTransformer();
                transformer.setOutputProperty(OutputKeys.INDENT, "yes");
                transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
                
		DOMSource source = new DOMSource(doc);
		StreamResult result = new StreamResult(new File(currentDir + "/CLData_Java.xml"));		
		transformer.transform(source, result);
		
                System.out.println("Successfully migrated JSON data to XML!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (ParserConfigurationException pce) {
		System.out.println(pce.getMessage());            
            } catch (TransformerException tfe) {
		System.out.println(tfe.getMessage());                
	    }
    }
}
