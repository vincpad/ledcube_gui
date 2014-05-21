// Class to manage writing and reading of the frames in a text file

class AnimFile {
  public String fileName;

  public AnimFile() {    // Init of the file name variable
    fileName = null;   
  }
  public void changeFile(String fName) {
    fileName = fName;
  }
  public boolean[] read(int lineNumber){    // Reading of a specific line, return an array with all values
    if(lineNumber == -1 || fileName == null) {
      println("No frame or file selected !");
      boolean[] a = new boolean[dim*dim*dim];
      return a;
    }
    else {
      String[] lines = loadStrings(fileName);
      boolean[] a = stringToArray(lines[lineNumber]);
      return a;
    }
    
  }
  public int countLines() {
    if(fileName != null) {
      String[] lines = loadStrings(fileName);
      return lines.length;
    }
    else {
      println("No file selected !");
      return -1;
    }
  }
  public void erase(int lineNumber, boolean[] data){    // Erasing of a specific line, replace the line content with an array of values
    if(fileName != null) {
      String[] lines = loadStrings(fileName);
      String d = arrayToString(data);
      lines[lineNumber] = d;
      saveStrings(fileName, lines);
    } 
    else {
      println("No file selected !");
    }
  }
  public void insert(int lineNumber){   // Insert a blank line and push all next lines
    if(fileName != null) {
      String[] lines = loadStrings(fileName);
      String newLines[] = new String[lines.length + 1];
      for(int i=0; i<lineNumber; i++){
        newLines[i] = lines[i];
      }
      for(int i=lines.length-1; i>=lineNumber; i--){
        newLines[i+1]=lines[i];
      }
      saveStrings(fileName, newLines);
      boolean[] emptyArray = new boolean[dim*dim*dim];
      for (int i = 0; i < pow(dim,3); ++i) {
        emptyArray[i] = false;
      }
      erase(lineNumber, emptyArray);
    }
    else {
      println("No file selected !");
    }
  }
  public void remove(int lineNumber){   // Remove a line and push all next lines
    if(fileName != null) {
      String[] lines = loadStrings(fileName);
      String newLines[] = new String[lines.length - 1];
      for(int i=0; i<lineNumber; i++){
        newLines[i] = lines[i];
      }
      for(int i=lines.length-1; i>lineNumber; i--){
        newLines[i-1]=lines[i];
      }
      saveStrings(fileName, newLines);
    }
    else {
      println("No file selected !");
    }
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