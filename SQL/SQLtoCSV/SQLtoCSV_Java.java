
import java.sql.* ;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class SQLtoCSV_Java {       
    
    public static void main(String[] args) {

            String CSV_QUOTE = "\"";
            String COMMA_DELIMITER = ",";
            String NEW_LINE_SEPARATOR = "\n";
                     
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

                // WRITE CSV
                FileWriter writer = new FileWriter(currentDir + "/CLData_Java.csv");

                // HEADERS
                for(int i=1; i <= rs_column_count; i++) {
                       writer.append(rsmd.getColumnName(i));
                  
                       if(i < rs_column_count) {
                           writer.append(COMMA_DELIMITER);
                       }
                }
                writer.append(NEW_LINE_SEPARATOR);

                // DATA ROWS
                while (rs.next()) {                       
                       for(int i=1; i <= rs_column_count; i++) {
                              writer.append(CSV_QUOTE + rs.getString(i).replace(CSV_QUOTE, "\"\"") + CSV_QUOTE);
                  
                              if(i < rs_column_count) {
                                  writer.append(COMMA_DELIMITER);
                              }  
                       }
                       writer.append(NEW_LINE_SEPARATOR);
                }
		
                rs.close();
                stmt.close();
                conn.close();

                writer.flush();
                writer.close();
                
                System.out.println("Successfully migrated SQL data to CSV!");
                
            } catch (SQLException err) {            
                System.out.println(err.getMessage());            
            } catch (IOException ioe) {
                System.err.println(ioe.getMessage());
            }
    
        
    }
}
