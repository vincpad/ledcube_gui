import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import processing.opengl.*; 
import controlP5.*; 
import java.io.*; 
import ddf.minim.analysis.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ledcube_gui extends PApplet {

// Led cube GUI, by cybervinc
// Still in creation, and not fully commented
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//




 

Hud myHud;

public void setup() {
	size(1200, 800, OPENGL);
	myAnimFile = new AnimFile();
	myCube = new LedCube(cubeSize, this);
	mySerial = new SerialComm();
	myHud = new Hud(this);

	frameRate(30);
		
	//drawHud();
	initSnake();
	createSnake();
	//fftVisualizerSetup();	// uncomment to enable audio visualizer
}

public void draw() {
	//fftVisualizer();	// uncomment to enable audio visualizer
  	snake();
	myCube.refresh();
  	playAnimation();
  	myHud.refreshDisplayedText();
}
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
// Class to display and manage the HUD
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

class Hud extends PGraphics{
	PApplet applet;
	PGraphics disp;

	ControlP5 cp5;
	ListBox comPorts, framelist;
	Button loadfile, disconnectb, loadframe, insertbefore, newframeattheend, deleteframe, eraseframe, playbutton, stopbutton, updateports, snakemode;
	Numberbox animationspeed;

	public Hud(PApplet applet_) {	// initialize the HUD
		applet = applet_;
		disp = applet_.g;
		cp5 = new ControlP5(applet);
		comPorts = cp5.addListBox("serialPorts")
                 .setPosition(1080, 50)
                 .setSize(120, 100)
                 .setItemHeight(15)
                 .setBarHeight(15)
                 .setColorBackground(color(255, 128))
                 .setColorActive(color(0))
                 .setColorForeground(color(255, 100,0))
                 ;
        comPorts.captionLabel().toUpperCase(true);
        comPorts.captionLabel().set("Serial ports :");
        comPorts.captionLabel().setColor(0xffff0000);
        comPorts.captionLabel().style().marginTop = 3;
        comPorts.valueLabel().style().marginTop = 3;
        updateComPortsList();
    
        framelist = cp5.addListBox("frameList")
                     .setPosition(1080, 270)
                     .setSize(120, 300)
                     .setItemHeight(15)
                     .setBarHeight(15)
                     .setColorBackground(color(255, 128))
                     .setColorActive(color(0))
                     .setColorForeground(color(255, 100,0))
                     ;
        framelist.captionLabel().toUpperCase(true);
        framelist.captionLabel().set("Frames list :");
        framelist.captionLabel().setColor(0xffff0000);
        framelist.captionLabel().style().marginTop = 3;
        framelist.valueLabel().style().marginTop = 3;
        updateFrameList();
    
        // Buttons
        updateports = cp5.addButton("updatePorts")
                             .setPosition(1080, 150)
                             .setSize(120, 20)
                             .setColorForeground(color(255, 100,0))
                             ;
        updateports.setLabel("Update ports");
    
        loadfile = cp5.addButton("loadFile")
                             .setPosition(1080, 220)
                             .setSize(120, 20)
                             .setColorForeground(color(255, 100,0))
                             ;
        loadfile.setLabel("Load file");
    
        disconnectb = cp5.addButton("disconnect")
                                .setPosition(1080, 170)
                                .setSize(120, 20)
                                .setColorForeground(color(255, 100,0))
                                ;
        disconnectb.setLabel("Disconnect");
        updateDisconnectButton();
    
        loadframe = cp5.addButton("loadFrame")
                                 .setPosition(1080, 570)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        loadframe.setLabel("Load frame (L)");
    
        insertbefore = cp5.addButton("insertBefore")
                                 .setPosition(1080, 590)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        insertbefore.setLabel("Insert frame before (I)");
    
        newframeattheend = cp5.addButton("newFrameAtTheEnd")
                                 .setPosition(1080, 610)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        newframeattheend.setLabel("New frame at the end (N)");
    
        deleteframe = cp5.addButton("deleteFrame")
                                 .setPosition(1080, 630)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        deleteframe.setLabel("Delete frame (D)");
    
        eraseframe = cp5.addButton("eraseFrame")
                                 .setPosition(1080, 650)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        eraseframe.setLabel("Erase frame (E)");
    
        animationspeed = cp5.addNumberbox("animationSpeed")
                            .setPosition(1080,700)
                            .setSize(120,20)
                            .setRange(0,2000)
                            .setMultiplier(10)
                            .setScrollSensitivity(1.1f)
                            .setValue(200)
                            ;
        animationspeed.setLabel("Time between 2 frames");
    
        playbutton = cp5.addButton("playButton")
                                 .setPosition(1080, 740)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        playbutton.setLabel("Play (P)");
    
        stopbutton = cp5.addButton("stopButton")
                                 .setPosition(1080, 760)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        stopbutton.setLabel("Stop (S)");
    
        snakemode = cp5.addButton("snakeMode")
                                 .setPosition(500, 50)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        snakemode.setLabel("Snake mode");
	}
	
	// Function for updating the com ports list list after a serial connection/disconnection, also triggered by the "Update list" button
	public void updateComPortsList() {
	    comPorts.clear();
	    for (int i=0;i<Serial.list().length;i++) {
	        ListBoxItem port = comPorts.addItem(Serial.list()[i], i);
	        if(Serial.list()[i].equals(mySerial.getPortName())) {
	            port.setColorBackground(0xff00ff00);
	        }
	        else {
	            port.setColorBackground(0xffff0000);
	        }
	    }
	}

	// Function for updating the frame list after a frame removal or creation
  	public void updateFrameList() {
      	framelist.clear();
      	delay(100);
      	for (int i=0;i<myAnimFile.numberOfLines();i++) {
          	String item = "Frame " + String.valueOf(i+1);
          	ListBoxItem frame = framelist.addItem(item, i);
          	frame.setColorBackground(0xffff0000);
      	}
  	}
	

	// Set the "Disconnect button" invisible if no port selected
	public void updateDisconnectButton() {
	    if(mySerial.available()) {
	        disconnectb.setVisible(true);
	    }
	    else {
	        disconnectb.setVisible(false);
	    } 
	}

	

	public void refreshDisplayedText() {
	    displayedFrameLabel = "";
	    if(myAnimFile.fileName != null) {
	        displayedFrameLabel = "File :" + myAnimFile.fileName;
	    }
	    else {
	        displayedFrameLabel = "No file selected";
	        displayedFrameN = -1;
	    }
	    if(displayedFrameN != -1) {
	        displayedFrameLabel = displayedFrameLabel + "   -    Frame " + String.valueOf(displayedFrameN + 1);
	    }
	    if(snakeEnabled == true) {
	        displayedFrameLabel = "Playing snake !";
	    }
	    PFont f = createFont("Georgia", 24);
      	disp.textFont(f);
	    disp.textSize(10);
	    disp.fill(255);
	    disp.text(displayedFrameLabel, 20, 20);
	}

	public void updatePorts() {
	    updateComPortsList();
	}
}
// HUD management
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//
/*
    void drawHud() {
        comPorts = cp5.addListBox("serialPorts")
                 .setPosition(1080, 50)
                 .setSize(120, 100)
                 .setItemHeight(15)
                 .setBarHeight(15)
                 .setColorBackground(color(255, 128))
                 .setColorActive(color(0))
                 .setColorForeground(color(255, 100,0))
                 ;
        comPorts.captionLabel().toUpperCase(true);
        comPorts.captionLabel().set("Serial ports :");
        comPorts.captionLabel().setColor(0xffff0000);
        comPorts.captionLabel().style().marginTop = 3;
        comPorts.valueLabel().style().marginTop = 3;
        updateComPortsList();
    
        framelist = cp5.addListBox("frameList")
                     .setPosition(1080, 270)
                     .setSize(120, 300)
                     .setItemHeight(15)
                     .setBarHeight(15)
                     .setColorBackground(color(255, 128))
                     .setColorActive(color(0))
                     .setColorForeground(color(255, 100,0))
                     ;
        framelist.captionLabel().toUpperCase(true);
        framelist.captionLabel().set("Frames list :");
        framelist.captionLabel().setColor(0xffff0000);
        framelist.captionLabel().style().marginTop = 3;
        framelist.valueLabel().style().marginTop = 3;
        updateFrameList();
    
        // Buttons
        updateports = cp5.addButton("updatePorts")
                             .setPosition(1080, 150)
                             .setSize(120, 20)
                             .setColorForeground(color(255, 100,0))
                             ;
        updateports.setLabel("Update ports");
    
        loadfile = cp5.addButton("loadFile")
                             .setPosition(1080, 220)
                             .setSize(120, 20)
                             .setColorForeground(color(255, 100,0))
                             ;
        loadfile.setLabel("Load file");
    
        disconnectb = cp5.addButton("disconnect")
                                .setPosition(1080, 170)
                                .setSize(120, 20)
                                .setColorForeground(color(255, 100,0))
                                ;
        disconnectb.setLabel("Disconnect");
        updateDisconnectButton();
    
        loadframe = cp5.addButton("loadFrame")
                                 .setPosition(1080, 570)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        loadframe.setLabel("Load frame (L)");
    
        insertbefore = cp5.addButton("insertBefore")
                                 .setPosition(1080, 590)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        insertbefore.setLabel("Insert frame before (I)");
    
        newframeattheend = cp5.addButton("newFrameAtTheEnd")
                                 .setPosition(1080, 610)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        newframeattheend.setLabel("New frame at the end (N)");
    
        deleteframe = cp5.addButton("deleteFrame")
                                 .setPosition(1080, 630)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        deleteframe.setLabel("Delete frame (D)");
    
        eraseframe = cp5.addButton("eraseFrame")
                                 .setPosition(1080, 650)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        eraseframe.setLabel("Erase frame (E)");
    
        animationspeed = cp5.addNumberbox("animationSpeed")
                            .setPosition(1080,700)
                            .setSize(120,20)
                            .setRange(0,2000)
                            .setMultiplier(10)
                            .setScrollSensitivity(1.1)
                            .setValue(200)
                            ;
        animationspeed.setLabel("Time between 2 frames");
    
        playbutton = cp5.addButton("playButton")
                                 .setPosition(1080, 740)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        playbutton.setLabel("Play (P)");
    
        stopbutton = cp5.addButton("stopButton")
                                 .setPosition(1080, 760)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        stopbutton.setLabel("Stop (S)");
    
        snakemode = cp5.addButton("snakeMode")
                                 .setPosition(500, 50)
                                 .setSize(120, 20)
                                 .setColorForeground(color(255, 100,0))
                                 ;
        snakemode.setLabel("Snake mode");
    }
public void snakeMode() {
    if(snakeEnabled == false) {
        snakemode.setLabel("Frame edit mode");
        snakeEnabled = true;
    }
    else if(snakeEnabled == true) {
        snakeEnabled = false;
        snakemode.setLabel("Snake mode");
    }
}
    // Function triggered by the "disconnect" button
public void disconnect() {
    mySerial.disconnect();
    println("Disconnected from "+ mySerial.getPortName());
    updateComPortsList();
    updateDisconnectButton();
}

// Function triggered by the "load file" button
public void loadFile() {
    selectInput("Select an animation file or an empty one", "fileSelected");
}

// Function triggered by the loadFile function
public void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or you hit cancel.");
  } else {
    println("You selected " + selection.getAbsolutePath());
    myAnimFile.load(selection.getAbsolutePath());
    selectedFrameN = -1; 
    displayedFrameN = -1;
    updateFrameList();
  }
}

// Function triggered by the "New frame at the end" button
public void newFrameAtTheEnd() {
    myAnimFile.writeLineB(generateArray());
    updateFrameList();
    myAnimFile.write();
}

// Function for updating the frame list after a frame removal or creation
public void updateFrameList() {
    framelist.clear();
    delay(100);
    for (int i=0;i<myAnimFile.numberOfLines();i++) {
        String item = "Frame " + String.valueOf(i+1);
        ListBoxItem frame = framelist.addItem(item, i);
        frame.setColorBackground(0xffff0000);
    }
}

// Function for updating the com ports list list after a serial connection/disconnection, also triggered by the "Update list" button
public void updateComPortsList() {
    comPorts.clear();
    for (int i=0;i<Serial.list().length;i++) {
        ListBoxItem port = comPorts.addItem(Serial.list()[i], i);
        if(Serial.list()[i].equals(mySerial.getPortName())) {
            port.setColorBackground(0xff00ff00);
        }
        else {
            port.setColorBackground(0xffff0000);
        }
    }
}

// Function for displaying a frame by reading the selected frame line in the animation file, also triggered by the "Load frame" button
public void loadFrame() {
    readArray(myAnimFile.readLineB(selectedFrameN));
    if(mySerial.available()) {
        mySerial.sendFrames();
    }
    displayedFrameN = selectedFrameN;
}
// Triggered by the "Load frame" button
public void insertBefore() {
    myAnimFile.insertLine(selectedFrameN);
    myAnimFile.writeLineB(selectedFrameN, new boolean[int(pow(myCube.getSize(), 3))]);  // Fill the frame with a blank boolean array
    updateFrameList();
    myAnimFile.write();
}
public void deleteFrame() {
    myAnimFile.removeLine(selectedFrameN);
    updateFrameList();
    myAnimFile.write();
}
public void eraseFrame() {
    myAnimFile.writeLineB(selectedFrameN, generateArray());
    updateFrameList();
    myAnimFile.write();
}

// Set the "Disconnect button" invisible if no port selected
public void updateDisconnectButton() {
    if(mySerial.available()) {
        disconnectb.setVisible(true);
    }
    else {
        disconnectb.setVisible(false);
    } 
}

public void animationSpeed(int spd) {
    animationTime = spd;
}

public void playButton() {
    if(playing == false) {
        playing = true;
        playbutton.setLabel("Pause (P)");
    }
    else if(playing == true) {
        playing = false;
        playbutton.setLabel("Play (P)");
    }
}
public void stopButton() {
    playing = false;
    animCounter = 0;
    playbutton.setLabel("Play (P)");
}
public void refreshDisplayedText() {
    displayedFrameLabel = "";
    if(myAnimFile.fileName != null) {
        displayedFrameLabel = "File :" + myAnimFile.fileName;
    }
    else {
        displayedFrameLabel = "No file selected";
        displayedFrameN = -1;
    }

    if(displayedFrameN != -1) {
        displayedFrameLabel = displayedFrameLabel + "   -    Frame " + String.valueOf(displayedFrameN + 1);
    }

    if(snakeEnabled == true) {
        displayedFrameLabel = "Playing snake !";
    }
    textSize(10);
    fill(255);
    text(displayedFrameLabel, 20, 20);

}

public void updatePorts() {
    updateComPortsList();
}*/
// Class to manage the 3D-displayed leds and the real ones
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

class Led {
 
  // variables
  int id;                 // id
  int ledX, ledY, ledZ;   // correspondence with the cube leds
  int x3d, y3d, z3d, w3d; // position in the cube drawn (x, y, z) and width (w)
  
  // constructor
  public Led(int id, int x3d, int y3d, int z3d, int w3d, int ledX, int ledY, int ledZ) {
    this.id = id;
    this.x3d = x3d; this.y3d = y3d; this.z3d = z3d; this.w3d = w3d;
    this.ledX = ledX; this.ledY = ledY; this.ledZ = ledZ;

  }
  public void toggleState() {
    if(myCube.led_value[ledX][ledY][ledZ] == false) {
      forceState(true);
    }
    else {
      forceState(false);
    }  
  }
  public void forceState(boolean state) {
    myCube.led_value[ledX][ledY][ledZ] = state;
  }

  // display the cube on screen
  public void display(PGraphics scrn) {
    if(myCube.led_value[ledX][ledY][ledZ] == false) {
      scrn.fill(color(255));
    }
    if(myCube.led_value[ledX][ledY][ledZ] == true) {
      scrn.fill(color(0,0,255));
    }
    draw(scrn);
  }
 
  // draw the cube in the buffer
  public void drawInBuffer(PGraphics buffer) {
    int idColor = myCube.getColor(id);
    buffer.fill(idColor);
    draw(buffer);
  }
 
  private void draw(PGraphics g) {
    g.pushMatrix();
      g.translate(x3d, y3d, z3d);
      g.sphere(w3d);
    g.popMatrix();
  } 
  public boolean getState() {
    return myCube.led_value[ledX][ledY][ledZ];
  }
}
// Class to display and manage leds of the cube
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

class LedCube extends PGraphics{
	int dim;

  //  Camera settings
  int zX = -60, zY = -60, zZ = 150;
  float zoomValue=1, rotx = PI/4, roty = PI/4;

  PGraphics disp;
  PApplet applet;
  PGraphics buffer; // Graphical buffer to do color-based 3D picking

  Led[] leds; // Leds making the 3D cube
  boolean[][][] led_value;  // 3 dimensional array to store all leds state

	public LedCube(int dim_, PApplet applet_) {	// creating the Led objects to draw the cube
		dim = dim_;
    disp = applet_.g;
    applet = applet_;
    led_value = new boolean[dim][dim][dim]; 
		leds = new Led[dim*dim*dim];
    disp.sphereDetail(10);
		int id = 0;
  		for (int i = 0; i < dim; ++i) {
  		  for (int j = 0; j < dim; ++j) {
  		    for (int k = 0; k < dim; ++k) {
  		      leds[id] = new Led(id, -dim*5+5+10*i, -dim*5+5+10*j, -dim*5+5+10*k, 2, i, j, k);
  		      id++;
  		    }
  		  } 
  		}
  		led_value = new boolean[dim][dim][dim];

      buffer = createGraphics(applet.width, applet.height, P3D);
	}
	public void refresh() {  // refresh the cube display
		disp.pushMatrix();
    	disp.camera(zX, zY, zZ, 0, 0, 0, 0, 1, 0);
    	disp.lights();
    	disp.background(100);
    	disp.rotateY(roty);
    	disp.rotateX(rotx);
    	disp.scale(zoomValue);
    	drawaxes();
    	for (int i = 0; i < leds.length; i++) {
    	  leds[i].display(disp);
    	}
    	disp.popMatrix();
	} 
	public void clear() {  // setting off all leds
		for (int i = 0; i < dim; ++i) {
    		for (int j = 0; j < dim; ++j) {
      			for (int k = 0; k < dim; ++k) {
        			led_value[i][j][k] = false;
      			}
    		}
  		}
	}
	private  void drawaxes(){  // drawing the X,Y,Z axis
    	int val = -dim*5+5;
      PFont f = createFont("Georgia", 24);
      disp.textFont(f);
    	disp.textSize(10);
    	disp.stroke(255,0,0);
    	disp.fill(255);
    	disp.line(val, val, val, -val+10, val, val);
    	disp.line(val, val, val, val, -val+10, val);
    	disp.line(-val+10,val,val,-val+5,val,val-2);
    	disp.line(-val+10,val,val,-val+5,val,val+2);
    	disp.line(val,-val+10,val,val,-val+5,val-2);
    	disp.line(val,-val+10,val,val,-val+5,val+2);
    	disp.text("Y",-val+15,val,val);
    	disp.text("X",val,-val+15,val);
    	disp.stroke(0,255,0);
    	disp.line(val, val, val, val, val, -val+10);
    	disp.line(val,val,-val+10,val-2,val,-val+5);
    	disp.line(val,val,-val+10,val+2,val,-val+5);
    	disp.text("Z",val,val,-val+15);
    	disp.noStroke();
	}
	public int getSize() { // return the cube size
		return dim;
	}
  public void drawInBuffer() {  
    // Draw the scene in the buffer to do color-based 3D picking
    buffer.beginDraw();
    buffer.background(getColor(-1)); // since background is not an object, its id is -1
    buffer.noStroke();
    buffer.camera(zX, zY, zZ, 0, 0, 0, 0, 1, 0);  // Create camera in the buffer, with the same settings as GUI
    buffer.rotateY(roty);
    buffer.rotateX(rotx);
    buffer.scale(zoomValue);
    for (int i = 0; i < leds.length; i++) {
      leds[i].drawInBuffer(buffer);
    }
    buffer.endDraw();
  }
  public void do3dPicking() {
    // Get the pixel color under the mouse
    int pick = buffer.get(applet.mouseX, applet.mouseY);
    // Get object id
    int id = getId(pick);
    if (id >= 0) {
      // change the cube color
      leds[id].toggleState();
      if(mySerial.available()) {
        mySerial.sendFrames();
      }
    } 
  }
  public void setLed(int x, int y, int z, boolean state) {
    led_value[x][y][z] = state;
  }
  public boolean getLedState(int x, int y, int z) {
    return led_value[x][y][z];
  }
  public int getId(int c) {
    return -(c + 2);
  }
  public int getColor(int id) {
    return -(id + 2);
  }
  public void zoom(float value) {
    zoomValue=zoomValue+0.04f*value;
  }
  public void applyRot() {
    rotx += (applet.pmouseY-applet.mouseY) * 0.01f;
    roty += -(applet.pmouseX-applet.mouseX) * 0.01f;
  }
}
// Class to manage the communication with the cube
// Frames are sended to the cube with 64 bytes, each byte represents a column, with one bit for each pixel of this column

class SerialComm extends PApplet{
  public Serial currentPort;
  public String portName;
  private boolean connected = false;  // Connection state
  private int[] sendBuffer = new int[64];

  public void SerialComm() {
  }
  public void connect(String port) {
    if(connected == true) {
      disconnect();
    }
    currentPort = new Serial(this, port, 115200);
    connected = true;
    portName = port;
    println("Waiting 2 seconds for the cube initialisation ...");
    delay(2000);
    sendFrames();
  }
  public void disconnect() {
    if(connected == true) {
      currentPort.stop();
      connected = false;
    }
    portName = null;
  }
  public void sendFrames() {
    int n = 0;
    for(int i=0;i<myCube.getSize();i++){
      for(int j=0;j<myCube.getSize();j++){
        int toSend = 0;
        for(int k=0;k<myCube.getSize();k++){
          toSend = bitWrite(toSend, k, myCube.getLedState(j,i,k));
        }
        sendBuffer[n] = toSend;
        n++;
      }
    }
    for (int i = 0; i <= 63; ++i) {
      currentPort.write(toSignedByte(sendBuffer[i]));
    }
    /*for (int m = 0; m <= 63; ++m) {   // uncomment to see what is sent
      print(sendBuffer[m]);
      print(", ");
    }
    println(""); */
  }
  public boolean available() {
    return connected;
  }
  public String getPortName() {
    return portName;
  }
}
// All that is triggered by events is here
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

public void mouseClicked() {
  // Draw the scene in the buffer to do color-based 3D picking
  myCube.drawInBuffer();
  myCube.do3dPicking();
}
// Triggered when mouse wheel is used
public void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  myCube.zoom(e); // Update scene size values (zoom)
} 
// Triggered when mouse is dragged
public void mouseDragged() {
  if(mouseX<1080) { // Not in the HUD zone (to avoid cube rotation when slide the frames list for example)
      myCube.applyRot();
  }
}
// Triggered when clicking on a list object
public void controlEvent(ControlEvent theEvent) {
  if(theEvent.isGroup()){
    // if the event happen in the serial ports list
    if(theEvent.name().equals("serialPorts")) {
  
      int serialPortN = (int)theEvent.group().value();  // get the serial port number in the list
  
      if(previousSerialPortN >= 0){
        ListBoxItem previousPort = myHud.comPorts.getItem(previousSerialPortN); //  get the previous item
        previousPort.setColorBackground(0xffff0000);  //  and restore its original background colors
      }
      previousSerialPortN = serialPortN;  //  update the selected index
      myHud.comPorts.getItem(serialPortN).setColorBackground(color(100, 128));  //  and set the background color to be the active/'selected one'
      String serialPort = Serial.list()[serialPortN];  // get the serial port name
      mySerial.connect(serialPort); // connect to this port
      myHud.updateComPortsList(); // update the ports list
      myHud.updateDisconnectButton(); // update the disconnect button
      println("Connected to " + mySerial.getPortName());
    }
    // if the event happen in the frames list
    if(theEvent.name().equals("frameList")) {
      int frameN = (int)theEvent.group().value();
  
      if(previousFrameN >= 0 && previousFrameN < myAnimFile.numberOfLines()) {
        ListBoxItem oldframe = myHud.framelist.getItem(previousFrameN); //  get the previous item
        oldframe.setColorBackground(0xffff0000);  //  and restore its original background colors
      }
      previousFrameN = frameN;  //  update the selected index
      myHud.framelist.getItem(frameN).setColorBackground(color(100, 128));//  and set the bg colour to be the active/'selected one'
      selectedFrameN = frameN;  // set the global variable "selectedFrameN"
      println("Frame selected: " + frameN);
    }
  }
}
// triggered if any key is pressed
public void keyPressed() {
  if(actionDone == false) {
    // same actions as the HUD buttons
    if (key == 'l' || key == 'L') {
      loadFrame();
    }
    else if (key == 'i' || key == 'I') {
      insertBefore();
    }
    else if (key == 'n' || key == 'N') {
      newFrameAtTheEnd();
    }
    else if (key == 'd' || key == 'D') {
      deleteFrame();
    }
    else if (key == 'e' || key == 'E') {
      eraseFrame();
    }
    else if (key == 's' || key == 'P') {
      playButton();
    }
    else if (key == 's' || key == 'S') {
      stopButton();
    }

    // used by the snake game
    if (keyCode == DOWN) {
          nextDirection = 1;
        }
    else if (keyCode == RIGHT) {
      nextDirection = 5;
    }
    else if (keyCode == UP) {
      nextDirection = 4;
    }
    else if (keyCode == LEFT) {
      nextDirection = 2;
    }
    else if (keyCode == CONTROL) {
      nextDirection = 3;
    }
    else if (keyCode == SHIFT) {
      nextDirection = 0;
    }
    else if (key == ' ') {
      gameover = false;
    }
    actionDone = true;
  }
}
// triggered when any key is released
public void keyReleased() {
    actionDone2 = false;
    actionDone = false;
}
// Audio visualizer for the led cube
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

int[] value = new int[66];




Minim minim;
AudioPlayer jingle;
//AudioInput jingle;
FFT fft;
boolean fileselected = false;
public void fftVisualizerSetup() {
  minim = new Minim(this);
  selectInput("Select an audio file:", "fileSelected2");
}

public void fileSelected2(File selection) {
  String audioFileName = selection.getAbsolutePath();
  jingle = minim.loadFile(audioFileName, 2048); //minim.getLineIn(Minim.STEREO, 2048); // 
  jingle.loop();

  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
  // calculate averages based on a miminum octave width of 22 Hz
  // split each octave into 8 bands
  fft.logAverages(22,8);
  fileselected = true;
}
public void fftVisualizer() {
  if(fileselected == true) {
    fft.forward(jingle.mix);
    myCube.clear();
    int n = 0;
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {

        int val=PApplet.parseInt(fft.getAvg(n)/8);
        if(fft.getAvg(n)/8>8) {
          val = 8;
        }
        value[n] = val;
        for(int k = 1; k <= value[n]; k++) {
          boolean state = true;
          if(value[n] == 0) {
            state = false;
          }
          myCube.setLed(i,j,k-1,state);
        }
        n++;
      }
    }   
    if(mySerial.available()) {
      mySerial.sendFrames();
    }
  }
}
// Many functions, needs some triage
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

public byte toSignedByte(int value) { // Convert unsigned values (0-255) to java signed bytes
    if(value < 128) {
      return (byte)value;
    } 
    else {
      return PApplet.parseByte(value - 256);
    }
}
public int bitWrite(int b, int p, boolean v) {  //Write a specific bit in a variable
  int r = 0;
  if(v == true) {
    r = (1 << p) | b;
  }
  if(v == false) {
    r = (~(1 << p)) & b;
  }
  return r;
}
public boolean[] generateArray() {
  boolean[] a = new boolean[PApplet.parseInt(pow(myCube.getSize(), 3))];
  int n = 0;
  for (int i = 0; i < myCube.getSize(); ++i) {
    for (int j = 0; j < myCube.getSize(); ++j) {
      for (int k = 0; k < myCube.getSize(); ++k) {
        a[n] = myCube.getLedState(i,j,k);
        n++;
      }
    } 
  }
  return a;
}
public void readArray(boolean[] array) {
  int n = 0;
  for (int i = 0; i < myCube.getSize(); ++i) {
    for (int j = 0; j < myCube.getSize(); ++j) {
      for (int k = 0; k < myCube.getSize(); ++k) {
        myCube.setLed(i,j,k,array [n]);
        n++;
      }
    } 
  }
} /*
void readCurrentState() {
  for (int i = 0; i < dim; ++i) {
    for (int j = 0; j < dim; ++j) {
      for (int k = 0; k < dim; ++k) {
        leds[fromLedToId(i,j,k)].forceState(led_value[i][j][k]);
      }
    }
  }
} */
public void setLed(int x, int y, int z, boolean state) {
  
  myCube.setLed(x,y,z,state);
}
public void playAnimation() {
  if(playing == true) {
    if(animCounter>=myAnimFile.numberOfLines()) {
      animCounter=0;
    }
    if(millis() - now >= animationTime){
      selectedFrameN = animCounter;
      myHud.updateFrameList();
      loadFrame();
      animCounter++;
      now = millis();
    }
  }
}

// Function triggered by the "snake mode" or the "frame edit mode" button
  public void snakeMode() {
      if(snakeEnabled == false) {
          myHud.snakemode.setLabel("Frame edit mode");
          snakeEnabled = true;
      }
      else if(snakeEnabled == true) {
          snakeEnabled = false;
          myHud.snakemode.setLabel("Snake mode");
      }
  }
      // Function triggered by the "disconnect" button
  public void disconnect() {
      mySerial.disconnect();
      println("Disconnected from "+ mySerial.getPortName());
      myHud.updateComPortsList();
      myHud.updateDisconnectButton();
  }
  
  // Function triggered by the "load file" button
  public void loadFile() {
      selectInput("Select an animation file or an empty one", "fileSelected");
  }
  
  // Function triggered by the loadFile function
  public void fileSelected(File selection) {
    if (selection == null) {
      println("Window was closed or you hit cancel.");
    } else {
      println("You selected " + selection.getAbsolutePath());
      myAnimFile.load(selection.getAbsolutePath());
      selectedFrameN = -1; 
      displayedFrameN = -1;
      myHud.updateFrameList();
    }
  }
  
  // Function triggered by the "New frame at the end" button
  public void newFrameAtTheEnd() {
      myAnimFile.writeLineB(generateArray());
      myHud.updateFrameList();
      myAnimFile.write();
  }

  // Function for displaying a frame by reading the selected frame line in the animation file, also triggered by the "Load frame" button
  public void loadFrame() {
      readArray(myAnimFile.readLineB(selectedFrameN));
      if(mySerial.available()) {
          mySerial.sendFrames();
      }
      displayedFrameN = selectedFrameN;
  }

  // Triggered by the "Load frame" button
  public void insertBefore() {
      myAnimFile.insertLine(selectedFrameN);
      myAnimFile.writeLineB(selectedFrameN, new boolean[PApplet.parseInt(pow(myCube.getSize(), 3))]);  // Fill the frame with a blank boolean array
      myHud.updateFrameList();
      myAnimFile.write();
  }

  public void deleteFrame() {
      myAnimFile.removeLine(selectedFrameN);
      myHud.updateFrameList();
      myAnimFile.write();
  }

  public void eraseFrame() {
      myAnimFile.writeLineB(selectedFrameN, generateArray());
      myHud.updateFrameList();
      myAnimFile.write();
  }

  public void animationSpeed(int spd) {
      animationTime = spd;
  }

  public void playButton() {
      if(playing == false) {
          playing = true;
          myHud.playbutton.setLabel("Pause (P)");
      }
      else if(playing == true) {
          playing = false;
          myHud.playbutton.setLabel("Play (P)");
      }
  }

  public void stopButton() {
      playing = false;
      animCounter = 0;
      myHud.playbutton.setLabel("Play (P)");
  }
//SNAKE 3D
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

SnakePixel[] spixel = new SnakePixel[512];
boolean created = false;
int foodPosx=-1, foodPosy=-1, foodPosz=-1;
int nextDirection;
boolean gameover = false;
int foodCounter = 0;
boolean snakeEnabled = false;

public void snake() {
	if(snakeEnabled == true ) {
		if(millis() - now >= animationTime){  // Do this only every <animationTime> ms (number box in the GUI)
			keyboardManagement();
			if(gameover == false) {		// If the snake is always alive
				moveSnake();
				checkCollisions();
				myCube.clear();
				refreshSnake();
				if(foodCounter >= 10) {  // If no food during 10 movements, generate food
					generateFood();
					foodCounter = 0;
				}
				if(foodExists() == false) {
					foodCounter++;
				}
				now = millis();
			}	
		}
	}
}
public void checkCollisions() {
int i=1;
	if(spixel[0].posx == foodPosx && spixel[0].posy == foodPosy && spixel[0].posz == foodPosz) {  // Collision with food
		lengthenSnake();
		removeFood();
	}
	while(spixel[i].checkExistence()) {  // Collision with its body
		if(spixel[0].posx == spixel[i].posx && spixel[0].posy == spixel[i].posy && spixel[0].posz == spixel[i].posz) {
			gameOver();
		}
		i++;
	}
}
public void resetSnake() {
	initSnake();
	createSnake();
}
public void keyboardManagement() {
	if(nextDirection != -1) {
		setSnakeDirection(nextDirection);
		nextDirection = -1;
	}
}
public void gameOver() {
	println("game over");
	println("Press space to continue ...");
	resetSnake();
	gameover = true;
}
public void generateFood() {
	foodPosx = PApplet.parseInt(random(0, myCube.getSize()));
	foodPosy = PApplet.parseInt(random(0, myCube.getSize()));
	foodPosz = PApplet.parseInt(random(0, myCube.getSize()));
}
public void removeFood() {
	foodPosx = -1;
	foodPosy = -1;
	foodPosz = -1;
}
public boolean foodExists() {
	if(foodPosx != -1 && foodPosy != -1 && foodPosz != -1) {
		return true;
	}
	else return false;
}
public void displayFood() {
	if(foodExists()) {
		myCube.setLed(foodPosx, foodPosy, foodPosz, true);
	}
}
public void lengthenSnake() {
int i=0,dir=0;
while(spixel[i].checkExistence()) { // Look for the snake's tail
		i++;
	}
	if(spixel[i-1].checkIfTurning()) {
		dir = spixel[i-1].prevDirection;
	}
	else {
		dir = spixel[i-1].direction;
	}
	spixel[i].enable(spixel[i-1].prevPosx, spixel[i-1].prevPosy, spixel[i-1].prevPosz, dir);
}
public void refreshSnake() {
	int i=0;
	while(spixel[i].checkExistence()) {
		spixel[i].write();
		i++;
	}
	displayFood();
	if(mySerial.available()) {
		mySerial.sendFrames();
	}
}
public void moveSnake() {
	for(int i=PApplet.parseInt(pow(myCube.getSize(), 3))-1;i>=0;i--) {
		if(spixel[i].checkExistence() == true){
			spixel[i].move();
		}
	}
}
public void initSnake() {
	for(int i = 0; i<pow(myCube.getSize(),3); i++) {
		spixel[i] = new SnakePixel(i);
	}
}
public void createSnake() {
	spixel[0].enable(PApplet.parseInt(random(0,myCube.getSize())), PApplet.parseInt(random(0,myCube.getSize())), PApplet.parseInt(random(0,myCube.getSize())), PApplet.parseInt(random(0,5)));
}
public void setSnakeDirection(int direction_) {
	if(spixel[0].direction + 3 == direction_ || spixel[0].direction == direction_ + 3) {// Check if the direction change is possible (ex : up to down is impossible)
	}
	else {
		spixel[0].setDirection(direction_);
	}
}
class SnakePixel {
	public int prevPosx, prevPosy, prevPosz;
	public int posx, posy, posz;
	public int id;
	public int direction;
	public int prevDirection;
	public boolean exists;
	public boolean turning;
	
	public SnakePixel(int id_) {
		id = id_;
		turning = false;
	}
	public void enable(int x, int y, int z, int direction_) {
		posx = x;
		prevPosx = posx;
		posy = y;
		prevPosy = posy;
		posz = z;
		prevPosz = posz;
		direction = direction_;
		exists = true;
	}
	public void move() {
		if(exists = true) {
			prevPosx = posx;
			prevPosy = posy;
			prevPosz = posz;
			switch (direction) {
				case 0 :	// up (+z)
					if(posz < myCube.getSize()-1) { posz++; }
					else { posz = 0; }
				break;
				case 1 :	// right (+y)
					if(posy < myCube.getSize()-1) { posy++; }
					else { posy = 0; }
				break;
				case 2 :	// forward (-x)
					if(posx > 0) { posx--; }
					else { posx = myCube.getSize()-1; }
				break;
				case 3 :	// down (-z)
					if(posz > 0) { posz--; }
					else { posz = myCube.getSize()-1; }
				break;
				case 4 :	// left (-y)
					if(posy > 0) { posy--; }
					else { posy = myCube.getSize()-1; }
				break;
				case 5 :	// backward (+x)
					if(posx < myCube.getSize()-1) { posx++; }
					else { posx = 0; }
				break;
			}
			if(turning == true) {
				propagateDirection();
			}
		}
	}
	public void setDirection(int direction_) {
		prevDirection = direction;
		direction = direction_;
		turning = true;
	}
	private void propagateDirection() {
		if(spixel[id+1].checkExistence() == true) {
			spixel[this.id+1].setDirection(direction);
		}
		turning = false;
	}
	public void write() {
		setLed(posx,posy,posz,true);
	}
	public boolean checkExistence() {
		return exists;
	}
	public boolean checkIfTurning() {
		return turning;
	}
	public int getPrevDirection	() {
		return prevDirection;
	}
}
// Global variables used by several functions
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

boolean playing;	// True if animation is playing
int animationTime;	// Time between 2 frames
int now;	//	Time variable for counters
int animCounter = 0;	// Used for the animation management
String displayedFrameLabel = "No frame selected";	// Label bisplayed on the up-left corner
int previousSerialPortN, previousFrameN, selectedFrameN = -1, displayedFrameN = -1; // Numbers ...
boolean actionDone, actionDone2;	// No comment

//	HUD objects
/*ControlP5 cp5;	// Object to manage HUD
ListBox comPorts, framelist;
Button loadfile, disconnectb, loadframe, insertbefore, newframeattheend, deleteframe, eraseframe, playbutton, stopbutton, updateports, snakemode;
Numberbox animationspeed;


*/




static int cubeSize = 8; // cube dimension
AnimFile myAnimFile;	// Object to manage animation file
LedCube myCube;
SerialComm mySerial;	// Object to manage the connection with the cube
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ledcube_gui" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
