
import java.sql.* ;
import java.util.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.json.simple.parser.JSONParser;

public class JSONtoSQL_Java {       
        
    public static void main(String[] args) {
	
	    JSONParser parser = new JSONParser();
	    
            try {
		String currentDir = new File("").getAbsolutePath();
		String jsonFile = currentDir + "\\Cldata.json";
		
		Object jsonobj = parser.parse(new FileReader(jsonFile));
		JSONArray jsondata = (JSONArray) jsonobj;

		// Connect to Database
		String url = "jdbc:mysql://localhost:3306/****";            
                String username = "****";
                String password  = "****";
		Connection conn = DriverManager.getConnection(url, username, password);
		
		// Append data to Database
		String insertSQL = "INSERT INTO cldata (`user`, `city`, `category`, `post`, `link`, `time`)"
				    + "VALUES (?, ?, ?, ?, ?, ?)";
				
		Iterator<Map> iterator = jsondata.iterator();		
		while (iterator.hasNext()) {
		    Map innerdata = new LinkedHashMap();
		    innerdata = iterator.next();		    
		    Set<String> keys = innerdata.keySet();
		    
		    // prepare SQL statement with binded string values
		    PreparedStatement pstmt = conn.prepareStatement(insertSQL);
		    
		    pstmt.setString(1, innerdata.get("user").toString());
		    pstmt.setString(2, innerdata.get("category").toString());
		    pstmt.setString(3, innerdata.get("city").toString());
		    pstmt.setString(4, innerdata.get("post").toString());
		    pstmt.setString(5, innerdata.get("link").toString());
		    pstmt.setString(6, innerdata.get("time").toString());
		    
		    // execute insert SQL stetement
		    pstmt.executeUpdate();		    
		}
				
                System.out.println("Successfully converted json to sql!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (ParseException pse) {
                System.out.println(pse.getMessage());
            } catch (SQLException sqe) {
                System.out.println(sqe.getMessage());
            }
    }
}
