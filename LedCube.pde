// Class to display and manage leds of the cube
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

class LedCube extends PGraphics{
	int dim;
  Led[] leds; // Leds making the 3D cube
  boolean[][][] led_value;  // 3 dimensional array to store all leds state
  //  Camera settings
  int zX = -60, zY = -60, zZ = 150;
  float zoomValue=1, rotx = PI/4, roty = PI/4;

  PGraphics disp;
  PApplet applet;
  PGraphics buffer; // Graphical buffer to do color-based 3D picking
  PFont f;
  

	public LedCube(int dim_, PApplet applet_) {	// creating the Led objects to draw the cube
		dim = dim_;
    disp = applet_.g;
    applet = applet_;
    led_value = new boolean[dim][dim][dim]; 
		leds = new Led[dim*dim*dim];
    f = createFont("Georgia", 24);
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
    color pick = buffer.get(applet.mouseX, applet.mouseY);
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
  public int getId(color c) {
    return -(c + 2);
  }
  public color getColor(int id) {
    return -(id + 2);
  }
  public void zoom(float value) {
    zoomValue=zoomValue+0.04*value;
  }
  public void applyRot() {
    rotx += (applet.pmouseY-applet.mouseY) * 0.01;
    roty += -(applet.pmouseX-applet.mouseX) * 0.01;
  }
}