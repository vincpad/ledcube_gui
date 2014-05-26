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
void readCurrentState() {
  for (int i = 0; i < dim; ++i) {
    for (int j = 0; j < dim; ++j) {
      for (int k = 0; k < dim; ++k) {
        leds[fromLedToId(i,j,k)].forceState(led_value[i][j][k]);
      }
    }
  }
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