
import java.util.ArrayList;
import java.util.Map;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import java.io.FileInputStream;
import java.io.ObjectInputStream;


public class BINtoCSV_Java {       
    
    public static void main(String[] args) {
	
	    String currentDir = new File("").getAbsolutePath();
            String JSON_FILE = currentDir + "/CLData.json";
            String COMMA_DELIMITER = ",";
            String NEW_LINE_SEPARATOR = "\n";

            try {
                // LOAD OBJECT
                FileInputStream fis = new FileInputStream("../BuildBINs/CLData_Java.bin");
                ObjectInputStream ois = new ObjectInputStream(fis);
                @SuppressWarnings("unchecked")
                ArrayList <Map<String, String>> cldata = (ArrayList<Map<String, String>>) ois.readObject();
                ois.close();
                fis.close();

                // INITIALIZE CSV
                FileWriter writer = new FileWriter(currentDir + "/CLData_Java.csv");

                // HEADERS
                String headers = String.join(",", cldata.get(0).keySet());
                writer.append(headers);
                writer.append(NEW_LINE_SEPARATOR);
                
                // DATA ROWS
                for(int i=0; i < cldata.size(); i++) {
                   int n = 1;

                   for (String key : cldata.get(i).keySet()) {
                       String value = cldata.get(i).get(key);
                       writer.append("\"" + value.replace("\"", "\"\"") + "\"");
                       
                       if (n < cldata.get(i).size()) {
                          writer.append(COMMA_DELIMITER);
                       }
                       n = n + 1;
                   }
                   writer.append(NEW_LINE_SEPARATOR);
                }

		writer.flush();
		writer.close();
                
                System.out.println("Successfully migrated binary data to CSV!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (ClassNotFoundException cne) {
                System.out.println(cne.getMessage());
            }
    }
}
