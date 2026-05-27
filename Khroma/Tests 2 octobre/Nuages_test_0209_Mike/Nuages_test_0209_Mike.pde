PShader nebula;

float speed = 0.5;
PVector direction = new PVector(-1.0, 0.2); // diagonale
color cloudColor = color(255, 100, 200);   // rose/violet

int n_scanX = 200;
float[] scanX = new float[n_scanX];
float[] scanY = new float[n_scanX];
float[] scan_couleur = new float[n_scanX];

// Easing
float[] x = new float[n_scanX];
float[] y = new float[n_scanX];
float[] dx = new float[n_scanX];
float[] dy = new float[n_scanX]; 
float[] targetX = new float[n_scanX];
float[] targetY = new float[n_scanX] ;
int[] taille = new int[n_scanX] ;
float easing = 0.05; // vitesse d'animation

boolean mode_auto = true;
int frequence = 4;

void settings() {
  size(12000, 2000, P2D); // Test en petite taille
}

void setup() {
  nebula = loadShader("nebula.frag");
  
  for(int i = 0 ; i<n_scanX ; i++){
    scanX[i] = round(random(0,width));
    scanY[i] = 0;
    scan_couleur[i] = round(random(0,360));
    x[i] = scanX[i];
    y[i] = scanX[i];
    targetX[i] = scanX[i];
    targetY[i] = scanX[i];
  }

  
  colorMode(HSB,360,100,100,100);
  
}

void draw() {
  
  surface.setTitle("FPS = " + frameRate);
  nebula.set("resolution", float(width), float(height));
  nebula.set("time", millis() / 1000.0);
  nebula.set("u_direction", direction.x, direction.y);
  nebula.set("u_speed", speed);
  nebula.set("u_cloudColor",
             red(cloudColor)/255.0,
             green(cloudColor)/255.0,
             blue(cloudColor)/255.0);

  shader(nebula);
  rect(0, 0, width, height); // IMPORTANT : dessiner une surface
  
  
  fill(0,0,100);
  text("FPS = " + frameRate,50,50);
    
  // Mike
  // Easing 
  for (int i=0; i<n_scanX; i++) {
    dx[i] = targetX[i] - x[i];
    if (abs(dx[i]) > 3) {
      x[i] += dx[i] * easing;
    }
    scanX[i] = x[i]; 
    //if (abs(dx[i]) <= 3) {
    //  x[i] = int(targetX[i]);
    //}

    dy[i] = targetY[i] - y[i];
    if (abs(dy[i]) > 3) {
      y[i] += dy[i] * easing;
    }    
    scanY[i] = y[i]; 
    //if (abs(dy[i]) <= 3) {
    //  y[i] = int(targetY[i]);
    //}
  }
  
  // Draw
  //background(0,100,100);
  strokeWeight(100);
  for(int i = 0 ; i<n_scanX ; i++){
    stroke(scan_couleur[i],100,100);
    line(scanX[i],0,scanX[i],height);
  }
    line(mouseX,0,mouseX,height);
  
  //println("FPS = " + frameRate);
  
  if(mode_auto){
    if(frameCount % (60*frequence) == 0){
      for (int i = 0; i <n_scanX; i++) {
        targetX[i] = random(0, width);
        //targetY[i] = random(0, height);
      }
    }
  }
}

void keyReleased() {

  if (key==' ') {
    for (int i = 0; i <n_scanX; i++) {
      targetX[i] = random(0, width);
      //targetY[i] = random(0, height);
    }
  }
}
