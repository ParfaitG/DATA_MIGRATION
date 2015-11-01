
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

import java.util.ArrayList;
import java.io.FileWriter;
import java.io.IOException;

import org.xml.sax.*;
import org.w3c.dom.*;

public class XMLtoCSV_java {    

        public static void main(String [] args){
            
            // Initalize objects
            String userstr = null;
            ArrayList<String> user;
            user = new ArrayList<String>();
            
            String categorystr = null;
            ArrayList<String> category;
            category = new ArrayList<String>();
            
            String citystr = null;
            ArrayList<String> city;
            city = new ArrayList<String>();
            
            String poststr = null;
            ArrayList<String> post;
            post = new ArrayList<String>();
            
            String timestr = null;
            ArrayList<String> time;
            time = new ArrayList<String>();
            
            String linkstr = null;
            ArrayList<String> link;
            link = new ArrayList<String>();
            
            Document dom;            
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            
            try {
                // Parse XML file
                DocumentBuilder db = dbf.newDocumentBuilder();                
                dom = db.parse("D:\\Documents\\GitHub\\DATA_MIGRATION\\XMLtoCSV\\CLData.xml");
    
                Element doc = dom.getDocumentElement();
                NodeList cllist = doc.getElementsByTagName("missedConnection");
                
                // Extract XML data by node
                for (int i=0; i<(cllist.getLength()); i++ ) {
                    
                    Node cNode = cllist.item(i);
                    Element celem = (Element) cNode;
                    
                    userstr = celem.getElementsByTagName("user").item(0).getTextContent();
                    if (userstr != null) {
                        if (!userstr.isEmpty())
                            user.add(userstr);
                    } else {
                        user.add("");
                    }
                    
                    citystr = celem.getElementsByTagName("city").item(0).getTextContent();
                    if (citystr != null) {
                        if (!citystr.isEmpty())
                            city.add(citystr);
                    } else {
                        city.add("");
                    }
                    
                    categorystr = celem.getElementsByTagName("category").item(0).getTextContent();
                    if (categorystr != null) {
                        if (!categorystr.isEmpty())
                            category.add(categorystr);
                    } else {
                        category.add("");
                    }
                    
                    poststr = celem.getElementsByTagName("post").item(0).getTextContent();
                    poststr = poststr.replace("\"", "");
                    if (poststr != null) {
                        if (!poststr.isEmpty())
                            post.add("\"" + poststr + "\"");
                    } else {
                        post.add("");
                    }
                    
                    timestr = celem.getElementsByTagName("time").item(0).getTextContent();
                    if (timestr != null) {
                        if (!timestr.isEmpty())
                            time.add(timestr);
                    } else {
                        time.add("");
                    }
                    
                    linkstr = celem.getElementsByTagName("link").item(0).getTextContent();
                    if (linkstr != null) {
                        if (!linkstr.isEmpty())
                            link.add(linkstr);
                    } else {
                        link.add("");
                    }
                    
                }
                
                String COLUMN_HEADER = "user,category,city,post,time,link";
                String COMMA_DELIMITER = ",";
                String NEW_LINE_SEPARATOR = "\n";
                     
                // Output data to CSV
                FileWriter writer = new FileWriter("D:\\Java\\projects\\CLData_xml.csv");
                
                // Column headers
                writer.append(COLUMN_HEADER.toString());
                writer.append(NEW_LINE_SEPARATOR);
            
                // Data rows
                for (int j=0; j<(user.size()); j++ ) {                    
                    writer.append(user.get(j).toString());
                    writer.append(COMMA_DELIMITER);
                    writer.append(category.get(j).toString());
                    writer.append(COMMA_DELIMITER);
                    writer.append(city.get(j).toString());
                    writer.append(COMMA_DELIMITER);
                    writer.append(post.get(j).toString());
                    writer.append(COMMA_DELIMITER);          
                    writer.append(time.get(j).toString());
                    writer.append(COMMA_DELIMITER);  
                    writer.append(link.get(j).toString());                    
                    writer.append(NEW_LINE_SEPARATOR);                        
                }
                
                writer.flush();
                writer.close();
                
                System.out.println("Successfully created csv file!");            
                
            } catch (ParserConfigurationException pce) {
                System.out.println(pce.getMessage());
            } catch (SAXException se) {
                System.out.println(se.getMessage());
            } catch (IOException ioe) {
                System.err.println(ioe.getMessage());
            }
        }
    
}