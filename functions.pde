// Many functions, needs some triage
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

color getColor(int id) {
  return -(id + 2);
}
int getId(color c) {
  return -(c + 2);
}
void refreshCube() {
  pushMatrix();
    camera(zX, zY, zZ, 0, 0, 0, 0, 1, 0);
    lights();
    background(100);
    rotateY(roty);
    rotateX(rotx);
    scale(zoomValue);
    drawaxes();
    for (int i = 0; i < leds.length; i++) {
      leds[i].display(this.g);
    }
    popMatrix();
}
void drawSpheres() {
  sphereDetail(10);
	leds = new Led[dim*dim*dim];
	int id = 0;
  	for (int i = 0; i < dim; ++i) {
  	  for (int j = 0; j < dim; ++j) {
  	    for (int k = 0; k < dim; ++k) {
  	      leds[id] = new Led(id, -dim*5+5+10*i, -dim*5+5+10*j, -dim*5+5+10*k, 2, i, j, k);  
  	      id++;
  	    }
  	  } 
  	}
} /*
void fromIdToLed(int ledId) {
  int id = 0;
  for (int i = 0; i < dim; ++i) {
    for (int j = 0; j < dim; ++j) {
      for (int k = 0; k < dim; ++k) {
        if(ledId == id) {
          setLed(i, j, k, leds[id].getState());
        }
        id++;
      }
    }
  }
} */
int fromLedToId(int x, int y, int z) {
  int l = 0;
  int id = 0;
  for (int i = 0; i < dim ; ++i) {
    for (int j = 0; j < dim; ++j) {
      for (int k = 0; k < dim; ++k) {
        if(i == x && j == y && k == z) {
          id = l;
        }
        l++;
      }
    }
  }
  return id;
}
byte toSignedByte(int value) { // Convert unsigned values (0-255) to java signed bytes
    if(value < 128) {
      return (byte)value;
    } 
    else {
      return byte(value - 256);
    }
}
int bitWrite(int b, int p, boolean v) {  //Write a specific bit in a variable
  int r = 0;
  if(v == true) {
    r = (1 << p) | b;
  }
  if(v == false) {
    r = (~(1 << p)) & b;
  }
  return r;
}
boolean[] generateArray() {
  boolean[] a = new boolean[dim*dim*dim];
  int n = 0;
  for (int i = 0; i < dim; ++i) {
    for (int j = 0; j < dim; ++j) {
      for (int k = 0; k < dim; ++k) {
        a[n] = led_value[i][j][k];
        n++;
      }
    } 
  }
  return a;
}
void readArray(boolean[] array) {
  int n = 0;
  for (int i = 0; i < dim; ++i) {
    for (int j = 0; j < dim; ++j) {
      for (int k = 0; k < dim; ++k) {
        leds[fromLedToId(i,j,k)].forceState(array [n]);
        n++;
      }
    } 
  }
}
void clearCube() {
  for(int i=0; i<pow(dim,3); i++) {
    leds[i].forceState(false);
  }
}
void readCurrentState() {
  for (int i = 0; i < dim; ++i) {
    for (int j = 0; j < dim; ++j) {
      for (int k = 0; k < dim; ++k) {
        leds[fromLedToId(i,j,k)].forceState(led_value[i][j][k]);
      }
    }
  }
}
void drawaxes(){
    int val = -dim*5+5;
    textSize(10);
    stroke(255,0,0);
    fill(255);
    line(val, val, val, -val+10, val, val);
    line(val, val, val, val, -val+10, val);
    line(-val+10,val,val,-val+5,val,val-2);
    line(-val+10,val,val,-val+5,val,val+2);
    line(val,-val+10,val,val,-val+5,val-2);
    line(val,-val+10,val,val,-val+5,val+2);
    text("Y",-val+15,val,val);
    text("X",val,-val+15,val);
    stroke(0,255,0);
    line(val, val, val, val, val, -val+10);
    line(val,val,-val+10,val-2,val,-val+5);
    line(val,val,-val+10,val+2,val,-val+5);
    text("Z",val,val,-val+15);
    noStroke();
}
void setLed(int x, int y, int z, boolean state) {
  
  led_value[x][y][z] = state;
}
void playAnimation() {
  if(playing == true) {
    if(animCounter>=myAnimFile.numberOfLines()) {
      animCounter=0;
    }
    if(millis() - now >= animationTime){
      selectedFrameN = animCounter;
      updateFrameList();
      loadFrame();
      animCounter++;
      now = millis();
    }
  }
}