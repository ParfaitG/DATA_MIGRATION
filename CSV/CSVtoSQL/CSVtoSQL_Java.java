
import java.sql.* ;

import java.io.File;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;


public class CSVtoSQL_Java {       
    
    public static void main(String[] args) {                  

            try {                
                String currentDir = new File("").getAbsolutePath();    
		String csvFile = currentDir + "/CLData.csv";

		BufferedReader br = null;
		String line = null;
		String cvsSplitBy = ",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)";

		// CONNECT TO DB
		String database = currentDir + "/CLData.db";
                Connection conn = DriverManager.getConnection("jdbc:sqlite:"+database);
		conn.setAutoCommit(false);

                Statement stmt = conn.createStatement();
                stmt.executeUpdate("DELETE FROM cldata");

		String insertSQL = "INSERT INTO cldata (`user`, `city`, `category`, `post`, `link`, `time`)"
				    + "VALUES (?, ?, ?, ?, ?, ?)";		
                // READ CSV   
		int i = 0;       
		br = new BufferedReader(new FileReader(csvFile));
		while ((line = br.readLine()) != null) {
			String[] csvdata = line.split(cvsSplitBy, -1);                        
                        
			if (i == 0) {               
                             i += 1; 
                             continue; 
                        }

                        PreparedStatement pstmt = conn.prepareStatement(insertSQL);

                        for(int n=1; n <= csvdata.length; n++) {
                             pstmt.setString(n, csvdata[n-1]);
		        }
		    
                        // APPEND DATA
                        pstmt.executeUpdate();
		}

                conn.commit();
                pstmt.close();
                conn.close();

                System.out.println("Successfully migrated CSV data into SQL database!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (SQLException err) {            
                System.out.println(err.getMessage());
            } 
    }
}
