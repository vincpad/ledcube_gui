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
      myAnimFile.writeLineB(selectedFrameN, new boolean[int(pow(myCube.getSize(), 3))]);  // Fill the frame with a blank boolean array
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