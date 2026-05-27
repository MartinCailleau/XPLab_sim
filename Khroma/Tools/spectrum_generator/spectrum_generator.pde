int densite_spectrum = 10;

void setup(){
  size(2160,2160);
  pixelDensity(1);
  colorMode(HSB,360,100,100,100);
}


void draw(){
  background(0,100,0);
  
  // Horizontal
  //for(int i = 0 ; i< width ; i++){
  //  float pixel_to_spectrum = map(i,0,width,283,0);
  //  stroke(pixel_to_spectrum,100,100);
  //  line(i,0,i,100);
  //}
  
  // Vertical  
  for(int i = 0 ; i< height ; i++){
    float pixel_to_spectrum = map(i,0,height,283,0);// spectre complet
    //float pixel_to_spectrum = map(i,0,height,222,39);// bleu vers orange
    stroke(pixel_to_spectrum,100,100);
    line(0,i,width,i);
  }
  
  

}

void keyReleased(){
  if(key == 's'){
    saveFrame("spectrum-######.png");
  }
}
