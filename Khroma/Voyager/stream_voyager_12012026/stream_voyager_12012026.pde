import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
import processing.core.PApplet;
import processing.opengl.PGraphics2D;
import processing.opengl.PGraphics3D;
DwPixelFlow context;
DwFilter filter;
PGraphics3D pg_render;
PGraphics3D pg_luminance;
PGraphics3D pg_bloom;

import codeanticode.syphon.*;
SyphonServer server;

import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

int compteur_scan;
float[][] scanX = new float[3840][10000];
int[] scanY = new int[10000];
float[] longueur = new float[10000];
int speed_factor = 4;

int intervalleX = 100;
int intervalleY = 10;
PImage img_source;
int n_sources = 2;
PImage[] img_source2 = new PImage[n_sources];
int[][] couleur = new int[3840][2160];
float[][] stream_speed = new float[3840][2160];
float[][] stream_w = new float[3840][2160];
String[][] data = new String[3840][2160];
int[][] toss = new int[3840][2160];

//float intensity_bloom_val = 2.5;
//float radius_bloom_val = 0.82;
float intensity_bloom_val = 0;
float radius_bloom_val = 0;

int choix_source;

PFont myFont;

String[] molecule = new String[20];

int n_param = 13;
int gap_param;

float zoom_val;
float zoomY_val; 
float zoomZ_val;

PImage spectre;

int map_width = 1920;
int map_height = 1080;
int userX;
int userY;
int userY2;

boolean zoomY_on;

// Easing ///////////////////////////////////////
PFont police1;
int nombre = 1; // nombre d'objets
float[] x = new float[nombre];
float[] y = new float[nombre];
float[] dx = new float[nombre];
float[] dy = new float[nombre]; 
float[] targetX = new float[nombre];
float[] targetY = new float[nombre] ;
int[] taille = new int[nombre] ;
float easing = 0.05; // vitesse d'animation

void setup() {
  //size(3840, 2160, P3D);
  size(1920, 1080, P3D);
  //rectMode(CENTER);
  colorMode(HSB, 360, 100, 100);
  pixelDensity(1);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000); // réception
  myRemoteLocation = new NetAddress("localhost",9000); // envoi
  
  myFont = createFont("DIN-Regular", 200);
  textFont(myFont,20);
  
  spectre = loadImage("/Users/mike/Documents/Processing/2025/P5 Khroma/Medias/Spectrogramme/spectre_2512.png");
  spectre.resize(width,0);
  

  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");


  
  
}


void draw() {
  
  easing();
  
  if(frameCount % (60*5) == 0){
    targetY[0] = random(200,width-200);
  }
  
  background(0,100,0);

  surface.setTitle("FPS = " + frameRate);
  textSize(20);
   
  //stream();
  
  image(spectre,0,0);
  
  //fill(0,100,0);
  //stroke(0,0,100);
  //rect(0,0,map_width,map_height);
  //fill(0,100,100);
  //noStroke();
  userX = int(map(zoom_val,0,1,0,map_width));
  //// contrôle de la position du spectateur
  //zoom_val = map(constrain(mouseX,0,map_width),0,map_width,0,1);
  zoom_val = map(constrain(mouseX,0,map_width),0,map_width,0,1);
  //userY2 = constrain(int(y[0]),0,map_height);
  userY2 = int(y[0]);
  userY = int(map(constrain(mouseY,0,map_height),0,map_height,-height*0.30,height*0.30));
  //circle(userX,userY2,15);
  
  stroke(0,100,100);
  strokeWeight(2);
  //line(mouseX,0,mouseX,height);
  line(y[0],0,y[0],height);
  
  server.sendScreen();
  
  if(keyPressed && key == 'a'){
    OscMessage myMessage = new OscMessage("/zoom_val"); 
    myMessage.add(zoom_val); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation); 
  }  
  //if(keyPressed && key == 'b'){
    OscMessage myMessage = new OscMessage("/userY2"); 
    myMessage.add(userY2); /* add an int to the osc message */
    oscP5.send(myMessage, myRemoteLocation); 
 // }
  if(constrain(mouseX,0,map_width)>map_width*0.75) {    
    OscMessage myMessage2 = new OscMessage("/userY"); 
    myMessage2.add(userY); /* add an int to the osc message */
    oscP5.send(myMessage2, myRemoteLocation); 
    zoomY_on = true;
  }
  if(zoomY_on = true && constrain(mouseX,0,map_width)<map_width*0.75) {      
    OscMessage myMessage3 = new OscMessage("/userY"); 
    myMessage3.add(0); /* add an int to the osc message */
    oscP5.send(myMessage3, myRemoteLocation); 
    zoomY_on = false;
  }

  if(infoMode) {
    fill(0, 100, 100);
    text("intensity_bloom_val = " + intensity_bloom_val, 50, 50);
    text("intensity_bloom_val = " + radius_bloom_val, 50, 75);
  }
  
  if(source_ON){
    image(sourceTR,0,0);
  }
}

void mouseReleased() {
  background(0);
  scanY[compteur_scan] = int(random(100, height-100));
  compteur_scan++;
  println(compteur_scan + "," + compteur_scan);
}
