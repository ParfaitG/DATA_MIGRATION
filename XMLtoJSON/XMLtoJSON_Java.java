
import java.util.*;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.json.simple.parser.JSONParser;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

import org.xml.sax.*;
import org.w3c.dom.*;

import com.google.gson.*;

public class XMLtoJSON_Java {       

    public static void main(String[] args) {
	
	    // CREATE JSON ARRAYS
	    JSONArray jsondata = new JSONArray();
	    Map innerdata = new LinkedHashMap();
	    JSONArray innerarray = new JSONArray();
	    
	    // CREATE DOM OBJECT
            Document dom;            
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	    	    
            try {	
		String currentDir = new File("").getAbsolutePath();
		String xmlFile = currentDir + "\\Cldata.xml";
		
		DocumentBuilder db = dbf.newDocumentBuilder();                
                dom = db.parse(xmlFile);		

                Element doc = dom.getDocumentElement();
                NodeList cllist = doc.getElementsByTagName("missedConnection");
                
                // Extract XML data by node
                for (int i=0; i<(cllist.getLength()); i++ ) {
		    		    
                    Node cNode = cllist.item(i);
                    Element celem = (Element) cNode;
		    
		    innerdata.put("user", celem.getElementsByTagName("user").item(0).getTextContent());
		    innerdata.put("category", celem.getElementsByTagName("category").item(0).getTextContent());
		    innerdata.put("city", celem.getElementsByTagName("city").item(0).getTextContent());
		    innerdata.put("time", celem.getElementsByTagName("time").item(0).getTextContent());
		    innerdata.put("post", celem.getElementsByTagName("post").item(0).getTextContent());
		    innerdata.put("link", celem.getElementsByTagName("link").item(0).getTextContent());
					    
		    innerarray.add(innerdata);
		    jsondata.add(innerdata);
		    innerdata = new LinkedHashMap();
		    innerarray = new JSONArray();		    
		
		}
		
		// PRETTY PRINT RAW JSON
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		JsonParser jp = new JsonParser();
		JsonElement je = jp.parse(jsondata.toJSONString());
		String prettyJsonString = gson.toJson(je);		
		
		// SAVE JSON TO FILE
		FileWriter file = new FileWriter(currentDir + "\\Cldata_Java.json");
		file.write(prettyJsonString);
		file.flush();
		file.close();
	
                System.out.println("Successfully converted csv to json data!");
	            
	    } catch (ParserConfigurationException pce) {
                System.out.println(pce.getMessage());
            } catch (SAXException se) {
                System.out.println(se.getMessage());
            } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } 
    }
}
