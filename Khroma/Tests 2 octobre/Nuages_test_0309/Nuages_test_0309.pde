PShader nebula;

float speed = 0.5;
PVector direction = new PVector(-1.0, 0.2);
color cloudColor = color(255, 100, 200);   // rose/violet

int n_scanX = 20; // <= 200 (MAX_LINES)
float[] scanX = new float[n_scanX];
float[] x = new float[n_scanX];
float[] targetX = new float[n_scanX];
float[] dx = new float[n_scanX];
float easing = 0.05;

boolean mode_auto = true;
int frequence = 4;

void settings() {
  //size(12000, 2000, P2D);
  size(1920, 10280, P2D);
  
  pixelDensity(1);
}

void setup() {
  nebula = loadShader("nebula.frag");
  
  
  for(int i = 0 ; i < n_scanX; i++){
    scanX[i] = random(0, width);
    x[i] = scanX[i];
    targetX[i] = scanX[i];
  }

  colorMode(HSB,360,100,100,100);
}

void draw() {
  surface.setTitle("FPS = " + int(frameRate));

  // Easing animation des lignes
  for (int i=0; i<n_scanX; i++) {
    dx[i] = targetX[i] - x[i];
    if (abs(dx[i]) > 0.5) x[i] += dx[i] * easing;
    scanX[i] = x[i];
  }

  // Passer les données au shader
  nebula.set("resolution", float(width), float(height));
  nebula.set("time", millis() / 1000.0);
  nebula.set("u_direction", direction.x, direction.y);
  nebula.set("u_speed", speed);
  nebula.set("u_cloudColor",
             red(cloudColor)/255.0,
             green(cloudColor)/255.0,
             blue(cloudColor)/255.0);
  nebula.set("n_lines", n_scanX);
  nebula.set("lineX", scanX);

  // Appliquer le shader
  shader(nebula);
  rect(0, 0, width, height);

  // Auto-update des positions
  if(mode_auto && frameCount % (60*frequence) == 0){
    for (int i = 0; i < n_scanX; i++) targetX[i] = random(0, width);
  }

  // Affichage FPS
  fill(0,0,100);
  text("FPS = " + int(frameRate), 20, 30);
}

void keyReleased() {
  if (key == ' ') {
    for (int i = 0; i < n_scanX; i++) targetX[i] = random(0, width);
  }
}
