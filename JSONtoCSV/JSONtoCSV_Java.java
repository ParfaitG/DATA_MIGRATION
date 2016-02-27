
import java.util.*;

import java.io.File;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.json.simple.parser.JSONParser;

public class JSONtoCSV_Java {       
    
    public static void main(String[] args) {
	
	    String currentDir = new File("").getAbsolutePath();
	    JSONParser parser = new JSONParser();
	    String COLUMN_HEADER = "user,category,city,time,post,link";
            String COMMA_DELIMITER = ",";
            String NEW_LINE_SEPARATOR = "\n";
	    
            try {                
		String jsonFile = currentDir + "\\Cldata.json";
		
		Object jsonobj = parser.parse(new FileReader(jsonFile));
		JSONArray jsondata = (JSONArray) jsonobj;
		
                // Output data to CSV
                FileWriter writer = new FileWriter(currentDir + "\\Cldata_Java.csv");
                
                // Column headers
                writer.append(COLUMN_HEADER.toString());
		writer.append(NEW_LINE_SEPARATOR);		
				
		Iterator<Map> iterator = jsondata.iterator();		
		while (iterator.hasNext()) {
		    Map innerdata = new LinkedHashMap();
		    innerdata = iterator.next();		    
		    Set<String> keys = innerdata.keySet();
		    
		    // Data rows		    
		    writer.append(innerdata.get("user").toString());
		    writer.append(COMMA_DELIMITER);
		    writer.append(innerdata.get("category").toString());
		    writer.append(COMMA_DELIMITER);
		    writer.append(innerdata.get("city").toString());
		    writer.append(COMMA_DELIMITER);                    
		    writer.append(innerdata.get("time").toString());
		    writer.append(COMMA_DELIMITER);          
		    writer.append("\"" + innerdata.get("post").toString() + "\"");
		    writer.append(COMMA_DELIMITER);  
		    writer.append(innerdata.get("link").toString());                    
		    writer.append(NEW_LINE_SEPARATOR);   
		    
		}
		
		writer.flush();
		writer.close();
		    
                System.out.println("Successfully converted json to csv data!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (ParseException pse) {
                System.out.println(pse.getMessage());
            } 
    }
}
