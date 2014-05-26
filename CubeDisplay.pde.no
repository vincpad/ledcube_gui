/*class CubeDisplay extends PApplet{
	int zX = -60, zY = -60, zZ = 150;
	float zoomValue=1, rotx = PI/4, roty = PI/4;
	int dim = 4;
	Sphere[] spheres;

	public CubeDisplay() {
		mainApplet.registerDraw(this);
		//draw();
	}

	public void draw() {
		stroke(255,0,0);
    	fill(255);
    	line(10, 10, 10, -10+10, 10, 10);
    	println("hi");
	}


	public void init() {
		
	}


	public void refresh() {
  		pushMatrix();
    	camera(zX, zY, zZ, 0, 0, 0, 0, 1, 0);
    	lights();
    	background(100);
    	rotateY(roty);
    	rotateX(rotx);
    	scale(zoomValue);
    	drawaxes();
    	for (int i = 0; i < spheres.length; i++) {
    	  spheres[i].display(this.g);
    	}
    	popMatrix();
	} 
	public void createSphereObjects() {
  		sphereDetail(10);
		spheres = new Sphere[dim*dim*dim];
		int id = 0;
  		for (int i = 0; i < dim; ++i) {
  		  for (int j = 0; j < dim; ++j) {
  		    for (int k = 0; k < dim; ++k) {
  		      spheres[id] = new Sphere(
  		        id,                      // identifiant
  		        -dim*5+5+10*i ,  // position x
  		        -dim*5+5+10*j,  // position y
  		        -dim*5+5+10*k,  // position z
  		        2     // taille
  		      );
  		      id++;
  		    }
  		  } 
  		}
	}

	public void drawaxes(){
    	int val = -dim*5+5;
    	textSize(10);
    	stroke(255,0,0);
    	fill(255);
    	line(val, val, val, -val+10, val, val);
    	line(val, val, val, val, -val+10, val);
    	line(-val+10,val,val,-val+5,val,val-2);
    	line(-val+10,val,val,-val+5,val,val+2);
    	line(val,-val+10,val,val,-val+5,val-2);
    	line(val,-val+10,val,val,-val+5,val+2);
    	text("Y",-val+15,val,val);
    	text("X",val,-val+15,val);
    	stroke(0,255,0);
    	line(val, val, val, val, val, -val+10);
    	line(val,val,-val+10,val-2,val,-val+5);
    	line(val,val,-val+10,val+2,val,-val+5);
    	text("Z",val,val,-val+15);
    	noStroke();
	}

} */