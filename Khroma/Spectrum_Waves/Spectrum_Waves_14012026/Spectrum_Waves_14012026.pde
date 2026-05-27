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

// IMPORT THE SPOUT LIBRARY
import spout.*;
Spout spout;

int compteur_scan;
float[][] scanX = new float[3840][10000];
int[] scanY = new int[10000];
float[] longueur = new float[10000];
int speed_factor = 4;

int intervalleX = 100;//100
int intervalleY = 10;//10
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

int choix_source = 1;

PFont myFont;

String[] molecule = new String[20];

int n_param = 13;
int gap_param;

float zoom_val;
float zoomY_val; 
float zoomZ_val;




void setup() {
  size(1200, 1200, P3D);
  pixelDensity(1);
  //size(1000, 1000, P3D);
  //rectMode(CENTER);
  colorMode(HSB, 360, 100, 100);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,9000); // réception
  myRemoteLocation = new NetAddress("localhost",12000); // envoi
  
  myFont = createFont("DIN-Regular", 200);
  textFont(myFont,20);
 
  setup_stream(); 
  
}


void draw() {

  surface.setTitle("FPS = " + frameRate);
  textSize(20);
  
  

  pg_render.beginDraw();
  // Vous devez dessiner ci-dessous vos visuels en suivant ce modèle
  pg_render.colorMode(HSB, 360, 100, 100);
  //pg_render.rectMode(CENTER);
  pg_render.background(0);

  if (pauseON) {
    for (int h = 0; h<width; h+=intervalleX) {
      for (int i = 0; i<height; i+=intervalleY) {
        scanX[h][i]+=stream_speed[h][i];
        if (scanX[h][i]>width+intervalleX) {
          scanX[h][i] = -width;
        }
      }
    }
  } 
  
  //else {
  //  for (int h = 0; h<width; h+=intervalleX) {
  //    for (int i = 0; i<height; i+=intervalleY) {
  //      scanX[h][i] = 0;
  //    }
  //  }
  //}
    
  pg_render.noStroke();
  //for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {   
  for (int i = 0; i<width; i+=intervalleX) {
    for (int j = 0; j<height; j+=intervalleY) {
      

      pg_render.pushMatrix();
      pg_render.translate(width/2,height/2);
      pg_render.rotate(radians(map(j,0,height,-45,45)));
        
      pg_render.pushMatrix();
      //float zoom_val = map(abs(mouseY-j),0,250,100,0);
      //float zoom_val = map(abs(mouseY-j),0,250,250,0);
      //pg_render.translate(scanX[i][j], 0,zoom_val);
      pg_render.translate(scanX[i][j], 0);
      //couleur[i][j] = img_source2[choix_source].get(i, j);
      pg_render.fill(couleur[i][j]);
      if(toss[i][j] < 1){
        //if(abs(userY2_remap-j)<gap_param){
          pg_render.fill(0,0,100);
          pg_render.textSize(intervalleY);
          pg_render.text(data[i][j],i-width/2,j+intervalleY/2-height/2);
        //}
      }
      else{
        pg_render.rect(i-width/2, j-height/2, stream_w[i][j], intervalleY*.5);
      }
      pg_render.popMatrix();
      
      pg_render.popMatrix();
    }    
  }


  if (keyPressed && key == 'c') {
    pg_render.fill(230, 100, 100);
    pg_render.circle(mouseX, mouseY, 200);
  }

  pg_render.endDraw();

  filter.luminance_threshold.param.threshold = 0.0f; // when 0, all colors are used
  filter.luminance_threshold.param.exponent  = 1;
  filter.luminance_threshold.apply(pg_render, pg_luminance);

  // Voici les 2 paramètres que vous pouvez ajuster
  if (keyPressed && key == 'b') {
    intensity_bloom_val = map(mouseX, 0, width, 0, 10);
  }
  if (keyPressed && key == 'r') {
    radius_bloom_val = map(mouseX, 0, width, 0, 5);
  }
  filter.bloom.param.mult   = intensity_bloom_val;
  //filter.bloom.param.radius = map(mouseY, 0, height, 0, 20); // rayon de la brillance
  //filter.bloom.param.mult   = 0.75; // intensite de la brillance
  filter.bloom.param.radius = radius_bloom_val;
  //filter.bloom.param.mult   = 3;
  //filter.bloom.param.radius = 0.58;

  filter.bloom.apply(pg_luminance, pg_bloom, pg_render);


  //// display result
  blendMode(REPLACE);
  background(0);
  pushMatrix();
  //if(keyPressed && key == ' '){
  //if(mouseX > width-100){
    //translate(0,map(mouseY,0,height,-height*0.30,height*0.30));
    translate(0,userY);    
  //}
  pushMatrix();
  //translate(0,0,map(mouseX,0,width,-500,500));
  //translate(0,4*gap_param,map(mouseX,0,width,0,500));
  //zoom_val = map(mouseX,0,width,0,1);
  zoomY_val = map(zoom_val,0,1,0,0.3);
  zoomZ_val = map(zoom_val,0,1,0,500);
  translate(0,zoomY_val,zoomZ_val);
  //translate(0,-height*0.30,map(mouseX,0,width,0,500));
  imageMode(CENTER);
  image(pg_render, width/2,height/2);

  
  //// échelle
  //stroke(0,0,100);
  //  for(int i = 0 ; i<n_param ; i++){
      
  //    float legende_decalage = map(zoom_val,0,1,0,width*.3);
  //    text(molecule[i],legende_decalage,i*gap_param);
  //    line(0,i*gap_param,width,i*gap_param);
  //  }
    
    
  popMatrix();
  popMatrix();

  //fill(0, 100, 100);
  //text("position du spectateur", 25, 50);
  
  //stroke(0,100,100);
  //strokeWeight(2);
  ////line(mouseX,0,mouseX,height);
  //line(0,userY2_remap,width,userY2_remap);

 if(cast == 1){
    // Create syhpon server to send frames out.
    server = new SyphonServer(this, "Processing Syphon");
  }
 if(cast == 2){    
   // Send at the size of the window    
    spout.sendTexture();
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
