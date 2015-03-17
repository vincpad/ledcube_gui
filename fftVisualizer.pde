// Audio visualizer for the led cube
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

boolean[][][] history = new boolean[8][8][8];

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
  for (int i = 0; i < 8; ++i) {
    for (int j = 0; j < 8; ++j) {
      for (int k = 0; k < 8; ++k) {
        history[i][j][k] = false;
      }
    }
  }

}

void fileSelected2(File selection) {
  String audioFileName = selection.getAbsolutePath();
  jingle = minim.loadFile(audioFileName, 1024); //minim.getLineIn(Minim.STEREO, 2048); // 
  jingle.loop();

  fft = new FFT(jingle.bufferSize(), jingle.sampleRate());
  // calculate averages based on a miminum octave width of 22 Hz
  // split each octave into 8 bands
  //fft.logAverages(22,8);
  fft.linAverages(9);
  fileselected = true;
}
void fftVisualizer() {
  if(fileselected == true) {
    fft.forward(jingle.mix);
    myCube.clear();
    float[] coef = new float[]{0.3, 0.6, 1, 2, 4, 4.5, 6, 9};
    for(int i = 0; i < 8; i++) {
        float valTmp = fft.getAvg(i)*coef[i];
  
        int val = int(valTmp);
        if(val>8) {
          val = 8;
        }
        
        for(int k = 1; k <= val; k++) {
          boolean state = true;
          if(val == 0) {
            state = false;
          }
          
          myCube.setLed(0,i,k-1,state);
          //history[i][0][k-1] = state;
        }
        print(i);
        print("  ");
        println(fft.getAvg(i));
      }
    }

    for (int i = 7; i > 0; --i) {
      for (int j = 0; j < 8; ++j) {
        for (int k = 0; k < 8; ++k) {
          myCube.setLed(i,j,k,history[i][j][k]);
        }
      }
    }

    if(mySerial.available()) {
      mySerial.sendFrames();
    }

    for (int j = 0; j < 8; ++j) {
        for (int k = 0; k < 8; ++k) {
          history[0][j][k] = myCube.getLedState(0,j,k);
        }
    }
    for (int i = 7; i > 0; --i) {
      for (int j = 0; j < 8; ++j) {
        for (int k = 0; k < 8; ++k) {
          history[i][j][k] = history[i-1][j][k];
        }
      }
    }
}