
import java.sql.*;
import java.util.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

import com.google.gson.*;

public class SQLtoJSON_Java {       
    
    public static void main(String[] args) {
	
	    // CREATE JSON OBJECTS
	    JsonArray jsondata = new JsonArray();
            JsonObject jo = new JsonObject(); 
	    	    
            try {
		String currentDir = new File("").getAbsolutePath();		
                String database = currentDir + "/CLData.db";

                // CONNECT TO DATABASE
                Connection conn = DriverManager.getConnection("jdbc:sqlite:"+database);
                conn.setAutoCommit(false);

                // QUERY DATABASE
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM cldata");
                ResultSetMetaData rsmd = rs.getMetaData();
                int rs_column_count = rsmd.getColumnCount();
		
                // DATA ROWS
                while (rs.next()) {          
                       jo = new JsonObject();
             
                       for(int i=1; i <= rs_column_count; i++) {
                              jo.addProperty(rsmd.getColumnName(i), rs.getString(i));
                       }

                       jsondata.add(jo);
                }
		
                rs.close();
                stmt.close();
                conn.close();

		// SAVE JSON
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		String prettyJsonString = gson.toJson(jsondata);
		
		FileWriter file = new FileWriter(currentDir + "/CLData_Java.json");
		file.write(prettyJsonString);
		file.flush();
		file.close();
	
                System.out.println("Successfully migrated SQL data to JSON!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (SQLException sqe) {
                System.out.println(sqe.getMessage());
            }
    }
}
