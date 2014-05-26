//SNAKE 3D
//
// Part of ledcube_gui project : https://github.com/cybervinc/ledcube_gui
//

SnakePixel[] spixel = new SnakePixel[512];
boolean created = false;
int foodPosx=-1, foodPosy=-1, foodPosz=-1;
int nextDirection;
boolean gameover = false;
int foodCounter = 0;
boolean snakeEnabled = false;

void snake() {
	if(snakeEnabled == true ) {
		if(millis() - now >= animationTime){  // Do this only every <animationTime> ms (number box in the GUI)
			keyboardManagement();
			if(gameover == false) {		// If the snake is always alive
				moveSnake();
				checkCollisions();
				myCube.clear();
				refreshSnake();
				if(foodCounter >= 10) {  // If no food during 10 movements, generate food
					generateFood();
					foodCounter = 0;
				}
				if(foodExists() == false) {
					foodCounter++;
				}
				now = millis();
			}	
		}
	}
}
void checkCollisions() {
int i=1;
	if(spixel[0].posx == foodPosx && spixel[0].posy == foodPosy && spixel[0].posz == foodPosz) {  // Collision with food
		lengthenSnake();
		removeFood();
	}
	while(spixel[i].checkExistence()) {  // Collision with its body
		if(spixel[0].posx == spixel[i].posx && spixel[0].posy == spixel[i].posy && spixel[0].posz == spixel[i].posz) {
			gameOver();
		}
		i++;
	}
}
void resetSnake() {
	initSnake();
	createSnake();
}
void keyboardManagement() {
	if(nextDirection != -1) {
		setSnakeDirection(nextDirection);
		nextDirection = -1;
	}
}
void gameOver() {
	println("game over");
	println("Press space to continue ...");
	resetSnake();
	gameover = true;
}
void generateFood() {
	foodPosx = int(random(0, myCube.getSize()));
	foodPosy = int(random(0, myCube.getSize()));
	foodPosz = int(random(0, myCube.getSize()));
}
void removeFood() {
	foodPosx = -1;
	foodPosy = -1;
	foodPosz = -1;
}
boolean foodExists() {
	if(foodPosx != -1 && foodPosy != -1 && foodPosz != -1) {
		return true;
	}
	else return false;
}
void displayFood() {
	if(foodExists()) {
		myCube.setLed(foodPosx, foodPosy, foodPosz, true);
	}
}
void lengthenSnake() {
int i=0,dir=0;
while(spixel[i].checkExistence()) { // Look for the snake's tail
		i++;
	}
	if(spixel[i-1].checkIfTurning()) {
		dir = spixel[i-1].prevDirection;
	}
	else {
		dir = spixel[i-1].direction;
	}
	spixel[i].enable(spixel[i-1].prevPosx, spixel[i-1].prevPosy, spixel[i-1].prevPosz, dir);
}
void refreshSnake() {
	int i=0;
	while(spixel[i].checkExistence()) {
		spixel[i].write();
		i++;
	}
	displayFood();
	if(mySerial.available()) {
		mySerial.sendFrames();
	}
}
void moveSnake() {
	for(int i=int(pow(myCube.getSize(), 3))-1;i>=0;i--) {
		if(spixel[i].checkExistence() == true){
			spixel[i].move();
		}
	}
}
void initSnake() {
	for(int i = 0; i<pow(myCube.getSize(),3); i++) {
		spixel[i] = new SnakePixel(i);
	}
}
void createSnake() {
	spixel[0].enable(int(random(0,myCube.getSize())), int(random(0,myCube.getSize())), int(random(0,myCube.getSize())), int(random(0,5)));
}
void setSnakeDirection(int direction_) {
	if(spixel[0].direction + 3 == direction_ || spixel[0].direction == direction_ + 3) {// Check if the direction change is possible (ex : up to down is impossible)
	}
	else {
		spixel[0].setDirection(direction_);
	}
}
class SnakePixel {
	public int prevPosx, prevPosy, prevPosz;
	public int posx, posy, posz;
	public int id;
	public int direction;
	public int prevDirection;
	public boolean exists;
	public boolean turning;
	
	public SnakePixel(int id_) {
		id = id_;
		turning = false;
	}
	public void enable(int x, int y, int z, int direction_) {
		posx = x;
		prevPosx = posx;
		posy = y;
		prevPosy = posy;
		posz = z;
		prevPosz = posz;
		direction = direction_;
		exists = true;
	}
	public void move() {
		if(exists = true) {
			prevPosx = posx;
			prevPosy = posy;
			prevPosz = posz;
			switch (direction) {
				case 0 :	// up (+z)
					if(posz < myCube.getSize()-1) { posz++; }
					else { posz = 0; }
				break;
				case 1 :	// right (+y)
					if(posy < myCube.getSize()-1) { posy++; }
					else { posy = 0; }
				break;
				case 2 :	// forward (-x)
					if(posx > 0) { posx--; }
					else { posx = myCube.getSize()-1; }
				break;
				case 3 :	// down (-z)
					if(posz > 0) { posz--; }
					else { posz = myCube.getSize()-1; }
				break;
				case 4 :	// left (-y)
					if(posy > 0) { posy--; }
					else { posy = myCube.getSize()-1; }
				break;
				case 5 :	// backward (+x)
					if(posx < myCube.getSize()-1) { posx++; }
					else { posx = 0; }
				break;
			}
			if(turning == true) {
				propagateDirection();
			}
		}
	}
	public void setDirection(int direction_) {
		prevDirection = direction;
		direction = direction_;
		turning = true;
	}
	private void propagateDirection() {
		if(spixel[id+1].checkExistence() == true) {
			spixel[this.id+1].setDirection(direction);
		}
		turning = false;
	}
	public void write() {
		setLed(posx,posy,posz,true);
	}
	public boolean checkExistence() {
		return exists;
	}
	public boolean checkIfTurning() {
		return turning;
	}
	public int getPrevDirection	() {
		return prevDirection;
	}
}