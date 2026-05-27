PGraphics sourceTR;
PImage sourceIMG;
int nNoise = 10000;
float pixel_to_spectrum;
float[] noiseX = new float[nNoise];
float[] noiseY = new float[nNoise];
float[] noiseW = new float[nNoise];

void setup_source() {
  //for(int i = 0 ; i< nNoise ; i++){
  //  noiseX[i] = round(random(width));
  //  noiseY[i] = round(random(height));
  //  noiseW[i] = round(random(5,25));
  //}

  //sourceTR = createGraphics(width, height, P2D);
  //sourceTR.beginDraw();
  //sourceTR.colorMode(HSB, 360, 100, 100, 100);
  //for(int i = 0 ; i< height ; i++){
  //  pixel_to_spectrum = map(i,0,height,300,0);// du violet vers le rouge
  //  //pixel_to_spectrum = map(i,0,height,222,39);// bleu vers orange
  //  sourceTR.stroke(pixel_to_spectrum,100,100);
  //  sourceTR.line(0,i,height,i);
  //}
  
  //for(int i = 0 ; i< nNoise ; i++){
  //  sourceTR.stroke(0,100,0);
  //  sourceTR.line(noiseX[i],noiseY[i],noiseX[i]+noiseW[i],noiseY[i]);
  //}
  //sourceTR.image(img_source2[choix_source],0,0);// spectre 4K
  //sourceTR.endDraw();
  
  for (int i = 0; i<width; i+=intervalleX) {
  //for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {
    for (int j = 0; j<height; j+=intervalleY) {
      couleur[i][j] = img_source2[choix_source].get(i, j);
      compteur_couleur++;
      println("compteur_couleur = " + compteur_couleur);
      println("couleur[i][j] = " + couleur[i][j]);
    }
  }
  
}
