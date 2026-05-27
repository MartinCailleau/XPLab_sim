import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

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


int frequence = 300;

color[] mol_couleur = new color[max_molecules];

PFont myFont;


int longueur_onde_start = 0;
int longueur_onde_end = 17;

// Kinect
float main_gauche_X; 
float main_gauche_Y; 
float main_droite_X; 
float main_droite_Y; 
int total_user;

float[] raie_H2O = new float[3];
int[] raie_H2O_position = new int[n_particules];
float[] raie_CO2 = new float[3];
int[] raie_CO2_position = new int[n_particules];


PShader maskShader;
PImage srcImage;
PGraphics srcLive;
PGraphics maskImage;

void setup() {
  //size(1024, 1024, P2D); 
  size(3072, 1024, P2D); 
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
  
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12001);
  myRemoteLocation = new NetAddress("192.168.1.214",9001);
  
  raie_H2O[0] = 0.94;
  raie_H2O[1] = 1.38;
  raie_H2O[2] = 6.3;
   
  raie_CO2[0] = 2;
  raie_CO2[1] = 4.3;
  raie_CO2[2] = 15;
  
  // masque
  srcImage = loadImage("/Users/mike/Documents/Processing/2025/P5 Khroma/Medias/Spectrogramme/Spectre-atmosphère-exoplanète-fr.png");
  srcLive = createGraphics(width, height, P2D);
  maskImage = createGraphics(width, height, P2D);
  maskImage.noSmooth();
  maskShader = loadShader("mask.glsl");
  maskShader.set("mask", maskImage);
  
  for(int i = 0 ; i<n_particules ; i++){
    raie_H2O_position[i] = round(random(0,2));
    raie_CO2_position[i] = round(random(0,2));
  }
  
}

void draw() {
  surface.setTitle("FPS = " + frameRate);
  // data
  
  background(0);
  
  
  push();
  colorMode(HSB,360,100,100,100);
  noStroke();
  stroke(0,0,100,50);
  for(int i = 0 ; i<width ; i+= width/360){
    fill(map(i,0,width,306,0),100,100);
    rect(i,0,i,height);
  }
  pop();
  
  draw_cloud();
  
  maskImage.beginDraw();
  maskImage.background(0); 
  maskImage.noStroke();
  maskImage.fill(255, 0, 0);
  //maskImage.rect(mouseX, 0, 100, height);
  if(total_user>0){
    maskImage.rect(main_gauche_X, 0, 100, height);
    maskImage.rect(main_droite_X, 0, 100, height);
  }
  if(full_data){
    maskImage.rect(0,0,width,height);
  }
  maskImage.endDraw();

  shader(maskShader);    
  image(srcLive, 0, 0, width, height);
  
  resetShader();
  
  stroke(255,0,0);
  textAlign(CENTER);
  textSize(20);
  for(int i = 0; i<width ; i+= width/18){
  //if(i>0){
  text(int(map(i,0,width,0,18))+"μm", i,height-30);
  //}
  }
  //text("μm",20,height-100);
  
  strokeWeight(1);
  stroke(255,0,0);
  //line(main_gauche_X,0,main_gauche_X,height);
  
  // On dessine les raies d'absorption des molécules d'H2O
  stroke(100);
  for(int i = 0 ; i<3 ; i++){
    float H20 = map(raie_H2O[i],0,18,0,width);
    line(H20,0, H20,height);
  }
  
  for(int i = 0 ; i<3 ; i++){
    float CO2 = map(raie_CO2[i],0,18,0,width);
    line(CO2,0, CO2,height);
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



/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  if (theOscMessage.checkAddrPattern("/6kiX")==true) {
    main_gauche_X = theOscMessage.get(0).floatValue();
    main_gauche_X = map(main_gauche_X,0,1920,0,3072);
    return;   
  } 
  if (theOscMessage.checkAddrPattern("/6kiY")==true) {
    main_gauche_Y = theOscMessage.get(0).floatValue();    
    return;   
  } 
  
  if (theOscMessage.checkAddrPattern("/User")==true) {
    total_user = theOscMessage.get(0).intValue();
    return;   
  } 
  

  if (theOscMessage.checkAddrPattern("/10kiX")==true) {
    main_droite_X = theOscMessage.get(0).floatValue();  
    main_droite_X = map(main_droite_X,0,1920,0,3072);  
    return;   
  } 
  if (theOscMessage.checkAddrPattern("/10kiY")==true) {
    main_droite_Y = theOscMessage.get(0).floatValue();    
    return;   
  } 
  
}
