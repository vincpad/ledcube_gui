// All that is triggered by events is here
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

void mouseClicked() {
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
 
  // Get the pixel color under the mouse
  color pick = buffer.get(mouseX, mouseY);
  // Get object id
  int id = getId(pick);
  // If id >= 0 (background id = -1)
  if (id >= 0) {
    // change the cube color
    leds[id].toggleState();
    if(mySerial.available()) {
        mySerial.sendFrames();
    }
  }
}
// Triggered when mouse wheel is used
void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  zoomValue=zoomValue+0.01*e; // Update scene size values (zoom)
} 
// Triggered when mouse is dragged
void mouseDragged() {
  float rate = 0.01;
  if(mouseX<1080) { // Not in the HUD zone (to avoid cube rotation when slide the frames list for example)
    rotx += (pmouseY-mouseY) * rate;  // Update scene rotation values
    roty += (mouseX-pmouseX) * rate;
  }
}
// Triggered when clicking on a list object
void controlEvent(ControlEvent theEvent) {
  if(theEvent.isGroup()){
    // if the event happen in the serial ports list
    if(theEvent.name().equals("serialPorts")) {
  
      int serialPortN = (int)theEvent.group().value();  // get the serial port number in the list
  
      if(previousSerialPortN >= 0){
        ListBoxItem previousPort = comPorts.getItem(previousSerialPortN); //  get the previous item
        previousPort.setColorBackground(0xffff0000);  //  and restore its original background colors
      }
      previousSerialPortN = serialPortN;  //  update the selected index
      comPorts.getItem(serialPortN).setColorBackground(color(100, 128));  //  and set the background color to be the active/'selected one'
      serialPort = Serial.list()[serialPortN];  // get the serial port name
      mySerial.connect(serialPort); // connect to this port
      updateComPortsList(); // update the ports list
      updateDisconnectButton(); // update the disconnect button
      println("Connected to "+serialPort);
    }
    // if the event happen in the frames list
    if(theEvent.name().equals("frameList")) {
      int frameN = (int)theEvent.group().value();
  
      if(previousFrameN >= 0 && previousFrameN < myAnimFile.numberOfLines()) {
        ListBoxItem oldframe = framelist.getItem(previousFrameN); //  get the previous item
        oldframe.setColorBackground(0xffff0000);  //  and restore its original background colors
      }
      previousFrameN = frameN;  //  update the selected index
      framelist.getItem(frameN).setColorBackground(color(100, 128));//  and set the bg colour to be the active/'selected one'
      selectedFrameN = frameN;  // set the global variable "selectedFrameN"
      println("Frame selected: "+frameN);
    }
  }
}
// triggered if any key is pressed
void keyPressed() {
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
void keyReleased() {
    actionDone2 = false;
    actionDone = false;
}