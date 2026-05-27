PShader nebula;

float speed = 0.5;
PVector direction = new PVector(-1.0, 0.2); // diagonale
color cloudColor = color(255, 100, 200);   // rose/violet

void settings() {
  size(12000, 2000, P2D); // Test en petite taille
}

void setup() {
  nebula = loadShader("nebula.frag");
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
  
  println("FPS = " + frameRate);
}
