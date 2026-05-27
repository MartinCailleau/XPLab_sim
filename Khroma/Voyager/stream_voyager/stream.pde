void setup_stream(){
  gap_param = height/n_param;
  println("gap_param = " + gap_param);
  molecule[0] = "O <1 micron";
  molecule[1] = "O3 < 1 micron";
  molecule[2] = "H2O r1 1-2 microns";
  molecule[3] = "H2O r2 1-2 microns";
  molecule[4] = "CH4 r1 2-4 microns";
  molecule[5] = "CO2 r1 2-4 microns";
  molecule[6] = "CH4 r2 2-4 microns";
  molecule[7] = "CO2 r2 4-8 microns";
  molecule[8] = "O3 r1 4-8 microns";
  molecule[9] = "H2O r3 4-8 microns";
  molecule[10] = "CH4 r3 4-8 microns";
  molecule[11] = "O3 r2 8-16 microns";
  molecule[12] = "CO2 r3 8-16 microns";
  
  // Pixelflow
  context = new DwPixelFlow(this);
  context.print();
  context.printGL();
  filter = new DwFilter(context);

  pg_render = (PGraphics3D) createGraphics(width, height, P3D);
  pg_render.smooth(8);

  pg_luminance = (PGraphics3D) createGraphics(width, height, P3D);
  pg_luminance.smooth(8);

  pg_bloom = (PGraphics3D) createGraphics(width, height, P3D);
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

  setup_source();
  
  for (int i = 0; i<width; i+=intervalleX) {
  //for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {
    for (int j = 0; j<height; j+=intervalleY) {
      //couleur[i][j] = img_source2[choix_source].get(i, j);
      couleur[i][j] = sourceTR.get(i, j);
    }
  }


  for(int h = 0 ; h<width ; h+=intervalleX){
  for(int i = 0 ; i<height ; i+=intervalleY){
      if(i<=1*gap_param){
        data[h][i] = molecule[0];
        //println("molecule[0] détectée");
      }
      if(i>=1*gap_param && i<=2*gap_param){
        data[h][i] = molecule[1];
        //println("molecule[1] détectée");
      }
      if(i>=2*gap_param && i<=3*gap_param){
        data[h][i] = molecule[2];
      }
      if(i>=3*gap_param && i<=4*gap_param){
        data[h][i] = molecule[3];
      }
      if(i>=4*gap_param && i<=5*gap_param){
        data[h][i] = molecule[4];
      }
      if(i>=5*gap_param && i<=6*gap_param){
        data[h][i] = molecule[5];
      }
      if(i>=6*gap_param && i<=7*gap_param){
        data[h][i] = molecule[6];
      }
      if(i>=7*gap_param && i<=8*gap_param){
        data[h][i] = molecule[7];
      }
      if(i>=8*gap_param && i<=9*gap_param){
        data[h][i] = molecule[8];
      }
      if(i>=9*gap_param && i<=10*gap_param){
        data[h][i] = molecule[9];
      }
      if(i>=10*gap_param && i<=11*gap_param){
        data[h][i] = molecule[10];
      }
      if(i>=11*gap_param && i<=12*gap_param){
        data[h][i] = molecule[11];
      }
      if(i>=12*gap_param && i<=13*gap_param){
        data[h][i] = molecule[12];
      }
      if(i>=13*gap_param){
        data[h][i] = "data unknown";
        //println("data unknown");
      }
  }
  }
  
  for (int h = 0; h<width; h+=intervalleX) {
    for (int i = 0; i<intervalleY*85; i+=intervalleY) {
      //scanX[i] = int(random(-100, 100)-width);
      //stream_speed[i] = round(random(4*speed_factor, 7*speed_factor));//4-10
      //stream_speed[i] = map(i,0,intervalleY*85,15,20);
      stream_speed[h][i] = round(random(3,10));//10-15
      stream_w[h][i] = round(random(90,100));
 
      
      toss[h][i] = round(random(0,5));
    }
    for (int i = intervalleY*85; i<height; i+=intervalleY) {
      //scanX[i] = int(map(i,0,width,0,width/2));
      //stream_speed[i] = round(random(4*speed_factor, 7*speed_factor));// 4-10
      //stream_speed[i] = map(i,intervalleY*85,height,20,15);
      stream_speed[h][i] = round(random(3,10));
      stream_w[h][i] = round(random(90,100));

      toss[h][i] = round(random(0,5));
    }
  }
  
}

void stream(){
  pg_render.beginDraw();
  // Vous devez dessiner ci-dessous vos visuels en suivant ce modèle
  pg_render.colorMode(HSB, 360, 100, 100);
  //pg_render.rectMode(CENTER);
  pg_render.background(0);

  if (!mousePressed) {
    for (int h = 0; h<width; h+=intervalleX) {
      for (int i = 0; i<height; i+=intervalleY) {
        scanX[h][i]+=stream_speed[h][i];
        if (scanX[h][i]>width+intervalleX) {
          scanX[h][i] = -width;
        }
      }
    }
  } else {
    for (int h = 0; h<width; h+=intervalleX) {
      for (int i = 0; i<height; i+=intervalleY) {
        scanX[h][i] = 0;
      }
    }
  }
    
  pg_render.noStroke();
  //intervalleX = 20;
  //for (int i = 0; i<img_source2[choix_source].width; i+=intervalleX) {   
  for (int i = 0; i<width; i+=intervalleX) {
    for (int j = 0; j<height; j+=intervalleY) {
      pg_render.pushMatrix();
      //float zoom_val = map(abs(mouseY-j),0,250,100,0);
      float zoom_val = map(abs(mouseY-j),0,250,250,0);
      //pg_render.translate(scanX[i][j], 0,zoom_val);
      pg_render.translate(scanX[i][j], 0);
      //couleur[i][j] = img_source2[choix_source].get(i, j);
      pg_render.fill(couleur[i][j]);
      if(toss[i][j] == 0){
        if(abs(mouseY-j)<gap_param){
          pg_render.fill(0,0,100);
          pg_render.textSize(intervalleY*2);
          pg_render.text(data[i][j],i,j+intervalleY/2);
        }
      }
      else{
        pg_render.rect(i, j, stream_w[i][j], intervalleY*.5);
      }
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
  if(mouseX > width-100){
    translate(0,map(mouseY,0,height,-height*0.30,height*0.30));
  }
  pushMatrix();
  //translate(0,0,map(mouseX,0,width,-500,500));
  //translate(0,4*gap_param,map(mouseX,0,width,0,500));
  zoom_val = map(mouseX,0,width,0,1);
  zoomY_val = map(zoom_val,0,1,0,0.3);
  zoomZ_val = map(zoom_val,0,1,0,500);
  translate(0,zoomY_val,zoomZ_val);
  //translate(0,-height*0.30,map(mouseX,0,width,0,500));
  imageMode(CENTER);
  image(pg_render, width/2,height/2);

  
  // échelle
  stroke(0,0,100);
    for(int i = 0 ; i<n_param ; i++){
      
      float legende_decalage = map(zoom_val,0,1,0,width*.3);
      text(molecule[i],legende_decalage,i*gap_param);
      line(0,i*gap_param,width,i*gap_param);
    }
    
    
  popMatrix();
  popMatrix();
}
