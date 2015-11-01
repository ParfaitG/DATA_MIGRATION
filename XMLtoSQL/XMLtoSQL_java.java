
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

import java.sql.* ;
import java.util.ArrayList;
import java.io.IOException;

import org.xml.sax.*;
import org.w3c.dom.*;

public class XMLtoSQL_java {       
    
    public static void main(String[] args) {
        
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
                dom = db.parse("D:\\Documents\\GitHub\\DATA_MIGRATION\\XMLtoSQL\\CLData.xml");
		    
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
                
		// Connect to Database
		String url = "jdbc:mysql://localhost:3306/horseracing";            
                String username = "root";
                String password  =  "poet87*";
		Connection conn = DriverManager.getConnection(url, username, password);
		
		// Append data to Database
		String insertSQL = "INSERT INTO cldata (`user`, `city`, `category`, `post`, `link`, `time`)"
				    + "VALUES (?, ?, ?, ?, ?, ?)";		
		
		for (int i=0; i<(user.size()); i++ ) {
		    PreparedStatement pstmt = conn.prepareStatement(insertSQL);
		    
		    pstmt.setString(1, user.get(i).toString());
		    pstmt.setString(2, city.get(i).toString());
		    pstmt.setString(3, category.get(i).toString());
		    pstmt.setString(4, post.get(i).toString());
		    pstmt.setString(5, link.get(i).toString());
		    pstmt.setString(6, time.get(i).toString());
		    
		    // execute insert SQL stetement
		    pstmt.executeUpdate();
		}
		
                System.out.println("Successfully uploaded sql data!");
	            
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
