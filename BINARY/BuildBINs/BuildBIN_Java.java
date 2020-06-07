
import java.util.ArrayList;
import java.util.Map;
import java.util.LinkedHashMap;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import java.io.File;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class BuildBIN_Java {
    
    public static void main(String[] args) {

            BufferedReader br = null;
	    String line = null;
	    String cvsSplitBy = ",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)";
            String[] headers = null;
            ArrayList <Map<String, String>> cldata = new ArrayList<Map<String, String>>();

            try {             
		String currentDir = new File("").getAbsolutePath();
         
                // READ CSV    
		int i = 0;       
		br = new BufferedReader(new FileReader("../../CSV/CSVtoXML/CLData.csv"));
		while ((line = br.readLine()) != null) {
			String[] csvdata = line.split(cvsSplitBy, -1);                        
                        
			if (i == 0) {               
                             headers = csvdata;
                             i += 1; 
                             continue; 
                        }

                        // STORE ROWS IN LIST OF MAPs
                        Map<String, String> clMap = new LinkedHashMap<String, String>();

                        for(int n=0; n < csvdata.length; n++) {
                             clMap.put(headers[n], csvdata[n]);
		        }
                        cldata.add(clMap);
		}                         

                // SAVE OBJECT
                FileOutputStream fos = new FileOutputStream(currentDir + "/CLData_Java.bin");
                ObjectOutputStream oos = new ObjectOutputStream(fos);
                oos.writeObject(cldata);
                oos.close();
                fos.close();

                // LOAD OBJECT
                FileInputStream fis = new FileInputStream(currentDir + "/CLData_Java.bin");
                ObjectInputStream ois = new ObjectInputStream(fis);
                @SuppressWarnings("unchecked")
                ArrayList <Map<String, String>> new_cldata = (ArrayList<Map<String, String>>) ois.readObject();
                ois.close();
                fis.close();
                
                System.out.println("Size = " + String.valueOf(new_cldata.size()));
                for(int n=1; n < 5; n++){
                    for (String key : new_cldata.get(n).keySet()) {
                        String value = new_cldata.get(n).get(key);
                        System.out.println("key = " + key);
                        System.out.println("value = " + value);
                    }
                }

                System.out.println("Successfully created binary data!");
	            
	    } catch (FileNotFoundException ffe) {
                System.out.println(ffe.getMessage());
	    } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            } catch (ClassNotFoundException cne) {
                System.out.println(cne.getMessage());
            }
    }
}
