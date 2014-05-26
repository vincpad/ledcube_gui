// Global variables used by several functions
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

boolean playing;	// True if animation is playing
int animationTime;	// Time between 2 frames
int now;	//	Time variable for counters
int animCounter = 0;	// Used for the animation management
String displayedFrameLabel = "No frame selected";	// Label bisplayed on the up-left corner
int previousSerialPortN, previousFrameN, selectedFrameN = -1, displayedFrameN = -1; // Numbers ...
boolean actionDone, actionDone2;	// No comment

//	HUD objects
ControlP5 cp5;	// Object to manage HUD
ListBox comPorts, framelist;
Button loadfile, disconnectb, loadframe, insertbefore, newframeattheend, deleteframe, eraseframe, playbutton, stopbutton, updateports, snakemode;
Numberbox animationspeed;







static int cubeSize = 8; // cube dimension
AnimFile myAnimFile;	// Object to manage animation file
LedCube myCube;
SerialComm mySerial;	// Object to manage the connection with the cube