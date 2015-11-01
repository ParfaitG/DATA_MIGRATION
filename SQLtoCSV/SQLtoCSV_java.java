import java.sql.* ;
import java.util.ArrayList;
import java.io.FileWriter;
import java.io.IOException;

public class SQLtoCSV_java {       
    
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
                       
            try {            
                String url = "jdbc:mysql://<hostname>:3306/<databasename>";            
                String username = "****";
                String password  =  "****";
                            
                // Connect to database
                Connection conn = DriverManager.getConnection(url, username, password);
                
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM cldata");
                
                // Export table data
                ResultSetMetaData rsmd = rs.getMetaData();
                int columnsNumber = rsmd.getColumnCount();
                while (rs.next()) {
                                                                    
                        userstr = rs.getString(1);
                        if (userstr != null){
                            user.add(userstr);
                        } else {
                            user.add("");
                        }
                        
                        citystr = rs.getString(2);                        
                        if (citystr != null){
                            city.add(citystr);
                        } else {
                            city.add("");
                        }
                        
                        categorystr = rs.getString(3);                        
                        if (categorystr != null){
                            category.add(categorystr);
                        } else { 
                            category.add("");
                        }
                            
                        poststr = rs.getString(4).replace("\"", "");                        
                        if (poststr != null){
                            post.add("\"" + poststr + "\"");
                        } else {
                            post.add("");
                        }
                            
                        linkstr = rs.getString(5);                        
                        if (linkstr != null){
                            link.add(linkstr);
                        } else {
                            link.add("");
                        }
                            
                        timestr = rs.getString(6);                        
                        if (timestr != null){
                            time.add(timestr);
                        } else {
                            time.add("");
                        }                                                   
                }                    
                
                rs.close();
                stmt.close();
                conn.close();
                
                String COLUMN_HEADER = "user,city,category,post,time,link";
                String COMMA_DELIMITER = ",";
                String NEW_LINE_SEPARATOR = "\n";
                     
                // Output data to CSV
                FileWriter writer = new FileWriter("C:\\Path\\To\\CSVFile.csv");
                
                // Column headers
                writer.append(COLUMN_HEADER.toString());
                writer.append(NEW_LINE_SEPARATOR);
            
                // Data rows
                for (int j=0; j<(user.size()); j++ ) {                    
                    writer.append(user.get(j).toString());
                    writer.append(COMMA_DELIMITER);
                    writer.append(city.get(j).toString());
                    writer.append(COMMA_DELIMITER);
                    writer.append(category.get(j).toString());
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
                
            } catch (SQLException err) {            
                System.out.println(err.getMessage());            
            } catch (IOException ioe) {
                System.err.println(ioe.getMessage());
            }
    
        
    }
}
