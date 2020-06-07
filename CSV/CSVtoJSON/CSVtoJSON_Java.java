
import java.io.File;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import com.google.gson.*;

public class CSVtoJSON_Java {       

    public static void main(String[] args) {
	
	    BufferedReader br = null;
	    String line = null;
	    String cvsSplitBy = ",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)";
	    String[] headers = null;

	    // CREATE JSON OBJECTS
	    JsonArray jsondata = new JsonArray();
            JsonObject jo = new JsonObject(); 

            try {
                String currentDir = new File("").getAbsolutePath();
                String csvFile = currentDir + "/CLData.csv";

                // READ CSV                            
		int i = 0;
		br = new BufferedReader(new FileReader(csvFile));
		while ((line = br.readLine()) != null) {

			String[] csvdata = line.split(cvsSplitBy, -1);                        
                        
			if (i == 0) {      
                             headers = csvdata;                     
                             i += 1; 
                             continue; 
                        }

		        jo = new JsonObject();
                        for(int n=0; n < csvdata.length; n++) {
                             jo.addProperty(headers[n], csvdata[n]);
		        }

			jsondata.add(jo);
		}
		
		// SAVE JSON
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		String prettyJsonString = gson.toJson(jsondata);
		
		FileWriter file = new FileWriter(currentDir + "/CLData_Java.json");
		file.write(prettyJsonString);
		file.flush();
		file.close();
	
                System.out.println("Successfully converted CSV data to JSON!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } 
    }
}
