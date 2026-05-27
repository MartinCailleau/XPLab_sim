import codeanticode.syphon.*;
SyphonServer server;

JSONArray exoplanets;

float scrollY = 0;
float lineHeight = 22;
float topMargin = 40;

int choix_exoplanet;
int n_particules = 100; 
int max_molecules = 10; 
float[][] x = new float[max_molecules][n_particules];
float[][] targetX = new float[max_molecules][n_particules];
float[][] dx = new float[max_molecules][n_particules];
float[][] y = new float[max_molecules][n_particules];
float[][] targetY = new float[max_molecules][n_particules];
float[][] dy = new float[max_molecules][n_particules];
float easing = 0.05;

boolean mode_auto = true;
int frequence = 300;

color[] mol_couleur = new color[max_molecules];

PFont myFont;

boolean syphon_on = true;

void setup() {
  size(12000, 2160, P2D); 
  //size(1920, 1080, P2D); 
  
  pixelDensity(1);
  
  background(0);
  fill(255);
  textSize(14);
  
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
  
  // Charge ton JSON (place-le dans le dossier “data”) :
  exoplanets = loadJSONArray("../datas/exoplanet_set_03092025.json");
  
  myFont = createFont("DIN Alternate Bold", 200);
  textFont(myFont,200);
  textAlign(CENTER,CENTER);
  
  for(int h = 0 ; h< max_molecules ; h++){
    for(int i = 0 ; i < n_particules; i++){
      x[h][i] = random(width);
      targetX[h][i] = x[h][i];
      y[h][i] = random(width);
      targetY[h][i] = y[h][i];
    }
  }
  mol_couleur[0] = #f9f871;
  mol_couleur[1] = #ffc75f;
  mol_couleur[2] = #ff9671;
  mol_couleur[3] = #ff6f91;
  mol_couleur[4] = #d65db1;
  mol_couleur[5] = #845ec2;
  mol_couleur[6] = #FF03A7;
  mol_couleur[7] = #FF030B;
}

void draw() {
  surface.setTitle("FPS = " + frameRate);
  // data
  
  //for (int i = 0; i < exoplanets.size(); i++) {
    JSONObject planet = exoplanets.getJSONObject(choix_exoplanet);
    String name = planet.getString("name");
    String star = planet.hasKey("star") ? planet.getString("star") : "";
    JSONArray detections = planet.getJSONArray("detections");
    String notes = planet.hasKey("notes") ? planet.getString("notes") : "";
    
    // Construire la chaîne pour les molécules/éléments détectés
    String detList = "";
    for (int j = 0; j < detections.size(); j++) {
      detList += detections.getString(j);
      if (j < detections.size() - 1) detList += ", ";
    }
    
  // easing
  //println("detections.size() = " + detections.size());
  for(int h = 0 ; h<  detections.size() ; h++){
    for(int i = 0 ; i < n_particules; i++){
      dx[h][i] = targetX[h][i] - x[h][i];
      if (abs(dx[h][i]) > 3) {
        x[h][i] += dx[h][i] * easing;
      }
      dy[h][i] = targetY[h][i] - y[h][i];
      if (abs(dy[h][i]) > 3) {
        y[h][i] += dy[h][i] * easing;
      }
    }
  }
  
  if(mode_auto){
    if(frameCount % frequence == 0){    
      for(int h = 0 ; h<  detections.size() ; h++){
        for(int i = 0 ; i < n_particules; i++){
          targetX[h][i] = random(width);
          targetY[h][i] = random(height);
        }
      }   
    }
  }
  
  else{    
    for(int h = 0 ; h<  detections.size() ; h++){
      for(int i = 0 ; i < n_particules; i++){
        targetX[h][i] = random(width);
        targetY[h][i] = random(height);
      }
    }
  }
  



  // draw
  background(20);
  fill(255);
  textSize(20);

    
    //// Affichage
    //text(name + (star.equals("") ? "" : " (autour de " + star + ")"), 40, y);
    //y += lineHeight;
    //text("  Détections : " + detList, 60, y);
    //y += lineHeight;
    //if (!notes.equals("")) {
    //  text("  Notes : " + notes, 60, y);
    //  y += lineHeight;
    //}
    //y += lineHeight;  // espacement entre planètes
    
    textAlign(LEFT);
    pushMatrix();
    translate(454,258);
    text("FPS = " + frameRate,40,30);
    //if(i == choix_exoplanet){
          // Affichage
          text(name + (star.equals("") ? "" : " (autour de " + star + ")"), 40, 50);
          text("  Détections : " + detList, 60, 70);
          if (!notes.equals("")) {
            text("  Notes : " + notes, 60, 90);
          }
          
          text("nombre éléments détectés = " + detections.size(),40,200); 
          for (int j = 0; j < detections.size(); j++) {
            text("élément # " + j + " = " + detections.getString(j),40,220+(j*20));
          }
           // text("élément # " + 0 + " = + "  + detections.getString(0),40,240);
    popMatrix();
          
    //push();
    textAlign(CENTER);
    textSize(100);
    text("name = " + name,width/2-3088,height/2);
    //pop();
         

    textSize(40);
    for(int h = 0 ; h<  detections.size() ; h++){
      fill(mol_couleur[h]);
      for(int i = 0 ; i < n_particules; i++){
        text(detections.getString(h),x[h][i],y[h][i]);
      }
    }
    
    if(syphon_on){
       server.sendScreen();
    }
    
}

// Défilement avec molette
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scrollY += e * 20;
  constrainScroll();
}

// Défilement avec clic-glisse
boolean dragging = false;
float prevMouseY;

void mousePressed() {
  dragging = true;
  prevMouseY = mouseY;
}

void mouseReleased() {
  dragging = false;
}

void mouseDragged() {
  if (dragging) {
    float dy = mouseY - prevMouseY;
    scrollY += dy;
    prevMouseY = mouseY;
    constrainScroll();
  }
}

// Limiter le scroll
void constrainScroll() {
  float minY = height - getTotalHeight();
  if (scrollY < minY) scrollY = minY;
  if (scrollY > 0) scrollY = 0;
}

// Calcul de la hauteur totale nécessaire pour tout afficher
float getTotalHeight() {
  float h = topMargin;
  for (int i = 0; i < exoplanets.size(); i++) {
    JSONObject planet = exoplanets.getJSONObject(i);
    float linesHere = 2; // nom + détect.
    String notes = planet.hasKey("notes") ? planet.getString("notes") : "";
    if (!notes.equals("")) linesHere += 1;
    h += linesHere * lineHeight + lineHeight;  // espacement
  }
  return h + 100;  // marge de sécurité
}

void keyReleased(){
  if(key == 'i'){
    println(mouseX + " ' " + mouseY);
  }
  if(key == 'a'){
    mode_auto = !mode_auto;
  }
  if(key == TAB){
    choix_exoplanet++;
    if(choix_exoplanet>=exoplanets.size()){
      choix_exoplanet = 0;
    }
  }
}
