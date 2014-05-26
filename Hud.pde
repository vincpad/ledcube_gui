// HUD management
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

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
// Driggered by the "Load frame" button
public void insertBefore() {
    myAnimFile.insertLine(selectedFrameN);
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
}