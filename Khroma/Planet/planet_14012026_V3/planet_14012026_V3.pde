import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

import codeanticode.syphon.*;
SyphonServer server;

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

// Booléens
boolean syphon_on = true;

//-------------------------------------------------------------
// Paramètres de composition
//-------------------------------------------------------------
// Rayon du noyau central
float coreRadius = 100;

// Paramètres des 3 couronnes
// Chaque couronne est définie par son rayon intérieur, rayon extérieur
// et le nombre de segments (arcs) qui la compose pour faire 360 degrés.

// Couronne 1 (la plus intérieure, autour du noyau)
float crown1InnerRadius = 100;
float crown1OuterRadius = 200;
int crown1Segments = 3;
ArrayList crown1Colors;

// Couronne 2 (intermédiaire)
float crown2InnerRadius = 200;
float crown2OuterRadius = 300;
int crown2Segments = 3;
ArrayList crown2Colors;

// Couronne 3 (la plus extérieure)
float crown3InnerRadius = 300;
float crown3OuterRadius = 400;
int crown3Segments = 6;
ArrayList crown3Colors;

//-------------------------------------------------------------
// Paramètres de rotation
//-------------------------------------------------------------
boolean rotateCrown1 = false;   // Activer/désactiver la rotation de la couronne 1
float rotationSpeed1 = 0.005;  // Vitesse de rotation de la couronne 1 (en radians par frame)
float currentRotation1 = 0;    // Angle de rotation actuel de la couronne 1

boolean rotateCrown2 = false;   // Activer/désactiver la rotation de la couronne 2
float rotationSpeed2 = -0.003; // Vitesse de rotation de la couronne 2 (négatif pour sens inverse)
float currentRotation2 = 0;

boolean rotateCrown3 = true;   // Activer/désactiver la rotation de la couronne 3
float rotationSpeed3 = 0.002;  // Vitesse de rotation de la couronne 3
float currentRotation3 = 0;

// Pixelflow
float intensity_bloom_val = 0;
float radius_bloom_val = 0;

//-------------------------------------------------------------
// Configuration du sketch
//-------------------------------------------------------------
void setup() {
  size(1024, 1024, P2D); // Définit la taille du sketch directement avec des chiffres
  pixelDensity(1);
  
  smooth(); // Adoucit les bords
  colorMode(HSB, 360, 100, 100, 100); // Utilise le mode HSB pour des couleurs vives avec opacité
  ellipseMode(CENTER); // Les ellipses et arcs sont centrés par défaut
  background(0); // Fond noir initial
  
  
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");

  // Initialisation des ArrayList pour chaque couronne et ajout des couleurs

  // Couleurs pour la couronne 1
  crown1Colors = new ArrayList();
  crown1Colors.add(color(#F98650));    // Rouge vif
  crown1Colors.add(color(#B4543C));  // Vert vif
  crown1Colors.add(color(#6E3D36)); // Bleu vif
  crown1Colors.add(color(60, 100, 100));   // Jaune vif

  // Couleurs pour la couronne 2
  crown2Colors = new ArrayList();
  crown2Colors.add(color(#D75B35)); // Magenta
  crown2Colors.add(color(#020202)); // Cyan
  crown2Colors.add(color(#BE5537));  // Orange
  crown2Colors.add(color(270, 100, 100)); // Violet
  crown2Colors.add(color(0, 50, 100));    // Rouge clair
  crown2Colors.add(color(120, 50, 100));  // Vert clair
  crown2Colors.add(color(240, 50, 100)); // Bleu clair
  crown2Colors.add(color(60, 50, 100));   // Jaune clair

  // Couleurs pour la couronne 3 - Génération dynamique pour couvrir la roue chromatique
  crown3Colors = new ArrayList();
  float hueStep = 360.0 / crown3Segments; // Calcul le pas de teinte pour chaque segment

  for (int i = 0; i < crown3Segments; i++) {
    float currentHue = i * hueStep;
    crown3Colors.add(color(currentHue, 100, 100)); // Saturation et luminosité à 100%
  }
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12001);
  myRemoteLocation = new NetAddress("192.168.1.214",9001);
  
  // Pixelflow
  pg_render = (PGraphics3D) createGraphics(width, height, P3D);
  pg_render.smooth(8);

  pg_luminance = (PGraphics3D) createGraphics(width, height, P3D);
  pg_luminance.smooth(8);

  pg_bloom = (PGraphics3D) createGraphics(width, height, P3D);
  pg_bloom.smooth(0);
  
}

//-------------------------------------------------------------
// Fonction de dessin
//-------------------------------------------------------------
void draw() {
  surface.setTitle("FPS = " + frameRate);
  
  push();
  background(0); // Redessine le fond noir à chaque frame
  translate(width / 2, height / 2); // Centre l'origine au milieu du sketch

  // Facteur d'échelle pour rendre tout responsive
  float scaleFactor = min(width, height) / 1024.0;

  // Mise à jour des angles de rotation si la rotation est activée
  if (rotateCrown3) currentRotation3 += rotationSpeed3;
  if (rotateCrown2) currentRotation2 += rotationSpeed2;
  if (rotateCrown1) currentRotation1 += rotationSpeed1;

  // Ordre de dessin : du plus grand au plus petit (extérieur vers intérieur)
  
  
  // Dessiner la couronne 3 (la plus extérieure)
  drawCrown(crown3InnerRadius * scaleFactor, crown3OuterRadius * scaleFactor, crown3Segments, crown3Colors, currentRotation3);
  
  // Dessiner la couronne 2
  drawCrown(crown2InnerRadius * scaleFactor, crown2OuterRadius * scaleFactor, crown2Segments, crown2Colors, currentRotation2);

  // Dessiner la couronne 1 (la plus intérieure)
  drawCrown(crown1InnerRadius * scaleFactor, crown1OuterRadius * scaleFactor, crown1Segments, crown1Colors, currentRotation1);

  // Dessiner le noyau central (toujours en dernier)
  drawCore(coreRadius * scaleFactor);
  pop();
  
  
}

//-------------------------------------------------------------
// Fonctions utilitaires pour dessiner les éléments
//-------------------------------------------------------------

// Dessine le noyau central
void drawCore(float radius) {
  
  pg_render.beginDraw();
  pg_render.colorMode(HSB, 360, 100, 100);
  pg_render.background(0);
  
  pg_render.fill(0, 0, 100); // Couleur blanche pour le noyau
  pg_render.noStroke(); // Pas de contour
  pg_render.ellipse(0, 0, radius * 2, radius * 2);
  
  pg_render.endDraw();

  // Les détails internes au noyau sont commentés, je les garde ainsi.
}

// Dessine une couronne composée d'arcs "parts de pizza" avec des couleurs spécifiées et un angle de rotation
void drawCrown(float innerR, float outerR, int totalSegments, ArrayList segmentColors, float rotationAngle) {
  float segmentAngularStep = TWO_PI / totalSegments;

  // Appliquer la rotation pour cette couronne
  pushMatrix(); // Sauvegarde l'état actuel de la transformation
  rotate(rotationAngle); // Applique la rotation

  // 1. Dessiner tous les segments colorés de la couronne extérieure
  for (int i = 0; i < totalSegments; i++) {
    float startAngle = i * segmentAngularStep;
    float endAngle = startAngle + segmentAngularStep;

    // Pixelflow
    pg_render.beginDraw();
    pg_render.colorMode(HSB, 360, 100, 100);
    pg_render.background(0);
    
    pg_render.fill((int)segmentColors.get(i % segmentColors.size()));
    pg_render.noStroke(); // Pas de contour pour les segments remplis

    pg_render.arc(0, 0, outerR * 2, outerR * 2, startAngle, endAngle, PIE);
    
    pg_render.endDraw();
    
    image(pg_render, 0,0);
  }

  // 2. Dessiner un cercle noir pour masquer la partie intérieure
  fill(0); // Couleur de fond pour masquer
  noStroke();
  ellipse(0, 0, innerR * 2, innerR * 2);

  // 3. Ajouter les contours blancs pour délimiter clairement cette couronne
  stroke(255); // Contour blanc
  strokeWeight(2); // Épaisseur du contour
  noFill(); // S'assurer qu'on ne remplit pas le cercle pour dessiner juste le contour
  ellipse(0, 0, outerR * 2, outerR * 2); // Contour extérieur
  ellipse(0, 0, innerR * 2, innerR * 2); // Contour intérieur
  noStroke(); // Réinitialiser le noStroke

  popMatrix(); // Restaure l'état de la transformation (enlève la rotation pour les prochains éléments)


  if(syphon_on){
       server.sendScreen();
  }
    
}

// Permet de sauvegarder le sketch en appuyant sur 's'
void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("circular_composition_rotating_####.png");
  }
}
