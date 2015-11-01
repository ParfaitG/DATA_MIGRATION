
import java.sql.* ;
import java.util.ArrayList;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;


public class CSVtoSQL_java {       
    
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
		String csvFile = "D:\\Documents\\GitHub\\DATA_MIGRATION\\CSVtoSQL\\ClData.csv";
		BufferedReader br = null;
		String line = "";
		String cvsSplitBy = ",";
                            
		br = new BufferedReader(new FileReader(csvFile));
		while ((line = br.readLine()) != null) {

			// Use comma as separator
			String[] cldata = line.split(cvsSplitBy);
			
			userstr = cldata[0];
                        if (userstr != null){
                            user.add(userstr);
                        } else {
                            user.add(null);
                        }                        
                         
                        categorystr =  cldata[1];
                        if (categorystr != null){
                            category.add(categorystr);
                        } else { 
                            category.add("");
                        }
			
                        citystr = cldata[2];
                        if (citystr != null){
                            city.add(citystr);
                        } else {
                            city.add("");
                        }
                        
                        poststr =  cldata[3];                        
                        if (poststr != null){
                            post.add("\"" + poststr + "\"");
                        } else {
                            post.add("");
                        }
                            
                        linkstr =  cldata[4];
                        if (linkstr != null){
                            link.add(linkstr);
                        } else {
                            link.add("");
                        }
                            
                        timestr =  cldata[5];
                        if (timestr != null){
                            time.add(timestr);
                        } else {
                            time.add("");
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
		    
		    if (i == 0 ){
			// Skip column headers
			continue;
		    }
		    
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
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (SQLException err) {            
                System.out.println(err.getMessage());
            } 
    }
}
