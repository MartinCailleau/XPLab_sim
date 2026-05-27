import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
import processing.core.PApplet;
import processing.opengl.PGraphics2D;
DwPixelFlow context;
DwFilter filter;
PGraphics2D pg_render;
PGraphics2D pg_luminance;
PGraphics2D pg_bloom;

import codeanticode.syphon.*;
SyphonServer server;

int compteur_scan;
float[] scanX = new float[10000];
int[] scanY = new int[10000];
float[] longueur = new float[10000];
int speed_factor = 4;

int intervalleX = 10;
int intervalleY = 5;
PImage img_source;
int n_sources = 2;
PImage[] img_source2 = new PImage[n_sources];
int[][] couleur = new int[1920][1920];
float[] stream_speed = new float[1920];

float intensity_bloom_val = 2.5;
float radius_bloom_val = 0.82;

int choix_source;


void setup() {
  //size(3840, 1920, P3D);
  size(1483, 1483, P3D);
  rectMode(CENTER);
  colorMode(HSB, 360, 100, 100);

  pixelDensity(1);

  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");

  // Pixelflow
  context = new DwPixelFlow(this);
  context.print();
  context.printGL();
  filter = new DwFilter(context);

  pg_render = (PGraphics2D) createGraphics(width, height, P2D);
  pg_render.smooth(8);

  pg_luminance = (PGraphics2D) createGraphics(width, height, P2D);
  pg_luminance.smooth(8);

  pg_bloom = (PGraphics2D) createGraphics(width, height, P2D);
  pg_bloom.smooth(0);

  //img_source = loadImage("/Users/mike/Documents/Processing/P5images:video/Feu/fire_texture1080.jpg");
  //img_source = loadImage("/Users/mike/Documents/Processing/P5images:video/SolidBackground/blanc1920x1200.jpg");
  //img_source = loadImage("../../Medias/Light/spectrum1.png");
  //img_source = loadImage("../../Medias/Light/spectrum_bar_vertical.png");
  //img_source = loadImage("../../Medias/Light/spectrum_bar_1920x1920.png");
  //img_source = loadImage("../../Medias/Light/spectrum_1920x1920.png");
  //img_source = loadImage("../../Medias/Light/spectrum_bleu-orange_1920x1920.png");
  
  //img_source2[0] = loadImage("../../Medias/Light/spectrum_1920x1920.png");
  img_source2[0] = loadImage("/Users/mike/Documents/Processing/2025/Khroma/Medias/Jupiter/Hubble’s_observation_of_Jupiter_in_2021.jpg");
  img_source2[1] = loadImage("../../Medias/Light/spectrum_bleu-orange_1920x1920.png");





  //for (int i = 0; i<width; i+=intervalleX) {
  for (int i = 0; i<intervalleY*85; i+=intervalleY) {
    //scanX[i] = int(random(-100, 100)-width);
    //stream_speed[i] = round(random(4*speed_factor, 7*speed_factor));//4-10
    //stream_speed[i] = map(i,0,intervalleY*85,15,20);
    stream_speed[i] = round(random(15,20));
  }
  for (int i = intervalleY*85; i<height; i+=intervalleY) {
    //scanX[i] = int(map(i,0,width,0,width/2));
    //stream_speed[i] = round(random(4*speed_factor, 7*speed_factor));// 4-10
    //stream_speed[i] = map(i,intervalleY*85,height,20,15);
    stream_speed[i] = round(random(15,20));
  }
  
  
  for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {
    for (int j = 0; j<height; j+=intervalleY) {
      couleur[i][j] = img_source2[choix_source].get(i, j);
    }
  }
}


void draw() {

  surface.setTitle("FPS = " + frameRate);

  pg_render.beginDraw();
  // Vous devez dessiner ci-dessous vos visuels en suivant ce modèle
  pg_render.colorMode(HSB, 360, 100, 100);
  pg_render.rectMode(CENTER);
  pg_render.background(0);

  if (!mousePressed) {
    for (int i = 0; i<height; i+=intervalleY) {
      scanX[i]+=stream_speed[i];
      if (scanX[i]>width+intervalleX) {
        scanX[i] = -width;
      }
    }
  } else {
    for (int i = 0; i<height; i+=intervalleY) {
      //scanX[i] = 0;
      //scanX[i] = int(random(-100, 100)-width*1.5);
      scanX[i] = 0;
    }
  }


  pg_render.noStroke();
  //intervalleX = 20;
  for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {
    for (int j = 0; j<height; j+=intervalleY) {
      pg_render.pushMatrix();
      pg_render.translate(scanX[j], 0);
      //couleur[i][j] = img_source2[choix_source].get(i, j);
      pg_render.fill(couleur[i][j]);
      pg_render.rect(i, j, 5, intervalleY*.5);
      pg_render.popMatrix();
    }
  }

  // double
  //for (int i = 0; i<width; i+=intervalleX) {
  //  for (int j = 0; j<height; j+=intervalleY) {
  //    pg_render.pushMatrix();
  //    pg_render.translate(scanX[j]+1100,0);
  //    couleur[i][j] = img_source.get(i,j);
  //    pg_render.fill(couleur[i][j]);
  //    pg_render.rect(i,j,intervalleX,intervalleY*.5);
  //    pg_render.popMatrix();
  //  }
  //}


  //for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {
  //  for (int j = 0; j<height; j+=intervalleY) {
  //    pg_render.pushMatrix();
  //    pg_render.translate(scanX[j]+600, 0);
  //    couleur[i][j] = img_source2[choix_source].get(i, j);
  //    pg_render.fill(couleur[i][j]);
  //    pg_render.rect(i, j, intervalleX, intervalleY*.5);
  //    pg_render.popMatrix();
  //  }
  //}

  //for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {
  //  for (int j = 0; j<height; j+=intervalleY) {
  //    pg_render.pushMatrix();
  //    pg_render.translate(scanX[j]+1200, 0);
  //    couleur[i][j] = img_source2[choix_source].get(i, j);
  //    pg_render.fill(couleur[i][j]);
  //    pg_render.rect(i, j, intervalleX, intervalleY*.5);
  //    pg_render.popMatrix();
  //  }
  //}

  //for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {
  //  for (int j = 0; j<height; j+=intervalleY) {
  //    pg_render.pushMatrix();
  //    pg_render.translate(scanX[j]+1800, 0);
  //    couleur[i][j] = img_source2[choix_source].get(i, j);
  //    pg_render.fill(couleur[i][j]);
  //    pg_render.rect(i, j, intervalleX, intervalleY*.5);
  //    pg_render.popMatrix();
  //  }
  //}

  //for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {
  //  for (int j = 0; j<height; j+=intervalleY) {
  //    pg_render.pushMatrix();
  //    pg_render.translate(scanX[j]+2400, 0);
  //    couleur[i][j] = img_source2[choix_source].get(i, j);
  //    pg_render.fill(couleur[i][j]);
  //    pg_render.rect(i, j, intervalleX, intervalleY*.5);
  //    pg_render.popMatrix();
  //  }
  //}

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
  image(pg_render, 0, 0);


  //// ghost trail
  //fill(0, 10);
  //rect(width/2, height/2, width, height);
  //stroke(255);
  //strokeWeight(5);
  //if (compteur_scan>0) {
  //  for (int i = 0; i<compteur_scan; i++) {
  //    line(scanX[i], 0, scanX[i], height);
  //  }
  //}


  server.sendScreen();

  if (infoMode) {
    fill(0, 100, 100);
    text("intensity_bloom_val = " + intensity_bloom_val, 50, 50);
    text("intensity_bloom_val = " + radius_bloom_val, 50, 75);
  }
}

void mouseReleased() {
  background(0);
  scanY[compteur_scan] = int(random(100, height-100));
  compteur_scan++;
  println(compteur_scan + "," + compteur_scan);
}
