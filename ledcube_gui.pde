// Led cube GUI, by cybervinc
// Still in creation, and not fully commented
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

import processing.serial.*;
import processing.opengl.*;
import controlP5.*;
import java.io.*; 

Hud myHud;

void setup() {
	size(1200, 800, OPENGL);
	myAnimFile = new AnimFile();
	myCube = new LedCube(cubeSize, this);
	mySerial = new SerialComm();
	myHud = new Hud(this);
	frameRate(30);
	initSnake();
	createSnake();
	fftVisualizerSetup();	// uncomment to enable audio visualizer
}

void draw() {
	fftVisualizer();	// uncomment to enable audio visualizer
	s();
  	snake();
	myCube.refresh();
  	playAnimation();
  	myHud.refreshDisplayedText();
  	//e(1);
}