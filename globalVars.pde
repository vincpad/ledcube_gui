// Global variables used by several functions

boolean playing;	// True if animation is playing
int animationTime;	// Time between 2 frames
int now;	//	Time variable for 
int animCounter = 0;	// Used for the animation management
String displayedFrameLabel = "No frame selected";	// Label bisplayed on the up-left corner
String serialPort;	// Current serial port name
int previousSerialPortN, previousFrameN, selectedFrameN, displayedFrameN = -1; // Numbers ...
boolean actionDone, actionDone2;	// No comment

//	HUD objects
ControlP5 cp5;	// Object to manage HUD
ListBox comPorts, framelist;
Button loadfile, disconnectb, loadframe, insertbefore, newframeattheend, deleteframe, eraseframe, playbutton, stopbutton, updateports, snakemode;
Numberbox animationspeed;

//	Camera settings
int zX = -60, zY = -60, zZ = 150;
float zoomValue=1, rotx = PI/4, roty = PI/4;


int dim = 8; // cube dimension

File myFile = new File("test.txt");	// Object to manage animation file

Sphere[] spheres;	// Spheres objects making the 3D cube
PGraphics buffer;	// Graphical buffer to do color-based 3D picking

SerialComm mySerial = new SerialComm();	// Object to manage the connection with the cube

boolean[][][] led_value = new boolean[dim][dim][dim];	// 3 dimensional array to store all leds state