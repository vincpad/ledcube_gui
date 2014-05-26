// Audio visualizer for the led cube
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

int[] value = new int[66];

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer jingle;
//AudioInput jingle;
FFT fft;
boolean fileselected = false;
void fftVisualizerSetup() {
  minim = new Minim(this);
  selectInput("Select an audio file:", "fileSelected2");
}

void fileSelected2(File selection) {
  String audioFileName = selection.getAbsolutePath();
  jingle = minim.loadFile(audioFileName, 2048); //minim.getLineIn(Minim.STEREO, 2048); // 
  jingle.loop();

  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
  // calculate averages based on a miminum octave width of 22 Hz
  // split each octave into 8 bands
  fft.logAverages(22,8);
  fileselected = true;
}
void fftVisualizer() {
  if(fileselected == true) {
    fft.forward(jingle.mix);
    myCube.clear();
    int n = 0;
    for(int i = 0; i < 8; i++) {
      for(int j = 0; j < 8; j++) {

        int val=int(fft.getAvg(n)/8);
        if(fft.getAvg(n)/8>8) {
          val = 8;
        }
        value[n] = val;
        for(int k = 1; k <= value[n]; k++) {
          boolean state = true;
          if(value[n] == 0) {
            state = false;
          }
          myCube.setLed(i,j,k-1,state);
        }
        n++;
      }
    }   
    if(mySerial.available()) {
      mySerial.sendFrames();
    }
  }
}