
import java.util.ArrayList;
import java.util.Map;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

import java.io.FileInputStream;
import java.io.ObjectInputStream;

import com.google.gson.*;

public class BINtoJSON_Java {       

    public static void main(String[] args) {

	    // CREATE JSON OBJECTS
	    JsonArray jsondata = new JsonArray();
            JsonObject jo = new JsonObject(); 

            try {
                String currentDir = new File("").getAbsolutePath();

                // LOAD OBJECT
                FileInputStream fis = new FileInputStream("../BuildBINs/CLData_Java.bin");
                ObjectInputStream ois = new ObjectInputStream(fis);
                @SuppressWarnings("unchecked")
                ArrayList <Map<String, String>> cldata = (ArrayList<Map<String, String>>) ois.readObject();
                ois.close();
                fis.close();
                
                // BUILD JSON
                for(int n=0; n < cldata.size(); n++){
                    jo = new JsonObject();

                    for (String key : cldata.get(n).keySet()) {
                        String value = cldata.get(n).get(key);
                        jo.addProperty(key, value);
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
	
                System.out.println("Successfully migrated binary data to JSON!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (ClassNotFoundException cne) {
                System.out.println(cne.getMessage());
            }
    }
}
