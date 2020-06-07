
import java.sql.* ;
import java.util.*;
import java.lang.reflect.Type;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import com.google.gson.*;
import com.google.gson.reflect.TypeToken;

public class JSONtoSQL_Java {       
        
    public static void main(String[] args) {
	
	    String currentDir = new File("").getAbsolutePath();
            String JSON_FILE  = currentDir + "/CLData.json";
            String DATABASE   = currentDir + "/CLData.db";
	    
            try {
                // READ JSON
                Type type = new TypeToken<List<Map<String, String>>>(){}.getType();
                List<Map<String, String>> cldata = new Gson().fromJson(new FileReader(JSON_FILE), type);;

                // CONNECT TO DB
                Connection conn = DriverManager.getConnection("jdbc:sqlite:"+DATABASE);
                conn.setAutoCommit(false);

                Statement stmt = conn.createStatement();
                stmt.executeUpdate("DELETE FROM cldata");

                String insertSQL = "INSERT INTO cldata (`user`, `city`, `category`, `post`, `link`, `time`)"
		                    + "VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(insertSQL);

                // APPEND DATA
                for(int i=0; i < cldata.size(); i++) {
                   int n = 1;
                   Map<String, String> mcdata = cldata.get(i);

                   for (Map.Entry<String,String> entry : mcdata.entrySet()) {
                       pstmt.setString(n, entry.getValue());
                       n = n + 1;
                   }
                   // APPEND DATA    
                   pstmt.executeUpdate();
                }

                conn.commit();
                pstmt.close();
                conn.close();
				
                System.out.println("Successfully migrated JSON data to SQL database!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (SQLException sqe) {
                System.out.println(sqe.getMessage());
            }
    }
}
