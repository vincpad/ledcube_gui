// Led cube GUI, by cybervinc
// Still in creation, and not fully commented


import processing.serial.*;
import processing.opengl.*;
import controlP5.*;
import java.io.*; 

void setup() {
	size(1200, 800, OPENGL);
	cp5 = new ControlP5(this);
	noStroke();
	frameRate(30);
	buffer = createGraphics(width, height, P3D);
	drawSpheres();
	drawHud();
	initSnake();
	createSnake();
}

void draw() {
  //snake();  // Uncomment for snake game mode 
  refreshCube();
  playAnimation();
  refreshDisplayedText();
}