
PShader caustics;
float caustic_speed = 0.5;
float caustic_scale = 1;
void setup() {
  size(3840, 3840, P2D);
  
  // Chargement du shader (il doit être dans le dossier "data/")
  caustics = loadShader("caustics.glsl");
}

void draw() {
  surface.setTitle("FPS = " + frameRate);
  // Passage des uniforms au shader
  caustics.set("resolution", (float)width, (float)height);
  caustics.set("time", millis() / 1000.0); // temps en secondes
  
  // 🔧 Paramètres modifiables directement dans Processing :
  if(keyPressed && key == '&'){
    caustic_speed = map(mouseX,0,1920,0.1,1);
  }
  if(keyPressed && key == 'é'){
    caustic_scale = map(mouseX,0.1,1920,0,5);
  }
  caustics.set("speed", caustic_speed);       // vitesse (0 = figé, >1 = rapide)
  caustics.set("reverse", false);   // true = animation inversée
  caustics.set("scale", caustic_scale);       // zoom (0.5 = réduit, 2.0 = zoomé)
  caustics.set("brightness", 0.0);  // luminosité (-0.5 à +0.5 conseillé)
  caustics.set("contrast", 2.0);    // contraste (1 = normal, >2 = fort contraste)

  // Activation du shader
  shader(caustics);

  // Dessin d’un rectangle plein écran pour appliquer le shader
  rect(0, 0, width, height);
  
  fill(255,0,0);
  text("FPS = " + frameRate,0,50);
}
