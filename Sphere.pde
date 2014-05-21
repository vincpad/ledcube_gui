// Class to manage the 3D-displayed spheres

class Sphere {
 
  // variables
  int id;          // id
  int x, y, z, w;  // position (x, y, z) and width (w)
  boolean state;         // state
 
  // constructor
  public Sphere(int id, int x, int y, int z, int w) {
    this.id = id;
    this.x = x; this.y = y; this.z = z; this.w = w;
    state = false;
  }
  public void changeState() {
    if(state == false) {
      forceState(true);
    }
    else {
      forceState(false);
    }  
  }
  public void forceState(boolean s) {
    state = s;
    fromIdToLed(id);
  }

  // display the cube on screen
  public void display(PGraphics ecran) {
    if(state == false) {
      ecran.fill(color(255));
    }
    if(state == true) {
      ecran.fill(color(0,0,255));
    }
    drawSphere(ecran);
  }
 
  // draw the cube in the buffer
  public void drawBuffer(PGraphics buffer) {
    color idColor = getColor(id);
    buffer.fill(idColor);
    drawSphere(buffer);
  }
 
  private void drawSphere(PGraphics g) {
    g.pushMatrix();
      g.translate(x, y, z);
      g.sphere(w);
    g.popMatrix();
  }
  
  public boolean getState() {
    
    return state;
  }
}