// Led cube GUI, by cybervinc
// Still in creation, and not fully commented
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

import processing.serial.*;
import processing.opengl.*;
import controlP5.*;
import java.io.*; 

void setup() {
	size(1200, 800, OPENGL);
	cp5 = new ControlP5(this);
	myAnimFile = new AnimFile();
	noStroke();
	frameRate(30);
	buffer = createGraphics(width, height, P3D);
	drawSpheres();
	drawHud();
	initSnake();
	createSnake();
	//fftVisualizerSetup();	// uncomment to enable audio visualizer
}

void draw() {
	//fftVisualizer();	// uncomment to enable audio visualizer
  	snake();
	refreshCube();
  	playAnimation();
  	refreshDisplayedText();
}