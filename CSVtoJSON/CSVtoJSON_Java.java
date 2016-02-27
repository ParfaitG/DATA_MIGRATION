
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

import com.google.gson.*;

public class CSVtoJSON_Java {       
    
    public static void main(String[] args) {
	
	    // Create JSON Arrays
	    JSONArray jsondata = new JSONArray();
	    Map innerdata = new LinkedHashMap();
	    JSONArray innerarray = new JSONArray();
	    	    
            try {
		
		String currentDir = new File("").getAbsolutePath();
		String csvFile = currentDir + "\\Cldata.csv";
		BufferedReader br = null;
		String line = "";
		String cvsSplitBy = ",";
                            
		br = new BufferedReader(new FileReader(csvFile));
		int i = 0;
		while ((line = br.readLine()) != null) {
		    
			if (i == 0) { i += 1; continue; }
			// Use comma as separator
			String[] csvdata = line.split(cvsSplitBy);
			
			innerdata.put("user", csvdata[0]);
			innerdata.put("category", csvdata[1]);
			innerdata.put("city", csvdata[2]);
			innerdata.put("time", csvdata[3]);
			innerdata.put("post", csvdata[4]);
			innerdata.put("link", csvdata[5]);
						
			innerarray.add(innerdata);
			jsondata.add(innerdata);
			innerdata = new LinkedHashMap();
			innerarray = new JSONArray();
			i += 1;
		
		}
		
		// PRETTY PRINT RAW JSON
		Gson gson = new GsonBuilder().setPrettyPrinting().create();
		JsonParser jp = new JsonParser();
		JsonElement je = jp.parse(jsondata.toJSONString());
		String prettyJsonString = gson.toJson(je);
		
		// SAVE JSON TO FILE
		FileWriter file = new FileWriter(currentDir + "\\Cldata_Java.json");
		file.write(prettyJsonString);
		file.flush();
		file.close();
	
                System.out.println("Successfully converted csv to json data!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } 
    }
}
