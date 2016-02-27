
import java.sql.*;
import java.util.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.json.simple.parser.JSONParser;

import com.google.gson.*;

public class SQLtoJSON_Java {       
    
    public static void main(String[] args) {
	
	    // CREATE JSON OBJECTS
	    JSONArray jsondata = new JSONArray();
	    Map innerdata = new LinkedHashMap();
	    JSONArray innerarray = new JSONArray();
	    	    
            try {
		String currentDir = new File("").getAbsolutePath();		
                String url = "jdbc:mysql://localhost:3306/****";            
                String username = "***";
                String password  =  "****";
                            
                // CONNECT TO DATABASE
                Connection conn = DriverManager.getConnection(url, username, password);
                
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM cldata");
                
                // EXTRACT DATA ROW BY ROW
                ResultSetMetaData rsmd = rs.getMetaData();
                int columnsNumber = rsmd.getColumnCount();
		
                while (rs.next()) {		    
						
			innerdata.put("user", rs.getString(2));
			innerdata.put("category", rs.getString(3));
			innerdata.put("city", rs.getString(4));
			innerdata.put("time", rs.getString(5));
			innerdata.put("post", rs.getString(6));
			innerdata.put("link", rs.getString(7));
						
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
	
                System.out.println("Successfully converted sql to json data!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (SQLException sqe) {
                System.out.println(sqe.getMessage());
            }
    }
}
