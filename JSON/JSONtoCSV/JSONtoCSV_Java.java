
import java.util.*;
import java.lang.reflect.Type;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import com.google.gson.*;
import com.google.gson.reflect.TypeToken;

public class JSONtoCSV_Java {       
    
    public static void main(String[] args) {
	
	    String currentDir = new File("").getAbsolutePath();
            String JSON_FILE = currentDir + "/CLData.json";
            String COMMA_DELIMITER = ",";
            String NEW_LINE_SEPARATOR = "\n";
	    
            try {
                // READ JSON
                Type type = new TypeToken<List<Map<String, String>>>(){}.getType();
                List<Map<String, String>> cldata = new Gson().fromJson(new FileReader(JSON_FILE), type);

                // WRITE CSV
                FileWriter writer = new FileWriter(currentDir + "/CLData_Java.csv");

                // HEADERS
                Map<String, String> mcdata = cldata.get(0);

                String headers = String.join(",", mcdata.keySet());
                writer.append(headers);
                writer.append(NEW_LINE_SEPARATOR);
                
                // DATA ROWS
                for(int i=0; i < cldata.size(); i++) {
                   int n = 1;
                   mcdata = cldata.get(i);

                   for (Map.Entry<String,String> entry : mcdata.entrySet()) {
                       writer.append("\"" + entry.getValue().replace("\"", "\"\"") + "\"");
                       
                       if (n < mcdata.size()) {
                          writer.append(COMMA_DELIMITER);
                       }
                       n = n + 1;
                   }
                   writer.append(NEW_LINE_SEPARATOR);
                }

		writer.flush();
		writer.close();
                
                System.out.println("Successfully migrated JSON data to CSV!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } 
    }
}
