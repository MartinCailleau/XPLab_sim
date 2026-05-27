// Easing ///////////////////////////////////////
int nombre = 200; // nombre d'objets
float[] x = new float[nombre];
float[] y = new float[nombre];
float[] dx = new float[nombre];
float[] dy = new float[nombre]; 
float[] targetX = new float[nombre];
float[] targetY = new float[nombre] ;
int[] taille = new int[nombre] ;
float easing = 0.05; // vitesse d'animation

float[] triangleX = new float[nombre];
float[] triangleY = new float[nombre];

int crown_width = 200;




void setup() {
  size(1024, 1024,P2D);
  smooth();
  colorMode(HSB,360,100,100,100);
  ellipseMode(CENTER);

  for (int i=0; i<nombre; i++) {
    x[i] = width/2;
    y[i] = height/2;
    targetX[i] = width/2;
    targetY[i] = height/2;
    taille[i] = int(random(0,4));
  }
  
}



void draw() {

  fill(0);
  noStroke();
  rect(0, 0, width, height);

  for (int i=0; i<nombre; i++) {
    dx[i] = targetX[i] - x[i];
    if (abs(dx[i]) > 3) {
      x[i] += dx[i] * easing;
    }
    if (abs(dx[i]) <= 3) {
      x[i] = int(targetX[i]);
    }

    dy[i] = targetY[i] - y[i];
    if (abs(dy[i]) > 3) {
      y[i] += dy[i] * easing;
    }    
    if (abs(dy[i]) <= 3) {
      y[i] = int(targetY[i]);
    }
  }


  // crown 2
  noStroke();
  fill(200,100,100);
  arc(width/2,height/2,crown_width*2,crown_width*2,radians(270),radians(360));
  fill(150,100,100);
  arc(width/2,height/2,crown_width*2,crown_width*2,radians(180),radians(270));
  fill(100,100,100);
  arc(width/2,height/2,crown_width*2,crown_width*2,radians(90),radians(180));
  fill(50,100,100);
  arc(width/2,height/2,crown_width*2,crown_width*2,0,radians(90));
  // crown 1 (center)
  fill(0,100,100);
  arc(width/2,height/2,crown_width,crown_width,0,radians(360));


}




void keyReleased() {

  if (key==' ') {
    for (int i = 0; i <nombre; i++) {
      targetX[i] = random(0, width);
      targetY[i] = random(0, height);
    }
  }
}
