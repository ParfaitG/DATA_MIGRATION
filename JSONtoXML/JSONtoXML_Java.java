
import java.util.*;

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

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.json.simple.parser.JSONParser;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class JSONtoXML_Java {       
        
    public static void main(String[] args) {
	
	    JSONParser parser = new JSONParser();
	    
            try {		
		String currentDir = new File("").getAbsolutePath();		
		String jsonFile = currentDir + "\\Cldata.json";
		
		// Instantiate JSON object
		Object jsonobj = parser.parse(new FileReader(jsonFile));
		JSONArray jsondata = (JSONArray) jsonobj;
				
		// Instantiate XML document object
                DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();            
                DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.newDocument();
                
                // Root element
		Element rootElement = doc.createElement("CLData");
		doc.appendChild(rootElement);
		
		// Iterate through json data creating elements and values
		Iterator<Map> iterator = jsondata.iterator();		
		while (iterator.hasNext()) {
		    Map innerdata = new LinkedHashMap();
		    innerdata = iterator.next();		    
		    Set<String> keys = innerdata.keySet();
		    		    		    		    
		    Element mcNode = doc.createElement("missedConnection");
                    rootElement.appendChild(mcNode);    
                    
                    Element userNode = doc.createElement("user");
                    userNode.appendChild(doc.createTextNode(innerdata.get("user").toString()));
                    mcNode.appendChild(userNode);
                    
                    Element cityNode = doc.createElement("city");
                    cityNode.appendChild(doc.createTextNode(innerdata.get("city").toString()));
                    mcNode.appendChild(cityNode);
                    
                    Element categoryNode = doc.createElement("category");
                    categoryNode.appendChild(doc.createTextNode(innerdata.get("category").toString()));
                    mcNode.appendChild(categoryNode);
                    
                    Element postNode = doc.createElement("post");
                    postNode.appendChild(doc.createTextNode(innerdata.get("post").toString()));
                    mcNode.appendChild(postNode);
                    
                    Element linkNode = doc.createElement("link");
                    linkNode.appendChild(doc.createTextNode(innerdata.get("link").toString()));
                    mcNode.appendChild(linkNode);
                    
                    Element timeNode = doc.createElement("time");
                    timeNode.appendChild(doc.createTextNode(innerdata.get("time").toString()));
                    mcNode.appendChild(timeNode);		    
		}

		// Output content to xml file
		TransformerFactory transformerFactory = TransformerFactory.newInstance();                
		Transformer transformer = transformerFactory.newTransformer();
                transformer.setOutputProperty(OutputKeys.INDENT, "yes");
                transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
                
		DOMSource source = new DOMSource(doc);
		StreamResult result = new StreamResult(new File(currentDir + "\\Cldata_Java.xml"));		
		transformer.transform(source, result);
		
                System.out.println("Successfully converted json to xml data!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (ParseException pse) {
                System.out.println(pse.getMessage());
            } catch (ParserConfigurationException pce) {
		System.out.println(pce.getMessage());            
            } catch (TransformerException tfe) {
		System.out.println(tfe.getMessage());                
	    }
    }
}
