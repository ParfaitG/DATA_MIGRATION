
import java.util.ArrayList;
import java.util.Map;

import java.sql.* ;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import java.io.FileInputStream;
import java.io.ObjectInputStream;

public class BINtoSQL_Java {       
    
    public static void main(String[] args) {
                
            String currentDir = new File("").getAbsolutePath();
            String database = currentDir + "/CLData.db";
		
            try { 
                // LOAD OBJECT
                FileInputStream fis = new FileInputStream("../BuildBINs/CLData_Java.bin");
                ObjectInputStream ois = new ObjectInputStream(fis);
                @SuppressWarnings("unchecked")
                ArrayList <Map<String, String>> cldata = (ArrayList<Map<String, String>>) ois.readObject();
                ois.close();
                fis.close();

                // CONNECT TO DB
                Connection conn = DriverManager.getConnection("jdbc:sqlite:"+database);
                conn.setAutoCommit(false);

                Statement stmt = conn.createStatement();
                stmt.executeUpdate("DELETE FROM cldata");

                String insertSQL = "INSERT INTO cldata (`user`, `city`, `category`, `post`, `link`, `time`)"
		                    + "VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(insertSQL);

                // DATA ROWS
                for(int i=0; i < cldata.size(); i++) {
                   int n = 1;
                   for (String key : cldata.get(i).keySet()) {
                       String value = cldata.get(i).get(key);                       
                       pstmt.setString(n, value);                       
                       n = n + 1;
                   }
                    // APPEND DATA    
                    pstmt.executeUpdate();
                }

                conn.commit();
                pstmt.close();
                conn.close();

                System.out.println("Successfully migrated binary data into SQL database!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (SQLException err) {            
                System.out.println(err.getMessage());
            } catch (ClassNotFoundException cne) {
                System.out.println(cne.getMessage());
            }
    }
}
