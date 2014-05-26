// Many functions, needs some triage
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//





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
  boolean[] a = new boolean[int(pow(myCube.getSize(), 3))];
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
void readArray(boolean[] array) {
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
void setLed(int x, int y, int z, boolean state) {
  
  myCube.setLed(x,y,z,state);
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