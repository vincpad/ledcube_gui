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
    color idColor = myCube.getColor(id);
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