
import java.io.File;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

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

public class CSVtoXML_Java {
    
    public static void main(String[] args) {

            BufferedReader br = null;
	    String line = null;
	    String cvsSplitBy = ",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)";
            String[] headers = null;

            try {             
		String currentDir = new File("").getAbsolutePath();
		String csvFile = currentDir + "/CLData.csv";
                            
		// Write to XML document
                DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();            
                DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
		Document doc = docBuilder.newDocument();
                
		Element rootElement = doc.createElement("CLData");
		doc.appendChild(rootElement);

                // Read from CSV File    
		int i = 0;       
		br = new BufferedReader(new FileReader(csvFile));
		while ((line = br.readLine()) != null) {
			String[] csvdata = line.split(cvsSplitBy, -1);                        
                        
			if (i == 0) {               
                             headers = csvdata;
                             i += 1; 
                             continue; 
                        }

                        Element mcNode = doc.createElement("missedConnection");
                        rootElement.appendChild(mcNode); 

                        for(int n=0; n < csvdata.length; n++) {
                             Element currNode = doc.createElement(headers[n]);
                             currNode.appendChild(doc.createTextNode(csvdata[n]));
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
                
                System.out.println("Successfully migrated CSV data to XML!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (ParserConfigurationException pce) {
		System.out.println(pce.getMessage());            
            } catch (TransformerException tfe) {
		System.out.println(tfe.getMessage());                
	    }
    }
}
