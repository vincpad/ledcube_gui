// HUD management

void drawHud() {

    // Lists
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
                        //.setFocus(true)
                        .setMultiplier(10)
                        .setScrollSensitivity(1.1)
                        .setValue(500)
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
    snakemode.setLabel("Frame edit mode");
}

/*
void snakeMode() {
    if(snakeEnabled == false) {
        snakeInitialized = false;
        snakeEnabled = true;
        snakemode.setLabel("Frame edit mode");
        println("Snake mode");
    }
    if(snakeEnabled == true) {
        snakeEnabled = false;
        snakeInitialized = false;
        snakemode.setLabel("Snake mode");
    }
}
*/

// Function triggered by the "disconnect" button
void disconnect() {
    mySerial.disconnect();
    println("Disconnected from "+ serialPort);
    updateComPortsList();
    updateDisconnectButton();
}

// Function triggered by the "load file" button
void loadFile() {

    //selectInput("Select a file to process:", "fileSelected");
    
    println(myFile.countLines());
}

// Function triggered by the loadFile function
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    //println("User selected " + selection.getAbsolutePath());  // Issue with my compiler, says that "getAbsolutePath()); doesn't exist."
  }
}

// Function triggered by the "New frame at the end" button
void newFrameAtTheEnd() {
    int l = myFile.countLines();
    println(l);
    myFile.insert(l);
    myFile.erase(l, generateArray());
    updateFrameList();
    loadFrame();
}

// Function for updating the frame list after a frame removal or creation
void updateFrameList() {
    framelist.clear();
    for (int i=0;i<=myFile.countLines()-1;i++) {
        String item = "Frame " + String.valueOf(i+1);
        ListBoxItem frame = framelist.addItem(item, i);
        frame.setColorBackground(0xffff0000);
    }
}

// Function for updating the com ports list list after a serial connection/disconnection, also triggered by the "Update list" button
void updateComPortsList() {
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
void loadFrame() {
    readArray(myFile.read(selectedFrameN));
    if(mySerial.available()) {
        mySerial.sendFrames();
    }
    displayedFrameN = selectedFrameN;
}
// Driggered by the "Load frame" button
void insertBefore() {
    myFile.insert(selectedFrameN);
    updateFrameList();
}
void deleteFrame() {
    myFile.remove(selectedFrameN);
    updateFrameList();
}
void eraseFrame() {

    myFile.erase(selectedFrameN, generateArray());
}

// Set the "Disconnect button" invisible if no port selected
void updateDisconnectButton() {
    if(mySerial.available()) {
        disconnectb.setVisible(true);
    }
    else {
        disconnectb.setVisible(false);
    } 
}

void animationSpeed(int spd) {
    animationTime = spd;
}

void playButton() {
    if(playing == false) {
        playing = true;
        playbutton.setLabel("Pause (P)");
    }
    else if(playing == true) {
        playing = false;
        playbutton.setLabel("Play (P)");
    }
}
void stopButton() {
    playing = false;
    animCounter = 0;
    playbutton.setLabel("Play (P)");
}
void refreshDisplayedText() {
    if(displayedFrameN != -1) {
        displayedFrameLabel = "Frame " + String.valueOf(displayedFrameN + 1);
    }
    textSize(10);
    fill(255);
    text(displayedFrameLabel, 20, 20);

}

void updatePorts() {
    updateComPortsList();
}