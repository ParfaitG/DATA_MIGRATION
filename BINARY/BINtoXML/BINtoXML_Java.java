
import java.util.ArrayList;
import java.util.Map;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.ObjectInputStream;

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

public class BINtoXML_Java {
    
    public static void main(String[] args) {

            try {             
		String currentDir = new File("").getAbsolutePath();
		String csvFile = currentDir + "/CLData.csv";

                // Load Object
                FileInputStream fis = new FileInputStream("../BuildBINs/CLData_Java.bin");
                ObjectInputStream ois = new ObjectInputStream(fis);
                @SuppressWarnings("unchecked")
                ArrayList <Map<String, String>> cldata = (ArrayList<Map<String, String>>) ois.readObject();
                ois.close();
                fis.close();

		// Initialize XML document
                DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();            
                DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.newDocument();
                
		Element rootElement = doc.createElement("CLData");
		doc.appendChild(rootElement);

                // Build XML nodes
                for(int i=0; i < cldata.size(); i++) {
                   Element mcNode = doc.createElement("missedConnection");
                   rootElement.appendChild(mcNode); 

                   for (String key : cldata.get(i).keySet()) {
                       String value = cldata.get(i).get(key);
                     
                       Element currNode = doc.createElement(key);
                       currNode.appendChild(doc.createTextNode(value));
                       mcNode.appendChild(currNode);                     
                   }
                }

                // Output content to xml file
		TransformerFactory transformerFactory = TransformerFactory.newInstance();                
		Transformer transformer = transformerFactory.newTransformer();
                transformer.setOutputProperty(OutputKeys.INDENT, "yes");
                transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
                
		DOMSource source = new DOMSource(doc);
		StreamResult result = new StreamResult(new File(currentDir + "/CLData_Java.xml"));		
		transformer.transform(source, result);
                
                System.out.println("Successfully migrated binary data to XML!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (ParserConfigurationException pce) {
		System.out.println(pce.getMessage());            
            } catch (TransformerException tfe) {
		System.out.println(tfe.getMessage());                
	    } catch (ClassNotFoundException cne) {
                System.out.println(cne.getMessage());
            }
    }
}
