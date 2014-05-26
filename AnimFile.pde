// Class to handle an image array and an image file
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

class AnimFile {
  String fileName;
  ArrayList lines;

  public AnimFile() { // AnimFile constructor ...
    lines = new ArrayList();
  }
  public void load(String f) {  // Load the file in an array
    fileName = f;
    int currentLine = 0;
    String strLine;
    String l = null;
    try{
      lines.clear();
      BufferedReader br = new BufferedReader(new FileReader(fileName));
      while ((strLine = br.readLine()) != null)   { //Read File Line By Line
        lines.add(strLine);
      }
      br.close();
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());  
    }
  }
  public void write() {   // Write the array in the opened file
    try{
      //File fileName = new File(fileName);
      BufferedWriter bw =  new BufferedWriter(new FileWriter(fileName));
      for(int i=0; i<lines.size(); i++) {
        bw.write(lines.get(i) + "\n");
      }
      bw.close();
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
  }
  public String readLine(int lineNumber) {  // Read a specific line and return its content (String)
    String l = null;
    try{
      l = lines.get(lineNumber).toString();
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
    return l;
  }
  public boolean[] readLineB(int lineNumber) {  // Read a specific line and return its content (Boolean array)
    String l = null;
    try{
      l = lines.get(lineNumber).toString();
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
    return stringToArray(l);
  }
  public void insertLine(int lineNumber) {  // Insert a blank line
    try {
      lines.add(lineNumber);
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
  }
  public void writeLine(String data) {  // Add a line at the end of the array and write it with some data (String)
    try {
      lines.add(data);
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
  }
  public void writeLine(int lineNumber, String data) {  // Replace a specific line in the array with some data (String)
    try {
      lines.set(lineNumber, data);
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
  }
  public void writeLineB(boolean[] data) {  // Add a line at the end of the array and write it with some data (Boolean array)
    String l = arrayToString(data);
    try {
      lines.add(l);
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
  }
  public void writeLineB(int lineNumber, boolean[] data) {   // Replace a specific line in the array with some data (Boolean array)
    String l = arrayToString(data);
    try {
      lines.set(lineNumber, l);
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
  }
  public void removeLine(int lineNumber) {  // Delete a specific line
    try {
      lines.remove(lineNumber);
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
  }
  public int numberOfLines() {  // Returns the current number of frames in the array
    int n = 0;
    try {
      n = lines.size();
    }
    catch (Exception e)  {  //Catch exception if any
      System.err.println("Error : " + e.getMessage());
    }
    return n;
  }
  public String arrayToString(boolean[] a) {   // Convert a boolean array to a string of 0 and 1, separated by commas
    String s = "";
    String n = new String();
    for(int i=0; i<a.length; i++){
      if(a[i] == true)
        n = "1,";
      else if(a[i] == false)
        n = "0,";
      s = s + n;
    }
    return s;
  }
  public boolean[] stringToArray(String s) {   // Convert string of 0 and 1, separated by commas to a boolean array
    String[] n = s.split(",");
    boolean[] a = new boolean[n.length];
    for (int i = 0; i<n.length; i++) {
      if(n[i].equals("1"))
        a[i] = true;
      else if(n[i].equals("0"))
        a[i] = false;
    }
    return a;
  }
}